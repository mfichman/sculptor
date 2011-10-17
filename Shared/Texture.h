//
//  Texture.h
//  Sculptor
//
//  Created by Matthew Fichman on 12/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

@class Model;

@interface Texture :  NSManagedObject  {
	GLuint handle;
	UIImage *image;
}

+ (Texture *)textureWithData:(NSDictionary *)data andContext:(NSManagedObjectContext *)context;

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * serverId;
@property (nonatomic, retain) NSString * path;
@property (nonatomic, retain) NSString * thumb;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSSet* models;
@end


@interface Texture (CoreDataGeneratedAccessors)
- (void)addModelsObject:(Model *)value;
- (void)removeModelsObject:(Model *)value;
- (void)addModels:(NSSet *)value;
- (void)removeModels:(NSSet *)value;

@end

