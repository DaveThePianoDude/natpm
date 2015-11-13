//
//  test_appAppDelegate.m
//  test-app
//

#import "test_appAppDelegate.h"
#import "test_appViewController.h"
#include <QuartzCore/QuartzCore.h>


@implementation test_appAppDelegate

@synthesize window, vc;

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBAppEvents activateApp];
    [FBAppCall handleDidBecomeActive];
}

- (void)applicationDidFinishLaunching:(UIApplication *)application 
{
    // Create and initialize the window
	self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];

	// Create primary view controller
	vc = [[test_appViewController alloc] init];
    
	//[window addSubview:vc.view];
    
    [self.window setRootViewController:vc];
    
    [window makeKeyAndVisible];
}

- (void)dealloc 
{
  [window release];
  [super dealloc];
}

@end
