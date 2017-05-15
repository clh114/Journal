//
//  TouchIDValidateModel.h
//  Journal
//
//  Created by cailihang on 2017/5/14.
//  Copyright © 2017年 cailihang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TouchIDValidateModel : NSObject

+ (void)validateTouchIDtodo:(void(^)(BOOL isSuccessful, NSError *error)) todo;

@end
