//
//  test_appAppDelegate.m
//  test-app
//

#import "NowAndThenPMDelegate.h"
#import "NowAndThenPMViewController.h"
#include <QuartzCore/QuartzCore.h>


@implementation NowAndThenPMDelegate

@synthesize window, vc;

- (void)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {

}

- (void)applicationDidBecomeActive:(UIApplication *)application {

}

- (void)applicationDidFinishLaunching:(UIApplication *)application 
{
    // Create and initialize the window
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

	// Create primary view controller
	vc = [[NowAndThenPMViewController alloc] init];
    
    [self.window setRootViewController:vc];
    
    [window makeKeyAndVisible];
}

- (void)dealloc 
{
  //[window release];
  //[super dealloc];
}

@end
