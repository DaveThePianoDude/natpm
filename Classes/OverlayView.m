//
//  OverlayView.m
//  test-app
//
//  Created by David Holland on 7/23/13.
//
//  HISTORY:
//
//  07.24.13    Managed to get it to display 'ghost' image overlay from .png file.

#define radians(degrees) (degrees * M_PI/180)

#define BORDER_MARGIN 0.05

#import "OverlayView.h"
#import "test_appAppDelegate.h"

@implementation OverlayView

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
   
    return NO;
}

- (id)initWithParams:(CGRect)frame : (UIImage*)matchingImage :(float)trans
{
    if (self = [super initWithFrame:frame]) {
        
        // clear the background color of the overlay
        self.opaque = NO;
        self.alpha = 1.0;
        self.backgroundColor = [UIColor clearColor];

        // get screen dimensions and total span of height in pixls
        double screenHeight = [[UIScreen mainScreen] bounds].size.width; // flip this for landscape mode

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
        
        // adjust the original then image height and add on some margin
        double newScreenHeight = thenImageSize.height * heightFraction + (thenImageSize.height * heightFraction * BORDER_MARGIN);
        
        // do the same for the screen width
        double newScreenWidth = thenImageSize.width * heightFraction + (thenImageSize.width * heightFraction * BORDER_MARGIN);
        
        // create a new size object for then image, fit into the
        CGSize newSize = CGSizeMake(newScreenWidth, newScreenHeight);
        
        UIGraphicsBeginImageContext(CGSizeMake(1000,800));
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextTranslateCTM(context, newScreenHeight, 0);
        
        CGContextRotateCTM (context, radians(90));
        
        // create a new image that fits exactly within the iPhone's screen frame...
        
        [thenImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height) blendMode:kCGBlendModeOverlay alpha:trans];
        
        // grab the transformed image from the context
        UIImage* transformed = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        UIImageView *transformedView = [[UIImageView alloc] initWithImage:transformed];

        transformedView.userInteractionEnabled = YES;
        
        self.userInteractionEnabled = YES;
        
        [self addSubview:transformedView];
        
        [transformedView release];
    }
    
    return self;
}

- (void) dealloc
{
    [super dealloc];
}


@end
