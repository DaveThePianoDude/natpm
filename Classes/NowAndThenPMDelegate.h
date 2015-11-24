//
//  Now and Then PhotoMatcher (NatPM)
//
//  Created by David Holland on 9/5/13.
//  Modified for second release (verson 2.0) November 2015

#import <UIKit/UIKit.h>
#import "JPSImagePickerController.h"

@class NowAndThenPMViewController;

@interface NowAndThenPMDelegate : UIResponder <UIApplicationDelegate, UIImagePickerControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, retain) NowAndThenPMViewController *vc;

@end

