//
//  UserInfoModel.m
//  Journal
//
//  Created by cailihang on 2017/5/14.
//  Copyright © 2017年 cailihang. All rights reserved.
//

#import "UserInfoModel.h"

@implementation UserInfoModel

+ (void)updateUserInfo:(NSString *)tableName withUserId:(NSString *)userId andUserName:(NSString *)username andPS:(NSString *)PS andWebsite:(NSString *)website todo:(void(^)(BOOL isSuccessful, NSError *error)) todo{
    BmobQuery *bquery = [BmobQuery queryWithClassName:tableName];
    [bquery getObjectInBackgroundWithId:userId block:^(BmobObject *object,NSError *error){
        if (!error) {
            if (object) {
                [object setObject:username forKey:@"username"];
                [object setObject:PS forKey:@"PS"];
                [object setObject:website forKey:@"website"];
                //异步更新数据
                [object updateInBackgroundWithResultBlock:todo];
            }
        }
    }];
}

+ (BOOL)isUsernameRepeated:(NSString *)username withUserId:(NSString *)userId {
    __block BOOL isRepeatUsername = false;
    
    BmobQuery *query = [BmobUser query];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (!error) {
            for (BmobObject *obj in array) {
                if (![(NSString *)[obj objectForKey:@"username"] isEqualToString:username]) {
                    isRepeatUsername = true;
                    break;
                }
            }
        }
    }];
    
    return isRepeatUsername;
}

@end
