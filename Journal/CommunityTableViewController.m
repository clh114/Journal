//
//  CommunityTableViewController.m
//  Journal
//
//  Created by cailihang on 2017/4/25.
//  Copyright © 2017年 cailihang. All rights reserved.
//

#import "CommunityTableViewController.h"
#import "SharedNoteDetailViewController.h"
#import "Note.h"
#import "AllUtils.h"
#import <MJRefresh.h>

@interface CommunityTableViewController ()

@property (strong, nonatomic) IBOutlet UITableView *noteView;
@property (strong, nonatomic) NSMutableArray *allNoteArray;

@end

@implementation CommunityTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        //异步查询
        dispatch_async(queue, ^{
            self.allNoteArray = [Note querySharedNotesInTable:NOTE_TABLE withLimitCont:1000];
            NSLog(@"笔记数组的count = %lu",(unsigned long)[self.allNoteArray count]);
            
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

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.allNoteArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"noteCell" forIndexPath:indexPath];
    UILabel *noteTime = (UILabel *)[cell viewWithTag:1];
    UILabel *noteText = (UILabel *)[cell viewWithTag:2];
    
    noteTime.text = [[self.allNoteArray objectAtIndex:indexPath.row] valueForKey:@"noteCreatedAt"];
    noteText.text = [[self.allNoteArray objectAtIndex:indexPath.row] valueForKey:@"noteText"];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"sharedNoteDetailSegue"]) {
        //因为NoteDetailViewController是镶嵌在一个NavgationContoller里面，所以应该是跳转到导航控制器而不是NoteDetailViewController
        UINavigationController *navController = [segue destinationViewController];
        SharedNoteDetailViewController *detail = (SharedNoteDetailViewController *)navController.topViewController;
        NSIndexPath *indePath = self.noteView.indexPathForSelectedRow;
        detail.noteId = [[self.allNoteArray objectAtIndex:indePath.row] valueForKey:@"noteId"];
        detail.noteText = [[self.allNoteArray objectAtIndex:indePath.row] valueForKey:@"noteText"];
        detail.indexPath = indePath;
    }
}

#pragma mark - 懒加载显示笔记内容
- (NSMutableArray *)allNoteArray{
    Note *note = [[Note alloc] init];
    note.noteId = @"";
    note.userId = @"";
    note.username = @"";
    note.noteText = @"";
    note.noteCreatedAt = @"";
    if (!_allNoteArray) {
        self.allNoteArray = [[NSMutableArray alloc] initWithCapacity:3];
    }
    return _allNoteArray;
}
@end
