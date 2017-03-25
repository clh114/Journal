//
//  WriteNoteViewController.m
//  Journal
//
//  Created by cailihang on 19/03/2017.
//  Copyright © 2017 cailihang. All rights reserved.
//

#import "WriteNoteViewController.h"
#import "AllUtils.h"
#import <IQKeyboardManager.h>
#import "BmobOperation.h"

@interface WriteNoteViewController () <UITextViewDelegate>
- (IBAction)backBt:(id)sender;
- (IBAction)saveBt:(id)sender;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) NSString *text;

@end

@implementation WriteNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.textView.delegate = self;
    
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
    BmobUser *user = [BmobUser currentUser];
    self.username = user.username;
    self.userID = user.objectId;
    self.text = [self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (![self.text isEqualToString:@""]) {
        [BmobOperation addNoteToNoteTable:NOTE_TABLE userId:_userID username:_username noteTitle:@"" noteText:_text todo:^(BOOL isSuccessful, NSError *error) {
            if (isSuccessful) {
                //            [AllUtils showPromptDialog:@"提示" andMessage:@"保存成功！" OKButton:@"确定" OKButtonAction:nil cancelButton:@"" cancelButtonAction:nil contextViewController:self];
                [AllUtils jumpToViewController:@"homeViewController" contextViewController:self handler:nil];
            }else {
                [AllUtils showPromptDialog:@"提示" andMessage:@"服务器异常，增加笔记失败！" OKButton:@"确定" OKButtonAction:nil cancelButton:@"" cancelButtonAction:nil contextViewController:self];
            }
        }];
    } else {
        [AllUtils jumpToViewController:@"homeViewController" contextViewController:self handler:nil];
    }
}
@end
