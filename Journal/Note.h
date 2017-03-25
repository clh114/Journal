//
//  Note.h
//  Journal
//
//  Created by cailihang on 20/03/2017.
//  Copyright © 2017 cailihang. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NOTE_TABLE @"Note"
#define USER_TABLE @"_User"

@interface Note : NSObject

@property(nonatomic,copy) NSString* noteId;
@property(nonatomic,copy) NSString* userId;
@property(nonatomic,copy) NSString* username;
@property(nonatomic,copy) NSString* noteTitle;
@property(nonatomic,copy) NSString* noteText;
//所有应该以更新笔记的
@property(nonatomic,copy) NSString* noteCreatedAt;//创建笔记的时间；
@end
