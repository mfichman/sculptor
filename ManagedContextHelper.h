//
//  ManagedContextHelper.h
//  Sculptor
//
//  Created by Matthew Fichman on 12/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ManagedContextHelper : NSObject {

}

+ (void)save:(NSManagedObjectContext *)context;

@end
