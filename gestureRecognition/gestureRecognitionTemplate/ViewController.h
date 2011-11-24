//
//  ViewController.h
//  gestureRecognitionTemplate
//
//  Created by Dorian Bauer on 17/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "gestureRecognitionCommons.h"

@interface ViewController : UIViewController

@property(nonatomic) BOOL changeColor;

- (void)cleanScreen;

- (void)drawPointOnScreen:(CGPoint)pointToDraw;

- (void)spiraleDetectedBy:(UIGestureRecognizer *)gestureRecognizer withOrientation:(UIScrewOrientation)orientation andMouvementDirection:(UIMouvementDirection)direction;


@end
