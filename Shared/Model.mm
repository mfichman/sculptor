// 
//  Model.m
//  Sculptor
//
//  Created by Matthew Fichman on 12/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Model.h"
#import "ManagedContextHelper.h"
#import "Fetcher.h"

#include "Vector.hpp"

#define MAX_VERTICES 2048

@implementation Model 


+ (Model *)modelWithData:(NSDictionary *)data andContext:(NSManagedObjectContext *)context {
	
	NSString *modelId = [data objectForKey:@"id"];
	
	/* Try to look up the model by server ID first.  If it doesn't exist, then create it */
	NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
	request.entity = [NSEntityDescription entityForName:@"Model" inManagedObjectContext:context];
	request.predicate = [NSPredicate predicateWithFormat:@"serverId = %@", modelId];
	
	NSError *error = nil;
	Model *model = [[context executeFetchRequest:request error:&error] lastObject];
	
	/* If the model was missing, then create it from the data */
	if (!error && !model) {
		data = [Fetcher modelForId:[data objectForKey:@"id"]];
		
		model = [NSEntityDescription insertNewObjectForEntityForName:@"Model" inManagedObjectContext:context];
		model.title = [data objectForKey:@"title"];
		model.serverId = [data objectForKey:@"id"];
		model.author = nil;
		model.texture = nil;
		
		NSScanner *scanner;
		float value;
		
		/* Read in the vertices from the vertex string */
		float vertexArray[MAX_VERTICES];
		int numVertexComponents = 0;
		scanner = [NSScanner scannerWithString:[data objectForKey:@"vertices"]];
		while (numVertexComponents < MAX_VERTICES && [scanner scanFloat:&value]) {
			vertexArray[numVertexComponents++] = value;
		}
		
		/* Read in the normals from the normal string */
		float normalArray[MAX_VERTICES];
		int numNormalComponents = 0;
		scanner = [NSScanner scannerWithString:[data objectForKey:@"normals"]];
		while (numNormalComponents < MAX_VERTICES && [scanner scanFloat:&value]) {
			normalArray[numNormalComponents++] = value;
		}
		
		/* Read in texcoords */
		float texcoordArray[MAX_VERTICES];
		int numTexcoordComponents = 0;
		scanner = [NSScanner scannerWithString:[data objectForKey:@"texcoords"]];
		while (numTexcoordComponents < MAX_VERTICES && [scanner scanFloat:&value]) {
			texcoordArray[numTexcoordComponents++] = value;
		}
		
		/* Auto-generate the normals if there aren't any in the download */
		if (numNormalComponents == 0) {
			NSLog(@"Auto-generating normals!");
			
			for (int i = 0; i <= numVertexComponents - 9; i += 9) {
				/* For each face, take 2 vectors and get the cross product to find the normal */
				Vector v1(vertexArray[i+0], vertexArray[i+1], vertexArray[i+2]);
				Vector v2(vertexArray[i+3], vertexArray[i+4], vertexArray[i+5]);
				Vector v3(vertexArray[i+6], vertexArray[i+7], vertexArray[i+8]);
				Vector d1 = v2 - v1;
				Vector d2 = v3 - v1;
				
				Vector norm = d1.cross(d2).unit();
				
				/* This will create sharp edges, but that's ok */
				normalArray[i+0] = norm.x; normalArray[i+1] = norm.y; normalArray[i+2] = norm.z;
				normalArray[i+3] = norm.x; normalArray[i+4] = norm.y; normalArray[i+5] = norm.z;
				normalArray[i+6] = norm.x; normalArray[i+7] = norm.y; normalArray[i+8] = norm.z;
			}
			numNormalComponents = numVertexComponents;
		}
		
	
		/* 
		 * Take the min of the # normals and # vertices.  Also, the count must
		 * be congruent to 0 mod 3. 
		 */
		
		int count = (numVertexComponents < numNormalComponents) ? numVertexComponents : numNormalComponents;
		count = (count * 3) / 3;
		model.vertices = [NSData dataWithBytes:vertexArray length:count*sizeof(float)];
		model.normals = [NSData dataWithBytes:normalArray length:count*sizeof(float)];
		if (numTexcoordComponents) {
			model.texcoords = [NSData dataWithBytes:texcoordArray length:count*sizeof(float)*3/2];
		}
		
		NSLog(@"Vertex count: %d", count);
		
		[ManagedContextHelper save:context];
	}
	
	if (model) {
		model.lastViewed = [NSDate date];
		[ManagedContextHelper save:context];
	}
	
	return model;
}

@dynamic normals;
@dynamic lastViewed;
@dynamic serverId;
@dynamic title;
@dynamic vertices;
@dynamic texcoords;
@dynamic dateCreated;
@dynamic favorite;
@dynamic indices;
@dynamic dateModified;
@dynamic author;
@dynamic texture;
@dynamic materialRed;
@dynamic materialBlue;
@dynamic materialGreen;
@dynamic notes;

@end
