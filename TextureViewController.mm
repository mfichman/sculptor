//
//  TextureViewController.m
//  Sculptor
//
//  Created by Matthew Fichman on 12/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TextureViewController.h"
#import "Fetcher.h"

@implementation TextureViewController

@synthesize texture, delegate, managedObjectContext, imageView, scrollView, activityIndicator;

/* Zoom the scroll view to make the photo fill the whole screen */
- (void)zoomPhotoToFill {	
	/* Now zoom so there are no white spaces, and the maxium image area is showing */
	float screenAspect = self.scrollView.frame.size.width/self.scrollView.frame.size.height;
	float imageAspect = self.imageView.frame.size.width/self.imageView.frame.size.height;
	
	CGRect zoomRect;
	zoomRect.origin.x = 0;
	zoomRect.origin.y = 0;
	
	
	if (screenAspect > imageAspect) {
		zoomRect.size.width = self.imageView.frame.size.width;
		zoomRect.size.height = 1;
	} else {
		zoomRect.size.width = 1;
		zoomRect.size.height = self.imageView.frame.size.height;
		
	}
	
	[self.scrollView zoomToRect:zoomRect animated:NO];	
}

- (void)viewWillAppear:(BOOL)animated {
	
	NSLog(@"Loading image: %@", self.texture.url);
	
	self.imageView.image = nil;
	
	/* Spin the indicator */
	self.activityIndicator.hidden = NO;
	[self.activityIndicator startAnimating];
	
	/* Download the image asynchronously, and then set the image when the DL is complete */
	dispatch_queue_t downloadQueue = dispatch_queue_create("Downloader", NULL);
	dispatch_async(downloadQueue, ^{
		UIImage *image = [Fetcher imageForUrl:self.texture.url];
		dispatch_async(dispatch_get_main_queue(), ^{
			self.scrollView.zoomScale = 1.0;
			self.imageView.image = image;
			self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
			self.scrollView.contentSize = image.size;
			
			NSLog(@"Image loaded.");
			
			self.activityIndicator.hidden = YES;
			[self.activityIndicator stopAnimating];
			[self zoomPhotoToFill];
			[self.view setNeedsDisplay];
		});
	});
	dispatch_release(downloadQueue);
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Select" style:UIBarButtonItemStyleDone target:self action:@selector(select:)] autorelease];	
	self.scrollView.minimumZoomScale = 0.1;
	self.scrollView.maximumZoomScale = 10.0;
	self.scrollView.delegate = self;
}

- (void)select:(id)sender {
	[self.delegate textureViewController:self textureSelected:self.texture];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)sender {
	return self.imageView;
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	[self zoomPhotoToFill];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)releaseOutlets {
	self.imageView = nil;
	self.activityIndicator = nil;
	self.scrollView = nil;
}

- (void)viewDidUnload {
    [super viewDidUnload];
	[self releaseOutlets];
}

- (void)dealloc {
	self.managedObjectContext = nil;
	self.texture = nil;
	[self releaseOutlets];
    [super dealloc];
}


@end
