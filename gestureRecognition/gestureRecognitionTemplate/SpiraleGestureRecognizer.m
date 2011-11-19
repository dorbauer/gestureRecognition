//
//  UIGestureRecognizer.m
//  gestureRecognitionTemplate
//
//  Created by Dorian Bauer on 17/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SpiraleGestureRecognizer.h"

@interface SpiraleGestureRecognizer() {
@private
    
    UIQuarterCirclePattern _lastDetectedPattern;
}
@property(nonatomic,strong) NSMutableArray *touchedPoints;
@property(nonatomic,strong) NSMutableArray *touchDirections;


- (BOOL)doesLastTouchConformToPattern;
- (UIQuarterCirclePattern)checkForPattern;
- (UIMouvementDirection)getDirection:(UITouch*)touch;

@end


@implementation SpiraleGestureRecognizer

@synthesize vc = _vc;
@synthesize lastKnownMouvementDirection = _lastKnownMouvementDirection;
@synthesize touchedPoints = _touchedPoints;
@synthesize touchDirections = _touchDirections;

#pragma Mark - Initialisation

-(id)initWithTarget:(id)target action:(SEL)action{
    if (self = [super initWithTarget:target action:action])
    {
        _touchDirections = [[NSMutableArray alloc] init];
        _touchedPoints = [[NSMutableArray alloc] init];
    }
    return self;
}



#pragma Mark - Private GestureRecognizer Methods

- (BOOL)doesLastTouchConformToPattern{
    
    return NO;
}

- (UIQuarterCirclePattern)checkForPattern{
    
    //Not enough point to detect a Pattern
    if ([[self touchDirections] count] < kMinimumTouchesForPatternRecognition) {
        return UIQuarterCirclePatternNil;
    }
    
    NSCountedSet *xValues = [[NSCountedSet alloc]init];
    NSCountedSet *yValues = [[NSCountedSet alloc]init];
    
    //Compute DeltaX and DeltaY Between all the first kMinimumTouchesForPatternRecognition Points
    for (int i = 0; i < ([[self touchDirections] count]); i++) {
        
        UIMouvementDirection tmpMvmtDir = [[[self touchDirections] objectAtIndex:i] intValue];
        
#ifdef DEBUG        
        NSLog(@"Direction of the Point is : %d",tmpMvmtDir);
#endif
        
        [xValues addObject:[NSNumber numberWithInt:(int)(tmpMvmtDir/10)]];
        [yValues addObject:[NSNumber numberWithInt:(int)(tmpMvmtDir%10)]];
    }

    //Which x Direction ist the most represented ?
    NSEnumerator *e = [xValues objectEnumerator];
    id tmp;
    int max = 0;
    UIMouvementDirection xMedianValue = UIMouvementDirectionNoDirection;
    while (tmp = [e nextObject]) {
        if ( [xValues countForObject:tmp] > max  ) {
            xMedianValue = [tmp intValue];
        }
    }
    
    //Which y Direction ist the most represented ?
    e = [yValues objectEnumerator];
    max = 0;
    UIMouvementDirection yMedianValue = UIMouvementDirectionNoDirection;
    while (tmp = [e nextObject]) {
        if ( [yValues countForObject:tmp] > max  ) {
            yMedianValue = [tmp intValue];
        }
    }

    NSLog(@"Pattern is :%d%d",xMedianValue,yMedianValue);
    
    if ( xMedianValue == UIMouvementDirectionStraightX || yMedianValue ==UIMouvementDirectionStraightY) {
        return UIQuarterCirclePatternNil;
    }
    
    //Temporary, waiting for a better Idee
    return UIQuarterCirclePatternNil;
    
}

- (UIMouvementDirection)getDirection:(UITouch*)touch{

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
    
    NSLog(@"x:%f   y:%f",location.x,location.y);
    NSString *x,*y;
    if (deltaX < 0) x = @"Left "; 
    else if( deltaX == 0 ) x = @"Straight ";
    else x = @"Right ";
    
    if (deltaY < 0) y = @"Top";
    else if( deltaY == 0) y = @"Straight";
    else y = @"Bottom";
    
    NSLog(@"%@%@",x,y);
#endif
    return finalDirection;

}



#pragma Mark - UIGestureRecognizer Herited Delegate Methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

    UITouch *touch = [[touches allObjects] objectAtIndex:0];
    
    //Clean Up things
    if ([touch tapCount] == 2) {
        [[self vc] cleanScreen];
        [[self touchedPoints] removeAllObjects];
        [[self touchDirections] removeAllObjects];
        return;
    }
    //Add to History
    [_touchedPoints addObject:touch];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
  
#ifdef DEBUG
    //NSLog(@"Touches Moved");
#endif    

    UITouch *touch = [[touches allObjects] objectAtIndex:0];
    
    //Add to History
    [[self touchedPoints] addObject:touch];
        
    //Draw on screen
    [[self vc] drawPointOnScreen:[touch locationInView:touch.view]];
    
    //Get LastDirection
    UIMouvementDirection lastMouvement = [self getDirection:touch];
    [[self touchDirections] addObject:[NSNumber numberWithInt:lastMouvement]];
    
    //Check For Pattern 
    if (_lastDetectedPattern == UIQuarterCirclePatternNil) _lastDetectedPattern = [self checkForPattern];
    else if ([self doesLastTouchConformToPattern]) return; //Temporary, waiting for a better Idee
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{

#ifdef DEBUG
    NSLog(@"Touches Ended !");
    NSLog(@"Touch Count:%d",[[self touchedPoints] count]);
#endif
    
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{

#ifdef DEBUG
    NSLog(@"Touches Cancelled !");
#endif    
    [[self touchDirections] removeAllObjects];
    [[self touchedPoints] removeAllObjects];
    self.lastKnownMouvementDirection = UIMouvementDirectionNoDirection;
}

- (void)reset{

#ifdef DEBUG
    NSLog(@"Reset");
#endif
    
}

#pragma Mark -Helper Methods


@end


