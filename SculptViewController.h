//
//  SculptViewController.h
//  Sculptor
//
//  Created by Matthew Fichman on 12/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EAGLViewController.h"
#import "Model.h"
#import "Texture.h"
#import "ColorPickerViewController.h"
#import "NotesViewController.h"
#import "InfoViewController.h"
#import "TextureListViewController.h"
#import "TextureViewController.h"

#include "Vector.hpp"
#include "Matrix.hpp"

@class SculptViewController;

@interface SculptViewController : EAGLViewController <ColorPickerViewControllerDelegate, 
		NotesViewControllerDelegate, InfoViewControllerDelegate, 
		TextureListViewControllerDelegate, TextureViewControllerDelegate> {
			
	/* Model displayed, plus some mutable data for editing */
	Model *model;
	Texture *texture;
	NSDictionary *modelData;
	
	/* Rotation view state */
	Matrix baseRotation;
	Vector rotationAxis;
	float rotationAngle;
	float zoomLevel;
	GLuint textureHandle;
	
	/* Color picker for material */
	ColorPickerViewController *materialPicker;
	NotesViewController *notesViewController;
	InfoViewController *infoViewController;
	TextureListViewController *textureListViewController;
	
	NSManagedObjectContext *managedObjectContext;
	UIBarButtonItem *like;
	UIActivityIndicatorView *activityIndicator;
}

@property (retain) Model *model;
@property (retain) Texture *texture;
@property (retain) NSDictionary *modelData;
@property (retain) NSManagedObjectContext *managedObjectContext;
@property (retain) UIBarButtonItem *like;
@property (retain) UIActivityIndicatorView *activityIndicator;

@end
