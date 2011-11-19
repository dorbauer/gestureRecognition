//
//  gestureRecognitionCommons.h
//  gestureRecognitionTemplate
//
//  Created by Dorian Bauer on 17/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#ifndef gestureRecognitionTemplate_gestureRecognitionCommons_h
#define gestureRecognitionTemplate_gestureRecognitionCommons_h

//Spirale Orientation
typedef enum {
    
    UISpiraleOrientationRight = 1,
    UISpiraleOrientationLeft = 2,
    
} UISpiraleOrientation;

//Quarter Mouvement directions

typedef enum {
    
    UIMouvementDirectionNoDirection = 0,
    UIMouvementDirectionRightTop = 1,
    UIMouvementDirectionRightBottom = 2,
    UIMouvementDirectionLeftTop = 3,
    UIMouvementDirectionLeftBottom = 4,

} UIMouvementDirection;

#endif
