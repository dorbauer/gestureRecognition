//
//  ViewController.m
//  gestureRecognitionTemplate
//
//  Created by Dorian Bauer on 17/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "detectionTestViewController.h"
#import "SpiraleGestureRecognizer.h"

@interface detectionTestViewController(){
@private
        CGPoint lastPoint;
        int _detectionsCount;
        int _highlightedPictureTag;
    
        NSDate *startTime;
        NSDate *stopTime;

}
@property(nonatomic, strong) IBOutlet UIImageView *imageView; 
@property(nonatomic, strong) IBOutlet UILabel *detectionCountLabel;
@property(nonatomic, strong) IBOutlet UILabel *deltaTimeLabel;
@property(nonatomic, strong) IBOutlet UILabel *pointsNeededLabel;
@end

@implementation detectionTestViewController
@synthesize imageView = _imageView;
@synthesize changeColor = _changeColor;
@synthesize deltaTimeLabel = _deltaTimeLabel;
@synthesize detectionCountLabel = _detectionCountLabel;
@synthesize pointsNeededLabel = _pointsNeededLabel;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - SpiraleGestureRecognizerDelegate Delegate Methods

// Clean the screen
- (void)doubleTapDetected{

    NSLog(@"\n\nClean Console Called \n\n");
    lastPoint.x = 0;
    lastPoint.y = 0;
    self.imageView.image = nil;
    
    UIImageView *tmp = (UIImageView*)[self.view viewWithTag:_highlightedPictureTag];
    tmp.highlighted = NO;
    _highlightedPictureTag = 0;
    _detectionsCount = 0;
    self.detectionCountLabel.text = @"DetectionsCount: 0";
    self.deltaTimeLabel.text = @"DeltaT: 0ms";
    self.pointsNeededLabel.text = @"First pattern detected after: 0 Points";
    
    startTime = nil;
    stopTime = nil;
    
    return;

}

- (void)spiraleDetectedBy:(UIGestureRecognizer *)gestureRecognizer withOrientation:(UIScrewOrientation)orientation andMouvementDirection:(UIMouvementDirection)direction{
    
    if (!stopTime) {
        stopTime = [NSDate date];
        self.deltaTimeLabel.text = [NSString stringWithFormat:@"DeltaT: %f ms",[stopTime timeIntervalSinceDate:startTime]];
        self.pointsNeededLabel.text = [NSString stringWithFormat:@"First pattern detected after: %d Points",[((SpiraleGestureRecognizer*)gestureRecognizer) touchCount] ];
    }
    
#ifdef DEBUG
    if (orientation == UIScrewOrientationScrewIn) NSLog(@"______________________ Utilisateur veux visser  ");
    else NSLog(@"______________________ Utilisateur veux dévisser  ");
    NSLog(@"______________________Direciton générale du mouvement: %d",direction);
#endif
    
    self.detectionCountLabel.text = [NSString stringWithFormat:@"DetectionsCount: %d",++_detectionsCount];
    
    
    if (_highlightedPictureTag != 0) [((UIImageView*)[self.view viewWithTag:_highlightedPictureTag]) setHighlighted:NO];
    
    _highlightedPictureTag = ((orientation*10)+(direction/10));
    UIImageView *tmp = (UIImageView*)[self.view viewWithTag:_highlightedPictureTag];
    tmp.highlighted = YES;
    
    
}

#pragma Mark - Draw On Screen Methods

- (void)drawPointOnScreen:(CGPoint)pointToDraw{
    
    if (!startTime) {
        startTime = [NSDate date];
    }
    
    if (lastPoint.x == 0 && lastPoint.y == 0) {
        lastPoint = pointToDraw;
        lastPoint.y -= 40;
    }
    pointToDraw.y -= 40;
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [self.imageView.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 5.0);
    
    if (self.changeColor) {
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 1.0, 0.0, 0.0, 1.0);
    }else{
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.0, 1.0, 0.0, 1.0);
    }
    
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), pointToDraw.x, pointToDraw.y);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    lastPoint = pointToDraw;

}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    //Setting up the SpiraleGestureRecognize
    SpiraleGestureRecognizer *customGR =  [[SpiraleGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    customGR.observatedViewController = self;
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
