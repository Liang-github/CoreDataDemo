//
//  CommonTool.m
//  CoreDataDemo
//
//  Created by PengLiang on 2017/12/8.
//  Copyright © 2017年 PengLiang. All rights reserved.
//

#import "CommonTool.h"

@implementation CommonTool

+ (NSString *)getPinYinFromString:(NSString *)string {
    CFMutableStringRef aCstring = CFStringCreateMutableCopy(NULL, 0, (__bridge CFStringRef)string);
    CFStringTransform(aCstring, NULL, kCFStringTransformMandarinLatin, NO);
    
    CFStringTransform(aCstring, NULL, kCFStringTransformStripDiacritics, NO);
    
    return [NSString stringWithFormat:@"%@",aCstring];
}

@end

