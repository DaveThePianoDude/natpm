//
//  test_appViewController.h
//  test-app
//
//  Copyright iPhoneDevTips.com All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SecondTitleView.h"
#import <CoreLocation/CoreLocation.h>
#import "JPSImagePickerController.h"

@interface NowAndThenPMViewController : UIViewController  <UINavigationControllerDelegate, UIImagePickerControllerDelegate, CLLocationManagerDelegate>
{
	UIButton *activatorButton;
    UIButton *pickerButton;
    UIButton *infoIcon;
    
    int frameWidth;
    int frameHeight;
    
    UISlider *transparencySlider;
    JPSImagePickerController *imagePicker;
    UIActivityIndicatorView *spinner;
    
    CLLocationManager *locationManager;
}

@property (assign) UIImage* matchingImage;
@property (strong) NSString* lat;
@property (strong) NSString* lon;

@end





