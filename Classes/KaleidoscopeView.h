//
//  KaleidoscopeView.h
//  Kaleidoscope
//

#import <UIKit/UIKit.h>


@interface KaleidoscopeView : UIView {
	NSValue *squareBounds;
	NSMutableDictionary *points;
	UITouch *currentTouch;
	CALayer *rotateLayer;
	CALayer *resizeIndicator;
}

@property (nonatomic,retain) NSValue *squareBounds;
@property (nonatomic,retain) NSMutableDictionary *points;
@property (nonatomic,assign) UITouch *currentTouch;
@property (nonatomic,retain) CALayer *rotateLayer;
@property (nonatomic,retain) CALayer *resizeIndicator;

- (void)tileSquares;


@end
