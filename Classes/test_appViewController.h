//
//  test_appViewController.h
//  test-app
//
//  Copyright iPhoneDevTips.com All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SecondTitleView.h"
#import <CoreLocation/CoreLocation.h>

@interface test_appViewController : UIViewController  <UINavigationControllerDelegate, UIImagePickerControllerDelegate, CLLocationManagerDelegate>
{
	UIButton *button;
    UIButton *pickerButton;
    UIButton *infoIcon;
    
    UISlider *transparencySlider;
    UIImagePickerController *imagePicker;
    UIActivityIndicatorView *spinner;
    
    CLLocationManager *locationManager;
}

@property (assign) UIImage* matchingImage;
@property (strong) NSString* lat;
@property (strong) NSString* lon;

@end





