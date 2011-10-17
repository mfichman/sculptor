//
//  ColorPickerViewController.m
//  Sculptor
//
//  Created by Matthew Fichman on 12/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ColorPickerViewController.h"


@implementation ColorPickerViewController

@synthesize red, blue, green, redLabel, blueLabel, greenLabel, colorView, delegate, color;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] 
			initWithTitle:@"Done" 
					style:UIBarButtonItemStyleDone 
					target:self 
					action:@selector(done:)] autorelease];
	
	if (!self.color) {
		self.color = [UIColor colorWithRed:0.5f green:0.5f blue:0.5f alpha:1.0f];
	}
	
	const CGFloat *components = CGColorGetComponents([self.color CGColor]);
	self.red.value = components[0];
	self.green.value = components[1];
	self.blue.value = components[2];
	
	self.colorView.color = self.color;
	
	self.redLabel.text = [NSString stringWithFormat:@"%.2f", self.red.value];
	self.blueLabel.text = [NSString stringWithFormat:@"%.2f", self.blue.value];
	self.greenLabel.text = [NSString stringWithFormat:@"%.2f", self.green.value];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)done:(id)sender {
	[self.delegate colorPickerViewControllerDone:self];
	
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	self.navigationController.toolbarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

- (IBAction)redChanged {
	self.redLabel.text = [NSString stringWithFormat:@"%.2f", self.red.value];
	self.colorView.color = [UIColor colorWithRed:self.red.value green:self.green.value blue:self.blue.value alpha:1.0f];
	self.color = colorView.color;
	
}

- (IBAction)blueChanged {
	self.blueLabel.text = [NSString stringWithFormat:@"%.2f", self.blue.value];
	self.colorView.color = [UIColor colorWithRed:self.red.value green:self.green.value blue:self.blue.value alpha:1.0f];
	self.color = colorView.color;
}

- (IBAction)greenChanged {
	self.greenLabel.text = [NSString stringWithFormat:@"%.2f", self.green.value];
	self.colorView.color = [UIColor colorWithRed:self.red.value green:self.green.value blue:self.blue.value alpha:1.0f];
	self.color = colorView.color;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)setColor:(UIColor *)aColor {
	[color release];
	color = [aColor retain];
}

- (void)releaseOutlets {
	self.red = nil;
	self.blue = nil;
	self.green = nil;
	self.redLabel = nil;
	self.blueLabel = nil;
	self.greenLabel = nil;
	self.colorView = nil;
}

- (void)viewDidUnload {
    [super viewDidUnload];
	[self releaseOutlets];
}


- (void)dealloc {
	[color release];
	[self releaseOutlets];
    [super dealloc];
}


@end
