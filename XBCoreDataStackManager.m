//
//  XBCoreDataStackManager.m
//  CoreDataDemo
//
//  Created by PengLiang on 2017/12/11.
//  Copyright © 2017年 PengLiang. All rights reserved.
//

#import "XBCoreDataStackManager.h"

@implementation XBCoreDataStackManager

+ (XBCoreDataStackManager *)shareInstance {
    static XBCoreDataStackManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[XBCoreDataStackManager alloc] init];
    });
    
    return manager;
}
- (NSURL *)getDoumentUrlPath {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}
- (NSManagedObjectContext *)manageObjectContext {
    if (_manageObjectContext != nil) {
        return _manageObjectContext;
    }
    _manageObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    // 设置存储调度器
    [_manageObjectContext setPersistentStoreCoordinator:self.persistentStoreCoordinator];
    
    return _manageObjectContext;
}
- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    return _managedObjectModel;
}
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    NSURL *url = [[self getDoumentUrlPath] URLByAppendingPathComponent:@"sqlit.db" isDirectory:YES];
    
    [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:nil];
    
    return _persistentStoreCoordinator;
}
- (void)save {
    [self.manageObjectContext save:nil];
}
@end
