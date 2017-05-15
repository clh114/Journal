//
//  RegisterModel.h
//  Journal
//
//  Created by cailihang on 2017/5/14.
//  Copyright © 2017年 cailihang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BmobSDK/Bmob.h>
#import "AllUtils.h"

@interface RegisterModel : NSObject

- (void)registerWithPhoneNumber:(NSString *)phoneNumberText andSMSCode:(NSString *)smsCodeText andPassword:(NSString *)passwordText contextViewController:(UIViewController *)contextViewController;

- (void)getSmsCodeWithPhoneNumber:(NSString *)phoneNumberText andContextViewController:(UIViewController *)contextViewController;

- (void) registerWithUsername:(NSString *)usernameText andEmail:(NSString *)emailText ContextViewController:(UIViewController *)contextViewController;

- (BOOL)isValidateEmail:(NSString *)email;
@end
