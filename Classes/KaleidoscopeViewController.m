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


#define BASE_SIZE_OF_TRIANGLE 108.


- (CALayer*)createEquilateralTriangle {
	KaleidoscopeAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
	UIView *previewView = [appDelegate.cameraController performSelector:@selector(previewView)];
	id contents = previewView.layer.contents;
	if (!contents) {
		contents = [[previewView.layer.sublayers objectAtIndex:0] contents];
	}
	CGFloat height = BASE_SIZE_OF_TRIANGLE * sinf(DegreesToRadians(60.));
	
	CGMutablePathRef path = CGPathCreateMutable();
	CGPathMoveToPoint(path, NULL, 0, 0);
	CGAffineTransform rotate60degrees = CGAffineTransformMakeRotation(DegreesToRadians(-60.));
	CGPathAddLineToPoint(path, &rotate60degrees, 0, BASE_SIZE_OF_TRIANGLE);
	CGPathAddLineToPoint(path, NULL, 0, BASE_SIZE_OF_TRIANGLE);
	CGPathCloseSubpath(path);
	
	CAShapeLayer *maskShapeLayer = [CAShapeLayer layer];
	maskShapeLayer.path = path;
	maskShapeLayer.lineWidth = 1;
	
//	UIGraphicsBeginImageContext(CGSizeMake(height, BASE_SIZE_OF_TRIANGLE));
//	CGContextRef ctx = UIGraphicsGetCurrentContext();
//	CGContextBeginPath(ctx);
//	CGContextAddPath(ctx, path);
//	UIColor *fillColor = [UIColor colorWithWhite:1 alpha:1];
//	CGContextSetFillColorSpace(ctx, CGColorGetColorSpace(fillColor.CGColor));
//	CGContextSetFillColorWithColor(ctx, fillColor.CGColor);
//	CGContextFillPath(ctx);
//	UIImage *maskImage = UIGraphicsGetImageFromCurrentImageContext();
//	CALayer *maskImageLayer = [CALayer layer];
//	maskImageLayer.contents = (id)maskImage.CGImage;
//	maskImageLayer.contentsGravity = kCAGravityCenter;
//	maskImageLayer.bounds = CGRectMake(0, 0, height, BASE_SIZE_OF_TRIANGLE);
//	UIGraphicsEndImageContext();
	
	CALayer *contentsLayer = [CALayer layer];
	contentsLayer.contentsGravity = kCAGravityCenter;
	contentsLayer.bounds = CGRectMake(0, 0, height, BASE_SIZE_OF_TRIANGLE);
	contentsLayer.position = CGPointMake(BASE_SIZE_OF_TRIANGLE/2, height/2);
	contentsLayer.contents = contents;
	contentsLayer.masksToBounds = YES;
	contentsLayer.transform = CATransform3DMakeRotation(DegreesToRadians(90.), 0., 0., 1.);
//	contentsLayer.mask = maskImageLayer;
	contentsLayer.mask = maskShapeLayer;

	CALayer *layer = [CALayer layer];
	layer.position = CGPointMake(0, 0);
	layer.anchorPoint = CGPointMake(0, 0);
	layer.bounds = CGRectMake(0, 0, BASE_SIZE_OF_TRIANGLE, height);
	[layer addSublayer:contentsLayer];
	return layer;
}


- (void)viewDidLoad {
    [super viewDidLoad];
	CGRect screenRect = [[UIScreen mainScreen] bounds];
	self.view.layer.sublayerTransform = CATransform3DMakeTranslation(screenRect.size.width/2, screenRect.size.height/2, 0);
	CALayer *layer;
	
	CGFloat height = BASE_SIZE_OF_TRIANGLE * sinf(DegreesToRadians(60.));
	
	NSArray *pointArray = [NSArray arrayWithObjects:
						   [NSValue valueWithCGPoint:CGPointMake(0,0)],
						   [NSValue valueWithCGPoint:CGPointApplyAffineTransform(CGPointMake(0,0), CGAffineTransformMakeTranslation(0, height*-2))],
						   [NSValue valueWithCGPoint:CGPointApplyAffineTransform(CGPointMake(0,0), CGAffineTransformMakeTranslation(0, height*2))],
						   [NSValue valueWithCGPoint:CGPointApplyAffineTransform(CGPointMake(0,0), CGAffineTransformMakeTranslation(BASE_SIZE_OF_TRIANGLE*1.5, height*-1))],
						   [NSValue valueWithCGPoint:CGPointApplyAffineTransform(CGPointMake(0,0), CGAffineTransformMakeTranslation(BASE_SIZE_OF_TRIANGLE*1.5, height))],
						   [NSValue valueWithCGPoint:CGPointApplyAffineTransform(CGPointMake(0,0), CGAffineTransformMakeTranslation(BASE_SIZE_OF_TRIANGLE*-1.5, height*-1))],
						   [NSValue valueWithCGPoint:CGPointApplyAffineTransform(CGPointMake(0,0), CGAffineTransformMakeTranslation(BASE_SIZE_OF_TRIANGLE*-1.5, height))],
						   [NSValue valueWithCGPoint:CGPointApplyAffineTransform(CGPointMake(0,0), CGAffineTransformMakeTranslation(BASE_SIZE_OF_TRIANGLE*1.5, height*-3))],
						   [NSValue valueWithCGPoint:CGPointApplyAffineTransform(CGPointMake(0,0), CGAffineTransformMakeTranslation(BASE_SIZE_OF_TRIANGLE*1.5, height*3))],
						   [NSValue valueWithCGPoint:CGPointApplyAffineTransform(CGPointMake(0,0), CGAffineTransformMakeTranslation(BASE_SIZE_OF_TRIANGLE*-1.5, height*-3))],
						   [NSValue valueWithCGPoint:CGPointApplyAffineTransform(CGPointMake(0,0), CGAffineTransformMakeTranslation(BASE_SIZE_OF_TRIANGLE*-1.5, height*3))],
						   nil];
	
	for (NSValue *v in pointArray) {
		layer = [self createEquilateralTriangle];
		layer.position = [v CGPointValue];
		[self.view.layer addSublayer:layer];
		
		layer = [self createEquilateralTriangle];
		layer.transform = CATransform3DMakeScale(1, -1, 1);
		layer.position = [v CGPointValue];
		[self.view.layer addSublayer:layer];
		
		layer = [self createEquilateralTriangle];
		layer.transform = CATransform3DMakeRotation(DegreesToRadians(-120.), 0, 0, 1);
		layer.position = [v CGPointValue];
		[self.view.layer addSublayer:layer];
		
		layer = [self createEquilateralTriangle];
		layer.transform = CATransform3DConcat(CATransform3DMakeScale(1, -1, 1), CATransform3DMakeRotation(DegreesToRadians(-120.), 0, 0, 1));
		layer.position = [v CGPointValue];
		[self.view.layer addSublayer:layer];
		
		layer = [self createEquilateralTriangle];
		layer.transform = CATransform3DConcat(CATransform3DMakeScale(1, -1, 1), CATransform3DMakeRotation(DegreesToRadians(120.), 0, 0, 1));
		layer.position = [v CGPointValue];
		[self.view.layer addSublayer:layer];
		
		layer = [self createEquilateralTriangle];
		layer.transform = CATransform3DMakeRotation(DegreesToRadians(120.), 0, 0, 1);
		layer.position = [v CGPointValue];
		[self.view.layer addSublayer:layer];
	}
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
