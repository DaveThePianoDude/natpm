//
//  OverlayView.h
//  test-app
//
//  Created by David Holland on 7/23/13.
//
//

#import <UIKit/UIKit.h>

@interface OverlayView : UIView

-(IBAction)sliderChanged:(id)sender;

- initWithParams:(CGRect)frame : (UIImage*)matchingImage : (float)trans;

@property (strong) UIImage* matchingImage;

@property (strong) UIImage* transformedImage;

@end

//static double BORDER_MARGIN = .05;  //5 percent border margin on TOP and BOTTOM of screen



