//
//  SculptViewController.m
//  Sculptor
//
//  Created by Matthew Fichman on 12/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SculptViewController.h"
#import "EAGLView.h"
#import "ManagedContextHelper.h"
#import "Fetcher.h"

#include "Matrix.hpp"

#define TEXTURE_SIZE 512
#define MIN_ZOOM 0.1
#define MAX_ZOOM 20

#define glError() { \
GLenum err = glGetError(); \
while (err != GL_NO_ERROR) { \
printf("%d\n", err);\
err = glGetError(); \
} \
}

@implementation SculptViewController

@synthesize model, managedObjectContext, like, activityIndicator, modelData, texture;

#define BYTES_PER_VERTEX (3*sizeof(float))

- (id)init {

	if ((self = [super init])) {
		zoomLevel = 3;
		materialPicker = [[ColorPickerViewController alloc] init];
		notesViewController = [[NotesViewController alloc] init];
		infoViewController = [[InfoViewController alloc] init];
		textureListViewController = [[TextureListViewController alloc] init];
		textureListViewController.textureViewController.delegate = self;
	}
		
	return self;
}

- (void)setTextureImage:(UIImage *)image {
	/* Allocate space for the texture...this will stretch the image if it isn't square */
	GLuint width = CGImageGetWidth(image.CGImage);
	GLuint height = CGImageGetHeight(image.CGImage);
	void *data = malloc(TEXTURE_SIZE * TEXTURE_SIZE * sizeof(GLuint));
	
	/* Set up a context to draw into */
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef aContext = CGBitmapContextCreate(
		data, TEXTURE_SIZE, TEXTURE_SIZE, 8, TEXTURE_SIZE * 4, colorSpace,
		kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
	CGColorSpaceRelease(colorSpace);
	CGContextClearRect(aContext, CGRectMake(0, 0, width, height));
	CGContextTranslateCTM(aContext, 0, 0);
	CGContextDrawImage(aContext, CGRectMake(0, 0, TEXTURE_SIZE, TEXTURE_SIZE), image.CGImage);
	
	/* Create the OpenGL texture */
	glBindTexture(GL_TEXTURE_2D, textureHandle);
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, TEXTURE_SIZE, TEXTURE_SIZE, 0, GL_RGBA, GL_UNSIGNED_BYTE, data);
	
	/* Free things */
	CGContextRelease(aContext);
	free(data);
	
	NSLog(@"Loaded texture %d", textureHandle);	
}

- (void)drawModel {
	
	/* Initialize the projection transformation */
	float width = self.view.frame.size.width;
	float height = self.view.frame.size.height;
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	glLoadMatrixf(Matrix::perspective(45.0, width/height, 0.1, 1000));
	//glOrthof(-1.0f, 1.0f, -1.0f/aspect, 1.0f/aspect, -10.0f, 10.0f);
	
	/* Initialize the model transformation */
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
	
	/* Set up basic rendering state */
	glEnable(GL_LIGHTING);
	glEnable(GL_LIGHT0);
	glEnable(GL_DEPTH_TEST);
	glDisable(GL_BLEND);
	
	/* Initialize lighting */
	float lightColor[] = { 1.0f, 1.0f, 1.0f, 1.0f };
	float lightPosition[] = { 0.0f, 0.0f, 1.0f, 0.0f };
	glLightfv(GL_LIGHT0, GL_DIFFUSE, lightColor);
	glLightfv(GL_LIGHT0, GL_POSITION, lightPosition);
	
	float materialColor[4];
	if (self.texture) {
		//glTexEnvf(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_REPLACE);
		glEnable(GL_TEXTURE_2D);
		glBindTexture(GL_TEXTURE_2D, textureHandle);
		materialColor[0] = 1.0f;
		materialColor[1] = 1.0f;
		materialColor[2] = 1.0f;
		materialColor[3] = 1.0f;
	} else {
		/* Material */
		glDisable(GL_TEXTURE_2D);
		materialColor[0] = self.model.materialRed.floatValue;
		materialColor[1] = self.model.materialGreen.floatValue;
		materialColor[2] = self.model.materialBlue.floatValue;
		materialColor[3] = 1.0f;
	
	}
	glMaterialfv(GL_FRONT_AND_BACK, GL_DIFFUSE, materialColor);
	
	/* Model transformation */
	zoomLevel = zoomLevel < MIN_ZOOM ? MIN_ZOOM : zoomLevel;
	zoomLevel = zoomLevel > MAX_ZOOM ? MAX_ZOOM : zoomLevel;
	glTranslatef(0, 0, -zoomLevel);
	glRotatef(rotationAngle, rotationAxis.x, rotationAxis.y, rotationAxis.z);
	glMultMatrixf(baseRotation);
	
	/* Draw the current model ! */
	const float *vertices = (float *)[self.model.vertices bytes];
	glEnableClientState(GL_VERTEX_ARRAY);
	glVertexPointer(3, GL_FLOAT, 0, vertices);
	
	const float *normals = (float *)[self.model.normals bytes];
	glEnableClientState(GL_NORMAL_ARRAY);
	glNormalPointer(GL_FLOAT, 0, normals);
	
	if (self.texture) {
		const float *texcoords = (float *)[self.model.texcoords bytes];
		glEnableClientState(GL_TEXTURE_COORD_ARRAY);
		glTexCoordPointer(2, GL_FLOAT, 0, texcoords);
		
	}
	
	glDrawArrays(GL_TRIANGLES, 0, self.model.vertices.length/BYTES_PER_VERTEX);	
}

- (void)drawFrame {
	[self.eaglView setFramebuffer];
    
	glClearColor(0.5f, 0.5f, 0.5f, 1.0f);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	
	if (self.model) {
		[self drawModel];
	}

	[self.eaglView presentFramebuffer];
}

/* 
 * The pan gesture recognizer is used to rotate the model.  This violates Apple's
 * UI guidelines -- pan is supposed to pan -- but no other gesture recognizer works
 * well for rotations in 3D.
 */
- (void)pan:(UIPanGestureRecognizer *)recognizer {

	if (recognizer.state == UIGestureRecognizerStateChanged ||
		recognizer.state == UIGestureRecognizerStateEnded) {
	
		CGPoint translation = [recognizer translationInView:self.view];
		rotationAxis = Vector(-translation.x, translation.y, 0).cross(Vector(0, 0, 1));
		rotationAngle = rotationAxis.length();
	}

	if (recognizer.state == UIGestureRecognizerStateEnded) {
		glGetFloatv(GL_MODELVIEW_MATRIX, baseRotation);
		baseRotation.data[12] = 0.0f;
		baseRotation.data[13] = 0.0f;
		baseRotation.data[14] = 0.0f;
		rotationAngle = 0.0f;
	}
}

/*
 * The tap gesture recognizer is used to place vertices on the model if it is in
 * writable mode.
 */
- (void)tap:(UITapGestureRecognizer *)recognizer {
 
	if (recognizer.state == UIGestureRecognizerStateChanged ||
		recognizer.state == UIGestureRecognizerStateEnded) {
		
		zoomLevel = 3;
	}
}

/* 
 * The pinch gesture recognizer is used to zoom in and out on the model 
 */
- (void)pinch:(UIPinchGestureRecognizer *)recognizer {
	if (recognizer.state == UIGestureRecognizerStateChanged ||
		recognizer.state == UIGestureRecognizerStateEnded) {
		
		zoomLevel /= recognizer.scale;
		recognizer.scale = 1;
	}
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	/* Create the activity indicator */
	CGRect appFrame = [[UIScreen mainScreen] applicationFrame];	
	CGRect frame = CGRectMake((appFrame.size.width - 40)/2, (appFrame.size.height - 40)/2, 40, 40);
	self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	self.activityIndicator.frame = frame;
	self.activityIndicator.backgroundColor = [UIColor clearColor];
	self.activityIndicator.hidden = YES;
	[self.view addSubview:self.activityIndicator];
	
	/* Initialize the toolbar, which will be displayed by the enclosing navigation controller */
	UIBarButtonItem *flexibleSpace = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
	UIBarButtonItem *notes = [[[UIBarButtonItem alloc] initWithTitle:@"Notes" style:UIBarButtonItemStyleBordered target:self action:@selector(notes:)] autorelease];
	UIBarButtonItem *info = [[[UIBarButtonItem alloc] initWithTitle:@"Info" style:UIBarButtonItemStyleBordered target:self action:@selector(info:)] autorelease];
	UIBarButtonItem *color = [[[UIBarButtonItem alloc] initWithTitle:@"Color" style:UIBarButtonItemStyleBordered target:self action:@selector(material:)] autorelease];
	UIBarButtonItem *tex = [[[UIBarButtonItem alloc] initWithTitle:@"Texture" style:UIBarButtonItemStyleBordered target:self action:@selector(texture:)] autorelease];
	self.like = [[[UIBarButtonItem alloc] initWithTitle:@"Like" style:UIBarButtonItemStyleBordered target:self action:@selector(like:)] autorelease];	
	tex.width = info.width = notes.width = color.width = self.like.width = 54;
	self.toolbarItems = [NSArray arrayWithObjects:flexibleSpace, color, tex, info, notes, self.like, flexibleSpace, nil];
	
	/* Create gesture recognizers for panning, rotation, etc. */
	UIGestureRecognizer *pan = [[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)] autorelease];
	UITapGestureRecognizer *tap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)] autorelease];
	UIGestureRecognizer *pinch = [[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)] autorelease];
	
	tap.numberOfTapsRequired = 2;
	[self.view addGestureRecognizer:pan];
	[self.view addGestureRecognizer:tap];
	[self.view addGestureRecognizer:pinch];
	
	baseRotation = Matrix(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1);
	
	/* Generate a texture we can re-use */
	if (!textureHandle) {
		glGenTextures(1, &textureHandle);
		glBindTexture(GL_TEXTURE_2D, textureHandle);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
	}
}

- (void)notes:(id)sender {
	/* Set the nodes for the view controller */
	notesViewController.text = self.model.notes;
	notesViewController.delegate = self;
	notesViewController.title = [NSString stringWithFormat:@"Notes for \"%@\"", self.model.title];
	
	/*  Push an enclosing navigation controller for the modal */
	UINavigationController *navigation = [[[UINavigationController alloc] init] autorelease];
	[navigation pushViewController:notesViewController animated:YES];
	navigation.navigationBar.barStyle = UIBarStyleBlack;
	
	[self presentModalViewController:navigation animated:YES];
}

- (void)info:(id)sender {
	/* Show the info table view */
	infoViewController.model = self.model;
	infoViewController.delegate = self;
	infoViewController.title = [NSString stringWithFormat:@"Info for \"%@\"", self.model.title];
	
    /*  Push an enclosing navigation controller for the modal */
	UINavigationController *navigation = [[[UINavigationController alloc] init] autorelease];
	[navigation pushViewController:infoViewController animated:YES];
	navigation.navigationBar.barStyle = UIBarStyleBlack;
								
	[self presentModalViewController:navigation animated:YES];
			
}

- (void)material:(id)sender {
	/* Get the color from the model, then push the material picker inside of a navigation controller */
	float red = self.model.materialRed.floatValue;
	float green = self.model.materialGreen.floatValue;
	float blue = self.model.materialBlue.floatValue;
	materialPicker.color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
	materialPicker.title = @"Color";
	materialPicker.delegate = self;
	
	/* Enclose the modal in a navigation controller */
	UINavigationController *navigation = [[[UINavigationController alloc] init] autorelease];
	[navigation pushViewController:materialPicker animated:NO];
	navigation.navigationBar.barStyle = UIBarStyleBlack;
	
	[self presentModalViewController:navigation animated:YES];
}

- (void)texture:(id)sender {
	/* Push a texture picker */
	textureListViewController.title = @"Textures";
	textureListViewController.delegate = self;
	textureListViewController.managedObjectContext = self.managedObjectContext;
	
	/* Enclose the modal in a navigation controller */
	UINavigationController *navigation = [[[UINavigationController alloc] init] autorelease];
	[navigation pushViewController:textureListViewController animated:NO];
	navigation.navigationBar.barStyle = UIBarStyleBlack;
	
	[self presentModalViewController:navigation animated:YES];
}

- (void)like:(id)sender {
	/* Toggle whether or not this model is a favorite of the user */
	self.model.favorite = [NSNumber numberWithBool:![self.model.favorite boolValue]];
	[ManagedContextHelper save:self.managedObjectContext];
	
	if ([self.model.favorite boolValue]) {
		self.like.title = @"Unlike"; 
	} else {
		self.like;
		self.like.title = @"Like";
	}
}

/* Download the image asynchronously, and then set the image when the DL is complete */
- (void)downloadTexture {
	if (self.model.texture != self.texture) {
		self.texture = nil;
		if (!self.model.texture) {
			return;
		}
		
		/* Set the activity indicatory and begin downloading */
		[self.activityIndicator startAnimating];
		dispatch_queue_t downloadQueue = dispatch_queue_create("Downloader", NULL);
		dispatch_async(downloadQueue, ^{
			UIImage *image = [Fetcher imageForUrl:self.model.texture.url];
			if (image) {
				dispatch_async(dispatch_get_main_queue(), ^{
					[self setTextureImage:image];
					[self.activityIndicator stopAnimating];
					self.texture = self.model.texture;
				});
			}
		});
		dispatch_release(downloadQueue);
	}
}

/* Download the model asynchronously, and then set the model when the DL is compelete */
- (void)downloadModel {
	if (!self.model && self.modelData) {
		[self.activityIndicator startAnimating];
		dispatch_queue_t downloadQueue = dispatch_queue_create("Downloader", NULL);
		dispatch_async(downloadQueue, ^{
			Model *aModel = [Model modelWithData:self.modelData andContext:self.managedObjectContext];
			dispatch_async(dispatch_get_main_queue(), ^{
				self.model = aModel;
				[self.activityIndicator stopAnimating];
				[self downloadTexture];
			});
		});
	} else if (self.model) {
		[self downloadTexture];
	}
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self downloadModel];
	
	/* Fix the visual style of the navigation item and toolbar */
	self.navigationController.toolbarHidden = NO;
	self.navigationController.toolbar.barStyle = UIBarStyleBlack;
	self.navigationController.toolbar.translucent = YES;
	self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
	self.navigationController.navigationBar.translucent = YES;
	
	/* Set the correct favorite button text */
	if ([self.model.favorite boolValue]) {
		self.like.title = @"Unlike"; 
	} else {
		self.like.title = @"Like";
	}
}

- (void)notesViewControllerDone:(NotesViewController *)controller {
	
	/* Hide the notes view */
	[self dismissModalViewControllerAnimated:YES];
	self.model.notes = controller.text;
	[ManagedContextHelper save:self.managedObjectContext];
}

- (void)infoViewControllerDone:(InfoViewController *)controller {
	
	/* Hide the info view */
	[self dismissModalViewControllerAnimated:YES];
}

- (void)textureListViewControllerDone:(TextureListViewController *)controller {
	
	/* Hide the texture view */
	[self dismissModalViewControllerAnimated:YES];
}

- (void)textureViewControllerDone:(TextureViewController *)controller {
	/* Hide the texture view */
	[self dismissModalViewControllerAnimated:YES];
}

- (void)textureViewController:(TextureViewController *)controller textureSelected:(Texture *)aTexture {
	self.model.texture = aTexture;
	self.texture = aTexture;
	[self setTextureImage:controller.imageView.image];
	[ManagedContextHelper save:self.managedObjectContext];
	[self dismissModalViewControllerAnimated:YES];
}

- (void)colorPickerViewControllerDone:(ColorPickerViewController *)controller {
	/* Get the color from the color picker, and store it in the data model */
	if (controller == materialPicker && materialPicker.color) {
		const CGFloat *components = CGColorGetComponents([materialPicker.color CGColor]);
		self.model.materialRed = [NSNumber numberWithFloat:components[0]];
		self.model.materialGreen = [NSNumber numberWithFloat:components[1]];
		self.model.materialBlue = [NSNumber numberWithFloat:components[2]];
		self.model.texture = nil;
		[ManagedContextHelper save:self.managedObjectContext];
	}
	
	[self dismissModalViewControllerAnimated:YES];
	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)releaseOutlets {
	self.like = nil;
	self.activityIndicator = nil;
}

- (void)viewDidUnload {
	[self releaseOutlets];
    [super viewDidUnload];
}

- (void)dealloc {
	glDeleteTextures(1, &textureHandle);
	[self releaseOutlets];
	[notesViewController release];
	[infoViewController release];
	[textureListViewController release];
	[materialPicker release];
	[managedObjectContext release];
	[model release];
	[texture release];
	[modelData release];
    [super dealloc];
}


@end
