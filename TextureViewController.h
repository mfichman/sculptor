//
//  TextureViewController.h
//  Sculptor
//
//  Created by Matthew Fichman on 12/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Texture.h"

@class TextureViewController;

@protocol TextureViewControllerDelegate
- (void)textureViewControllerDone:(TextureViewController *)controller;
- (void)textureViewController:(TextureViewController *)controller textureSelected:(Texture *)texture;
@end

@interface TextureViewController : UIViewController <UIScrollViewDelegate> {
	Texture *texture;
	NSManagedObjectContext *managedObjectContext;
	id <TextureViewControllerDelegate> delegate;
	
	IBOutlet UIImageView *imageView;
	IBOutlet UIScrollView *scrollView;
	IBOutlet UIActivityIndicatorView *activityIndicator;
}

@property (retain) Texture *texture;
@property (retain) NSManagedObjectContext *managedObjectContext;
@property (assign) id <TextureViewControllerDelegate> delegate;
@property (retain) IBOutlet UIImageView *imageView;
@property (retain) IBOutlet UIScrollView *scrollView;
@property (retain) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
