//
//  SpiraleGestureRecognizerMartinet.h
//  gestureRecognition
//
//  Created by Dorian Bauer on 26/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SpiraleGestureRecognizer.h"


@interface TwoFingersGestureRecognizerMartinet : SpiraleGestureRecognizer

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;

@end