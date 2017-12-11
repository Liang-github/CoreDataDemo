//
//  XBCoreDataStackManager.h
//  CoreDataDemo
//
//  Created by PengLiang on 2017/12/11.
//  Copyright © 2017年 PengLiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#define kXBCoreDataStackManager [XBCoreDataStackManager shareInstance]

@interface XBCoreDataStackManager : NSObject

+ (XBCoreDataStackManager *)shareInstance;
// 管理对象上下文
@property (nonatomic, strong) NSManagedObjectContext *manageObjectContext;
// 模型对象
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
// 存储调度器
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
// 保存
- (void)save;

@end
