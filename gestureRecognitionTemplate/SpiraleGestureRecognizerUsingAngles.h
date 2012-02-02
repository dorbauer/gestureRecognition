//
//  SpiraleGestureRecognizerUsingAngles.h
//  gestureRecognition
//
//  Created by guillaume laas on 19/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SpiraleGestureRecognizer.h"


@interface SpiraleGestureRecognizerUsingAngles : SpiraleGestureRecognizer{

    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;

@end
