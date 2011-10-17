//
//  Fetcher.h
//  Sculptor
//
//  Created by Matthew Fichman on 11/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Fetcher : NSObject {
}

+ (NSArray *)models;
+ (NSArray *)textures;
+ (NSDictionary *)modelForId:(NSString *)modelId;
+ (NSDictionary *)authorForId:(NSString *)authorId;
+ (NSDictionary *)textureForId:(NSString *)textureId;
+ (UIImage *)imageForUrl:(NSString *)url;

@end
