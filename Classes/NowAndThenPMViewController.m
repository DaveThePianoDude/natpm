//
//  Now and Then PhotoMatcher (NatPM)
//
//  Created by David Holland on 9/5/13.
//  Modified for second release (verson 2.0) November 2015

#define IDIOM    UI_USER_INTERFACE_IDIOM()
#define IPAD     UIUserInterfaceIdiomPad

#import "NowAndThenPMDelegate.h"
#import "NowAndThenPMViewController.h"
#import "OverlayView.h"

#import "JPSImagePickerController.h"

#include <sys/utsname.h>

@interface NowAndThenPMViewController () <JPSImagePickerDelegate>

@property (strong, nonatomic) IBOutlet UITextView *selectedFriendsView;
@property (strong, nonatomic) NSMutableArray * localAlbums;
@property BOOL IS_IPAD;

@property (strong, nonatomic) NSString*  LATITUDE;
@property (strong, nonatomic) NSString*  LONGITUDE;

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation NowAndThenPMViewController

@synthesize matchingImage;

#pragma mark View lifecycle

- (void)viewDidLoad {
 
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    
    [self setupImageView];
}

- (void)setupImageView {
    // Image View
    _imageView = [[UIImageView alloc] init];
    _imageView.translatesAutoresizingMaskIntoConstraints = NO;
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_imageView];
}

- (void)viewDidUnload {

    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}

#pragma mark UI handlers

// This function is called when the user clicks the green 'Activate Camera' button -> image picker is invoked as a camera.
- (void)buttonPressed:(UIButton *)button
{
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    [locationManager startUpdatingLocation];
    
	// Create image picker controller
    imagePicker = [[JPSImagePickerController alloc] init];
	imagePicker.delegate = self;
    imagePicker.flashlightEnabled = NO;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;

    int slider_margin = frameWidth * .261;
    
    NSString* messageHardwareType = nil;
    struct utsname platform;
    int rc = uname(&platform);
    
    if (rc != -1)
    {
        messageHardwareType = [NSString stringWithCString:platform.machine encoding:NSUTF8StringEncoding];
        
        if ([messageHardwareType rangeOfString:@"iPad"].location != NSNotFound)

            slider_margin = frameWidth * .111;
    }
    
    // make the transparency slider, starting with the frame
    CGRect sliderFrame = CGRectMake(0,frameHeight - slider_margin,frameWidth,40);
    
    transparencySlider = [[UISlider alloc]initWithFrame:sliderFrame];
    transparencySlider.minimumValue = 0;
    transparencySlider.maximumValue = 1;
    transparencySlider.continuous = NO;
    transparencySlider.value = 0.5;
    
    // add the slider
    [transparencySlider addTarget:self action:@selector(sliderChanged:) forControlEvents: UIControlEventValueChanged];
    
    [imagePicker.view addSubview:transparencySlider];
    
    // make a custom view
    OverlayView *overlayview = [[OverlayView alloc] initWithParams: self.view.frame : matchingImage : 0.5];
    
    // lay it over the image picker view
    [imagePicker.view addSubview:overlayview];
    
    imagePicker.view.userInteractionEnabled = true;
    
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

// the slider calls this event handler once its position has changed
-(IBAction) sliderChanged:(id) sender {
    
    for (UIView *subView in imagePicker.view.subviews)
    {
        if ([subView isKindOfClass:[OverlayView class]])
        {
            [subView removeFromSuperview];
        }
    }
    
    float sliderValue = transparencySlider.value;
    
    //[imagePicker dismissViewControllerAnimated: NO completion: nil];
    
    // make another custom view
    OverlayView *overlayview = [[OverlayView alloc] initWithParams: self.view.frame : matchingImage : sliderValue];
    
    overlayview.tag = "1";
    
    // lay it over the image picker view
    [imagePicker.view addSubview:overlayview];
    
    //[self presentViewController:imagePicker animated:NO completion:nil];
}

// This function is called when the image picker is invoked as an actual image picker!
- (void)pickerButtonPressed:(UIButton *)button
{
	// Create image picker controller
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType =  UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    // Delegate is self
	imagePicker.delegate = self;
    
    // Show image picker
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)infoButtonPressed:(UIButton *)button
{
     NSString *domain = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"AppDomainName"];
    
        NSString *message = [NSString stringWithFormat:@"1. Pick an old photo of a favorite person or place from your Camera Roll. 2. Go to that place or person.  3. Activate the camera and adjust transparency using the slider while matching up the historic photo with the current scene.  4. Take a new photo and press 'USE' to share with your friends at http://%@.com !", domain];
    
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Instructions:"
                              message: message
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
   }

-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
    
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

// This function is called once a photo is picked from the camera roll
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // If the app is in camera roll mode,...
    if (imagePicker.sourceType == ImagePickerControllerSourceTypeCamera)
    {
        // Get the image, whatever it is.
        UIImage* img  = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
            
        // Make a path to the 'NOW' image.
        NSString  *pngPath;
            
        // simply write it back to the Documents folder so app can load it into overlay.
        pngPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Then.png"];
        [UIImagePNGRepresentation(img) writeToFile:pngPath atomically:YES];
            
        // Dismiss the picker
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    // Assigning the last object as the current location of the device
    CLLocation *newLocation = locations.firstObject;
    
    double degrees = newLocation.coordinate.latitude;
    
    self.lat = [NSString stringWithFormat:@"%f",
                degrees];
    
    degrees = newLocation.coordinate.longitude;
    
    self.lon = [NSString stringWithFormat:@"%f",
                degrees];
}

-(void)image:(UIImage *)image
finishedSavingWithError:(NSError *)error
 contextInfo:(void *)contextInfo
{
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Save failed"
                              message: @"Failed to save image"\
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}

- (id)init
{
  if (self = [super init]) 
  {
    // set the hosting view
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
      
      locationManager = [[CLLocationManager alloc]init];
      
      // Custom initialization code
      locationManager.delegate = self;

      locationManager.desiredAccuracy = kCLLocationAccuracyBest;
      // Setting distance fiter to 10 to get notified only after location change about 10 meter
      locationManager.distanceFilter = kCLDistanceFilterNone;
      
      // Requesting for authorization
      if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]){
          [locationManager requestWhenInUseAuthorization];
      }
      
      // Immediately starts updating the location
      [locationManager startUpdatingLocation];
      [locationManager startUpdatingHeading];
      
    // add a modern Historia Title cover
    SecondTitleView *secondView = [[SecondTitleView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    UIImage* img2 = [UIImage imageNamed:@"NowAndThen_CoverUpdate.png"];
    UIGraphicsBeginImageContext(secondView.frame.size);
    [img2 drawInRect:CGRectMake(0,0,secondView.frame.size.width,secondView.frame.size.height)];
      
    UIImage* newImage2 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView * imageView2 = [[UIImageView alloc] initWithImage:newImage2];
    imageView2.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView2];
      
    // add a historic Historia Title cover  
    UIImage* img = [UIImage imageNamed:@"NowAndThen_Cover.png"];
    UIGraphicsBeginImageContext(self.view.frame.size);
    [img drawInRect:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
      
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView * imageView = [[UIImageView alloc] initWithImage:newImage];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView];
      
    // get some frame measurements for use later
    frameWidth = self.view.frame.size.width;
    frameHeight = self.view.frame.size.height;
      
    // do some animation
    [UIView animateWithDuration:1.5
                       animations:^{imageView.alpha = 0;}
                       completion:^(BOOL finished){
                           [UIView animateWithDuration:1.5
                                            animations:^{imageView.alpha = 1;}];
                       }];

    // default uses blank to deliver 'Camera.png' as file name
    NSString *suffix = @"";
      
    NSString* messageHardwareType = nil;
    struct utsname platform;
      
    if (uname(&platform) != -1)
    {
        messageHardwareType = [NSString stringWithCString:platform.machine encoding:NSUTF8StringEncoding];
          
        if ([messageHardwareType rangeOfString:@"iPad"].location != NSNotFound)
        
            suffix = @"_iPad"; // augment suffix if iPad is device
    }
      
    // pre-define the filename strings
    NSString *CameraStr = [NSString stringWithFormat:@"Camera%@.png", suffix];
    NSString *GalleryStr = [NSString stringWithFormat:@"Gallery%@.png", suffix];
    NSString *InstructionsStr = [NSString stringWithFormat:@"Instructions%@.png", suffix];
      
    // add button to activate camera
    activatorButton = [UIButton buttonWithType:UIButtonTypeSystem];
      
    [activatorButton setBackgroundImage:[UIImage imageNamed:CameraStr] forState:UIControlStateNormal];
    activatorButton.translatesAutoresizingMaskIntoConstraints = NO;
      
    [activatorButton addTarget:self action:@selector(buttonPressed:) forControlEvents: UIControlEventTouchUpInside];      
    [self.view addSubview:activatorButton];
      
    NSLayoutConstraint *leftActivator = [NSLayoutConstraint constraintWithItem:activatorButton
                                                              attribute:NSLayoutAttributeLeft
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeLeft
                                                             multiplier:1.0f
                                                               constant:frameWidth/57.2];
    NSLayoutConstraint *bottomActivator = [NSLayoutConstraint constraintWithItem:activatorButton
                                                                attribute:NSLayoutAttributeBottom
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.view
                                                                attribute:NSLayoutAttributeBottom
                                                               multiplier:1.0f
                                                                 constant:-frameHeight/18.3];
    [self.view addConstraints:@[leftActivator, bottomActivator]];
      
    // add button to activate gallery image picker
    pickerButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [pickerButton setBackgroundImage:[UIImage imageNamed:GalleryStr] forState:UIControlStateNormal];
    pickerButton.translatesAutoresizingMaskIntoConstraints = NO;
      
    [pickerButton addTarget:self action:@selector(pickerButtonPressed:) forControlEvents: UIControlEventTouchUpInside];
    [self.view addSubview:pickerButton];
      
    NSLayoutConstraint *rightPicker = [NSLayoutConstraint constraintWithItem:pickerButton
                                                              attribute:NSLayoutAttributeRight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeRight
                                                             multiplier:1.0f
                                                               constant:-frameWidth/57.2];
      
    NSLayoutConstraint *bottomPicker = [NSLayoutConstraint constraintWithItem:pickerButton
                                                                attribute:NSLayoutAttributeBottom
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.view
                                                                attribute:NSLayoutAttributeBottom
                                                               multiplier:1.0f
                                                                 constant:-frameHeight/18.3];
      
    [self.view addConstraints:@[rightPicker, bottomPicker]];
    
    // add button to show instructions
    infoIcon = [UIButton buttonWithType:UIButtonTypeSystem];
    [infoIcon setBackgroundImage:[UIImage imageNamed:InstructionsStr] forState:UIControlStateNormal];
    infoIcon.translatesAutoresizingMaskIntoConstraints = NO;
      
    [infoIcon addTarget:self action:@selector(infoButtonPressed:) forControlEvents: UIControlEventTouchUpInside];
    [self.view addSubview:infoIcon];
      
    NSLayoutConstraint *centerInfoX = [NSLayoutConstraint constraintWithItem:infoIcon
                                                                     attribute:NSLayoutAttributeCenterX
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.view
                                                                     attribute:NSLayoutAttributeCenterX
                                                                    multiplier:1.0f
                                                                      constant:0];
    
    NSLayoutConstraint *centerInfoY = [NSLayoutConstraint constraintWithItem:infoIcon
                                                                      attribute:NSLayoutAttributeCenterY
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.view
                                                                      attribute:NSLayoutAttributeCenterY
                                                                     multiplier:1.0f
                                                                       constant:-frameHeight/6];
    [self.view addConstraints:@[centerInfoX, centerInfoY]];
      
    // Adds a progress bar for data send operation.
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width * .75,100)];
    self.progressView.center = CGPointMake( self.view.frame.size.width * .5, self.view.frame.size.height * .15);
      
    [self.progressView setTransform:CGAffineTransformMakeScale(1.0, 3.0)];
    [self.view addSubview:self.progressView];
  }
    
  return self;
}

- (void)picker:(JPSImagePickerController *)picker didTakePicture:(UIImage *)picture {
    picker.confirmationString = @"Zoom in to inspect picture detail.\rUse FLIP to check that the photos line up.";
    picker.confirmationOverlayString = @"Analyzing Image...";
    picker.confirmationOverlayBackgroundColor = [UIColor orangeColor];
    double delayInSeconds = 1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        picker.confirmationOverlayString = @"Good Quality";
        picker.confirmationOverlayBackgroundColor = [UIColor colorWithRed:0 green:0.8f blue:0 alpha:1.0f];
    });
}

- (void)picker:(JPSImagePickerController *)picker didConfirmPicture:(UIImage *)picture {
    
    self.imageView.image = picture;
    
    self.progressView.progress = 0.12;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, NULL), ^{
        // we're on a secondary thread, do expensive computation here
        // when we're done, we schedule another block to run on the main thread
        
        // get current date/time up to the millisecond
        NSDate *currentTime = [NSDate date];
        NSTimeInterval inter = [currentTime timeIntervalSince1970];
        NSString *timestamp = [NSString stringWithFormat:@"%f", inter];
        
        // Get the image, whatever it is.
        UIImage* img  = picture;
        
        [locationManager stopUpdatingLocation];
        
        CGSize newSize = CGSizeMake(600,480);
        
        UIImageOrientation orient = UIImageOrientationUp;
        
        img = [[UIImage alloc] initWithCGImage: img.CGImage
                                         scale: 1.0
                                   orientation: orient];
        
        // this is a NOW image ... send it first, after resizing it
        img = [self imageWithImage:img scaledToSize:newSize];
        
        // get the data to send
        NSData *imageDataNOW = UIImagePNGRepresentation(img);
        NSString *domain = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"AppDomainName"];
        
        self.progressView.progress = 0.1;
        
        // get the url of the Now and Then page that stores NOW photos.
        NSString *urlString = [NSString stringWithFormat:@"https://%@.com/storenowphoto.php?createdAt=%@", domain, timestamp];
        
        // Build the request and send the image.
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:urlString]];
        [request setHTTPMethod:@"POST"];
        
        NSString *boundary = [[NSString alloc] initWithString: [[NSProcessInfo processInfo] globallyUniqueString]];
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        NSMutableData *body = [NSMutableData data];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"uploadedfile\"; filename=\"now.png\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:imageDataNOW]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [request setHTTPBody:body];
        
        NSData *returnDataNOW = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSString *returnStringNOW = [[NSString alloc] initWithData:returnDataNOW encoding:NSUTF8StringEncoding];
        
        self.progressView.progress = 0.3;
        
        NSLog(@"ReturnString NOW: %@", returnStringNOW);
        
        // next send the THEN image.  First get the image saved previously...
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString* path = [documentsDirectory stringByAppendingPathComponent:@"Then.png"];
        
        UIImage* imageTHEN = [UIImage imageWithContentsOfFile:path]; //this works
        
        imageTHEN = [[UIImage alloc] initWithCGImage: imageTHEN.CGImage
                                               scale: 1.0
                                         orientation: UIImageOrientationUp];
        
        imageTHEN = [self imageWithImage:imageTHEN scaledToSize:newSize];
        
        NSData *imageDataTHEN = UIImagePNGRepresentation(imageTHEN);
        
        NSString *urlStringTHEN = [NSString stringWithFormat:@"https://%@.com/storethenphoto.php?createdAt=%@", domain, timestamp];
        
        NSMutableURLRequest *requestTHEN = [[NSMutableURLRequest alloc] init];
        [requestTHEN setURL:[NSURL URLWithString:urlStringTHEN]];
        [requestTHEN setHTTPMethod:@"POST"];
        
        NSString *boundaryTHEN = [[NSString alloc] initWithString: [[NSProcessInfo processInfo] globallyUniqueString]];
        NSString *contentTypeTHEN = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundaryTHEN];
        [requestTHEN addValue:contentTypeTHEN forHTTPHeaderField: @"Content-Type"];
        
        NSMutableData *bodyTHEN = [NSMutableData data];
        [bodyTHEN appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundaryTHEN] dataUsingEncoding:NSUTF8StringEncoding]];
        [bodyTHEN appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"uploadedfile\"; filename=\"Then.png\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [bodyTHEN appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [bodyTHEN appendData:[NSData dataWithData:imageDataTHEN]];
        [bodyTHEN appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundaryTHEN] dataUsingEncoding:NSUTF8StringEncoding]];
        [requestTHEN setHTTPBody:bodyTHEN];
        
        NSData *returnDataTHEN = [NSURLConnection sendSynchronousRequest:requestTHEN returningResponse:nil error:nil];
        NSString *returnStringTHEN = [[NSString alloc] initWithData:returnDataTHEN encoding:NSUTF8StringEncoding];
        
        NSLog(@"ReturnString THEN: %@", returnStringTHEN);
        
        self.progressView.progress = 0.7;
        
        NSString *urlStringPLACE = [NSString stringWithFormat:@"https://%@.com/storephotomatch.php?&userName=admin&createdAt=%@&lat=%@&lon=%@", domain, timestamp, _lat, _lon ];
        
        [NSData dataWithContentsOfURL: [NSURL URLWithString:urlStringPLACE]];
        
        self.progressView.progress = 1.0;
    });
}

- (void)hideProgressBar:(id)sender {

}

- (void)pickerDidCancel:(JPSImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc
{
    [OverlayView dealloc];
}

#pragma mark -

@end


