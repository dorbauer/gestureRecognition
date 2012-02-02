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
@property(nonatomic, strong) IBOutlet UIImageView *imageView; 
@property(nonatomic, strong) IBOutlet UILabel *detectionCountLabel;
@property(nonatomic, strong) IBOutlet UILabel *deltaTimeLabel;
@property(nonatomic, strong) IBOutlet UILabel *pointsNeededLabel;
@property(nonatomic, strong) IBOutlet UILabel *nouveauLabel;
- (void)drawPointOnScreen:(CGPoint)pointToDraw;

@end
