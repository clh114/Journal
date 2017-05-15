//
//  SharedNoteDetailViewController.m
//  Journal
//
//  Created by cailihang on 2017/4/29.
//  Copyright © 2017年 cailihang. All rights reserved.
//

#import "SharedNoteDetailViewController.h"
#import "Note.h"
#import "AllUtils.h"
#import <BmobSDK/Bmob.h>

@interface SharedNoteDetailViewController ()
@property (weak, nonatomic) IBOutlet UITextView *noteTextView;

@end

@implementation SharedNoteDetailViewController
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.noteTextView.text = self.noteText;
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

@end
