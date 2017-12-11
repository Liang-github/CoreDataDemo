//
//  ContactListVC.m
//  CoreDataDemo
//
//  Created by PengLiang on 2017/12/11.
//  Copyright © 2017年 PengLiang. All rights reserved.
//

#import "ContactListVC.h"
#import "CoreDataTool.h"
#import "EditContactVC.h"
#import "CommonTool.h"
#import "AddContactVC.h"

@interface ContactListVC ()<NSFetchedResultsControllerDelegate, UISearchBarDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, assign) BOOL isTrash;

@end

@implementation ContactListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(trashClick)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addClick)];
    [self addSearchBar];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}
/**
 * 添加搜索栏
 */
- (void)addSearchBar {
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.delegate = self;
    self.navigationItem.titleView = searchBar;
}
/**
 * 实现搜索功能
 */
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    searchText = [[CommonTool getPinYinFromString:searchText] lowercaseString];
    
    if (searchText.length > 0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.name CONTAINS %@ || self.namePinYin CONTAINS %@ || self.phoneNum CONTAINS %@",searchText,searchText,searchText];
        self.fetchedResultsController.fetchRequest.predicate = predicate;
    } else {
        self.fetchedResultsController.fetchRequest.predicate = nil;
        
        [self.fetchedResultsController performFetch:nil];
        
        [self.tableView reloadData];
    }
}
- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Contact"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"namePinYin" ascending:YES]];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:kXBCoreDataStackManager.manageObjectContext sectionNameKeyPath:@"sectionName" cacheName:nil];
    
    _fetchedResultsController.delegate = self;
    
    // 执行查询
    [_fetchedResultsController performFetch:nil];
    
    [self.tableView reloadData];
    
    return _fetchedResultsController;
}
- (void)trashClick {
    // 删除文件的方法
    NSBatchDeleteRequest *batchRequest = [[NSBatchDeleteRequest alloc] initWithFetchRequest:[[NSFetchRequest alloc] initWithEntityName:@"Contact"]];
    // 执行批量删除文件的请求
    [kXBCoreDataStackManager.persistentStoreCoordinator executeRequest:batchRequest withContext:kXBCoreDataStackManager.manageObjectContext error:nil];
    self.fetchedResultsController = nil;
    
    [self.tableView reloadData];
}
- (void)addClick {
    AddContactVC *vc = [[AddContactVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    if (self.isTrash == YES) {
        return 0;
    } else {
        return self.fetchedResultsController.sections.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> info = self.fetchedResultsController.sections[section];
    return [info numberOfObjects];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_isTrash == NO) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        Contact *contact = [_fetchedResultsController objectAtIndexPath:indexPath];
        cell.textLabel.text = contact.name;
        cell.detailTextLabel.text = contact.phoneNum;
        return cell;
    } else {
        return nil;
    }
}

/**
 * 添加删除功能
 */
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.fetchedResultsController.sectionIndexTitles[section];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    Contact *contact = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [kXBCoreDataStackManager.manageObjectContext deleteObject:contact];
    
    [kXBCoreDataStackManager save];
}
- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    NSInteger sectionNum = self.tableView.numberOfSections;
    
    NSInteger fetchSection = self.fetchedResultsController.sections.count;
    
    switch (type) {
        case NSFetchedResultsChangeInsert:
            // 插入数据
            [self.tableView beginUpdates];
            if (sectionNum != fetchSection) {
                [self.tableView insertSections:[NSIndexSet indexSetWithIndex:newIndexPath.section] withRowAnimation:UITableViewRowAnimationMiddle];
            } else {
                [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationMiddle];
            }
            [self.tableView reloadData];
            
            [self.tableView endUpdates];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView beginUpdates];
            if (sectionNum != fetchSection) {
                [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationMiddle];
            } else {
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
            }
            [self.tableView endUpdates];
            break;
        case NSFetchedResultsChangeMove:
            [self.tableView reloadData];
            break;
        case NSFetchedResultsChangeUpdate:
            // 刷新数据
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
            [self.tableView endUpdates];
            break;
        default:
            break;
    }
}
/**
 * 跳转控制器
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // 添加控制器
    if ([segue.identifier isEqualToString:@"XBEdictContactVC"]) {
        EditContactVC *ediVC = (EditContactVC *)[segue destinationViewController];
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        Contact *contact = [self.fetchedResultsController objectAtIndexPath:indexPath];
        ediVC.contact = contact;
        
    }
}
@end
