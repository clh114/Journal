//
//  TouchIDValidateModel.m
//  Journal
//
//  Created by cailihang on 2017/5/14.
//  Copyright © 2017年 cailihang. All rights reserved.
//

#import "TouchIDValidateModel.h"
#import <LocalAuthentication/LocalAuthentication.h>

@implementation TouchIDValidateModel

+ (void)validateTouchIDtodo:(void(^)(BOOL isSuccessful, NSError *error)) todo {
    //创建LAContext
    LAContext* context = [[LAContext alloc] init];
    NSError* error = nil;
    NSString* result = @"请验证已有指纹";
    
    //首先使用canEvaluatePolicy 判断设备支持状态
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        //支持指纹验证
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:result reply:todo];
    }
}

@end
