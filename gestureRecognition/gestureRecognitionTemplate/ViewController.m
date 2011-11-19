//
//  ViewController.m
//  gestureRecognitionTemplate
//
//  Created by Dorian Bauer on 17/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "SpiraleGestureRecognizer.h"

@interface ViewController(){
@private
        CGPoint lastPoint;
}
@property(nonatomic, strong) IBOutlet UIImageView *imageView; 
@end

@implementation ViewController
@synthesize imageView = _imageView;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Drawing On Screen Methods

- (void)cleanScreen{

    NSLog(@"Clean Console Called \n\n\n\n\n\n");
    lastPoint.x = 0;
    lastPoint.y = 0;
    self.imageView.image = nil;
    return;

}

- (void)drawPointOnScreen:(CGPoint)pointToDraw{

    if (lastPoint.x == 0 && lastPoint.y == 0) {
        lastPoint = pointToDraw;
        lastPoint.y -= 20;
    }
    
    pointToDraw.y -= 20;
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [self.imageView.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 5.0);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 1.0, 0.0, 0.0, 1.0);
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), pointToDraw.x, pointToDraw.y);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    lastPoint = pointToDraw;

}

#pragma mark - Gesture Recognition Hanlder Methods

- (void)spiraleDetectedBy:(UIGestureRecognizer *)gestureRecognizer withOrientation:(UIScrewOrientation)orientation{

}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    //Setting up the SpiraleGestureRecognize
    SpiraleGestureRecognizer *customGR =  [[SpiraleGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    customGR.vc = self;
    [self.view addGestureRecognizer:customGR];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if( interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown){
        return NO;
    }
    return YES;
}

@end
