//
//  MyBookMarksTableViewController.m
//  Journal
//
//  Created by cailihang on 2017/5/6.
//  Copyright © 2017年 cailihang. All rights reserved.
//

#import "MyBookMarksTableViewController.h"
#import "BookMarkNoteDetailViewController.h"
#import "AllUtils.h"
#import <MJRefresh.h>
#import "Note.h"

@interface MyBookMarksTableViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *noteTableView;
//存放笔记对象的可变数组；
@property (strong, nonatomic) NSMutableArray *allNotesArray;

@end

@implementation MyBookMarksTableViewController
- (IBAction)backBt:(id)sender {
    [AllUtils jumpToViewController:@"homeViewController" contextViewController:self handler:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    BmobUser *user = [BmobUser currentUser];
    NSString *userId = user.objectId;
    NSString *username = user.username;
    NSLog(@"当前用户：%@", userId);

    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        //异步查询
        dispatch_async(queue, ^{
            self.allNotesArray = [Note queryMarkedNotesInTable:NOTE_TABLE withUserId:userId andUsername:username withLimitCount:1000];
            NSLog(@"笔记数组的count = %lu",(unsigned long)[self.allNotesArray count]);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.tableView.mj_header endRefreshing];
                [self.tableView reloadData];
                
            });
        });
    }];
    [header beginRefreshing];
    self.tableView.mj_header = header;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.allNotesArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoteCell" forIndexPath:indexPath];
    
    UILabel *noteUser = (UILabel *)[cell viewWithTag:1];
    UILabel *noteTime = (UILabel *)[cell viewWithTag:2];
    UILabel *noteText = (UILabel *)[cell viewWithTag:3];
    
    noteUser.text = [[self.allNotesArray objectAtIndex:indexPath.row] valueForKey:@"username"];
    noteTime.text = [[self.allNotesArray objectAtIndex:indexPath.row] valueForKey:@"noteCreatedAt"];
    noteText.text = [[self.allNotesArray objectAtIndex:indexPath.row] valueForKey:@"noteText"];
    
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //数据库删除；
        [Note deleteBookmarkNoteInTable:NOTE_TABLE withNoteId:[[self.allNotesArray objectAtIndex:indexPath.row] valueForKey:@"noteId"] todo:^(BOOL isSuccessful, NSError *error) {
            if (isSuccessful) {
                NSLog(@"successful");
            }else{
                NSLog(@"error %@",[error description]);
                [AllUtils showPromptDialog:@"提示" andMessage:@"网络问题，删除失败" OKButton:@"确定" OKButtonAction:nil cancelButton:@"" cancelButtonAction:nil contextViewController:self];
            }
        }];

        [self.allNotesArray removeObjectAtIndex:indexPath.row];//从数组中删除该值；
        [self.noteTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

#pragma mark - 界面跳转传递数据
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"BookMarkNoteDetailSegue"]) {
        //因为NoteDetailViewController是镶嵌在一个NavgationContoller里面，所以应该是跳转到导航控制器而不是NoteDetailViewController
        UINavigationController *navController = [segue destinationViewController];
        BookMarkNoteDetailViewController *detail = (BookMarkNoteDetailViewController *)navController.topViewController;
        NSIndexPath *indePath = self.noteTableView.indexPathForSelectedRow;
        detail.noteId = [[self.allNotesArray objectAtIndex:indePath.row] valueForKey:@"noteId"];
        detail.noteText = [[self.allNotesArray objectAtIndex:indePath.row] valueForKey:@"noteText"];
        detail.indexPath = indePath;
    }
}

#pragma mark - 懒加载显示笔记内容
- (NSMutableArray *)allNotesArray{
    
    Note *note = [[Note alloc] init];
    note.noteId = @"";
    note.userId = @"";
    note.username = @"";
    note.noteText = @"";
    note.noteCreatedAt = @"";
    if (!_allNotesArray) {
        
        self.allNotesArray = [[NSMutableArray alloc] initWithCapacity:3];
    }
    return _allNotesArray;
}

@end
