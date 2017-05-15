//
//  UserInfoModel.h
//  Journal
//
//  Created by cailihang on 2017/5/14.
//  Copyright © 2017年 cailihang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Note.h"
#import "AllUtils.h"
#import <BmobSDK/Bmob.h>

@interface UserInfoModel : NSObject

+ (void)updateUserInfo:(NSString *)tableName withUserId:(NSString *)userId andUserName:(NSString *)username andPS:(NSString *)PS andWebsite:(NSString *)website todo:(void(^)(BOOL isSuccessful, NSError *error)) todo;

+ (BOOL)isUsernameRepeated:(NSString *)username withUserId:(NSString *)userId;

@end
