//
//  ForgetPassWordModel.m
//  Journal
//
//  Created by cailihang on 2017/5/14.
//  Copyright © 2017年 cailihang. All rights reserved.
//

#import "ForgetPassWordModel.h"

@implementation ForgetPassWordModel

#pragma mark - 通过邮箱找回密码
- (void)findPasswordWithEmail:(NSString *)emailText contextViewController:(UIViewController *)contextViewController{
    NSString *email = [emailText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    BmobQuery *query = [BmobUser query];
    __block BOOL isRegistered = false;
    if (![email isEqualToString:@""]) {
        [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            if (!error) {
                for (BmobObject *obj in array) {
                    if ([(NSString*)[obj objectForKey:@"email"] isEqualToString:email]) {
                        isRegistered = true;
                        break;
                    }
                }
            } else {
                [AllUtils showPromptDialog:@"提示" andMessage:@"网络异常，请稍候重试！" OKButton:@"确定" OKButtonAction:nil cancelButton:@"" cancelButtonAction:nil contextViewController:contextViewController];
            }
            if (isRegistered) {
                [BmobUser requestPasswordResetInBackgroundWithEmail:email];
                [AllUtils showPromptDialog:@"提示" andMessage:@"已发送重置密码邮件，请查看邮箱" OKButton:@"确定" OKButtonAction:nil cancelButton:@"" cancelButtonAction:nil contextViewController:contextViewController];
                [AllUtils jumpToViewController:@"loginViewController" contextViewController:contextViewController handler:nil];
            } else {
                [AllUtils showPromptDialog:@"提示" andMessage:@"该邮箱地址未注册" OKButton:@"确定" OKButtonAction:nil cancelButton:@"" cancelButtonAction:nil contextViewController:contextViewController];
            }
        }];
    }
}

@end
