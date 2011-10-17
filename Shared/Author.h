//
//  Author.h
//  Sculptor
//
//  Created by Matthew Fichman on 12/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Model;

@interface Author :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * serverId;
@property (nonatomic, retain) NSString * fullName;
@property (nonatomic, retain) NSSet* models;

@end


@interface Author (CoreDataGeneratedAccessors)
- (void)addModelsObject:(Model *)value;
- (void)removeModelsObject:(Model *)value;
- (void)addModels:(NSSet *)value;
- (void)removeModels:(NSSet *)value;

@end

