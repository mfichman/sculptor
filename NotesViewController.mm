//
//  NotesViewController.m
//  Sculptor
//
//  Created by Matthew Fichman on 12/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NotesViewController.h"


@implementation NotesViewController

@synthesize delegate, textView, text;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.textView.font = [UIFont fontWithName:@"Marker Felt" size:20];
	self.textView.delegate = self;
	self.textView.text = self.text;
	
	[[NSNotificationCenter defaultCenter] 
		addObserver:self
		selector:@selector(keyboardDidShow:)
		name:UIKeyboardDidShowNotification
		object:self.view.window];
	
	[[NSNotificationCenter defaultCenter] 
		addObserver:self
		selector:@selector(keyboardDidShow:)
		name:UIKeyboardDidShowNotification
		object:self.view.window];

	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] 
		initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
		target:self 
		action:@selector(done:)] autorelease];
}

- (void)viewWillDisappear:(BOOL)animated {
	self.text = self.textView.text;
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void) animateTextView:(BOOL)up {
    const int movementDistance = 100; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
	
    int movement = (up ? -movementDistance : movementDistance);
	
    [UIView beginAnimations: @"NotesTextViewAnimation" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    //self.view.frame = CGRectOffset(self.view.frame, 0, movement);
	self.view.frame = CGRectMake(self.view.frame.origin.x, 
								 self.view.frame.origin.y, 
								 self.view.frame.size.width, 
								 self.view.frame.size.height + movement);
	
	
    [UIView commitAnimations];
}

- (void)keyboardDidShow:(NSNotification *)notification {
	[self animateTextView:YES];
}

- (void)keyboardDidHide:(NSNotification *)notification {
	[self animateTextView:NO];
}

- (void)done:(id)sender {
	[self.delegate notesViewControllerDone:self];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)releaseOutlets {
	self.textView = nil;
}

- (void)viewDidUnload {
	[self releaseOutlets];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
	[text release];
	[self releaseOutlets];
    [super dealloc];
}


@end
