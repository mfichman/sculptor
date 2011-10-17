//
//  FavoriteModelsViewController.h
//  Sculptor
//
//  Created by Matthew Fichman on 12/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "CoreDataTableViewController.h"
#import "SculptViewController.h"

@interface FavoriteModelsViewController : CoreDataTableViewController {
	NSManagedObjectContext *managedObjectContext;
}

@property (retain) NSManagedObjectContext *managedObjectContext;

@end
