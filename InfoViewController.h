//
//  InfoViewController.h
//  Sculptor
//
//  Created by Matthew Fichman on 12/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model.h"

@class InfoViewController;

@protocol InfoViewControllerDelegate

- (void)infoViewControllerDone:(InfoViewController *)controller;

@end

@interface InfoViewController : UITableViewController {
	Model *model;
	
	id <InfoViewControllerDelegate> delegate;
}

@property (retain) Model *model;
@property (assign) id <InfoViewControllerDelegate> delegate;

@end
