// 
//  Texture.m
//  Sculptor
//
//  Created by Matthew Fichman on 12/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Texture.h"
#import "Model.h"
#import "ManagedContextHelper.h"

@implementation Texture 

/* Loads a texture using the dictionary JSON object and the context */
+ (Texture *)textureWithData:(NSDictionary *)data andContext:(NSManagedObjectContext *)context {
	NSString *textureId = [data objectForKey:@"id"];
	
	/* Try to look up the texture by server ID first.  If it doesn't exist, then create it */
	NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
	request.entity = [NSEntityDescription entityForName:@"Texture" inManagedObjectContext:context];
	request.predicate = [NSPredicate predicateWithFormat:@"serverId = %@", textureId];
	
	NSError *error = nil;
	Texture *texture = [[context executeFetchRequest:request error:&error] lastObject];
	
	/* If the texture was missing then create it from the data */
	if (!error && !texture) {
		
		texture = [NSEntityDescription insertNewObjectForEntityForName:@"Texture" inManagedObjectContext:context];
		texture.title = [data objectForKey:@"title"];
		texture.serverId = [data objectForKey:@"id"];
		texture.url = [data objectForKey:@"data"];
		texture.thumb = [data objectForKey:@"thumb"];
		[ManagedContextHelper save:context];
	}
	return texture;
}


@dynamic title;
@dynamic serverId;
@dynamic path;
@dynamic models;
@dynamic thumb;
@dynamic url;

@end
