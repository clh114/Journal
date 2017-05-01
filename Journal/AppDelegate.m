//
//  AppDelegate.m
//  Journal
//
//  Created by cailihang on 2017/3/5.
//  Copyright © 2017年 cailihang. All rights reserved.
//

#import "AppDelegate.h"
#import "AllUtils.h"
#import "LockViewController.h"
#import "HomeViewController.h"
#import <BmobSDK/Bmob.h>
#import <LocalAuthentication/LocalAuthentication.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [Bmob registerWithAppKey:@"8ecde461cfbf340b723bb8b9681c1ee8"];
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    BmobUser *buser = [BmobUser currentUser];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"switch_status"] && buser) {
        //跳转到解锁界面
        [[NSNotificationCenter defaultCenter] postNotificationName:@"presentLockViewController" object:nil];
        [self touchIDValidate];
    }
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    BmobUser *buser = [BmobUser currentUser];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"switch_status"] && buser) {
        //跳转到解锁界面
        [[NSNotificationCenter defaultCenter] postNotificationName:@"presentLockViewController" object:nil];
        [self touchIDValidate];
    }
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
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
                //跳转到主页面
                [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissLockViewController" object:nil];
            }
            else
            {
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
