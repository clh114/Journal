//
//  BookMarkNoteDetailViewController.m
//  Journal
//
//  Created by cailihang on 2017/5/6.
//  Copyright © 2017年 cailihang. All rights reserved.
//

#import "BookMarkNoteDetailViewController.h"

@interface BookMarkNoteDetailViewController ()
@property (weak, nonatomic) IBOutlet UITextView *noteTextView;

@end

@implementation BookMarkNoteDetailViewController
- (IBAction)backBt:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
