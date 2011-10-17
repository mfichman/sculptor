//
//  ModelListViewController.m
//  Sculptor
//
//  Created by Matthew Fichman on 11/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ModelListViewController.h"
#import "SculptViewController.h"
#import "Fetcher.h"

@implementation ModelListViewController

@synthesize modelList, managedObjectContext;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	
	/* Download the list of textures asynchronously */
	dispatch_queue_t downloadQueue = dispatch_queue_create("Downloader", NULL);
	dispatch_async(downloadQueue, ^{
		NSArray *models = [Fetcher models];
		dispatch_async(dispatch_get_main_queue(), ^{
			self.modelList = models;
			[self.tableView reloadData];
		});
	});
	dispatch_release(downloadQueue);
	self.tableView.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
	self.tableView.separatorColor = [UIColor colorWithRed:0.23 green:0.23 blue:0.23 alpha:1.0];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	self.navigationController.toolbarHidden = YES;
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
	return YES;
}
#pragma mark -
#pragma mark Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	if (section == 0) {
		return self.modelList.count;
	} else {
		return 0;
	}
}


/* Create a table cell for the model downloaded from the server.  TODO: Add a thumbnail */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
	NSDictionary *model = [self.modelList objectAtIndex:indexPath.row];
	
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
	cell.textLabel.text = [model objectForKey:@"title"];
	cell.textLabel.textColor = [UIColor whiteColor];
	cell.detailTextLabel.text = [model objectForKey:@"author"];
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	/* Load the model data from the internets */
	NSDictionary *data = [self.modelList objectAtIndex:indexPath.row];
	
	/* Create the sculptor view */
	SculptViewController *sculpt = [[[SculptViewController alloc] init] autorelease];
	sculpt.modelData = data;
	sculpt.model = nil;
	//sculpt.model = [Model modelWithData:data andContext:self.managedObjectContext];
	sculpt.title = sculpt.model.title;
	sculpt.managedObjectContext = self.managedObjectContext;
	
	[self.navigationController pushViewController:sculpt animated:YES];
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	self.modelList = nil;
	self.managedObjectContext = nil;
    [super dealloc];
}


@end

