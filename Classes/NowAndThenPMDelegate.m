//
//  Now and Then PhotoMatcher (NatPM)
//
//  Created by David Holland on 9/5/13.
//  Modified for second release (verson 2.0) November 2015

#import "NowAndThenPMDelegate.h"
#import "NowAndThenPMViewController.h"
#include <QuartzCore/QuartzCore.h>


@implementation NowAndThenPMDelegate

@synthesize window, vc;

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {

    return true;
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
