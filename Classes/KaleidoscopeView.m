//
//  KaleidoscopeView.m
//  Kaleidoscope
//

#import <QuartzCore/QuartzCore.h>
#import "KaleidoscopeView.h"
#import "KaleidoscopeAppDelegate.h"


CGFloat DegreesToRadians(CGFloat degrees) {return degrees * M_PI / 180;};
CGFloat RadiansToDegrees(CGFloat radians) {return radians * 180 / M_PI;};


@implementation CALayer(NSKeyValueObserving)


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqual:@"squareBounds"]) {
		self.bounds = [[change objectForKey:NSKeyValueChangeNewKey] CGRectValue];
	} else {
		self.position = [[change objectForKey:NSKeyValueChangeNewKey] CGPointValue];
	}
}


@end


#define BASE_SIZE_OF_SQUARE 108.
#define MIN_SIZE_OF_SQUARE 40.
#define MAX_SIZE_OF_SQUARE 480./2


@implementation KaleidoscopeView

@synthesize points;
@synthesize squareBounds;
@synthesize currentTouch;
@synthesize rotateLayer;

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super initWithCoder:decoder]) {
        // Initialization code
		CGRect squareRect = CGRectMake(0, 0, BASE_SIZE_OF_SQUARE, BASE_SIZE_OF_SQUARE);
		self.squareBounds = [NSValue valueWithCGRect:squareRect];
		
		CGFloat width = squareRect.size.width;
		CGFloat height = squareRect.size.height;
		NSArray *horizontal = [NSArray arrayWithObjects:
							   [NSNumber numberWithInt:0],
							   [NSNumber numberWithInt:-2],
							   [NSNumber numberWithInt:2],
							   [NSNumber numberWithInt:-4],
							   [NSNumber numberWithInt:4],
							   nil];
		NSArray *vertical = [NSArray arrayWithObjects:
							 [NSNumber numberWithInt:0],
							 [NSNumber numberWithInt:-2],
							 [NSNumber numberWithInt:2],
							 [NSNumber numberWithInt:-4],
							 [NSNumber numberWithInt:4],
							 [NSNumber numberWithInt:-6],
							 [NSNumber numberWithInt:6],
							 nil];
		
		self.points = [NSMutableDictionary dictionaryWithCapacity:[horizontal count]*[vertical count]];
		for (NSNumber *h in horizontal) {
			for (NSNumber *v in vertical) {
				[self.points setObject:[NSValue valueWithCGPoint:CGPointMake(width*[h floatValue],height*[v floatValue])] forKey:[NSString stringWithFormat:@"%d,%d", [h intValue], [v intValue]]];
			}
		}
    }
    return self;
}


- (void)dealloc {
	[points release];
	[squareBounds release];
	[rotateLayer release];
    [super dealloc];
}


#pragma mark layer operations


- (CALayer*)createSquare {
	KaleidoscopeAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
	UIView *previewView = [appDelegate.cameraController performSelector:@selector(previewView)];
	id contents = previewView.layer.contents;
	if (!contents) {
		contents = [[previewView.layer.sublayers objectAtIndex:0] contents];
	}
	
	CALayer *contentsLayer = [CALayer layer];
	contentsLayer.contentsGravity = kCAGravityCenter;
	contentsLayer.bounds = CGRectMake(0, 0, MAX_SIZE_OF_SQUARE, MAX_SIZE_OF_SQUARE);
	contentsLayer.position = CGPointMake(MAX_SIZE_OF_SQUARE/2, MAX_SIZE_OF_SQUARE/2);
	contentsLayer.contents = contents;
	contentsLayer.transform = CATransform3DMakeRotation(DegreesToRadians(90.), 0., 0., 1.);
	
	CALayer *squareLayer = [CALayer layer];
	squareLayer.position = CGPointMake(0, 0);
	squareLayer.anchorPoint = CGPointMake(0, 0);
	squareLayer.bounds = [self.squareBounds CGRectValue];
	squareLayer.masksToBounds = YES;
	[squareLayer addSublayer:contentsLayer];
	return squareLayer;
}


- (void)tileSquares {
	CGRect screenRect = [[UIScreen mainScreen] bounds];
	self.layer.sublayerTransform = CATransform3DMakeTranslation(screenRect.size.width/2, screenRect.size.height/2, 0);
	
	self.rotateLayer = [CALayer layer];
	CALayer *squareLayer;
	for (NSString *k in [self.points allKeys]) {
		NSValue *v = [self.points objectForKey:k];
		NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
		
		squareLayer = [self createSquare];
		squareLayer.position = [v CGPointValue];
		[rotateLayer addSublayer:squareLayer];
		[self.points addObserver:squareLayer forKeyPath:k options:options context:NULL];
		[self addObserver:squareLayer forKeyPath:@"squareBounds" options:options context:NULL];
		
		squareLayer = [self createSquare];
		squareLayer.transform = CATransform3DMakeScale(-1, 1, 1);
		squareLayer.position = [v CGPointValue];
		[rotateLayer addSublayer:squareLayer];
		[self.points addObserver:squareLayer forKeyPath:k options:options context:NULL];
		[self addObserver:squareLayer forKeyPath:@"squareBounds" options:options context:NULL];
		
		squareLayer = [self createSquare];
		squareLayer.transform = CATransform3DMakeScale(1, -1, 1);
		squareLayer.position = [v CGPointValue];
		[rotateLayer addSublayer:squareLayer];
		[self.points addObserver:squareLayer forKeyPath:k options:options context:NULL];
		[self addObserver:squareLayer forKeyPath:@"squareBounds" options:options context:NULL];
		
		squareLayer = [self createSquare];
		squareLayer.transform = CATransform3DMakeScale(-1, -1, 1);
		squareLayer.position = [v CGPointValue];
		[rotateLayer addSublayer:squareLayer];
		[self.points addObserver:squareLayer forKeyPath:k options:options context:NULL];
		[self addObserver:squareLayer forKeyPath:@"squareBounds" options:options context:NULL];
	}
	[self.layer addSublayer:self.rotateLayer];
}


- (void)recalcPoints {
	CGRect squareRect = [self.squareBounds CGRectValue];
	CGFloat width = squareRect.size.width;
	CGFloat height = squareRect.size.height;
	
	for (NSString *k in [points allKeys]) {
		NSScanner *scanner = [NSScanner scannerWithString:k];
		CGFloat h,v;
		if ([scanner scanFloat:&h] && [scanner scanString:@"," intoString:nil] && [scanner scanFloat:&v]) {
			[self.points setObject:[NSValue valueWithCGPoint:CGPointMake(width*h, height*v)] forKey:k];
		}
	}
}


- (void)addSquareSize:(CGFloat)delta {
	CGRect rect = [self.squareBounds CGRectValue];
	if (rect.size.width+delta < MIN_SIZE_OF_SQUARE) {
		self.squareBounds = [NSValue valueWithCGRect:CGRectMake(0, 0, MIN_SIZE_OF_SQUARE, MIN_SIZE_OF_SQUARE)];
	} else if (rect.size.width+delta > MAX_SIZE_OF_SQUARE) {
		self.squareBounds = [NSValue valueWithCGRect:CGRectMake(0, 0, MAX_SIZE_OF_SQUARE, MAX_SIZE_OF_SQUARE)];
	} else {
		self.squareBounds = [NSValue valueWithCGRect:CGRectMake(0, 0, rect.size.width+delta, rect.size.width+delta)];
	}
	[self recalcPoints];
}


#pragma mark UIResponder methods


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	if (!currentTouch) {
		currentTouch = [touches anyObject];
	}
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	if ([touches containsObject:currentTouch]) {
		[CATransaction begin];
		[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
		
		CGPoint prevPoint = [currentTouch previousLocationInView:self];
		CGPoint curPoint = [currentTouch locationInView:self];
		CGFloat sizeDelta = sqrt(curPoint.x*curPoint.x + curPoint.y*curPoint.y) - sqrt(prevPoint.x*prevPoint.x + prevPoint.y*prevPoint.y);
		[self addSquareSize:sizeDelta];

//		Next codes works only iPhone 3GS
//		CGFloat curRadian = acos(curPoint.x/sqrt(curPoint.x*curPoint.x + curPoint.y*curPoint.y));
//		if (curPoint.y < 0) curRadian = M_PI*2 - curRadian;
//		CGFloat prevRadian = acos(prevPoint.x/sqrt(prevPoint.x*prevPoint.x + prevPoint.y*prevPoint.y));
//		if (prevPoint.y < 0) prevRadian = M_PI*2 - prevRadian;
//		self.rotateLayer.transform = CATransform3DRotate(self.rotateLayer.transform, curRadian - prevRadian, 0, 0, 1);
		
		[CATransaction commit];
	}
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	if ([touches containsObject:currentTouch]) {
		currentTouch = nil;
	}
}


- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	if ([touches containsObject:currentTouch]) {
		currentTouch = nil;
	}
}


@end
