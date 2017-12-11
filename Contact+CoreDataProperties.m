//
//  Contact+CoreDataProperties.m
//  CoreDataDemo
//
//  Created by PengLiang on 2017/12/8.
//  Copyright © 2017年 PengLiang. All rights reserved.
//
//

#import "Contact+CoreDataProperties.h"

@implementation Contact (CoreDataProperties)

+ (NSFetchRequest<Contact *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Contact"];
}

@dynamic name;
@dynamic namePinYin;
@dynamic phoneNum;
@dynamic sectionName;

@end
