//
//  InfoViewController.m
//  Sculptor
//
//  Created by Matthew Fichman on 12/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "InfoViewController.h"


@implementation InfoViewController

@synthesize model, delegate;

#pragma mark -
#pragma mark Initialization

#pragma mark -
#pragma mark View lifecycle

- (void)done:(id)sender {
	[self.delegate infoViewControllerDone:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.tableView.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
	self.tableView.separatorColor = [UIColor colorWithRed:0.23 green:0.23 blue:0.23 alpha:1.0];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self.tableView reloadData];
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
	return YES;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 4;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier] autorelease];
    }
	
	cell.detailTextLabel.textColor = [UIColor whiteColor];
	cell.textLabel.textColor = [UIColor lightGrayColor];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
	switch (indexPath.row) {
		case 0:
			cell.textLabel.text = @"Mesh title";
			cell.detailTextLabel.text = self.model.title;
			break;
		case 1:
			cell.textLabel.text = @"Last viewed";
			cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", self.model.lastViewed];
			break;
		case 2:
			cell.textLabel.text = @"Vertex count";
			cell.detailTextLabel.text = @"203";
			break;
		case 3:
			cell.textLabel.text = @"Favorite?";
			cell.detailTextLabel.text = self.model.favorite.boolValue ? @"Yes" : @"No";
			break;
		
	}
    // Configure the cell...
    
    return cell;
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	[model release];
    [super dealloc];
}


@end

