//
//  gestureRecognitionCommons.h
//  gestureRecognitionTemplate
//
//  Created by Dorian Bauer on 17/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#ifndef gestureRecognitionTemplate_gestureRecognitionCommons_h
#define gestureRecognitionTemplate_gestureRecognitionCommons_h

//OpenGl
#define kZoomUpdateInterval 0.1
#define kScreenToOpenGLRatio 336.84
#define kDefaultScrewStep 0.02
#define kDefaultDeltaZ 40.0
#define kImprecisionFactor 0.05

//User Test Cube Position
#define kTestCaseOneX     -2.5
#define kTestCaseTwoX      1.5
#define kTestCaseThreeX   -2.5
#define kTestCaseFourX    -0.5
#define kTestCaseFiveX     2.5

#define kTestCaseOneY      3.0
#define kTestCaseTwoY     -2.5
#define kTestCaseThreeY   -3.0
#define kTestCaseFourY    -0.5
#define kTestCaseFiveY    -4.0

#define kTestCaseOneZ     -8.0
#define kTestCaseTwoZ     -6.0
#define kTestCaseThreeZ   -7.5
#define kTestCaseFourZ    -1.5   
#define kTestCaseFiveZ    -9.0


//Switching ViewController Constatns
#define kDetectionTestViewController FALSE

//Method used
#define methodeDesAnglesCapablesUtilisees TRUE
#define methodeMartinet FALSE

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
    
    UIScrewOrientationNil = 0,
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

static inline int getHorizontalDelta(CGPoint firstPoint, CGPoint secondPoint){

    return (secondPoint.x - firstPoint.x);
}

static inline int getVerticalDelta(CGPoint firstPoint, CGPoint secondPoint){
    
    return (firstPoint.y - secondPoint.y);
}

static inline UIMouvementDirection getHorizontalDirectionFromGlobal(UIMouvementDirection direction){

    return direction/10;
}

static inline UIMouvementDirection getVerticalDirectionFromGlobal(UIMouvementDirection direction){
    
    return direction%10;
}

#endif
