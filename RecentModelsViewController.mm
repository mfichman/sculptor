    //
//  RecentModelsViewController.m
//  Sculptor
//
//  Created by Matthew Fichman on 12/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RecentModelsViewController.h"
#import "SculptViewController.h"


#define MAX_RECENT_MODELS 24
#define TWO_DAYS_IN_SECS 60 * 60 * 24

@implementation RecentModelsViewController

@synthesize managedObjectContext;

- (void)setManagedObjectContext:(NSManagedObjectContext *)context {
	[managedObjectContext release];
	managedObjectContext = [context retain];
	
	
	NSDate *twoDaysAgo = [NSDate dateWithTimeIntervalSinceNow:-TWO_DAYS_IN_SECS];
	
	/* Build a fetch request to the models in order, but only if recenty viewed */
	NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
	request.entity = [NSEntityDescription entityForName:@"Model" inManagedObjectContext:context];
	request.predicate = [NSPredicate predicateWithFormat:@"lastViewed > %@", twoDaysAgo];
	request.sortDescriptors = [NSArray arrayWithObject: [NSSortDescriptor sortDescriptorWithKey:@"lastViewed" ascending:NO]];
	request.fetchLimit = MAX_RECENT_MODELS;
	
	NSFetchedResultsController *frc = [[[NSFetchedResultsController alloc]
		initWithFetchRequest:request
		managedObjectContext:context 
		sectionNameKeyPath:nil 
		cacheName:nil] autorelease];

	/* Initialize the fields we want to be visible */
	self.fetchedResultsController = frc;
	self.titleKey = @"title";
	self.subtitleKey = @"dateCreated";
	self.searchKey = @"title";
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

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

	self.title = @"Recents";
	self.tableView.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
	self.tableView.separatorColor = [UIColor colorWithRed:0.23 green:0.23 blue:0.23 alpha:1.0];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
	return YES;
}

- (void)dealloc {
	[managedObjectContext release];
    [super dealloc];
}


@end
