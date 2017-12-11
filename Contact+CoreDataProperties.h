//
//  Contact+CoreDataProperties.h
//  CoreDataDemo
//
//  Created by PengLiang on 2017/12/8.
//  Copyright © 2017年 PengLiang. All rights reserved.
//
//

#import "Contact+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Contact (CoreDataProperties)

+ (NSFetchRequest<Contact *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *namePinYin;
@property (nullable, nonatomic, copy) NSString *phoneNum;
@property (nullable, nonatomic, copy) NSString *sectionName;

@end

NS_ASSUME_NONNULL_END
