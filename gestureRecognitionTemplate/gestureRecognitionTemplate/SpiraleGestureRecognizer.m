//
//  UIGestureRecognizer.m
//  gestureRecognitionTemplate
//
//  Created by Dorian Bauer on 17/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SpiraleGestureRecognizer.h"


@implementation SpiraleGestureRecognizer

@synthesize vc = _vc;

#pragma Mark - UIGestureRecognizer Herited Delegate Methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

    //First finger that hits the Screen
	UITouch *touch = [[touches allObjects] objectAtIndex:0];
    
    //Used for Touch for one touch Count for example 
    [touch tapCount];
    
    //Use for finger Count
    [touches count];
    
    NSLog(@"Nombre de doigt %d",[touches count]);
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{

	// First finger that hits the Screen
	UITouch *touch = [[touches allObjects] objectAtIndex:0];	
	
	CGPoint location = [touch locationInView:touch.view];
	CGPoint previousLocation = [touch previousLocationInView:touch.view];
	
	CGFloat deltaX, deltaY;
	
    deltaX = (location.x - previousLocation.x);
    deltaY = (location.y - previousLocation.y);
    
    NSLog(@"dx:%f     dy:%f",deltaX,deltaY);

}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{}

- (void)reset{}

@end
