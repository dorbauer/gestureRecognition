//
//  SpiraleGestureRecognizerUsingAngles.m
//  gestureRecognition
//
//  Created by guillaume laas on 19/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TwoFingersGestureRecognizerMartinet.h"



#pragma mark - Private Interface

@interface TwoFingersGestureRecognizerMartinet(){

    UITouch *leftHand;
    UITouch *rightHand;
}


@property (nonatomic) int fingersOnScreen;

@end

#pragma mark - Implementation

@implementation TwoFingersGestureRecognizerMartinet

@synthesize fingersOnScreen = _fingersOnScreen;

- (id)init {
    _fingersOnScreen = 0;
    leftHand = NULL;
    rightHand = NULL;
    return self;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

    
    self.fingersOnScreen += [touches count];
    
    UITouch *touch = [touches.allObjects objectAtIndex:0];
    if ([touch tapCount] == 3) {
        [[self observatedViewController] tripleTapDetected];
    }
    
    if ([touch locationInView:touch.view].y < ([[touch view] frame].size.height)/4 ) {
        
        leftHand = touch;
    }else{
        rightHand = touch;
    }
    
    
    return;
}

/*
 En général, un seul doigt appelle la fonction et on ne sait pas lequel. On ne pas dire par exemple le premier doigt posé soccupe de Z le seconde de X et Y. J'utilise donc un 5éme de l'écran à gauche qui sera utilisé pour gérer les Z et le doigt placé dans les 4/5 restants sera pour X et Y.
*/
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    int deltaZ = 0, deltaX = 0, deltaY = 0;
    
    UITouch *touch = [[touches allObjects] objectAtIndex:0];
    CGPoint currentTouch = [touch locationInView:touch.view];
    CGPoint previousTouch = [touch previousLocationInView:touch.view];
    
    switch ([[touches allObjects] count]) {
        case 1:
            {
                //Right Hand moved
                if([[touches allObjects] objectAtIndex:0] == rightHand){
                    NSLog(@"Right Hand Moved");
                    deltaY = getVerticalDelta(previousTouch, currentTouch);
                    deltaX = getHorizontalDelta(previousTouch, currentTouch);
                }else if([[touches allObjects] objectAtIndex:0] == leftHand){
                    NSLog(@"Left Hand Moved");
                    deltaZ = getHorizontalDelta(currentTouch, previousTouch);
                }
            }
            break;
        
        
        case 2:
            NSLog(@"Both Hand Moved");
            //Right hand
            if([[touches allObjects] objectAtIndex:0] == rightHand){
                deltaY = getVerticalDelta(previousTouch, currentTouch);
                deltaX = getHorizontalDelta(previousTouch, currentTouch);
                
                //Reused for the second hand, the left one in this case
                touch = [[touches allObjects] objectAtIndex:1];
                currentTouch = [touch locationInView:touch.view];
                previousTouch = [touch previousLocationInView:touch.view];
                
                deltaZ = getHorizontalDelta(currentTouch, previousTouch);
                
                
            }else{
                deltaZ = getHorizontalDelta(currentTouch, previousTouch);
                
                //Reused for the second hand, the left one in this case
                touch = [[touches allObjects] objectAtIndex:1];
                currentTouch = [touch locationInView:touch.view];
                previousTouch = [touch previousLocationInView:touch.view];
                
                
                deltaY = getVerticalDelta(previousTouch, currentTouch);
                deltaX = getHorizontalDelta(previousTouch, currentTouch);
            }
            break;

    }
    [[self observatedViewController] translateObjectWithDeltaX:deltaX andDeltaY:deltaY andDeltaZ:deltaZ*2];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{

    self.fingersOnScreen -= [touches count];
    if( [self fingersOnScreen] == 0 ) [[self observatedViewController] touchesEnded];
    leftHand = NULL;
    rightHand = NULL;
}


@end
