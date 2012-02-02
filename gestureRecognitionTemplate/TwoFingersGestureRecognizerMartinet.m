//
//  SpiraleGestureRecognizerUsingAngles.m
//  gestureRecognition
//
//  Created by guillaume laas on 19/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TwoFingersGestureRecognizerMartinet.h"



#pragma mark - Private Interface

@interface TwoFingersGestureRecognizerMartinet(){}

@property (nonatomic) int fingersOnScreen;

@end

#pragma mark - Implementation

@implementation TwoFingersGestureRecognizerMartinet

@synthesize fingersOnScreen = _fingersOnScreen;

- (id)init {
    _fingersOnScreen = 0;
    return self;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    NSLog(@"YYYYYYOOOOOOOUUUUUUHHHHHHOOOOOOOUUUUUU");
    
    self.fingersOnScreen += [touches count];
    
    UITouch *touch = [touches.allObjects objectAtIndex:0];
    if ([touch tapCount] == 3) {
        [[self observatedViewController] tripleTapDetected];
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
    
    ///GROS BUG  DE REPERE !! Normalement X et getVertical !!
    if (currentTouch.y < ([[touch view] frame].size.height)/4 ) {
        deltaZ = getHorizontalDelta(currentTouch, previousTouch);
        
    }else{
        deltaY = getVerticalDelta(previousTouch, currentTouch);
        deltaX = getHorizontalDelta(previousTouch, currentTouch);
    }

    [[self observatedViewController] translateObjectWithDeltaX:deltaX andDeltaY:deltaY andDeltaZ:deltaZ*2];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{

    self.fingersOnScreen -= [touches count];
    if( [self fingersOnScreen] == 0 ) [[self observatedViewController] touchesEnded];
}


@end
