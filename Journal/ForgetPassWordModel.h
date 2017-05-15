//
//  ForgetPassWordModel.h
//  Journal
//
//  Created by cailihang on 2017/5/14.
//  Copyright © 2017年 cailihang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BmobSDK/Bmob.h>
#import "AllUtils.h"

@interface ForgetPassWordModel : NSObject

- (void)findPasswordWithEmail:(NSString *)emailText contextViewController:(UIViewController *)contextViewController;


@end
