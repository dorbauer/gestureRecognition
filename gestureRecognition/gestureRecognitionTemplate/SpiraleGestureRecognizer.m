//
//  UIGestureRecognizer.m
//  gestureRecognitionTemplate
//
//  Created by Dorian Bauer on 17/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SpiraleGestureRecognizer.h"
#import "detectionTestViewController.h"

@interface SpiraleGestureRecognizer() {
@private
    
    UIQuarterCirclePattern _lastDetectedPattern;
    UIQuarterCirclePattern _currentDetectedPattern;
    
    BOOL _isLastPointSuspicious;
}
@property(nonatomic,strong) NSMutableArray *touchDirections;
@property(nonatomic) CGPoint firstTouch;
@property(nonatomic) CGPoint lastTouch;


- (BOOL)doesLastTouchConformToPattern;
- (void)checkForSpiralePattern;
- (UIQuarterCirclePattern)checkForPattern;
- (UIMouvementDirection)getDirectionTo:(UITouch*)touch;
- (UIMouvementDirection)getDirectionBetweenThisTouch:(CGPoint)firstTouch andThisTouch:(CGPoint)secondTouch;

@end


@implementation SpiraleGestureRecognizer

@synthesize observatedViewController;
@synthesize lastKnownMouvementDirection = _lastKnownMouvementDirection;
@synthesize touchDirections = _touchDirections;
@synthesize firstTouch = _firstTouch;
@synthesize lastTouch = _lastTouch;
@synthesize touchCount = _touchCount;


#pragma Mark - Initialisation

-(id)initWithTarget:(id)target action:(SEL)action{
    if (self = [super initWithTarget:target action:action])
    {
        _touchDirections = [[NSMutableArray alloc] init];
    }
    return self;
}



#pragma Mark - Private GestureRecognizer Methods

- (void)checkForSpiralePattern{
    
#ifdef DEBUG  
    //NSLog(@"Last is: %d",_lastDetectedPattern);
    //NSLog(@"Last is: %d",_currentDetectedPattern);
#endif
    
    switch (_lastDetectedPattern) {
        case UIQuarterCirclePatternNW:
        {
            if ( _currentDetectedPattern == UIQuarterCirclePatternNE ) {
                [self.observatedViewController spiraleDetectedBy:self withOrientation:UIScrewOrientationScrewIn andMouvementDirection:[self getDirectionBetweenThisTouch:_firstTouch andThisTouch:_lastTouch]];
                
            }else if( _currentDetectedPattern == UIQuarterCirclePatternSW ){
                [self.observatedViewController spiraleDetectedBy:self withOrientation:UIScrewOrientationScrewOut andMouvementDirection:[self getDirectionBetweenThisTouch:_firstTouch andThisTouch:_lastTouch]];
            }
            break;
        }
        case UIQuarterCirclePatternNE:
        {
            if ( _currentDetectedPattern == UIQuarterCirclePatternSE ) {
                [self.observatedViewController spiraleDetectedBy:self withOrientation:UIScrewOrientationScrewIn andMouvementDirection:[self getDirectionBetweenThisTouch:_firstTouch andThisTouch:_lastTouch]];
                
            }else if( _currentDetectedPattern == UIQuarterCirclePatternSW ){
                [self.observatedViewController spiraleDetectedBy:self withOrientation:UIScrewOrientationScrewOut andMouvementDirection:[self getDirectionBetweenThisTouch:_firstTouch andThisTouch:_lastTouch]];
            }
            break;
        }
        case UIQuarterCirclePatternSE:
        {
            if ( _currentDetectedPattern == UIQuarterCirclePatternSW ) {
                [self.observatedViewController spiraleDetectedBy:self withOrientation:UIScrewOrientationScrewIn andMouvementDirection:[self getDirectionBetweenThisTouch:_firstTouch andThisTouch:_lastTouch]];
                
            }else if( _currentDetectedPattern == UIQuarterCirclePatternSW ){
                [self.observatedViewController spiraleDetectedBy:self withOrientation:UIScrewOrientationScrewOut andMouvementDirection:[self getDirectionBetweenThisTouch:_firstTouch andThisTouch:_lastTouch]];
            }
            break;
        }
        case UIQuarterCirclePatternSW:
        {
            if ( _currentDetectedPattern == UIQuarterCirclePatternNE ) {
                [self.observatedViewController spiraleDetectedBy:self withOrientation:UIScrewOrientationScrewIn andMouvementDirection:[self getDirectionBetweenThisTouch:_firstTouch andThisTouch:_lastTouch]];
                
            }else if( _currentDetectedPattern == UIQuarterCirclePatternSW ){
                [self.observatedViewController spiraleDetectedBy:self withOrientation:UIScrewOrientationScrewOut andMouvementDirection:[self getDirectionBetweenThisTouch:_firstTouch andThisTouch:_lastTouch]];
            }
            break;
        }
    }
}

- (BOOL)doesLastTouchConformToPattern{
    
    UIMouvementDirection tmp = [[[self touchDirections] lastObject] intValue];
    switch (_currentDetectedPattern) {
        case UIQuarterCirclePatternNW:
        {
            if ( tmp == UIMouvementDirectionRightTop  || tmp == UIMouvementDirectionRightStraight || tmp == UIMouvementDirectionStraightTop ) {
                return YES;
            }
            break;
        }
        case UIQuarterCirclePatternNE:
        {
            if ( tmp == UIMouvementDirectionLeftTop  || tmp == UIMouvementDirectionLeftStraight || tmp == UIMouvementDirectionStraightTop ) {
                return YES;
            }
            break;
        }
        case UIQuarterCirclePatternSE:
        {
            if ( tmp == UIMouvementDirectionLeftBottom  || tmp == UIMouvementDirectionLeftStraight || tmp == UIMouvementDirectionStraightBottom ) {
                return YES;
            }
            break;
        }
        case UIQuarterCirclePatternSW:
        {
            if ( tmp == UIMouvementDirectionRightBottom  || tmp == UIMouvementDirectionRightStraight || tmp == UIMouvementDirectionStraightBottom ) {
                return YES;
            }
            break;
        }
            
    }
    
    //Only for "detectionViewController"
#ifdef kDetectionTestViewController
    [(detectionTestViewController*)observatedViewController setColor:![(detectionTestViewController*)observatedViewController changeColor]];
#endif
    return NO;
}

- (UIQuarterCirclePattern)checkForPattern{
    
#ifdef DEBUG        
    // NSLog(@"________CheckForPattern_________");
#endif
    
    
    //Not enough point to detect a Pattern
    if ([[self touchDirections] count] < kMinimumTouchesForPatternRecognition ) {
        return UIQuarterCirclePatternNil;
    }
    
    NSCountedSet *xValues = [[NSCountedSet alloc]init];
    NSCountedSet *yValues = [[NSCountedSet alloc]init];
    
    //Compute DeltaX and DeltaY Between all the first kMinimumTouchesForPatternRecognition Points
    for (int i = 0; i < ([[self touchDirections] count]); i++) {
        
        UIMouvementDirection tmpMvmtDir = [[[self touchDirections] objectAtIndex:i] intValue];
        
        [xValues addObject:[NSNumber numberWithInt:(int)(tmpMvmtDir/10)]];
        [yValues addObject:[NSNumber numberWithInt:(int)(tmpMvmtDir%10)]];
    }
    
    //Which x Direction is the most represented ?
    NSEnumerator *e = [xValues objectEnumerator];
    id tmp;
    int max = 0;
    UIMouvementDirection xMedianValue = UIMouvementDirectionNoDirection;
    while (tmp = [e nextObject]) {
        
        if ( [xValues countForObject:tmp] >= max  ) {
            xMedianValue = [tmp intValue];
            max = [xValues countForObject:tmp];
        }
    }
    
    //Which y Direction is the most represented ?
    e = [yValues objectEnumerator];
    max = 0;
    UIMouvementDirection yMedianValue = UIMouvementDirectionNoDirection;
    while (tmp = [e nextObject]) {
        
        if ( [yValues countForObject:tmp] >= max  ) {
            yMedianValue = [tmp intValue];
            max = [yValues countForObject:tmp];
            
        }
    }
    
    //NSLog(@"________________________________Pattern is :%d%d",xMedianValue,yMedianValue);
    
    [[self touchDirections] removeAllObjects];
    
    if ( xMedianValue == UIMouvementDirectionStraightX || yMedianValue ==UIMouvementDirectionStraightY) {
        return UIQuarterCirclePatternNil;
    }
    //Temporary, waiting for a better Idee
    return (xMedianValue*10+yMedianValue);
    
}

- (UIMouvementDirection)getDirectionTo:(UITouch*)touch{
    
    CGPoint location = [touch locationInView:touch.view];
	CGPoint previousLocation = [touch previousLocationInView:touch.view];
	
	CGFloat deltaX, deltaY;
    UIMouvementDirection finalDirection, xDirection, yDirection;
	
    deltaX = (location.x - previousLocation.x);
    deltaY = (location.y - previousLocation.y);
    
    if (deltaX < 0) xDirection = UIMouvementDirectionLeft; 
    else if( deltaX == 0 ) xDirection = UIMouvementDirectionStraightX;
    else xDirection = UIMouvementDirectionRight;
    
    if (deltaY < 0) yDirection = UIMouvementDirectionTop;
    else if( deltaY == 0) yDirection = UIMouvementDirectionStraightY;
    else yDirection = UIMouvementDirectionBottom;
    
    //Creates the composed UIMouvementDirection
    finalDirection = (xDirection*10+yDirection);
    
#ifdef DEBUG
    
    /*NSLog(@"x:%f   y:%f",location.x,location.y);
     NSString *x,*y;
     if (deltaX < 0) x = @"Left "; 
     else if( deltaX == 0 ) x = @"Straight ";
     else x = @"Right ";
     
     if (deltaY < 0) y = @"Top";
     else if( deltaY == 0) y = @"Straight";
     else y = @"Bottom";
     
     NSLog(@"%@%@",x,y);*/
#endif
    return finalDirection;
    
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



#pragma Mark - UIGestureRecognizer Herited Delegate Methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [[touches allObjects] objectAtIndex:0];
    [self setFirstTouch:[touch locationInView:touch.view]];
    _touchCount++;
    
    //Clean Up things
    if ([touch tapCount] == 2) {
        //detectionTest Screen Cleaning
        [[self observatedViewController] doubleTapDetected];
        [[self touchDirections] removeAllObjects];
        [self setTouchCount:0];
        return;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
#ifdef DEBUG
    //NSLog(@"Touches Moved");
#endif 
    
    _touchCount++;
    
    UITouch *touch = [[touches allObjects] objectAtIndex:0];
    [self setLastTouch:[touch locationInView:touch.view]];
    
    //Get LastDirection
    UIMouvementDirection lastMouvement = [self getDirectionTo:touch];
    [[self touchDirections] addObject:[NSNumber numberWithInt:lastMouvement]];
    
    //Check For Pattern 
    if (_currentDetectedPattern == UIQuarterCirclePatternNil) {
        _currentDetectedPattern = [self checkForPattern];
        
        if (_lastDetectedPattern != UIQuarterCirclePatternNil) {
            [self checkForSpiralePattern];
        }
        return;
    }
    else if( _isLastPointSuspicious && ![self doesLastTouchConformToPattern] ){
        
        _lastDetectedPattern = _currentDetectedPattern;
        _currentDetectedPattern = UIQuarterCirclePatternNil;
        _isLastPointSuspicious = NO;
        
        
        NSRange deletionRange;
        deletionRange.location = 0;
        deletionRange.length = [[self touchDirections] count] - 2;
        [[self touchDirections] removeObjectsInRange:deletionRange];
        
#ifdef DEBUG
        /* NSLog(@"\n\n________Changement de pattern");*/
#endif
        
        
    }else{
        
        _isLastPointSuspicious = NO;
        if(![self doesLastTouchConformToPattern] ){
#ifdef DEBUG
            //NSLog(@"\nPoint Suspicieux\n");
#endif
            _isLastPointSuspicious = YES;
        }
    }
    //Draw on screen -  DetectionTest
    
#if kDetectionTestViewController    
    [observatedViewController drawPointOnScreen:[touch locationInView:touch.view]]; 
#endif
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
#ifdef DEBUG
    //NSLog(@"Touches Ended !");
    //NSLog(@"Touch Count:%d",[[self touchedPoints] count]);
#endif
    
    UITouch *touch = [[touches allObjects] objectAtIndex:0];
    [self setLastTouch:[touch locationInView:touch.view]];
    
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    
#ifdef DEBUG
    //NSLog(@"Touches Cancelled !");
#endif    
    
}

- (void)reset{
    
#ifdef DEBUG
    //NSLog(@"Reset");
#endif
    
}

#pragma Mark -Helper Methods


@end


