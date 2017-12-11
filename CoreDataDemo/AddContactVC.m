//
//  AddContactVC.m
//  CoreDataDemo
//
//  Created by PengLiang on 2017/12/11.
//  Copyright © 2017年 PengLiang. All rights reserved.
//

#import "AddContactVC.h"
#import "Contact+CoreDataProperties.h"
#import "CoreDataTool.h"

@interface AddContactVC ()


@property (nonatomic, strong) UITextField *nameText;
@property (nonatomic, strong) UITextField *phoneNum;
@end

@implementation AddContactVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButton:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(updateContact:)];
    
    [self setUI];
}

- (void)setUI {
    
    _nameText = [[UITextField alloc] init];
    _nameText.frame = CGRectMake(20, 100, self.view.frame.size.width - 40, 30);
    _nameText.borderStyle = 3;
    _nameText.placeholder = @"姓名";
    [self.view addSubview:_nameText];
    
    _phoneNum = [[UITextField alloc] init];
    _phoneNum.frame = CGRectMake(20, 150, self.view.frame.size.width - 40, 30);
    _phoneNum.borderStyle = 3;
    _phoneNum.placeholder = @"电话号码";
    [self.view addSubview:_phoneNum];
}
- (void)cancelButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)updateContact:(id)sender {
    if ([self checkTextField] == NO) {
        return;
    }
    // 创建一个模型对象
    Contact *tact = [NSEntityDescription insertNewObjectForEntityForName:@"Contact" inManagedObjectContext:kXBCoreDataStackManager.manageObjectContext];
    tact.name = self.nameText.text;
    tact.phoneNum = self.phoneNum.text;
    tact.namePinYin = [CommonTool getPinYinFromString:tact.name];
    tact.sectionName = [[tact.namePinYin substringFromIndex:1] uppercaseString];
    
    [kXBCoreDataStackManager save];
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (BOOL)checkTextField {
    if (self.nameText.text.length == 0) {
        UIAlertController *c = [UIAlertController alertControllerWithTitle:@"提示" message:@"姓名不能为空" preferredStyle:UIAlertControllerStyleAlert];
        [c addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:c animated:YES completion:nil];
        return NO;
    } else if ([ZxkRegular regularPhone:self.phoneNum.text] == NO) {
        UIAlertController *c = [UIAlertController alertControllerWithTitle:@"提示" message:@"手机格式错误" preferredStyle:UIAlertControllerStyleAlert];
        [c addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:c animated:YES completion:nil];
        return NO;
    } else {
        return YES;
    }
}

@end
