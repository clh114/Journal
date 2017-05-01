//
//  LockViewController.m
//  Journal
//
//  Created by cailihang on 2017/4/30.
//  Copyright © 2017年 cailihang. All rights reserved.
//

#import "LockViewController.h"
#import "AllUtils.h"
#import "TouchIDValidate.h"

@interface LockViewController ()

@end

@implementation LockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jump:) name:@"dismissLockViewController" object:nil];
}

- (void)jump:(NSNotification *)notification {
    [self dismissViewControllerAnimated:YES completion:nil];
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
