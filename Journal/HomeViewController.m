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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpToViewController:) name:@"presentLockViewController" object:nil];
}

- (void)jumpToViewController:(NSNotification *)notification {
    LockViewController *lockViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"lockViewController"];
    [self presentViewController:lockViewController animated:NO completion:nil];
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

- (void)touchIDValidate {

    //创建LAContext
    LAContext* context = [[LAContext alloc] init];
    NSError* error = nil;
    NSString* result = @"请验证已有指纹";
    
    //首先使用canEvaluatePolicy 判断设备支持状态
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        //支持指纹验证
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:result reply:^(BOOL success, NSError *error) {
            if (success) {
                //验证成功，主线程处理UI
            }
            else
            {
//                //在主线程改变SWITCH状态
//                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//                    [switchButton setOn:NO];
//                }];
                NSLog(@"%@",error.localizedDescription);
                
            }
        }];
    }
    else
    {
        //不支持指纹识别，LOG出错误详情
        NSLog(@"不支持指纹识别");
        NSLog(@"%@",error.localizedDescription);
    }
    
}

@end
