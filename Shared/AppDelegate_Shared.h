//
//  AppDelegate_Shared.h
//  Sculptor
//
//  Created by Matthew Fichman on 11/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "ModelListViewController.h"
#import "FavoriteModelsViewController.h"
#import "RecentModelsViewController.h"

@interface AppDelegate_Shared : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
	UIViewController *rootViewController;
	ModelListViewController *modelListViewController;
	FavoriteModelsViewController *favoriteModelsViewController;
	RecentModelsViewController *recentModelsViewController;
    
@private
    NSManagedObjectContext *managedObjectContext_;
    NSManagedObjectModel *managedObjectModel_;
    NSPersistentStoreCoordinator *persistentStoreCoordinator_;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UIViewController *rootViewController;
@property (nonatomic, retain) IBOutlet ModelListViewController *modelListViewController;
@property (nonatomic, retain) IBOutlet FavoriteModelsViewController *favoriteModelsViewController;
@property (nonatomic, retain) IBOutlet RecentModelsViewController *recentModelsViewController;

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSString *)applicationDocumentsDirectory;
- (void)saveContext;

@end

