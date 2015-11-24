//
//  OverlayView.m
//
//  Created by David Holland on 7/23/13.
//
//  HISTORY:
//
//  07.24.13    Managed to get it to display 'ghost' image overlay from .png.
//  11.13.15    Upgraded and improved version for the iPhone 5.

#define radians(degrees) (degrees * M_PI/180)

#define BORDER_MARGIN_HEIGHT 0.05
#define BORDER_MARGIN_WIDTH 0.05

#import "OverlayView.h"
#import "NowAndThenPMDelegate.h"

#include <sys/utsname.h>

@implementation OverlayView

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    return NO;
}

- (id)initWithParams:(CGRect)frame : (UIImage*)matchingImage :(float)trans
{
    CGRect newR = frame;
    newR.size.height = 50;
    
    if (self = [super initWithFrame:newR]) {

        // get screen dimensions and total span of height in pixls
        double screenHeight = [[UIScreen mainScreen] bounds].size.width; // flip this for landscape mode
        
        double screenWidth = [[UIScreen mainScreen] bounds].size.height; // flip this for landscape mode

        // load an image to show in the overlay
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString* path = [documentsDirectory stringByAppendingPathComponent:@"Then.png"];
        
        // get the original THEN image
        UIImage* thenImage = [UIImage imageWithContentsOfFile:path];
        
        // get its size
        CGSize thenImageSize = thenImage.size;
        
        // find out how much one needs to shrink or expand the original image to fit the screen vertically (by height)
        double heightFraction = screenHeight / thenImageSize.height;
        double widthFraction = screenWidth / thenImageSize.width;
        
        // adjust the original then image height and add on some margin
        double newScreenHeight = thenImageSize.height * heightFraction + (thenImageSize.height * heightFraction * BORDER_MARGIN_HEIGHT);
        
        // do the same for the screen width
        double newScreenWidth = thenImageSize.width * heightFraction + (thenImageSize.width * widthFraction * BORDER_MARGIN_WIDTH);
        
        NSLog(@"ScreenWidth=%f", screenHeight);
        NSLog(@"ScreenHeight=%f", [[UIScreen mainScreen] bounds].size.height);
        NSLog(@"ImageWidth=%f", thenImage.size.width);
        NSLog(@"ImageHeight=%f", thenImage.size.height);
    
        float horizontalTranslation = 40;
        
        NSString* messageHardwareType = nil;
        struct utsname platform;
        int rc = uname(&platform);
        
        if (rc != -1)
        {
            messageHardwareType = [NSString stringWithCString:platform.machine encoding:NSUTF8StringEncoding];
            
            if ([messageHardwareType rangeOfString:@"iPad"].location != NSNotFound)
                
                horizontalTranslation = 0;
        }
        
        // create a new size object for then image, fit into the
        CGSize newSize = CGSizeMake(newScreenWidth, newScreenHeight);
        UIGraphicsBeginImageContext(CGSizeMake(screenWidth, screenWidth * 0.9));
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextTranslateCTM(context, newScreenHeight,horizontalTranslation);
        CGContextRotateCTM (context, radians(90));
        
        // create a new image that fits exactly within the iPhone's screen frame...
        [thenImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height) blendMode:kCGBlendModeOverlay alpha:trans];
        
        // get the transformed image from the context
        _transformedImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        @autoreleasepool {
            UIImageView *transformedView = [[UIImageView alloc] initWithImage:_transformedImage];
            
            transformedView.userInteractionEnabled = YES;
            
            self.userInteractionEnabled = YES;
            
            [self addSubview:transformedView];
        }
    }
    
    return self;
}

- (void) drawRect:(CGRect)rect {}

- (void) dealloc {}

- (void) sliderChanged:(id)sender {}

@end
