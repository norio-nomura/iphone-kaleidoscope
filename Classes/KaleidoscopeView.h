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
}

@property (nonatomic,retain) NSValue *squareBounds;
@property (nonatomic,retain) NSMutableDictionary *points;
@property (nonatomic,assign) UITouch *currentTouch;
@property (nonatomic,retain) CALayer *rotateLayer;

- (void)tileSquares;


@end
