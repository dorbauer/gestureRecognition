//
//  openGLViewController.m
//  gestureRecognition
//
//  Created by Dorian Bauer on 14/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "openGLViewController.h"
#import "ConstantsAndMacros.h"
#import "OpenGLCommon.h"

#import "SpiraleGestureRecognizerUsingAngles.h"
#import "TwoFingersGestureRecognizerMartinet.h"

@interface openGLViewController(){}

- (void)solidTranslate:(Vertex3D *)vertices numberOfVertex:(int)nbVertex andDeltaX:(float)deltaX andDeltaY:(float)deltaY andDeltaZ:(float)deltaZ;

- (float)getXPositionFor:(int)testCase;
- (float)getYPositionFor:(int)testCase;
- (float)getZPositionFor:(int)testCase;

- (void)performZoom;
- (BOOL)detectColision;
- (BOOL)detectSuperposition;

@property (nonatomic) int testCase;
@property (nonatomic) BOOL success;

@end

@implementation openGLViewController

@synthesize glView = _glView;
@synthesize success = _success;
@synthesize testCase = _testCase;

static GLfloat kZTranslate = 0.0;
static GLfloat kXTranslate = 0.0;
static GLfloat kYTranslate = 0.0;

#pragma mark -  cube position definition

Vertex3D vertices[]= {
    {-0.25, 0.25, -2.75},             // vertices[0]
    {0.25, 0.25, -2.75},              // vertices[1]
    {0.25, -0.25, -2.75},             // vertices[2]
    {-0.25, -0.25, -2.75},            // vertices[3]
    {-0.25, 0.25, -3.25},            // vertices[4]
    {0.25, 0.25, -3.25},             // vertices[5]
    {0.25, -0.25, -3.25},            // vertices[6]
    {-0.25, -0.25, -3.25}            // vertices[7]
};
Vertex3D verticesTwo[]= {
    {-0.25, 0.25, 0.25},             // vertices[0]
    {0.25, 0.25, 0.25},              // vertices[1]
    {0.25, -0.25, 0.25},             // vertices[2]
    {-0.25, -0.25, 0.25},            // vertices[3]
    {-0.25, 0.25, -0.25},            // vertices[4]
    {0.25, 0.25, -0.25},             // vertices[5]
    {0.25, -0.25, -0.25},            // vertices[6]
    {-0.25, -0.25, -0.25}            // vertices[7]
};
Vertex3D verticesScene[] = {
    {-1, 1, 0},             // vertices[0]
    {1, 1, 0},              // vertices[1]
    {1, -1, 0},             // vertices[2]
    {-1, -1, 0},            // vertices[3]
    {-1, 1, -1},             // vertices[4]
    {1, 1, -1},              // vertices[5]
    {1, -1, -1},             // vertices[6]
    {-1, -1, -1},            // vertices[7]
    
};
Vertex3D verticesScene2[] = {
    {-0.5, 0.5, 0},             // vertices[0]
    {0.5, 0.5, 0},              // vertices[1]
    {0.5, -0.5, 0},             // vertices[2]
    {-0.5, -0.5, 0},            // vertices[3]
    {-0.5, 0.5, -0.5},             // vertices[4]
    {0.5, 0.5, -0.5},              // vertices[5]
    {0.5, -0.5, -0.5},             // vertices[6]
    {-0.5, -0.5, -0.5},            // vertices[7]
    
};

static const GLubyte cubeFaces[] = {
    
    //Front Face
    0, 1, 2,
    0, 2, 3,
    
    //Right Face
    1, 2, 5,
    2, 5, 6,
    
    //Left Face
    0, 4, 3,
    7, 4, 3,
    
    //Rear Face
    4, 5, 6,
    4, 6, 7,
    
    //Upper Face
    2, 3, 7,
    2, 7, 6,
    
    //Bottom Face
    0, 1, 4,
    1, 4, 5,
};
static const GLubyte sceneFaces[] = {
    
    0,3,7,
    0,4,7,
    
    0,1,5,
    0,5,4,
    
    5,6,7,
    5,4,7,
    
    2,6,7,
    2,3,7,
    
};

static const Color3D colorsScene[] = {
    {0.7, 0.7, 0.7, 1.0},
    {0.7, 0.7, 0.7, 1.0},
    {0.7, 0.7, 0.7, 1.0},
    {0.7, 0.7, 0.7, 1.0},
    {0.3, 0.3, 0.3, 1.0},
    {0.3, 0.3, 0.3, 1.0},
    {0.3, 0.3, 0.3, 1.0},
    {0.3, 0.3, 0.3, 1.0}
    
};
static const Color3D colors[] = {
    {1.0, 0.0, 0.0, 1.0},               
    {1.0, 0.5, 0.0, 1.0},               
    {1.0, 0.5, 0.0, 1.0}, 
    {1.0, 0.0, 0.0, 1.0},               
    {1.0, 0.0, 0.0, 1.0},               
    {1.0, 0.5, 0.0, 1.0},               
    {1.0, 0.5, 0.0, 1.0}, 
    {1.0, 0.0, 0.0, 1.0}             
};
static const Color3D colorsTwo[] = {
    {0.0, 1.0, 1.0, 1.0},            
    {0.0, 0.5, 1.0, 1.0},           
    {0.0, 0.5, 1.0, 1.0},  
    {0.0, 1.0, 1.0, 1.0},
    {0.0, 1.0, 1.0, 1.0},
    {0.0, 0.5, 1.0, 1.0},
    {0.0, 0.5, 1.0, 1.0},  
    {0.0, 1.0, 1.0, 1.0}
};
static const Color3D successColor[] = {
    {1.0, 1.0, 1.0, 1.0},            
    {1.0, 1.0, 1.0, 1.0},            
    {1.0, 1.0, 1.0, 1.0},            
    {1.0, 1.0, 1.0, 1.0},            
    {1.0, 1.0, 1.0, 1.0},            
    {1.0, 1.0, 1.0, 1.0},            
    {1.0, 1.0, 1.0, 1.0},            
    {1.0, 1.0, 1.0, 1.0}
};
static const Color3D colisionColor[] = {
    {0.0, 1.0, 1.0, 1.0},            
    {0.0, 0.5, 1.0, 1.0},           
    {0.0, 0.5, 1.0, 1.0},  
    {0.0, 1.0, 1.0, 1.0},
    {0.0, 1.0, 1.0, 1.0},
    {0.0, 0.5, 1.0, 1.0},
    {0.0, 0.5, 1.0, 1.0},  
    {0.0, 1.0, 1.0, 1.0}
};


#pragma Mark Testing Methods

- (float)getXPositionFor:(int)testCase{
    
    switch (testCase) {
        case 1:
            return kTestCaseOneX;
            break;
        case 2:
            return kTestCaseTwoX;
            break;
        case 3:
            return kTestCaseThreeX;
            break;
        case 4:
            return kTestCaseFourX;
            break;
        case 5:
            return kTestCaseFiveX;
            break;
        default:
            break;
    }
    return 0.0;
}
- (float)getYPositionFor:(int)testCase{
    
    switch (testCase) {
        case 1:
            return kTestCaseOneY;
            break;
        case 2:
            return kTestCaseTwoY;
            break;
        case 3:
            return kTestCaseThreeY;
            break;
        case 4:
            return kTestCaseFourY;
            break;
        case 5:
            return kTestCaseFiveY;
            break;
        default:
            break;
    }
    return 0.0;
}
- (float)getZPositionFor:(int)testCase{
    
    switch (testCase) {
        case 1:
            return kTestCaseOneZ;
            break;
        case 2:
            return kTestCaseTwoZ;
            break;
        case 3:
            return kTestCaseThreeZ;
            break;
        case 4:
            return kTestCaseFourZ;
            break;
        case 5:
            return kTestCaseFiveZ;
            break;
        default:
            break;
    }
    return 0.0;
}

#pragma mark spiraleGestureRecognizerDelegate Methods
- (void)spiraleDetectedBy:(UIGestureRecognizer *)gestureRecognizer withOrientation:(UIScrewOrientation)orientation andMouvementDirection:(UIMouvementDirection)direction{
    
    switch ( orientation ) {
        case UIScrewOrientationScrewOut:  kZTranslate +=1.0; break;
        case UIScrewOrientationScrewIn:   kZTranslate -= 1.0; break;
    }
    
    switch ( getHorizontalDirectionFromGlobal(direction) ) {
        case UIMouvementDirectionRight:   kXTranslate +=1.0; break;
        case UIMouvementDirectionLeft:    kXTranslate -= 1.0; break;
    }
    switch ( getVerticalDirectionFromGlobal(direction) ) {
        case UIMouvementDirectionTop:     kYTranslate +=1.0; break;
        case UIMouvementDirectionBottom:  kYTranslate -= 1.0; break;
    }
    
    NSLog(@"Z:%f    X:%f    Y:%f",kZTranslate,kXTranslate,kYTranslate);
    
    [self.glView drawView];
}


- (void)spiraleDetectedBy:(UIGestureRecognizer *)gestureRecognizer withOrientation:(UIScrewOrientation)orientation andHorizontalDelta:(int)deltaX andVerticalDelta:(int)deltaY{
    
    
    float deltaZ = 0.0;
    switch ( orientation ) {
        case UIScrewOrientationScrewOut:  deltaZ =  kDefaultScrewStep; break;
        case UIScrewOrientationScrewIn:   deltaZ = -kDefaultScrewStep; break;
    }
    
    [self solidTranslate:vertices numberOfVertex:8 andDeltaX:(deltaX/kScreenToOpenGLRatio)
               andDeltaY:(deltaY/kScreenToOpenGLRatio)
               andDeltaZ:(deltaZ)];
    
    [self.glView drawView];
}

-(void)translateObjectWithDeltaX:(int)deltaX andDeltaY:(int)deltaY andDeltaZ:(int)deltaZ{
    
    NSLog(@"Method 2 Called");
    NSLog(@"deltaX:%d      deltaY:%d      deltaZ:%d",deltaX,deltaY,deltaZ);
    
    [self solidTranslate:vertices numberOfVertex:8 andDeltaX:(deltaX/kScreenToOpenGLRatio)
               andDeltaY:(deltaY/kScreenToOpenGLRatio)
               andDeltaZ:(deltaZ/kScreenToOpenGLRatio)];
    [self.glView drawView];
}

-(void)doubleTapDetected{};

-(void)tripleTapDetected{
    
    if ([[[[self view] gestureRecognizers] objectAtIndex:0] isKindOfClass:[SpiraleGestureRecognizerUsingAngles class]]){
        
        NSLog(@"Switching to martinet !");
        TwoFingersGestureRecognizerMartinet *myGR = [[TwoFingersGestureRecognizerMartinet alloc] initWithTarget:self 
                                                                                                         action:@selector(handleGesture:)];
        myGR.observatedViewController = self;
        [self.view removeGestureRecognizer:[[[self view] gestureRecognizers] objectAtIndex:0]];
        [self.view addGestureRecognizer:myGR];
        
    }else if( [[[[self view] gestureRecognizers] objectAtIndex:0] isKindOfClass:[TwoFingersGestureRecognizerMartinet class]] ){
        
        NSLog(@"Switching to Angles Method");
        SpiraleGestureRecognizerUsingAngles *myGR =  [[SpiraleGestureRecognizerUsingAngles alloc] initWithTarget:self 
                                                                                                          action:@selector(handleGesture:)];
        myGR.observatedViewController = self;
        [self.view removeGestureRecognizer:[[[self view] gestureRecognizers] objectAtIndex:0]];
        [self.view addGestureRecognizer:myGR];
    }
    [self.view setMultipleTouchEnabled:YES];
}

-(void)touchesEnded{
    
    if ([self detectSuperposition] == YES) {
        
        
        if ([self testCase] < 5) {
            UIAlertView *alertBox = [[UIAlertView alloc] initWithTitle:@"Bravo"
                                                               message:@"Passons au test suivant !"
                                                              delegate:self 
                                                     cancelButtonTitle:@"OK " 
                                                     otherButtonTitles:nil];
            [alertBox show];
            
        }else{
            self.testCase = 6;
            UIAlertView *alertBox = [[UIAlertView alloc] initWithTitle:@"Merci" 
                                                               message:@"Autre Méthode ?" 
                                                              delegate:self 
                                                     cancelButtonTitle:nil otherButtonTitles:@"Martinet",@"Spirale",nil];
            [alertBox show];
        }
    }
}

-(BOOL)detectColision{
    
    return NO;    
}

-(BOOL)detectSuperposition{
    
    Vertex3D usersCube = vertices[0];
    Vertex3D testCube  = verticesTwo[0];
    
    float xLeft = testCube.x - kImprecisionFactor;
    float xRight = testCube.x + kImprecisionFactor;
    
    if (usersCube.x > xLeft && usersCube.x < xRight) {
        
        float yLeft = testCube.y - kImprecisionFactor;
        float yRight = testCube.y + kImprecisionFactor;
        
        if (usersCube.y > yLeft && usersCube.y < yRight) {
            
            float zLeft = testCube.z - kImprecisionFactor;
            float zRight = testCube.z + kImprecisionFactor;
            
            if (usersCube.z > zLeft && usersCube.z < zRight) {
                
                return YES;
            }
        }
    }
    return NO;
    
}

-(void)prepareCubesForNextTest{

    if( [self testCase] == 6){
    
        //Réinit test cube to orignial position
        [self solidTranslate:verticesTwo numberOfVertex:8 andDeltaX:(-1)*[self getXPositionFor:5]
                   andDeltaY:(-1)*[self getYPositionFor:5] 
                   andDeltaZ:(-1)*[self getZPositionFor:5]];
        self.testCase = 0;
    }else{
    
        //Réinit test cube to orignial position
        [self solidTranslate:verticesTwo numberOfVertex:8 andDeltaX:(-1)*[self getXPositionFor:[self testCase]]
                   andDeltaY:(-1)*[self getYPositionFor:[self testCase]] 
                   andDeltaZ:(-1)*[self getZPositionFor:[self testCase]]];  
    }

    self.testCase += 1;
    
    //Init au test case suivant
    [self solidTranslate:verticesTwo numberOfVertex:8 andDeltaX:[self getXPositionFor:[self testCase]]
               andDeltaY:[self getYPositionFor:[self testCase]] 
               andDeltaZ:[self getZPositionFor:[self testCase]]];

}

-(void)solidTranslate:(Vertex3D *)vertices numberOfVertex:(int)nbVertex andDeltaX:(float)deltaX andDeltaY:(float)deltaY andDeltaZ:(float)deltaZ{
    
    GLfloat x;
    GLfloat y;
    GLfloat z;
    Vertex3D vertex;
    
    for (int i=0; i<nbVertex; i++) {
        vertex = vertices[i];
        x = vertex.x+ deltaX;
        y = vertex.y+ deltaY;
        z = vertex.z+ deltaZ;
        Vertex3DSet(&vertices[i], x, y, z);
    }
}


#pragma mark glViewDelegate Methos

- (void)drawView:(UIView *)theView{
    
    glLoadIdentity();
    glClearColor(0.7, 0.7, 0.7, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    glEnableClientState(GL_VERTEX_ARRAY);
    glEnableClientState(GL_COLOR_ARRAY);
    
    //Drawing the scene
    GLfloat ambientAndDiffuse[] = {0.0, 0.1, 0.9, 1.0};
    GLfloat ambientAndDiffuse1[] = {1.0, 0.1, 0.9, 1.0};
    GLfloat ambientAndDiffuse2[] = {0.0, 1.1, 0.9, 1.0};
    glMaterialfv(GL_FRONT_AND_BACK, GL_AMBIENT_AND_DIFFUSE, ambientAndDiffuse);
    
    glColorPointer(4, GL_FLOAT, 0, colorsScene);
    glVertexPointer(3, GL_FLOAT, 0, verticesScene);
    glPushMatrix();
    
    glScalef(3, 4, 10);
    //glTranslatef(0, 0, -6);
    
    glDrawElements(GL_TRIANGLES, 24, GL_UNSIGNED_BYTE, sceneFaces);
    glPopMatrix();
    
    
    //Drawing first user's cube
    glVertexPointer(3, GL_FLOAT, 0, vertices);
    
    if([self detectSuperposition] == YES){
        glColorPointer(4, GL_FLOAT, 0, successColor);
        
    }/*else if( [self detectColision] == YES ){
      glColorPointer(4, GL_FLOAT, 0, colisionColor);
      
      }*/else{
          glColorPointer(4, GL_FLOAT, 0, colors);
      }
    
    glPushMatrix();
    //glMaterialfv(GL_FRONT_AND_BACK, GL_AMBIENT_AND_DIFFUSE, ambientAndDiffuse1);
    glDrawElements(GL_TRIANGLES, 36, GL_UNSIGNED_BYTE, cubeFaces);
    glPopMatrix();
    
    //Drawing exercice's cube
    glVertexPointer(3, GL_FLOAT, 0, verticesTwo);
    
    if([self detectSuperposition] == YES){
        glColorPointer(4, GL_FLOAT, 0, successColor);
        
    }else{
        glColorPointer(4, GL_FLOAT, 0, colorsTwo);
    }
    
    glPushMatrix();
    //glMaterialfv(GL_FRONT_AND_BACK, GL_AMBIENT_AND_DIFFUSE, ambientAndDiffuse2);
    glDrawElements(GL_TRIANGLES, 36, GL_UNSIGNED_BYTE, cubeFaces);
    glPopMatrix();
    
    glDisableClientState(GL_VERTEX_ARRAY);    
    //glDisableClientState(GL_COLOR_ARRAY);
    
}


GLfloat ambientLight[] = { 0.2f, 0.2f, 0.2f, 1.0f };
GLfloat diffuseLight[] = { 0.8f, 0.8f, 0.8, 1.0f };

const GLfloat light0Position[] = {0, 1, 1.0, 0.0}; 
const GLfloat light0Direction[] = {0.0, 0.0, -1.0};

-(void)setupView:(GLView*)view
{
    
	const GLfloat zNear = 0.01, zFar = 1000.0;
    CGRect rect = view.bounds;
    
	glEnable(GL_DEPTH_TEST);
	glMatrixMode(GL_PROJECTION); 
    
	//Setting up the perspective Viewport 
    GLfloat fieldOfView = 45.0;
    GLfloat size = zNear * tanf(DEGREES_TO_RADIANS(fieldOfView) / 2.0); 
    glFrustumf(-size,                                           // Left
               size,                                           // Right
               -size / (rect.size.width / rect.size.height),    // Bottom
               size / (rect.size.width / rect.size.height),    // Top
               zNear,                                          // Near
               zFar);                                          // Far*/
    
    glViewport(0, 0, rect.size.width, rect.size.height);  
	glMatrixMode(GL_MODELVIEW);
    
    glEnable(GL_LIGHTING);
    glEnable(GL_LIGHT0);
    glEnable(GL_COLOR_MATERIAL);
    glEnable(GL_SHADE_MODEL);
    glEnable(GL_NORMALIZE);
    
    glShadeModel(GL_SMOOTH);
    
    //glLightfv(GL_LIGHT0, GL_SPOT_DIRECTION, light0Direction);
    glLightfv(GL_LIGHT0, GL_AMBIENT, ambientLight);
    glLightfv(GL_LIGHT0, GL_DIFFUSE, diffuseLight);
    glLightfv(GL_LIGHT0, GL_POSITION, light0Position);
    
	glLoadIdentity();
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
}

#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    //Interaction Methode Selection
    if ([self testCase] == 0 || [self testCase] == 6) {
        //Remove previous gestureRecognizer
        NSArray *tmp = [self.view gestureRecognizers];
        [self.view removeGestureRecognizer:[tmp lastObject]];
        
        if (buttonIndex == 0) {
            
            TwoFingersGestureRecognizerMartinet *myGR = [[TwoFingersGestureRecognizerMartinet alloc] initWithTarget:self 
                                                                                                             action:@selector(handleGesture:)];
            myGR.observatedViewController = self;
            [self.view addGestureRecognizer:myGR];
            [self.view setMultipleTouchEnabled:YES];
        
        }else if( buttonIndex == 1){
        
            SpiraleGestureRecognizerUsingAngles *myGR =  [[SpiraleGestureRecognizerUsingAngles alloc] initWithTarget:self 
                                                                                                              action:@selector(handleGesture:)];
            myGR.observatedViewController = self;
            [self.view addGestureRecognizer:myGR];
            [self.view setMultipleTouchEnabled:YES];
        }
    }
    
    if ([self testCase] != 5) {
        
        [self prepareCubesForNextTest];
        [[self glView] drawView];
    
    }else{
    
    }
}

#pragma mark - View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _testCase = 0;

    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated{

    UIAlertView *alertBox = [[UIAlertView alloc] initWithTitle:@"Projet de synthèse" 
                                                       message:@"" 
                                                      delegate:self 
                                             cancelButtonTitle:nil otherButtonTitles:@"Martinet",@"Spirale",nil];
    [alertBox show];
}

- (void)viewDidLoad{   
    [super viewDidLoad];      
    
    //Setting up the delegate method
    [[self glView] setDelegate:self];
}

- (void)viewDidUnload{
    self.glView = nil;
    [super viewDidUnload];
}


@end
