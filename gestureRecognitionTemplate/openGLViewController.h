//
//  openGLViewController.h
//  gestureRecognition
//
//  Created by Dorian Bauer on 14/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLView.h"
#import "SpiraleGestureRecognizerDelegate.h"

@interface openGLViewController : UIViewController <GLViewDelegate, SpiraleGestureRecognizerDelegate, UIAlertViewDelegate >
{
    GLView *glView;
}
@property(nonatomic,retain) IBOutlet GLView *glView;



@end
