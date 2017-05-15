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
#import "AllUtils.h"
#import "Note.h"

@interface NoteDetailViewController ()

- (IBAction)backBt:(id)sender;
- (IBAction)saveBt:(id)sender;

@property (weak, nonatomic) IBOutlet UITextView *noteTextTextView;

@end

@implementation NoteDetailViewController

- (IBAction)bookMark:(id)sender {
    [Note addBookmark:self.noteId todo:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            NSLog(@"successful");
            [AllUtils showPromptDialog:@"提示" andMessage:@"收藏日记成功！" OKButton:@"确定" OKButtonAction:nil cancelButton:@"" cancelButtonAction:nil contextViewController:self];
        }else{
            NSLog(@"error %@",[error description]);
            [AllUtils showPromptDialog:@"提示" andMessage:@"网络有问题了，收藏日记失败！" OKButton:@"确定" OKButtonAction:nil cancelButton:@"" cancelButtonAction:nil contextViewController:self];
        }
    }];
}

- (IBAction)share:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"匿名分享" message:@"是否将这篇日记匿名分享到社区？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *yes_action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [Note shareNoteWithNoteId:self.noteId todo:^(BOOL isSuccessful, NSError *error) {
            if (isSuccessful) {
                NSLog(@"更新成功！");
                [AllUtils showPromptDialog:@"提示" andMessage:@"分享成功！" OKButton:@"确定" OKButtonAction:nil cancelButton:@"" cancelButtonAction:nil contextViewController:self];
            } else if (error) {
                NSLog(@"%@", [error description]);
                [AllUtils showPromptDialog:@"提示" andMessage:@"网络异常,分享失败" OKButton:@"确定" OKButtonAction:nil cancelButton:@"" cancelButtonAction:nil contextViewController:self];
            }
        }];
    }];
    UIAlertAction *no_action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
    
    [alert addAction:yes_action];
    [alert addAction:no_action];
    [self presentViewController:alert animated:YES completion:nil];
}


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

- (IBAction)backBt:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveBt:(id)sender {
    [Note updateBmobObjectWithTableName:NOTE_TABLE noteId:self.noteId noteText:self.noteTextTextView.text todo:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            NSLog(@"更新成功！");
            [AllUtils jumpToViewController:@"homeViewController" contextViewController:self handler:nil];
        }
        else if (error) {
            NSLog(@"%@", [error description]);
            [AllUtils showPromptDialog:@"提示" andMessage:@"网络异常,保存失败" OKButton:@"确定" OKButtonAction:nil cancelButton:@"" cancelButtonAction:nil contextViewController:self];
        }
    }];
    
}

@end
