//
//  Model.h
//  Sculptor
//
//  Created by Matthew Fichman on 12/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "Texture.h"

@interface Model :  NSManagedObject {
}

+ (Model *)modelWithData:(NSDictionary *)data andContext:(NSManagedObjectContext *)context;

@property (nonatomic, retain) NSData * normals;
@property (nonatomic, retain) NSDate * lastViewed;
@property (nonatomic, retain) NSString * serverId;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSData * vertices;
@property (nonatomic, retain) NSData * texcoords;
@property (nonatomic, retain) NSDate * dateCreated;
@property (nonatomic, retain) NSNumber * favorite;
@property (nonatomic, retain) NSData * indices;
@property (nonatomic, retain) NSDate * dateModified;
@property (nonatomic, retain) NSManagedObject * author;
@property (nonatomic, retain) Texture * texture;
@property (nonatomic, retain) NSNumber * materialBlue;
@property (nonatomic, retain) NSNumber * materialGreen;
@property (nonatomic, retain) NSNumber * materialRed;
@property (nonatomic, retain) NSString * notes;

@end




