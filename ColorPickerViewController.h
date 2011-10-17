//
//  ColorPickerViewController.h
//  Sculptor
//
//  Created by Matthew Fichman on 12/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ColorView.h"

@class ColorPickerViewController;

@protocol ColorPickerViewControllerDelegate
/* Calls this function when the view controller is done editing */
- (void)colorPickerViewControllerDone:(ColorPickerViewController *)controller;

@end

@interface ColorPickerViewController : UIViewController {

	IBOutlet UISlider *red;
	IBOutlet UISlider *green;
	IBOutlet UISlider *blue;
	IBOutlet UILabel *redLabel;
	IBOutlet UILabel *blueLabel;
	IBOutlet UILabel *greenLabel;
	IBOutlet ColorView *colorView;
	UIColor *color;
	
	id <ColorPickerViewControllerDelegate> delegate;
}

@property (retain) IBOutlet UISlider *red;
@property (retain) IBOutlet UISlider *green;
@property (retain) IBOutlet UISlider *blue;
@property (retain) IBOutlet UILabel *redLabel;
@property (retain) IBOutlet	UILabel *greenLabel;
@property (retain) IBOutlet UILabel *blueLabel;
@property (retain) IBOutlet ColorView *colorView;
@property (retain) UIColor *color;
@property (assign) id <ColorPickerViewControllerDelegate> delegate;

- (IBAction)redChanged;
- (IBAction)blueChanged;
- (IBAction)greenChanged;

@end
