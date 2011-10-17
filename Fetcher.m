//
//  Fetcher.m
//  Sculptor
//
//  Created by Matthew Fichman on 11/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Fetcher.h"
#import "JSON.h"

#define SERVER_URL @"http://sculptor.heroku.com"
//#define SERVER_URL @"http://localhost:3000"


@implementation Fetcher

/* Fetches a list of models from the server in property list format */
+ (NSArray *)models {	
	NSURL *url = [NSURL URLWithString:[SERVER_URL stringByAppendingString:@"/models.json"]];
	NSLog(@"Querying server: %@", url);
	return [[NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil] JSONValue];
}

/* Fetches a list of textures from the server in property list format */
+ (NSArray *)textures {
	NSURL *url = [NSURL URLWithString:[SERVER_URL stringByAppendingString:@"/textures.json"]];
	NSLog(@"Querying server: %@", url);
	return [[NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil] JSONValue];
}

/* Fetches a full model from the server in property list format */
+ (NSDictionary *)modelForId:(NSString *)modelId {
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/models/%@.json", SERVER_URL, modelId]];
	NSLog(@"Querying server: %@", url);
	return [[NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil] JSONValue];	
}

/* Fetches an author from the server in property list format */
+ (NSDictionary *)authorForId:(NSString *)authorId {
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/authors/%@.json", SERVER_URL, authorId]];
	NSLog(@"Querying server: %@", url);
	return [[NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding	error:nil] JSONValue];
}

/* Fetches a texture from the server in property list format */
+ (NSDictionary *)textureForId:(NSString *)textureId {
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/textures/%@.json", SERVER_URL, textureId]];
	NSLog(@"Querying server: %@", url);
	return [[NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding	error:nil] JSONValue];
}

/* Fetches a texture image from the server */
+ (UIImage *)imageForUrl:(NSString *)url {
	NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
	NSLog(@"Querying server: %@", url);
	return [[[UIImage alloc] initWithData:data] autorelease];
}

@end
