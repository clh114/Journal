//
//  NoteViewController.m
//  Journal
//
//  Created by cailihang on 15/03/2017.
//  Copyright © 2017 cailihang. All rights reserved.
//

#import "NoteViewController.h"
#import "NoteDetailViewController.h"
#import "Note.h"
#import "BmobOperation.h"
#import "AllUtils.h"

@interface NoteViewController () <UITableViewDelegate, UITableViewDataSource>

//存放笔记对象的可变数组；
@property (strong, nonatomic) NSMutableArray *allNotesArray;

@property (weak, nonatomic) IBOutlet UITableView *noteTableView;


@end

@implementation NoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self queryNoteByUserId:NOTE_TABLE limitCount:50];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.allNotesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoteCell" forIndexPath:indexPath];
//    UILabel *noteTitle = (UILabel*)[cell viewWithTag:101];
    UILabel *noteTime = (UILabel*)[cell viewWithTag:102];
    UILabel *noteText = (UILabel*)[cell viewWithTag:103];
    
//    noteTitle.text = [[self.allNotesArray objectAtIndex:indexPath.row] valueForKey:@"noteTitle"];
    noteTime.text = [[self.allNotesArray objectAtIndex:indexPath.row] valueForKey:@"noteCreatedAt"];
    noteText.text = [[self.allNotesArray objectAtIndex:indexPath.row] valueForKey:@"noteText"];
    
    return cell;
}


#pragma mark - UITableViewDelegate
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return true;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //左滑删除；
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        //数据库删除；
        [BmobOperation deleteNoteFromDatabase:NOTE_TABLE noteId:[[self.allNotesArray objectAtIndex:indexPath.row] valueForKey:@"noteId"]];
        [self.allNotesArray removeObjectAtIndex:indexPath.row];//从数组中删除该值；
        [self.noteTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        if (100 * [self.allNotesArray count] < [UIScreen mainScreen].bounds.size.height) {
            
            self.noteTableView.frame = CGRectMake(self.noteTableView.frame.origin.x, self.noteTableView.frame.origin.y, self.noteTableView.frame.size.width, 100 * [self.allNotesArray count]);
        }else{
            
            self.noteTableView.frame = CGRectMake(self.noteTableView.frame.origin.x, self.noteTableView.frame.origin.y, self.noteTableView.frame.size.width, [UIScreen mainScreen].bounds.size.height - 65);
        }
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
//        detail.noteTitle = [[self.allNotesArray objectAtIndex:indePath.row] valueForKey:@"noteTitle"];
        detail.noteText = [[self.allNotesArray objectAtIndex:indePath.row] valueForKey:@"noteText"];
        detail.indexPath = indePath;
    }
}

#pragma mark - 查询笔记
- (void) queryNoteByUserId:(NSString*)tableName limitCount:(int)limitCount{

    BmobUser *user = [BmobUser currentUser];
    NSString *userId = user.objectId;
    NSLog(@"当前用户：%@", userId);
    BmobQuery *queryNote = [BmobQuery queryWithClassName:tableName];
    [queryNote orderByDescending:@"updatedAt"];
    queryNote.limit = limitCount;
    [queryNote findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (error) {
                  NSLog(@"查询笔记错误");
        } else {
                  NSLog(@"正在查询笔记。。。");
            for (BmobObject *obj in array) {
                Note *note = [[Note alloc] init];
                if ([(NSString*)[obj objectForKey:@"userID"] isEqualToString:userId]) {
                    note.noteId = [obj objectForKey:@"objectId"];
                    note.userId = [obj objectForKey:@"userID"];
                    note.username = [obj objectForKey:@"username"];
//                    note.noteTitle = [obj objectForKey:@"noteTitle"];
                    note.noteText = [obj objectForKey:@"text"];
                    note.noteCreatedAt = [AllUtils getDateFromString:[obj objectForKey:@"createdAt"]];
                    [self.allNotesArray addObject:note];

                }//if();
            }//for();
            
            if (self.tempText != nil && self.tempIndexPath != nil) {
//                [[self.allNotesArray objectAtIndex:self.tempIndexPath.row] setValue:self.tempTitle forKey:@"noteTitle"];
                [[self.allNotesArray objectAtIndex:self.tempIndexPath.row] setValue:self.tempText forKey:@"noteText"];
                for (int i = (int)self.tempIndexPath.row ; i >= 1; i--) {
                    
                    [self.allNotesArray exchangeObjectAtIndex:i withObjectAtIndex:i-1];//这样是可以的；
                }//for()
            }
        }//else();
        NSLog(@"笔记数组的count = %lu",(unsigned long)[self.allNotesArray count]);
        //解决TableView不能滚到最下面的bug；注意如何设置TableView的长度；
        //会导致新的cell变黑
//        if (100 * [self.allNotesArray count] < [UIScreen mainScreen].bounds.size.height) {
//            
//            self.noteTableView.frame = CGRectMake(self.noteTableView.frame.origin.x, self.noteTableView.frame.origin.y, self.noteTableView.frame.size.width, 100 * [self.allNotesArray count]);
//        }else{
//            
//            self.noteTableView.frame = CGRectMake(self.noteTableView.frame.origin.x, self.noteTableView.frame.origin.y, self.noteTableView.frame.size.width, [UIScreen mainScreen].bounds.size.height - 65);
//        }
        [self.noteTableView reloadData];
    }];

}

#pragma mark - 懒加载显示笔记内容
//这里标题的添加也使用懒加载；
- (NSMutableArray *)allNotesArray{
    
    Note *note = [[Note alloc] init];
    note.noteId = @"";
    note.userId = @"";
    note.username = @"";
//    note.noteTitle = @"";
    note.noteText = @"";
    note.noteCreatedAt = @"";
    if (!_allNotesArray) {
        
        self.allNotesArray = [[NSMutableArray alloc] initWithCapacity:3];
    }
    return _allNotesArray;
}

@end
