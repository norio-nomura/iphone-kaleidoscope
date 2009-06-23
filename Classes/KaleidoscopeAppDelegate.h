//
//  KaleidoscopeAppDelegate.h
//  Kaleidoscope
//

#import <UIKit/UIKit.h>

@class KaleidoscopeViewController;

@interface KaleidoscopeAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	id cameraController;
    KaleidoscopeViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) id cameraController;
@property (nonatomic, retain) IBOutlet KaleidoscopeViewController *viewController;

@end

