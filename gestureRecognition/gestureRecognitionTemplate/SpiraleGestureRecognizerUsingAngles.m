//
//  SpiraleGestureRecognizerUsingAngles.m
//  gestureRecognition
//
//  Created by guillaume laas on 19/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SpiraleGestureRecognizerUsingAngles.h"


@interface SpiraleGestureRecognizerUsingAngles()     

@property (nonatomic, strong) NSMutableArray *pointsOnHalfCircle;
@property (nonatomic, strong) NSMutableArray *pointsOnAngles;
@property (nonatomic) CGPoint pointOnAngle;
@property (nonatomic) UIScrewOrientation orientation;
@end

@implementation SpiraleGestureRecognizerUsingAngles

@synthesize pointOnAngle = _pointOnAngle;
@synthesize pointsOnHalfCircle = _pointsOnHalfCircle;
@synthesize pointsOnAngles = _pointsOnAngles;
@synthesize orientation = _orientation;

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
    NSLog(@"Delta X: %f     Delta Y: %f",deltaX,deltaX);
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

-(CGFloat) computeAngleUsingThisPointAsOrigin: (CGPoint)O thisPoint:(CGPoint)A andThisPoint: (CGPoint)B {
    
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

-(UIScrewOrientation) getSenseOfRotationFromThisPoint: (CGPoint) A throughThisPoint:(CGPoint)B andToThisPoint: (CGPoint)C {
    
    float scal = (A.x -B.x)*(C.y - A.y) + (B.y - A.y)*(C.x - A.x);
    
    if (scal >= 0)
        return UIScrewOrientationScrewOut;
    else
        return UIScrewOrientationScrewIn;
}

-(BOOL) isAngleIncreasing: (CGPoint) C{
    
    if (self.pointsOnAngles.count > 0 && self.pointsOnHalfCircle.count >= 5) {
           
        CGPoint O = [[self.pointsOnAngles objectAtIndex:0] CGPointValue];
        CGPoint A = [[self.pointsOnHalfCircle objectAtIndex: self.pointsOnHalfCircle.count -2]  CGPointValue];
        CGPoint B = [[self.pointsOnHalfCircle objectAtIndex:1] CGPointValue];
        
        float angleAOB = [self computeAngleUsingThisPointAsOrigin:O thisPoint:A andThisPoint:B];
        NSLog(@"valeur de l'angle AOB: %f", angleAOB);
        float angleAOC = [self computeAngleUsingThisPointAsOrigin:O thisPoint:A andThisPoint:C];
        NSLog(@"valeur de l'angle AOC: %f", angleAOC);
        
        if (angleAOB > angleAOC)
            return NO;
    }
    
    return YES;
}

-(UIMouvementDirection) getGeneralDirectionOfMovement{
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
    
    if (self.pointsOnAngles.count >= 1 && self.pointsOnHalfCircle.count >= 5){
        // the angle is increasing, we're still on the spiral
        if ([self isAngleIncreasing:currentPoint]){
            
            [self.pointsOnHalfCircle insertObject:[NSValue valueWithCGPoint:currentPoint] atIndex:0];
            
#if kDetectionTestViewController 
            [self.observatedViewController setColor:NO];
            [self.observatedViewController drawPointOnScreen:currentPoint]; 
#endif
            if (self.orientation) {
                UIMouvementDirection direction = [self getGeneralDirectionOfMovement];
                
                [self.observatedViewController spiraleDetectedBy:self withOrientation:self.orientation andMouvementDirection:direction];
            }
            
            return YES;
            
        }
        //the angle stopped increasing, we may be on the "loop"?
        else {
            CGPoint previousPoint = [[self.pointsOnHalfCircle objectAtIndex:0] CGPointValue];
            // the current point is on the spiral and on the loop
            if ([self isThisPoint:origin BeforeThisPoint:currentPoint] && [self isThisPoint:currentPoint BeforeThisPoint:previousPoint]){
                
                
                UIScrewOrientation orientation = [self getSenseOfRotationFromThisPoint:[[self.pointsOnHalfCircle objectAtIndex:4] CGPointValue]
                                                                      throughThisPoint:[[self.pointsOnHalfCircle objectAtIndex:2] CGPointValue] 
                                                                        andToThisPoint:[[self.pointsOnHalfCircle objectAtIndex:0] CGPointValue]];
                UIMouvementDirection direction = [self getGeneralDirectionOfMovement];
                
                //NSLog(@"This spiral is turning to: %d \ntowards %d", orientation, direction);
                
                [self.observatedViewController spiraleDetectedBy:self withOrientation:orientation andMouvementDirection:direction];
                
                self.orientation = orientation;
                
                [self.pointsOnAngles insertObject:[NSValue valueWithCGPoint:currentPoint ] atIndex:0];
                [self.pointsOnHalfCircle removeAllObjects];
                //[self.pointsOnHalfCircle insertObject:[NSValue valueWithCGPoint:currentPoint] atIndex:0];
                
#if kDetectionTestViewController 
                [self.observatedViewController setColor:YES];
                [self.observatedViewController drawPointOnScreen:currentPoint]; 
#endif
                
                return YES;
            }
            else {
                //[self.pointsOnAngles removeAllObjects];
                //[self.pointsOnHalfCircle removeAllObjects];
                //[self.pointsOnAngles insertObject:[NSValue valueWithCGPoint:currentPoint] atIndex:0];
                self.orientation = UIScrewOrientationNil;
                return NO;
            }
        }
        
    }
#if kDetectionTestViewController 
    [self.observatedViewController setColor:NO];
    [self.observatedViewController drawPointOnScreen:currentPoint]; 
#endif

    [self.pointsOnHalfCircle insertObject:[NSValue valueWithCGPoint:currentPoint] atIndex:0];
    return NO;
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches.allObjects objectAtIndex:0];
    CGPoint currentPoint = [touch locationInView:touch.view];
    
    [self.pointsOnAngles insertObject:[NSValue valueWithCGPoint:currentPoint] atIndex:0];
    
    //Clean Up things
    if ([touch tapCount] == 2) {
        //detectionTest Screen Cleaning
        [[self observatedViewController] doubleTapDetected];
        [self.pointsOnHalfCircle removeAllObjects];
        [self.pointsOnAngles removeAllObjects];
        return;
    }
}



- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches.allObjects objectAtIndex:0];
    CGPoint currentPoint = [touch locationInView:touch.view];
    
    
    [self isThisPointOnSpiral:currentPoint];
    
//    if([self isThisPointOnSpiral:currentPoint]){
//        //NSLog(@"This point is on the spiral");
//        if (self.pointsOnHalfCircle.count >= 3) {
//            
//            UIScrewOrientation orientation = [self getSenseOfRotationFromThisPoint:[[self.pointsOnHalfCircle objectAtIndex:2] CGPointValue]
//                                                                  throughThisPoint:[[self.pointsOnHalfCircle objectAtIndex:1] CGPointValue] 
//                                                                    andToThisPoint:[[self.pointsOnHalfCircle objectAtIndex:0] CGPointValue]];
//            UIMouvementDirection direction = [self getGeneralDirectionOfMovement];
//            
//            //NSLog(@"This spiral is turning to: %d \ntowards %d", orientation, direction);
//
//            [self.observatedViewController spiraleDetectedBy:self withOrientation:orientation andMouvementDirection:direction];
////#if kDetectionTestViewController 
////            [self.observatedViewController setColor:NO];
////            [self.observatedViewController drawPointOnScreen:[touch locationInView:touch.view]]; 
////#endif
//        }
//
//    }
//    else {
//        [self.observatedViewController spiraleDetectedBy:self withOrientation:UIScrewOrientationNil andMouvementDirection:UIMouvementDirectionNoDirection];
////#if kDetectionTestViewController 
////        [self.observatedViewController setColor:YES];
////        [self.observatedViewController drawPointOnScreen:[touch locationInView:touch.view]]; 
////#endif
//    }
//    
//
//    
//    //}

    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.pointsOnAngles removeAllObjects];
    [self.pointsOnHalfCircle removeAllObjects];
    self.orientation = UIScrewOrientationNil;
#ifdef DEBUG
    //NSLog(@"Touches Ended !");
    //NSLog(@"Touch Count:%d",[[self touchedPoints] count]);
#endif
    
    
}


@end
