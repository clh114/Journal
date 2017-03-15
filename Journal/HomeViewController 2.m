//
//  HomeViewController.m
//  Journal
//
//  Created by cailihang on 15/03/2017.
//  Copyright © 2017 cailihang. All rights reserved.
//

#import "HomeViewController.h"
#import "AllUtils.h"
#import <BmobSDK/Bmob.h>

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    BmobUser *user = [BmobUser currentUser];
    if (!user) {
        NSLog(@"%@", user);
        [AllUtils jumpToViewController:@"loginViewController" contextViewController:self handler:nil];
    }
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
