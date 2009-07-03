//
//  KaleidoscopeViewController.m
//  Kaleidoscope
//

#import <QuartzCore/QuartzCore.h>
#import "KaleidoscopeViewController.h"
#import "KaleidoscopeAppDelegate.h"

CGFloat DegreesToRadians(CGFloat degrees) {return degrees * M_PI / 180;};
CGFloat RadiansToDegrees(CGFloat radians) {return radians * 180 / M_PI;};


@implementation KaleidoscopeViewController


#define BASE_SIZE_OF_SQUARE 108.


- (CALayer*)createSquare {
	KaleidoscopeAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
	UIView *previewView = [appDelegate.cameraController performSelector:@selector(previewView)];
	id contents = previewView.layer.contents;
	if (!contents) {
		contents = [[previewView.layer.sublayers objectAtIndex:0] contents];
	}
	
	CALayer *contentsLayer = [CALayer layer];
	contentsLayer.contentsGravity = kCAGravityCenter;
	contentsLayer.bounds = CGRectMake(0, 0, BASE_SIZE_OF_SQUARE, BASE_SIZE_OF_SQUARE);
	contentsLayer.position = CGPointMake(BASE_SIZE_OF_SQUARE/2, BASE_SIZE_OF_SQUARE/2);
	contentsLayer.contents = contents;
	contentsLayer.masksToBounds = YES;
	contentsLayer.transform = CATransform3DMakeRotation(DegreesToRadians(90.), 0., 0., 1.);
	
	CALayer *layer = [CALayer layer];
	layer.position = CGPointMake(0, 0);
	layer.anchorPoint = CGPointMake(0, 0);
	layer.bounds = CGRectMake(0, 0, BASE_SIZE_OF_SQUARE, BASE_SIZE_OF_SQUARE);
	[layer addSublayer:contentsLayer];
	return layer;
}


- (void)tileSquares {
	CGRect screenRect = [[UIScreen mainScreen] bounds];
	self.view.layer.sublayerTransform = CATransform3DMakeTranslation(screenRect.size.width/2, screenRect.size.height/2, 0);
	CALayer *layer;
	
	NSArray *pointArray = [NSArray arrayWithObjects:
						   [NSValue valueWithCGPoint:CGPointMake(0,0)],
						   [NSValue valueWithCGPoint:CGPointApplyAffineTransform(CGPointMake(0,0), CGAffineTransformMakeTranslation(0, BASE_SIZE_OF_SQUARE*-2))],
						   [NSValue valueWithCGPoint:CGPointApplyAffineTransform(CGPointMake(0,0), CGAffineTransformMakeTranslation(0, BASE_SIZE_OF_SQUARE*2))],
						   [NSValue valueWithCGPoint:CGPointMake(BASE_SIZE_OF_SQUARE*2,0)],
						   [NSValue valueWithCGPoint:CGPointApplyAffineTransform(CGPointMake(0,0), CGAffineTransformMakeTranslation(BASE_SIZE_OF_SQUARE*2, BASE_SIZE_OF_SQUARE*-2))],
						   [NSValue valueWithCGPoint:CGPointApplyAffineTransform(CGPointMake(0,0), CGAffineTransformMakeTranslation(BASE_SIZE_OF_SQUARE*2, BASE_SIZE_OF_SQUARE*2))],
						   [NSValue valueWithCGPoint:CGPointMake(BASE_SIZE_OF_SQUARE*-2,0)],
						   [NSValue valueWithCGPoint:CGPointApplyAffineTransform(CGPointMake(0,0), CGAffineTransformMakeTranslation(BASE_SIZE_OF_SQUARE*-2, BASE_SIZE_OF_SQUARE*-2))],
						   [NSValue valueWithCGPoint:CGPointApplyAffineTransform(CGPointMake(0,0), CGAffineTransformMakeTranslation(BASE_SIZE_OF_SQUARE*-2, BASE_SIZE_OF_SQUARE*2))],
						   nil];
	
	for (NSValue *v in pointArray) {
		layer = [self createSquare];
		layer.position = [v CGPointValue];
		[self.view.layer addSublayer:layer];
		
		layer = [self createSquare];
		layer.transform = CATransform3DMakeScale(-1, 1, 1);
		layer.position = [v CGPointValue];
		[self.view.layer addSublayer:layer];
		
		layer = [self createSquare];
		layer.transform = CATransform3DMakeScale(1, -1, 1);
		layer.position = [v CGPointValue];
		[self.view.layer addSublayer:layer];
		
		layer = [self createSquare];
		layer.transform = CATransform3DMakeScale(-1, -1, 1);
		layer.position = [v CGPointValue];
		[self.view.layer addSublayer:layer];
		
	}
}


- (void)viewDidLoad {
    [super viewDidLoad];
	[self tileSquares];
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
