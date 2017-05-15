//
//  LockViewController.m
//  Journal
//
//  Created by cailihang on 2017/4/30.
//  Copyright © 2017年 cailihang. All rights reserved.
//

#import "LockViewController.h"
#import "AllUtils.h"
#import "TouchIDValidateModel.h"
@interface LockViewController ()

@end

@implementation LockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [TouchIDValidateModel validateTouchIDtodo:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            //通过发送通知跳转到主页面
            [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissLockViewController" object:nil];

        } else {
            NSLog(@"%@",error.localizedDescription);
        }
    }];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jump:) name:@"dismissLockViewController" object:nil];
}

- (void)jump:(NSNotification *)notification {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
