//
//  RegisterModel.m
//  Journal
//
//  Created by cailihang on 2017/5/14.
//  Copyright © 2017年 cailihang. All rights reserved.
//

#import "RegisterModel.h"

@implementation RegisterModel

- (void)registerWithPhoneNumber:(NSString *)phoneNumberText andSMSCode:(NSString *)smsCodeText andPassword:(NSString *)passwordText contextViewController:(UIViewController *)contextViewController {
    
    NSString *smsCode = [smsCodeText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *phoneNumber = [phoneNumberText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [passwordText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (password.length < 5) {
        [AllUtils showPromptDialog:@"提示" andMessage:@"密码要求至少6位字符" OKButton:@"确定" OKButtonAction:nil cancelButton:@"" cancelButtonAction:nil contextViewController:contextViewController];
    }
    else {
        BmobUser *user = [[BmobUser alloc] init];
        user.mobilePhoneNumber = phoneNumber;
        user.password = password;
        [user signUpOrLoginInbackgroundWithSMSCode:smsCode block:^(BOOL isSuccessful, NSError *error){
            if (error) {
                NSLog(@"%@", [error description]);
                [AllUtils showPromptDialog:@"提示" andMessage:@"验证码错误！" OKButton:@"确定" OKButtonAction:nil cancelButton:@"" cancelButtonAction:nil contextViewController:contextViewController];
            } else {
                [AllUtils jumpToViewController:@"registerViewController2" contextViewController:contextViewController handler:nil];
            }
        }];
    }

}

- (void)getSmsCodeWithPhoneNumber:(NSString *)phoneNumberText andContextViewController:(UIViewController *)contextViewController{
    
    NSString *phoneNumber = [phoneNumberText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //验证手机号是否已经注册
    __block BOOL isRepeatPhoneNumber = false;
    BmobQuery *query = [BmobUser query];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (!error) {
            for (BmobObject *obj in array) {
                if ([(NSString*)[obj objectForKey:@"mobilePhoneNumber"] isEqualToString:phoneNumber]) {
                    isRepeatPhoneNumber = true;
                    break;
                }
            }
        } else {
            [AllUtils showPromptDialog:@"提示" andMessage:@"网络异常，请稍候重试！" OKButton:@"确定" OKButtonAction:nil cancelButton:@"" cancelButtonAction:nil contextViewController:contextViewController];
        }
        if (isRepeatPhoneNumber) {
            [AllUtils showPromptDialog:@"提示" andMessage:@"该手机号已经注册，请直接登录！" OKButton:@"确定" OKButtonAction:nil cancelButton:@"" cancelButtonAction:nil contextViewController:contextViewController];
        } else {
            //请求验证码
            [BmobSMS requestSMSCodeInBackgroundWithPhoneNumber:phoneNumber andTemplate:@"test" resultBlock:^(int number, NSError *error){
                if (error) {
                    NSLog(@"%@", error);
                    [AllUtils showPromptDialog:@"提示" andMessage:@"请输入正确的手机号码" OKButton:@"确定" OKButtonAction:nil cancelButton:@"" cancelButtonAction:nil contextViewController:contextViewController];
                } else {
                    //获得smsID
                    NSLog(@"sms ID:%d", number);
                    [AllUtils showPromptDialog:@"提示" andMessage:@"验证码已发送，请稍等！" OKButton:@"确定" OKButtonAction:nil cancelButton:@"" cancelButtonAction:nil contextViewController:contextViewController];
                    
                }
            }];
        }
    }];

}

- (BOOL)isValidateEmail:(NSString *)email{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

- (void) registerWithUsername:(NSString *)usernameText andEmail:(NSString *)emailText ContextViewController:(UIViewController *)contextViewController{
    NSString *username = [usernameText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *email = [emailText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    //对邮箱格式进行检查
    if ([self isValidateEmail:email] == YES) {
        
        __block BOOL isRepeatUsername = false;
        __block BOOL isRepeatEmail = false;
        
        //输入信息不为空才能进行确认
        if (!([username isEqualToString:@""]) && !([email isEqualToString:@""])) {
            //查询用户名和邮箱是否已存在
            BmobQuery *query = [BmobUser query];
            [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                if (!error) {
                    for (BmobObject *obj in array)
                    {
                        if ([(NSString*)[obj objectForKey:@"username"] isEqualToString:username]) {
                            isRepeatUsername = true;
                            break;
                        } else if ([(NSString*)[obj objectForKey:@"email"] isEqualToString:email]) {
                            isRepeatEmail = true;
                            break;
                        }
                    }
                } else {
                    [AllUtils showPromptDialog:@"提示" andMessage:@"网络异常，请稍候重试" OKButton:@"确定" OKButtonAction:nil cancelButton:@"" cancelButtonAction:nil contextViewController:contextViewController];
                }
            }];
            if (isRepeatUsername) {
                [AllUtils showPromptDialog:@"提示" andMessage:@"该用户名已被占用" OKButton:@"确定" OKButtonAction:nil cancelButton:@"" cancelButtonAction:nil contextViewController:contextViewController];
            } else if (isRepeatEmail){
                [AllUtils showPromptDialog:@"提示" andMessage:@"该邮箱已经注册" OKButton:@"确定" OKButtonAction:nil cancelButton:@"" cancelButtonAction:nil contextViewController:contextViewController];
            } else {
                //对账户进行更新
                BmobUser *user = [BmobUser currentUser];
                [user setObject:username forKey:@"username"];
                [user setObject:email forKey:@"email"];
                [user updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                    if (isSuccessful) {
                        NSLog(@"更新后：");
                        NSLog(@"%@", user);
                        [AllUtils jumpToViewController:@"homeViewController" contextViewController:contextViewController handler:nil];
                    }
                }];
                
            }
        }
        else {
            [AllUtils showPromptDialog:@"提示" andMessage:@"请输入完整信息！" OKButton:@"确定" OKButtonAction:nil cancelButton:@"" cancelButtonAction:nil contextViewController:contextViewController];
        }
    }
    else {
        [AllUtils showPromptDialog:@"提示" andMessage:@"邮箱格式不正确！" OKButton:@"确定" OKButtonAction:nil cancelButton:@"" cancelButtonAction:nil contextViewController:contextViewController];
    }
    
}

@end
