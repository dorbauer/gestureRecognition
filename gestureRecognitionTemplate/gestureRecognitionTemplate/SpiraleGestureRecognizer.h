//
//  UIGestureRecognizer.h
//  gestureRecognitionTemplate
//
//  Created by Dorian Bauer on 17/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewController.h"

@interface SpiraleGestureRecognizer : UIGestureRecognizer
{

    ViewController *_vc;
}
@property(nonatomic, retain) ViewController *vc;

- (void)reset;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;

@end
