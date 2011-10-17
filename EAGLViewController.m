//
//  EAGLViewController.m
//  Model
//
//  Created by Matthew Fichman on 11/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "EAGLViewController.h"
#import "EAGLView.h"

// Uniform index.
enum {
    UNIFORM_TRANSLATE,
    NUM_UNIFORMS
};
GLint uniforms[NUM_UNIFORMS];

// Attribute index.
enum {
    ATTRIB_VERTEX,
    ATTRIB_COLOR,
    NUM_ATTRIBUTES
};

@interface EAGLViewController ()
@property (nonatomic, retain) EAGLContext *context;
@end

@implementation EAGLViewController

@synthesize animating, context, eaglView;

- (id)init {
	if ((self = [super init])) {
		//EAGLContext *aContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
		//if (!aContext) {
		//	aContext = [[[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1] autorelease];
		//}
    
		// Always use OpenGL ES 1, for simplicity
		EAGLContext *aContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
		
		if (!aContext) {
			NSLog(@"Failed to create ES context");
		} else if (![EAGLContext setCurrentContext:aContext]) {
			NSLog(@"Failed to set ES context current");
		}
    
		self.context = aContext;
    
		animating = FALSE;
		displayLinkSupported = FALSE;
		animationFrameInterval = 1;
		displayLink = nil;
		animationTimer = nil;
    
		// Use of CADisplayLink requires iOS version 3.1 or greater.
		// The NSTimer object is used as fallback when it isn't available.
		NSString *reqSysVer = @"3.1";
		NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
		if ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending) {
			displayLinkSupported = TRUE;
		}
	}
	
	return self;
}

- (void)loadView {
	[super loadView];
	
	CGRect frame = [[UIScreen mainScreen] applicationFrame];	
	frame.size.height -= 60;
	
	self.view = [[[UIView alloc] initWithFrame:frame] autorelease];
	self.eaglView = [[[EAGLView alloc] initWithFrame:frame] autorelease];
	[self.eaglView setContext: self.context];
	[self.eaglView setFramebuffer];
	[self.view addSubview:eaglView];
}

- (void)dealloc {
    // Tear down context.
    if ([EAGLContext currentContext] == context) {
        [EAGLContext setCurrentContext:nil];
	}
	
    [context release];
    [self.eaglView release];
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated {
    [self startAnimation];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self stopAnimation];
    [super viewWillDisappear:animated];
}

- (void)viewDidUnload {
	[super viewDidUnload];
    
	// Tear down context.
    if ([EAGLContext currentContext] == context) {
        [EAGLContext setCurrentContext:nil];
	}
	self.eaglView = nil;
	self.context = nil;	
}

- (NSInteger)animationFrameInterval {
    return animationFrameInterval;
}

- (void)setAnimationFrameInterval:(NSInteger)frameInterval {
    /*
	 Frame interval defines how many display frames must pass between each time the display link fires.
	 The display link will only fire 30 times a second when the frame internal is two on a display that refreshes 60 times a second. The default frame interval setting of one will fire 60 times a second when the display refreshes at 60 times a second. A frame interval setting of less than one results in undefined behavior.
	 */
    if (frameInterval >= 1) {
        animationFrameInterval = frameInterval;
        
        if (animating) {
            [self stopAnimation];
            [self startAnimation];
        }
    }
}

- (void)startAnimation {
    if (!animating) {
        if (displayLinkSupported) {
            /*
			 CADisplayLink is API new in iOS 3.1. Compiling against earlier versions will result in a warning, but can be dismissed if the system version runtime check for CADisplayLink exists in -awakeFromNib. The runtime check ensures this code will not be called in system versions earlier than 3.1.
            */
            displayLink = [NSClassFromString(@"CADisplayLink") displayLinkWithTarget:self selector:@selector(drawFrame)];
            [displayLink setFrameInterval:animationFrameInterval];
            
            // The run loop will retain the display link on add.
            [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        } else {
            animationTimer = [NSTimer scheduledTimerWithTimeInterval:(NSTimeInterval)((1.0 / 60.0) * animationFrameInterval) target:self selector:@selector(drawFrame) userInfo:nil repeats:TRUE];
        }
        animating = TRUE;
    }
}

- (void)stopAnimation {
    if (animating) {
        if (displayLinkSupported) {
            [displayLink invalidate];
            displayLink = nil;
		} else {
            [animationTimer invalidate];
            animationTimer = nil;
        }
        
        animating = FALSE;
    }
}

- (void)drawFrame {
    [self.eaglView setFramebuffer];
    
    // Replace the implementation of this method to do your own custom drawing.
    static const GLfloat squareVertices[] = {
        -0.5f, -0.33f,
        0.5f, -0.33f,
        -0.5f,  0.33f,
        0.5f,  0.33f,
    };
    
    static const GLubyte squareColors[] = {
        255, 255,   0, 255,
        0,   255, 255, 255,
        0,     0,   0,   0,
        255,   0, 255, 255,
    };
    
    static float transY = 0.0f;
    
    glClearColor(0.5f, 0.5f, 0.5f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);

	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
	glTranslatef(0.0f, (GLfloat)(sinf(transY)/2.0f), 0.0f);
	transY += 0.075f;
        
	glVertexPointer(2, GL_FLOAT, 0, squareVertices);
	glEnableClientState(GL_VERTEX_ARRAY);
	glColorPointer(4, GL_UNSIGNED_BYTE, 0, squareColors);
	glEnableClientState(GL_COLOR_ARRAY);
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    
    [self.eaglView presentFramebuffer];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


@end
