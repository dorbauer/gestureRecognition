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

@implementation openGLViewController

@synthesize glView = _glView;

static GLfloat kZTranslate = 0.0;

static const Vertex3D vertices[]= {
    
    {-0.5, -0.5, -7.5},                 // vertices[0]
    {0.5, -0.5, -7.5},                  // vertices[1]
    {0.5, 0.5, -7.5},                   // vertices[2]
    {-0.5, 0.5, -7.5},                  // vertices[3]
    {-0.5, -0.5, -8.5},                 // vertices[4]
    {0.5, -0.5, -8.5},                  // vertices[5]
    {0.5, 0.5, -8.5},                   // vertices[6]
    {-0.5, 0.5, -8.5},                  // vertices[7]
    
};
static const Color3D colors[] = {
    
    {1.0, 0.0, 0.0, 1.0},               // vertices[0]
    {1.0, 0.5, 0.0, 1.0},               // vertices[1]
    {1.0, 1.0, 0.0, 1.0},               // vertices[2]
    {0.5, 1.0, 0.0, 1.0},               // vertices[3]
    {0.0, 1.0, 0.0, 1.0},               // vertices[4]  
    {0.0, 1.0, 0.5, 1.0},               // vertices[5]
    {0.0, 1.0, 1.0, 1.0},               // vertices[6]
    {0.0, 0.5, 1.0, 1.0},               // vertices[7]
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


#pragma mark spiraleGestureRecognizerDelegate Methods
- (void)spiraleDetectedBy:(UIGestureRecognizer *)gestureRecognizer withOrientation:(UIScrewOrientation)orientation andMouvementDirection:(UIMouvementDirection)direction
{
#ifdef DEBUG
    NSLog(@"spiraleGestureRecognizerDelegate Method Called");
#endif
    
    if (orientation == UIScrewOrientationScrewIn){
        kZTranslate -= 0.1;
        
#ifdef DEBUG
        NSLog(@"______________________ Utilisateur veux visser  ");
#endif
        
    }else{
        kZTranslate += 0.1;

#ifdef DEBUG
        NSLog(@"______________________ Utilisateur veux dévisser  ");
#endif
    }
    
#ifdef DEBUG    
    NSLog(@"______________________Direction générale du mouvement: %d",direction);
    
#endif
    //Perform animation here ?
}

- (void)doubleTapDetected
{
    return;
}


#pragma mark glViewDelegate Methos

- (void)drawView:(UIView *)theView
{
#ifdef DEBUG
    NSLog(@"DrawView Called openGLController ");
#endif
    
    glLoadIdentity();
    glClearColor(0.7, 0.7, 0.7, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    glEnableClientState(GL_VERTEX_ARRAY);
    glEnableClientState(GL_COLOR_ARRAY);
    
    glVertexPointer(3, GL_FLOAT, 0, vertices);
    glColorPointer(4, GL_FLOAT, 0, colors);
    
    glPushMatrix();
        NSLog(@"kZTranslate: %f",kZTranslate);
        glTranslatef(0, 0, kZTranslate);
        glDrawElements(GL_TRIANGLES, 36, GL_UNSIGNED_BYTE, cubeFaces);
    glPopMatrix();
    
    glDisableClientState(GL_VERTEX_ARRAY);    
    glDisableClientState(GL_COLOR_ARRAY);    
}

-(void)setupView:(GLView*)view
{
#ifdef DEBUG
    NSLog(@"setupView openGLController");
#endif
    
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
	
	glLoadIdentity(); 
}


#pragma mark - View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{   
    [super viewDidLoad];  
    //Setting up the spiralGestureRecognizer
    
    SpiraleGestureRecognizer *customGR;
#if methodeDesAnglesCapablesUtilisees
     customGR =  [[SpiraleGestureRecognizerUsingAngles alloc] initWithTarget:self action:@selector(handleGesture:)];
#else
     customGR =  [[SpiraleGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
#endif
    customGR.observatedViewController = self;
    [self.view addGestureRecognizer:customGR];
    
    //Setting up the delegate method
    [[self glView] setDelegate:self];
    [[self glView] setAnimationInterval:( 1.0 / kRenderingFrequency)];
    [[self glView] startAnimation];
}

- (void)viewDidUnload
{
    self.glView = nil;
    [super viewDidUnload];
}

#pragma mark Misc

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}


- (void)didReceiveMemoryWarning
{
#ifdef DEBUG
    NSLog(@"didReceiveMemoryWarning openGLController");
#endif    
    
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}


@end
