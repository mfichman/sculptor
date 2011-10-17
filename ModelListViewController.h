//
//  ModelListViewController.h
//  Sculptor
//
//  Created by Matthew Fichman on 11/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#import "SculptViewController.h"

@interface ModelListViewController : UITableViewController {
	NSArray *modelList;
	NSManagedObjectContext *managedObjectContext;
}

@property (retain) NSArray *modelList;
@property (retain) NSManagedObjectContext *managedObjectContext;

@end
