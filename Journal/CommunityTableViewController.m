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
#import "BmobOperation.h"
#import "AllUtils.h"
#import <MJRefresh.h>

@interface CommunityTableViewController ()

@property (strong, nonatomic) IBOutlet UITableView *noteView;
@property (strong, nonatomic) NSMutableArray *allNoteArray;

@end

@implementation CommunityTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self qureyByisShare:NOTE_TABLE limitCount:100];
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self qureyByisShare:NOTE_TABLE limitCount:100];
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
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




/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


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

#pragma mark - 查询笔记
- (void)qureyByisShare:(NSString *)tableName limitCount:(int)limitCount{
    BmobQuery *queryNote = [BmobQuery queryWithClassName:tableName];
    queryNote.cachePolicy = kBmobCachePolicyCacheThenNetwork;
    [queryNote whereKey:@"isShare" equalTo:[NSNumber numberWithBool:YES]];
    [queryNote orderByDescending:@"updatedAt"];
    queryNote.limit = limitCount;
    [queryNote findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (error) {
            NSLog(@"查询笔记错误");
        } else {
            NSLog(@"正在查询笔记。。。");
            self.allNoteArray = [[NSMutableArray alloc]init];
            for (BmobObject *obj in array) {
                Note *note = [[Note alloc] init];
                note.noteId = [obj objectForKey:@"objectId"];
                note.noteText = [obj objectForKey:@"text"];
                note.noteCreatedAt = [AllUtils getDateFromString:[obj objectForKey:@"createdAt"]];
                [self.allNoteArray addObject:note];
            }
            
            if (self.tempText != nil && self.tempIndexPath != nil) {
                [[self.allNoteArray objectAtIndex:self.tempIndexPath.row] setValue:self.tempText forKey:@"noteText"];
                for (int i = (int)self.tempIndexPath.row ; i >= 1; i--) {
                    
                    [self.allNoteArray exchangeObjectAtIndex:i withObjectAtIndex:i-1];
                }
            }
        }
        NSLog(@"笔记数组的count = %lu",(unsigned long)[self.allNoteArray count]);
        
        [self.noteView reloadData];
    }];
    
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
