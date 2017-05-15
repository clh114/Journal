//
//  HomeViewController.m
//  Journal
//
//  Created by cailihang on 15/03/2017.
//  Copyright © 2017 cailihang. All rights reserved.
//

#import "HomeViewController.h"
#import "LockViewController.h"
#import "WriteNoteViewController.h"
#import "AllUtils.h"
#import <BmobSDK/Bmob.h>
#import <LocalAuthentication/LocalAuthentication.h>

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
    self.tabBar.tintColor = [UIColor whiteColor];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    BmobUser *user = [BmobUser currentUser];
    if (!user) {
        NSLog(@"未登录！");
        [AllUtils jumpToViewController:@"loginViewController" contextViewController:self handler:nil];
    }
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if (viewController.tabBarItem.tag == 1) {
        NSLog(@"这是添加日记页面");
        //要弹出导航VC，否则导航控制器比VC运行得晚，导航栏无法显示
        [viewController.parentViewController presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"writeNoteVCNav"] animated:YES completion:nil];
        return false;
    } else {
        return true;
    }
}

@end
