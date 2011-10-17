//
//  TextureListViewController.h
//  Sculptor
//
//  Created by Matthew Fichman on 12/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#import "TextureViewController.h"

@class TextureListViewController;

@protocol TextureListViewControllerDelegate
- (void)textureListViewControllerDone:(TextureListViewController *)controller;
@end


@interface TextureListViewController : UITableViewController {
	NSArray *textureList;
	NSMutableDictionary *thumbnailList;
	NSManagedObjectContext *managedObjectContext;
	TextureViewController *textureViewController;
	id <TextureListViewControllerDelegate> delegate;
}

@property (retain) NSArray *textureList;
@property (retain) NSMutableDictionary *thumbnailList;
@property (retain) NSManagedObjectContext *managedObjectContext;
@property (retain) TextureViewController *textureViewController;
@property (assign) id <TextureListViewControllerDelegate> delegate;
@end
