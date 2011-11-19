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

}
@property(nonatomic,weak) NSMutableArray *touchedPoints;
@end


@implementation SpiraleGestureRecognizer

@synthesize vc = _vc;
@synthesize lastKnownMouvementDirection = _lastKnownMouvementDirection;
@synthesize touchedPoints = _touchedPoints;

#pragma Mark - UIGestureRecognizer Herited Delegate Methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

    UITouch *touch = [[touches allObjects] objectAtIndex:0];
    if ([touch tapCount] == 2) {
        [[self vc] cleanScreen];
        return;
    }
    
    [[self touchedPoints] addObject:touch];
	CGPoint location = [touch locationInView:touch.view];
    
    NSLog(@"First Touch is in %f,%f",location.x, location.y);
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    
    UITouch *touch = [[touches allObjects] objectAtIndex:0];
    [[self touchedPoints] addObject:touch];

	// First finger that hits the Screen
		
	
	CGPoint location = [touch locationInView:touch.view];
	CGPoint previousLocation = [touch previousLocationInView:touch.view];
	
	CGFloat deltaX, deltaY;
	
    deltaX = (location.x - previousLocation.x);
    deltaY = (location.y - previousLocation.y);
    
    NSLog(@"dx:%f     dy:%f",deltaX,deltaY);
    
    switch (deltaX > 0) {
        case YES:
            NSLog(@"Finger moves to the right");
            if (deltaY > 0) {
                NSLog(@"Finger moves to the top");
                    
                NSLog(@"\n                          RIGHT TOP");
            }else{
                NSLog(@"Finger moves to the bottom");
                NSLog(@"\n                          RIGHT BOTTOM");
            }
            
            break;
            
        case NO:
            NSLog(@"Finger moves to the left");
            if (deltaY > 0) {
                NSLog(@"Finger moves to the top");
                NSLog(@"\n                          LEFT TOP");
            }else{
                NSLog(@"Finger moves to the bottom");
                NSLog(@"\n                          LEFT BOTTOM");
            }
            break;
            
        default:
            break;
    }
    
    //Draw on screen
    [[self vc] drawPointOnScreen:[touch locationInView:touch.view]];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{


}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{}

- (void)reset{}

@end
