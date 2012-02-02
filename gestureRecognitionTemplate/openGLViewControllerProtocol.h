//
//  openGLViewControllerProtocol.h
//  gestureRecognition
//
//  Created by Dorian Bauer on 26/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef gestureRecognition_openGLViewControllerProtocol_h
#define gestureRecognition_openGLViewControllerProtocol_h

#import <Foundation/Foundation.h>

@protocol OpenGLViewControllerProtocol
- (void)moveObjectwithHorizontalDelta:(int)deltaX andVerticalDelta:(int)deltaY;
@end


#endif
