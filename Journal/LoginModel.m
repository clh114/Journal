//
//  LoginModel.m
//  Journal
//
//  Created by cailihang on 2017/5/14.
//  Copyright © 2017年 cailihang. All rights reserved.
//

#import "LoginModel.h"

@implementation LoginModel

#pragma mark - 账户登录
- (void)loginwithAcount:(NSString *)usernameText andPassword:(NSString *)passwordText contextViewController:(UIViewController *)contextViewController{
    NSString *username = [usernameText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [passwordText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    [BmobUser loginInbackgroundWithAccount:username andPassword:password block:^(BmobUser *user, NSError *error){
        if (user) {
            NSLog(@"login success");
            [AllUtils jumpToViewController:@"homeViewController" contextViewController:contextViewController handler:nil];
        } else {
            NSLog(@"%@", error);
            [AllUtils showPromptDialog:@"提示" andMessage:@"用户名或密码错误！" OKButton:@"确定" OKButtonAction:nil cancelButton:@"" cancelButtonAction:nil contextViewController:contextViewController];
        }
    }];
}

@end
