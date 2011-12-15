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
- (void)spiraleDetectedBy:(UIGestureRecognizer *)gestureRecognizer withOrientation:(UIScrewOrientation)orientation andMouvementDirection:(UIMouvementDirection)direction;
- (void)doubleTapDetected;
@end
