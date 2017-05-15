//
//  AppDelegate.m
//  Journal
//
//  Created by cailihang on 2017/3/5.
//  Copyright © 2017年 cailihang. All rights reserved.
//

#import "AppDelegate.h"
#import "AllUtils.h"
#import <BmobSDK/Bmob.h>

@interface AppDelegate ()

@property (strong, nonatomic) UIVisualEffectView *blurView;
@property (strong, nonatomic) BmobUser *buser;
@property (strong, nonatomic) NSUserDefaults *defaults;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [Bmob registerWithAppKey:@"8ecde461cfbf340b723bb8b9681c1ee8"];
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    
    self.buser = [BmobUser currentUser];
    self.defaults = [NSUserDefaults standardUserDefaults];
    if ([self.defaults boolForKey:@"switch_status"] && self.buser) {
        NSLog(@"应该跳转到解锁界面");
        //跳转到解锁界面
        [AllUtils jumpToViewController:@"lockViewController" contextViewController:self.window.rootViewController handler:^{
        }];
    }
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    
    if ([self.defaults boolForKey:@"switch_status"] && self.buser) {
        //盖上view
        UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        view.backgroundColor = [UIColor grayColor];
        view.alpha = 1;
        view.tag = 1111;
        [[[UIApplication sharedApplication] keyWindow] addSubview:view];
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    if ([self.defaults boolForKey:@"switch_status"] && self.buser) {
        [self remove];
        UIViewController *topRootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
        while (topRootViewController.presentedViewController)
        {
            topRootViewController = topRootViewController.presentedViewController;
        }
        //跳转到解锁界面
        [AllUtils jumpToViewController:@"lockViewController" contextViewController:topRootViewController handler:^{
        }];
    }
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    //移除
    [self remove];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)remove {
    //移除
    NSArray* array = [[UIApplication sharedApplication] keyWindow].subviews;
    
    for(id view in array)
    {
        if ([view isKindOfClass:[UIView class]])
        {
            UIView* myView = view;
            if (myView.tag == 1111)
            {
                [myView removeFromSuperview];
            }
        }
    }
}

@end
