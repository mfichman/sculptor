//
//  TextureListViewController.m
//  Sculptor
//
//  Created by Matthew Fichman on 12/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TextureListViewController.h"
#import "Fetcher.h"

@implementation TextureListViewController

@synthesize textureList, textureViewController, managedObjectContext, delegate, thumbnailList;

#pragma mark -
#pragma mark View lifecycle


- (id)init {
	if ((self = [super init])) {
		self.textureViewController = [[[TextureViewController alloc] init] autorelease];
		self.thumbnailList = [NSMutableDictionary dictionary];
	}
	
	return self;
	
}

- (void)done:(id)sender {
	/* Notify the delegate that the done button was pressed */
	[self.delegate textureListViewControllerDone:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	/* Download the list of textures asynchronously */
	dispatch_queue_t downloadQueue = dispatch_queue_create("Downloader", NULL);
	dispatch_async(downloadQueue, ^{
		NSArray *textures = [Fetcher textures];
		dispatch_async(dispatch_get_main_queue(), ^{
			self.textureList = textures;
			[self.tableView reloadData];
		});
	});
	dispatch_release(downloadQueue);
	
	/* Cosmetic fixes */
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)] autorelease];
	self.tableView.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
	self.tableView.separatorColor = [UIColor colorWithRed:0.23 green:0.23 blue:0.23 alpha:1.0];
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
		return self.textureList.count;
	} else {
		return 0;
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
	/* Set the cell text */
	NSDictionary *texture = [self.textureList objectAtIndex:indexPath.row];
	cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
	cell.textLabel.text = [texture objectForKey:@"title"];
	cell.textLabel.textColor = [UIColor whiteColor];
	
	/* Get the iamge if it doesn't exist */
	NSString *rowKey = [NSString stringWithFormat:@"%d", indexPath.row];
	cell.imageView.image = [self.thumbnailList objectForKey:rowKey];
	if (!cell.imageView.image) {
		cell.imageView.image = [UIImage imageNamed:@"blank.png"];
		dispatch_queue_t downloadQueue = dispatch_queue_create("Downloader", NULL);
		dispatch_async(downloadQueue, ^{
			/* Start downloading the thumbnails */
			UIImage *image = [Fetcher imageForUrl:[texture objectForKey:@"thumb"]];
			if (!image) {
				image = [UIImage imageNamed:@"blank.png"];
			}
			dispatch_async(dispatch_get_main_queue(), ^{
				/* Add this image to the thumbnail list, then reload the row */
				[self.thumbnailList setObject:image forKey:rowKey];
				[self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
			});
		});
	}
    
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	/* Create a managed object for the texture data */
	NSDictionary *textureData = [self.textureList objectAtIndex:indexPath.row];

	/* Create a texture view */
	self.textureViewController.texture = [Texture textureWithData:textureData andContext:self.managedObjectContext];
	self.textureViewController.title = self.textureViewController.texture.title;
	self.textureViewController.managedObjectContext = self.managedObjectContext;
	
	[self.navigationController pushViewController:self.textureViewController animated:YES];
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	self.delegate = nil;
	self.textureList = nil;
	self.managedObjectContext = nil;
	self.textureViewController = nil;
    [super dealloc];
}


@end

