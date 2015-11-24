//
//  test_appAppDelegate.h
//  test-app
//
//  Copyright iPhoneDevTips.com All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JPSImagePickerController.h"

@class NowAndThenPMViewController;

@interface NowAndThenPMDelegate : UIResponder <UIApplicationDelegate, UIImagePickerControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, retain) NowAndThenPMViewController *vc;

@end

