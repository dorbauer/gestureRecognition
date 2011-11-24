//
//  gestureRecognitionCommons.h
//  gestureRecognitionTemplate
//
//  Created by Dorian Bauer on 17/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#ifndef gestureRecognitionTemplate_gestureRecognitionCommons_h
#define gestureRecognitionTemplate_gestureRecognitionCommons_h


// Constant for Pattern Recognition

#define kMinimumTouchesForPatternRecognition 5
#define kLeftCount @"LC"
#define kRightCount @"RC"
#define kXStraightCount @"XS"
#define kYStraightCount @"YS"
#define kBottomCount @"BC"
#define kTopCount @"TC"

//QuarterCirclePattern

typedef enum{

    UIQuarterCirclePatternNil = 0,
    
    UIQuarterCirclePatternN = 1,
    UIQuarterCirclePatternNW = 13,
    UIQuarterCirclePatternNE = 14,
    
    UIQuarterCirclePatternS = 2,
    UIQuarterCirclePatternSW = 23,
    UIQuarterCirclePatternSE = 24,
    
    
} UIQuarterCirclePattern;


//Spirale Orientation
typedef enum {
    
    UIScrewOrientationScrewIn = 1,
    UIScrewOrientationScrewOut = 2,
    
} UIScrewOrientation;

//Quarter Mouvement directions

typedef enum {
    
    UIMouvementDirectionNoDirection = 0,
    UIMouvementDirectionRight = 1,
    UIMouvementDirectionLeft = 2,
    UIMouvementDirectionTop = 3,
    UIMouvementDirectionBottom = 4,
    UIMouvementDirectionStraightX = 5,
    UIMouvementDirectionStraightY = 6,

    
    UIMouvementDirectionRightTop = 13,
    UIMouvementDirectionRightBottom = 14,
    UIMouvementDirectionLeftTop = 23,
    UIMouvementDirectionLeftBottom = 24,
    
    UIMouvementDirectionStraightTop = 53,
    UIMouvementDirectionStraightBottom = 54,
    UIMouvementDirectionLeftStraight = 26,
    UIMouvementDirectionRightStraight = 16,

} UIMouvementDirection;

#endif
