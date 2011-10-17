    //
//  FavoriteModelsViewController.m
//  Sculptor
//
//  Created by Matthew Fichman on 12/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FavoriteModelsViewController.h"
#import "ManagedContextHelper.h"


@implementation FavoriteModelsViewController

@synthesize managedObjectContext;

- (void)setManagedObjectContext:(NSManagedObjectContext *)context {
	[managedObjectContext release];
	managedObjectContext = [context retain];
		
	/* Make a fetch request for the favorites */
	NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
	request.entity = [NSEntityDescription entityForName:@"Model" inManagedObjectContext:context];
	request.predicate = [NSPredicate predicateWithFormat:@"favorite > 0"];
	request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor
		sortDescriptorWithKey:@"title" 
		ascending:YES]];
	
	NSFetchedResultsController *frc = [[[NSFetchedResultsController alloc]
	    initWithFetchRequest:request
		managedObjectContext:context
		sectionNameKeyPath:nil
	    cacheName:nil] autorelease];
	
	/* Set some more view options */
	self.fetchedResultsController = frc;
	self.titleKey = @"title";
	self.subtitleKey = @"dateCreated";
	self.searchKey = @"title";
}


// called to see if the specified managed object is allowed to be deleted (default is NO)
- (BOOL)canDeleteManagedObject:(NSManagedObject *)managedObject {
	return YES;
}

// called when the user commits a delete by hitting a Delete button in the user-interface (default is to do nothing)
// this method does not necessarily have to delete the object from the database
// (e.g. it might just change the object so that it does not match the fetched results controller's predicate anymore)
- (void)deleteManagedObject:(NSManagedObject *)managedObject {
	Model *model = (Model *)managedObject;
	model.favorite = [NSNumber numberWithBool:NO];
	[ManagedContextHelper save:self.managedObjectContext];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return YES;
}

- (void)managedObjectSelected:(NSManagedObject *)managedObject {
	
	/* Create the sculptor view */
	SculptViewController *sculpt = [[[SculptViewController alloc] init] autorelease];
	sculpt.model = (Model *)managedObject;
	sculpt.title = sculpt.model.title;
	sculpt.managedObjectContext = self.managedObjectContext;
	
	[self.navigationController pushViewController:sculpt animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	self.navigationController.toolbarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.navigationItem.rightBarButtonItem = self.editButtonItem;
	self.title = @"Favorites";
	self.tableView.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
	self.tableView.separatorColor = [UIColor colorWithRed:0.23 green:0.23 blue:0.23 alpha:1.0];
}

- (void)dealloc {
	[managedObjectContext release];
    [super dealloc];
}


@end
