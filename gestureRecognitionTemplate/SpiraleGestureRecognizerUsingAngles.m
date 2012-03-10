//
//  SpiraleGestureRecognizerUsingAngles.m
//  gestureRecognition
//
//  Created by guillaume laas on 19/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SpiraleGestureRecognizerUsingAngles.h"

#pragma mark - Private Interface

@interface SpiraleGestureRecognizerUsingAngles(){

}

-(void)cleanUp;

@property (nonatomic, strong) NSMutableArray *pointsOnHalfCircle;
@property (nonatomic, strong) NSMutableArray *pointsOnAngles;
@property (nonatomic) CGPoint pointOnAngle;
@property (nonatomic) UIScrewOrientation orientation;
@property (nonatomic) int fingersOnScreen;
@property (nonatomic) BOOL update;
@property (nonatomic) BOOL shouldUse3DOF;
@end



#pragma mark - Implementation

@implementation SpiraleGestureRecognizerUsingAngles

@synthesize pointOnAngle = _pointOnAngle;
@synthesize pointsOnHalfCircle = _pointsOnHalfCircle;
@synthesize pointsOnAngles = _pointsOnAngles;
@synthesize orientation = _orientation;
@synthesize fingersOnScreen = _fingersOnScreen;
@synthesize shouldUse3DOF = _shouldUse3DOF;
@synthesize update = _update;

- (id)init {
    _fingersOnScreen = 0;
    _update = NO;
    _shouldUse3DOF = NO;
    _orientation = UIScrewOrientationNil;
    return self;
}

- (NSMutableArray*) pointsOnHalfCircle{
    if (!_pointsOnHalfCircle)
        _pointsOnHalfCircle = [[NSMutableArray alloc] init];
    return _pointsOnHalfCircle;
    
}

- (NSMutableArray*) pointsOnAngles{
    if (!_pointsOnAngles)
        _pointsOnAngles = [[NSMutableArray alloc] init];
    return _pointsOnAngles;
}

- (UIMouvementDirection)getDirectionBetweenThisTouch:(CGPoint)firstTouch andThisTouch:(CGPoint)secondTouch{
    
    
    //Maybe we should introduce a precision Delta
	
	CGFloat deltaX, deltaY;
    UIMouvementDirection xDirection, yDirection;
	
    deltaX = (secondTouch.x - firstTouch.x);
    deltaY = (secondTouch.y - firstTouch.y);
    
#ifdef DEBUG
    // NSLog(@"Delta X: %f     Delta Y: %f",deltaX,deltaX);
#endif
    
    if (deltaX < 0) xDirection = UIMouvementDirectionLeft; 
    else if( deltaX == 0 ) xDirection = UIMouvementDirectionStraightX;
    else xDirection = UIMouvementDirectionRight;
    
    if (deltaY < 0) yDirection = UIMouvementDirectionTop;
    else if( deltaY == 0) yDirection = UIMouvementDirectionStraightY;
    else yDirection = UIMouvementDirectionBottom;
    
    //Creates the composed UIMouvementDirection
    return (xDirection*10+yDirection);
}

- (CGFloat)computeAngleUsingThisPointAsOrigin: (CGPoint)O thisPoint:(CGPoint)A andThisPoint: (CGPoint)B {
    
    int Xoa = A.y - O.y;
    int Yoa = A.x - O.x;
    int Xob = B.y -O.y;
    int Yob = B.x - O.x;
    
    float Na = sqrtf(Xoa*Xoa + Yoa*Yoa); //norme
    float Nb = sqrtf( Xob*Xob + Yob*Yob);
    float C = (Xoa * Xob + Yoa * Yob)/(Na*Nb);
    float S = Xoa*Yob - Yoa*Xob;
    
    float angle = abs(S) * acos(C);

    return angle;
}

- (UIScrewOrientation) getSenseOfRotationFromThisPoint: (CGPoint) A throughThisPoint:(CGPoint)B andToThisPoint: (CGPoint)C {
    
    float scal = (A.x -B.x)*(C.y - A.y) + (B.y - A.y)*(C.x - A.x);
    
    if (scal >= 0)
        return UIScrewOrientationScrewOut;
    else
        return UIScrewOrientationScrewIn;
}

- (BOOL)isAngleIncreasing: (CGPoint) C{
    
    if (self.pointsOnAngles.count > 0 && self.pointsOnHalfCircle.count >= 3) {
        
        CGPoint O = [[self.pointsOnAngles objectAtIndex:0] CGPointValue];
        CGPoint A = [[self.pointsOnHalfCircle objectAtIndex: self.pointsOnHalfCircle.count -2]  CGPointValue];
        CGPoint B = [[self.pointsOnHalfCircle objectAtIndex:1] CGPointValue];
        
        float angleAOB = [self computeAngleUsingThisPointAsOrigin:O thisPoint:A andThisPoint:B];
        float angleAOC = [self computeAngleUsingThisPointAsOrigin:O thisPoint:A andThisPoint:C];
        
        if (angleAOB > angleAOC)
            return NO;
    }
    return YES;
}

- (UIMouvementDirection) getGeneralDirectionOfMovement{
    if(self.pointsOnAngles.count > 0 && self.pointsOnHalfCircle.count > 0){
        CGPoint a = [self.pointsOnAngles.lastObject CGPointValue];
        CGPoint b = [[self.pointsOnHalfCircle objectAtIndex:0] CGPointValue];
        
        UIMouvementDirection dir = [self getDirectionBetweenThisTouch:a andThisTouch:b];
        return dir;
    }
    return UIMouvementDirectionNoDirection;
}

- (UIMouvementDirection) getGeneralDirectionOfMovementAlongX{
    return [self getGeneralDirectionOfMovement] /10;
}

- (BOOL) isThisPoint: (CGPoint) A BeforeThisPoint: (CGPoint) B{
    if ([self getGeneralDirectionOfMovementAlongX] == UIMouvementDirectionRight) return (A.x < B.x);
    if ([self getGeneralDirectionOfMovementAlongX] == UIMouvementDirectionLeft)  return (A.x > B.x);
    else return NO;
}

// once we've at least past 3 points, the following point will be tested to check if it is on the spiral or not. The very first point of a partial circle is called "origin" it is the first point touched or is located where 2 half circles meet. We use 2 Arrays of points; the first contains all the points that are not located on angles, the second contains points located on angles (aka origins of half circles).
// Method for detecting a spiral: 
//      let O the point of origin of a half circle
//      let A,B two consecutive points on the half circle
//      let C the next point
// We assume that O, A and B are part of a spiral, we need to check if C is still on the spiral.
// if the angle AÔB is smaller than AÔC, C is still on the spiral
// if the angle AÔC is smaller, we need to check if we have a loop
//      Now, if the point following C is located "before" C (towards the opposite sense of the general movement) then we have a "loop" and C is the new origin for the next partial circle.
// We repeat the algorithm with O = C
- (BOOL) isThisPointOnSpiral: (CGPoint)currentPoint {
    
    CGPoint origin;
    if (self.pointsOnAngles.count >0) 
        origin = [[self.pointsOnAngles objectAtIndex:0] CGPointValue];
    else
        return NO;
    
    if (self.pointsOnHalfCircle.count >= 5){
        // the angle is increasing, we're still on the spiral
        if ([self isAngleIncreasing:currentPoint]){
            
            [self.pointsOnHalfCircle insertObject:[NSValue valueWithCGPoint:currentPoint] atIndex:0];
            
            return YES;
            
        }
        
        //the angle stopped increasing, we may be on the "loop"?
        else {
            CGPoint previousPoint = [[self.pointsOnHalfCircle objectAtIndex:0] CGPointValue];
            
            // the current point is on the spiral and on the loop
            if ([self isThisPoint:origin BeforeThisPoint:currentPoint] && [self isThisPoint:currentPoint BeforeThisPoint:previousPoint]){
                
                [self.pointsOnAngles insertObject:[NSValue valueWithCGPoint:currentPoint ] atIndex:0];
                [self.pointsOnHalfCircle removeAllObjects];
                return YES;
            }else {
                
                self.update = NO;
                self.orientation = UIScrewOrientationNil;
                /*[self.pointsOnAngles removeAllObjects];
                [self.pointsOnHalfCircle removeAllObjects];
                [self.pointsOnAngles insertObject:[NSValue valueWithCGPoint:currentPoint] atIndex:0];
                return NO;*/
                return YES;
            }
        }
    }
    
    [self.pointsOnHalfCircle insertObject:[NSValue valueWithCGPoint:currentPoint] atIndex:0];
    return NO;
}

- (void)cleanUp{

    [[self observatedViewController] doubleTapDetected];
    [self.pointsOnAngles removeAllObjects];
    [self.pointsOnHalfCircle removeAllObjects];
    self.orientation = UIScrewOrientationNil;
    self.update = NO;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    self.fingersOnScreen = 0;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

#if DEBUG
    NSLog(@"FingersMouving in Began = %d",[touches count]);
#endif
    
    self.fingersOnScreen += [touches count];
    
    if ([self fingersOnScreen] == 2 ) {
        [self cleanUp];
    }
    
    UITouch *touch = [touches.allObjects objectAtIndex:0];
    CGPoint currentPoint = [touch locationInView:touch.view];
    [self.pointsOnAngles insertObject:[NSValue valueWithCGPoint:currentPoint] atIndex:0];
    
    if ([touch tapCount] == 3) {
        self.shouldUse3DOF = ![self shouldUse3DOF];
        NSString *message;
        ([self shouldUse3DOF] == YES) ? message = @"will be used" : @"won't be used";
        
        UIAlertView *tmp = [[UIAlertView alloc] initWithTitle:@"3DOF" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [tmp show];
    }
    
    //Switch to martinet
    if ([touch tapCount] == 4) {
        [[self observatedViewController] tripleTapDetected];
    } 
}



- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"FingersOnScreen = %d",_fingersOnScreen);
    NSLog(@"FingersMouving = %d",[touches count]);
    
    UITouch *touch = [touches.allObjects objectAtIndex:0];
    CGPoint currentPoint = [touch locationInView:touch.view];
    CGPoint previousLocation = [touch previousLocationInView:touch.view];
    
    if ([self fingersOnScreen] == 1){
    
        int deltaY = getVerticalDelta(previousLocation, currentPoint);
        int deltaX = getHorizontalDelta(previousLocation, currentPoint);
        [[self observatedViewController] translateObjectWithDeltaX:deltaX andDeltaY:deltaY andDeltaZ:0];    
    
    }else{
        
        //Mouvement already found, just zoom !
        if([self isThisPointOnSpiral:currentPoint]) {
                
                if (self.pointsOnAngles.count >= 2 && self.pointsOnHalfCircle.count >= 5){
                    
                    //Cherche la direction du mouvement
                    UIScrewOrientation orientation = [self getSenseOfRotationFromThisPoint:[[self.pointsOnHalfCircle objectAtIndex:4] CGPointValue]
                                                                          throughThisPoint:[[self.pointsOnHalfCircle objectAtIndex:2] CGPointValue] 
                                                                            andToThisPoint:[[self.pointsOnHalfCircle objectAtIndex:0] CGPointValue]];
                    
                    if (self.orientation == UIScrewOrientationNil) {
                        self.orientation = orientation;
                        self.update = YES;
                    }   
                    if ([self update]  == YES) {
                        //Envoi l'ordre de zoom/dézoom
                        
                        int deltaY = 0;
                        int deltaX = 0;
                        
                        //Prends en compte le X et Y, le cube suit le déplacement en même temps qu'il se déplace sur Z
                        if( [self shouldUse3DOF] == YES){
                            
                           deltaY = getVerticalDelta(previousLocation, currentPoint);
                           deltaX = getHorizontalDelta(previousLocation, currentPoint);
                        }
                        
                        [[self observatedViewController] spiraleDetectedBy:self withOrientation:[self orientation] andHorizontalDelta:deltaX andVerticalDelta:deltaY];

                    }
                }        
        }
    }

#if kDetectionTestViewController 
    [self.observatedViewController drawPointOnScreen:currentPoint]; 
#endif
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.pointsOnAngles removeAllObjects];
    [self.pointsOnHalfCircle removeAllObjects];
    self.orientation = UIScrewOrientationNil;
    self.fingersOnScreen -= [touches count];
    
    if( [self fingersOnScreen] == 0 ) [[self observatedViewController] touchesEnded];
}


@end
