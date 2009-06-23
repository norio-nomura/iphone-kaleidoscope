//
//  KaleidoscopeAppDelegate.m
//  Kaleidoscope
//

#import "KaleidoscopeAppDelegate.h"
#import "KaleidoscopeViewController.h"

@implementation KaleidoscopeAppDelegate

@synthesize window;
@synthesize cameraController;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    application.statusBarHidden = YES;
	self.cameraController = [(id)objc_getClass("PLCameraController") performSelector:@selector(sharedInstance)];
	[cameraController setDelegate:self];
	UIView *previewView = [cameraController performSelector:@selector(previewView)];
	[window addSubview:previewView];
	[cameraController performSelector:@selector(startPreview)];
    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [viewController release];
	[cameraController release];
    [window release];
    [super dealloc];
}


#pragma mark PLCameraControllerDelegate


-(void)cameraController:(id)sender tookPicture:(UIImage*)fullImage withPreview:(id)fp16 jpegData:(id)fp20 imageProperties:(id)fp24 {
}


- (void)cameraControllerReadyStateChanged:(id)fp8{
}


@end
