//
//  SpiraleGestureRecognizerDelegate.h
//  gestureRecognition
//
//  Created by Dorian Bauer on 15/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "gestureRecognitionCommons.h"

@protocol SpiraleGestureRecognizerDelegate

- (void)spiraleDetectedBy:(UIGestureRecognizer *)gestureRecognizer withOrientation:(UIScrewOrientation)orientation 
                                                             andMouvementDirection:(UIMouvementDirection)direction;

- (void)spiraleDetectedBy:(UIGestureRecognizer *)gestureRecognizer withOrientation:(UIScrewOrientation)orientation 
                                                                 andHorizontalDelta:(int)deltaX 
                                                                  andVerticalDelta:(int)deltaY;

- (void)translateObjectWithDeltaX:(int)deltaX andDeltaY:(int)deltaY andDeltaZ:(int)deltaZ;

- (void)touchesEnded;

- (void)doubleTapDetected;

- (void)tripleTapDetected;

- (void)drawPointOnScreen:(CGPoint)pointToDraw;

- (void)setColor:(BOOL)color;
@end
