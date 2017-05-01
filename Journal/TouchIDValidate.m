//
//  TouchIDValidate.m
//  Journal
//
//  Created by cailihang on 2017/5/1.
//  Copyright © 2017年 cailihang. All rights reserved.
//

#import "TouchIDValidate.h"
#import <LocalAuthentication/LocalAuthentication.h>


@implementation TouchIDValidate

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
