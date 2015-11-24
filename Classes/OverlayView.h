//
//  OverlayView.h
//  Now and Then PhotoMatcher (NatPM)
//
//  Created by David Holland on 7/23/13.
//  Modified for second release (verson 2.0) November 2015

#import <UIKit/UIKit.h>

@interface OverlayView : UIView

-(IBAction)sliderChanged:(id)sender;

- initWithParams:(CGRect)frame : (UIImage*)matchingImage : (float)trans;

@property (strong) UIImage* matchingImage;
@property (strong) UIImage* transformedImage;

@end




