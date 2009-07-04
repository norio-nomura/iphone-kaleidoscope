//
//  KaleidoscopeViewController.m
//  Kaleidoscope
//

#import "KaleidoscopeViewController.h"
#import "KaleidoscopeView.h"

@implementation KaleidoscopeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
	[(KaleidoscopeView*)self.view tileSquares];
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
