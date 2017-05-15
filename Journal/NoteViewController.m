//
//  NoteViewController.m
//  Journal
//
//  Created by cailihang on 15/03/2017.
//  Copyright © 2017 cailihang. All rights reserved.
//

#import "NoteViewController.h"
#import "NoteDetailViewController.h"
#import "SettingTableViewController.h"
#import "Note.h"
#import "AllUtils.h"
#import <MJRefresh.h>

@interface NoteViewController () <UITableViewDelegate, UITableViewDataSource>

//存放笔记对象的可变数组；
@property (strong, nonatomic) NSMutableArray *allNotesArray;
@property (weak, nonatomic) IBOutlet UITableView *noteTableView;

@end

@implementation NoteViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] init];
    BmobUser *user = [BmobUser currentUser];
    NSString *userId = user.objectId;
    NSLog(@"当前用户：%@", userId);
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        //异步查询
        dispatch_async(queue, ^{
            self.allNotesArray = [Note queryNote:NOTE_TABLE ByUserId:userId limitCount:1000];
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
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.allNotesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoteCell" forIndexPath:indexPath];
    UILabel *noteTime = (UILabel*)[cell viewWithTag:102];
    UILabel *noteText = (UILabel*)[cell viewWithTag:103];
    
    noteTime.text = [[self.allNotesArray objectAtIndex:indexPath.row] valueForKey:@"noteCreatedAt"];
    noteText.text = [[self.allNotesArray objectAtIndex:indexPath.row] valueForKey:@"noteText"];
    
    return cell;
}


#pragma mark - UITableViewDelegate
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //左滑删除；
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        //异步删除
        dispatch_async(queue, ^{
            //数据库删除；
            [Note deleteNoteFromDatabase:NOTE_TABLE noteId:[[self.allNotesArray objectAtIndex:indexPath.row] valueForKey:@"noteId"] todo:^(BOOL isSuccessful, NSError *error) {
                if (isSuccessful) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSLog(@"删除成功");
                        [self.allNotesArray removeObjectAtIndex:indexPath.row];//从数组中删除该值；
                        [self.noteTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    });
                }
                else if (error) {
                    NSLog(@"%@", [error description]);
                    [AllUtils showPromptDialog:@"提示" andMessage:@"删除失败，请稍后再试" OKButton:@"确定" OKButtonAction:nil cancelButton:@"" cancelButtonAction:nil contextViewController:self];
                }
            }];
        });
        
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}


#pragma mark - 界面跳转传递数据
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"NoteDetailSegue"]) {
        //因为NoteDetailViewController是镶嵌在一个NavgationContoller里面，所以应该是跳转到导航控制器而不是NoteDetailViewController
        UINavigationController *navController = [segue destinationViewController];
        NoteDetailViewController *detail = (NoteDetailViewController *)navController.topViewController;
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
