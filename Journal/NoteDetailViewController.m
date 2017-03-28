//
//  NoteDetailViewController.m
//  Journal
//
//  Created by cailihang on 25/03/2017.
//  Copyright © 2017 cailihang. All rights reserved.
//

#import "NoteDetailViewController.h"
#import "HomeViewController.h"
#import "NoteViewController.h"
#import "BmobOperation.h"
#import "AllUtils.h"

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
//                [object setObject:noteTitle forKey:@"noteTitle"];
                [object setObject:noteText forKey:@"text"];
                //异步更新数据
                [object updateInBackground];
                NSLog(@"更新成功！");
                [AllUtils jumpToViewController:@"homeViewController" contextViewController:self handler:nil];
            }
        }else{
            NSLog(@"%@", [error description]);
            [AllUtils showPromptDialog:@"提示" andMessage:@"网络异常,保存失败" OKButton:@"确定" OKButtonAction:nil cancelButton:@"" cancelButtonAction:nil contextViewController:self];
        }
    }];
    }

@end
