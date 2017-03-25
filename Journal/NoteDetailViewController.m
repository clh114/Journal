//
//  NoteDetailViewController.m
//  Journal
//
//  Created by cailihang on 25/03/2017.
//  Copyright © 2017 cailihang. All rights reserved.
//

#import "NoteDetailViewController.h"
#import "HomeViewController.h"
#import "BmobOperation.h"

@interface NoteDetailViewController ()
- (IBAction)backBt:(id)sender;
- (IBAction)saveBt:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *noteTextTextView;

@end

@implementation NoteDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.noteTextTextView.text = self.noteText;
    NSLog(@"noteId;%@",self.noteId);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backBt:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveBt:(id)sender {
    //使用显式界面跳转,因为需要执行MainViewController的viewDidLoad()方法；
    [self updateBmobObject:NOTE_TABLE noteId:self.noteId noteTitle:@"" noteText:self.noteTextTextView.text];
}

#pragma mark - 修改笔记
-(void)updateBmobObject:(NSString*)tableName  noteId:(NSString*)noteId noteTitle:(NSString*)noteTitle noteText:(NSString*)noteText{
    //查找GameScore表
    BmobQuery   *bquery = [BmobQuery queryWithClassName:tableName];
    [bquery getObjectInBackgroundWithId:noteId block:^(BmobObject *object,NSError *error){
        if (!error) {
            if (object) {
                //设置cheatMode为YES
                [object setObject:noteTitle forKey:@"noteTitle"];
                [object setObject:noteText forKey:@"noteText"];
                //异步更新数据
                [object updateInBackground];
            }
        }else{
            //进行错误处理
        }
    }];
//    //使用显式界面跳转,因为需要执行MainViewController的viewDidLoad()方法；
//    MainViewController *mainViewController = [[MainViewController alloc] init];
//    mainViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
//    mainViewController.tempIndexPath = self.indexPath;
//    mainViewController.tempTitle = self.noteTitleTextField.text;
//    mainViewController.tempText = self.noteTextTextView.text;
//    [self presentViewController:mainViewController animated:true completion:nil];
}
@end
