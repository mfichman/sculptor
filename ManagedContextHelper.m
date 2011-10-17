//
//  ManagedContextHelper
//  Sculptor
//
//  Created by Matthew Fichman on 12/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ManagedContextHelper.h"


@implementation ManagedContextHelper

+ (void)save:(NSManagedObjectContext *)context {
	NSError *error = nil;
	if ([context hasChanges] && ![context save:&error]) {
		NSLog(@"Error! %@, %@", error, [error userInfo]);
		abort();
	}
}

@end
