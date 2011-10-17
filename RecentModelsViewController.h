//
//  RecentModelsViewController.h
//  Sculptor
//
//  Created by Matthew Fichman on 12/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"

@interface RecentModelsViewController : CoreDataTableViewController {
	NSManagedObjectContext *managedObjectContext;
}

@property (retain) NSManagedObjectContext *managedObjectContext;

@end
