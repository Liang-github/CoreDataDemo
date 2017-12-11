//
//  EditContactVC.m
//  CoreDataDemo
//
//  Created by PengLiang on 2017/12/11.
//  Copyright © 2017年 PengLiang. All rights reserved.
//

#import "EditContactVC.h"
#import "ZxkRegular.h"
#import "CommonTool.h"
#import "CoreDataTool.h"

@interface EditContactVC ()

@property (nonatomic, strong) UITextField *nameTextFile;

@property (nonatomic, strong) UITextField *phoneNumNextFile;

@end

@implementation EditContactVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelClick)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneClick)];
    self.nameTextFile.text = self.contact.name;
    self.phoneNumNextFile.text = self.contact.phoneNum;
    
}

- (void)cancelClick {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)doneClick {
    if ([self checkTextField] == NO) {
        return;
    }
    
    self.contact.name = self.nameTextFile.text;
    self.contact.phoneNum = self.phoneNumNextFile.text;
    
    self.contact.namePinYin = [CommonTool getPinYinFromString:self.nameTextFile.text];
    
    self.contact.sectionName = [[self.contact.namePinYin substringFromIndex:1] uppercaseString];
    
    [kXBCoreDataStackManager save];
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (BOOL)checkTextField {
    if (self.nameTextFile.text.length == 0) {
        UIAlertController *c = [UIAlertController alertControllerWithTitle:@"提示" message:@"姓名不能为空" preferredStyle:UIAlertControllerStyleAlert];
        [c addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:c animated:YES completion:nil];
        return NO;
    } else if ([ZxkRegular regularPhone:self.phoneNumNextFile.text] == NO) {
        UIAlertController *c = [UIAlertController alertControllerWithTitle:@"提示" message:@"手机格式错误" preferredStyle:UIAlertControllerStyleAlert];
        [c addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:c animated:YES completion:nil];
        return NO;
    } else {
        return YES;
    }
}
@end
