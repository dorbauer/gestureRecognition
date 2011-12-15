//
//  ViewController.h
//  gestureRecognitionTemplate
//
//  Created by Dorian Bauer on 17/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpiraleGestureRecognizerDelegate.h"

@interface detectionTestViewController : UIViewController <SpiraleGestureRecognizerDelegate>

@property(nonatomic) BOOL changeColor;

- (void)drawPointOnScreen:(CGPoint)pointToDraw;

@end
