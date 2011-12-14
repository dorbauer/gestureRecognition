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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

#pragma mark glViewDelegate Methos

- (void)drawView:(UIView *)theView
{
#ifdef DEBUG
    NSLog(@"DrawView Called openGLController ");
#endif
    
    Vertex3D    vertex1 = Vertex3DMake(0.0, 1.0, -3.0);
    Vertex3D    vertex2 = Vertex3DMake(1.0, 0.0, -3.0);
    Vertex3D    vertex3 = Vertex3DMake(-1.0, 0.0, -3.0);
    Triangle3D  triangle = Triangle3DMake(vertex1, vertex2, vertex3);
    
    glLoadIdentity();
    glClearColor(0.7, 0.7, 0.7, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    glEnableClientState(GL_VERTEX_ARRAY);
    glColor4f(1.0, 0.0, 0.0, 1.0);
    
    glVertexPointer(3, GL_FLOAT, 0, &triangle);
    glDrawArrays(GL_TRIANGLES, 0, 9);
    glDisableClientState(GL_VERTEX_ARRAY);    
}
-(void)setupView:(GLView*)view
{
#ifdef DEBUG
    NSLog(@"setupView openGLController");
#endif
    
	const GLfloat zNear = 0.01, zFar = 1000.0, fieldOfView = 45.0; 
	GLfloat size; 
	glEnable(GL_DEPTH_TEST);
	glMatrixMode(GL_PROJECTION); 
	size = zNear * tanf(DEGREES_TO_RADIANS(fieldOfView) / 2.0); 
	CGRect rect = view.bounds; 
	glFrustumf(-size, size, -size / (rect.size.width / rect.size.height), size / 
			   (rect.size.width / rect.size.height), zNear, zFar); 
	glViewport(0, 0, rect.size.width, rect.size.height);  
	glMatrixMode(GL_MODELVIEW);
	
	glLoadIdentity(); 
}

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

#pragma mark - View lifecycle

- (void)viewDidLoad
{   
    [super viewDidLoad];  
    
    //Setting up the delegate method
    [[self glView] setDelegate:self];
    
    glView.animationInterval = 1.0 / kRenderingFrequency;
    [glView startAnimation];
}

- (void)viewDidUnload
{
    self.glView = nil;
    [super viewDidUnload];
}


@end
