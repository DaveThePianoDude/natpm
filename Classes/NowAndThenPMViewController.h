//
//  Now and Then PhotoMatcher (NatPM)
//
//  Created by David Holland on 9/5/13.
//  Modified for second release (verson 2.0) November 2015

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
    
    
    Boolean *showFlag;
}

@property (nonatomic, strong) UIProgressView *progressView; 

@property (assign) UIImage* matchingImage;
@property (strong) NSString* lat;
@property (strong) NSString* lon;

@end





