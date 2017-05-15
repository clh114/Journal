//
//  Note.h
//  Journal
//
//  Created by cailihang on 20/03/2017.
//  Copyright © 2017 cailihang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BmobSDK/Bmob.h>

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

+ (void)addNoteToNoteTable:(NSString*)tableName userId:(NSString*)userId  username:(NSString*)username noteText:(NSString*)noteText todo:(void(^)(BOOL isSuccessful, NSError *error)) todo;

+ (void)deleteNoteFromDatabase:(NSString*)tableName noteId:(NSString*)noteId todo:(void(^)(BOOL isSuccessful, NSError *error)) todo;

+ (void)updateBmobObjectWithTableName:(NSString*)tableName  noteId:(NSString*)noteId noteText:(NSString*)noteText todo:(void(^)(BOOL isSuccessful, NSError *error)) todo;

+ (NSMutableArray *)queryNote:(NSString*)tableName ByUserId:(NSString *)userId limitCount:(int)limitCount;

+ (void)addBookmark:(NSString *)noteId todo:(void(^)(BOOL isSuccessful, NSError *error)) todo;

+ (void)shareNoteWithNoteId:(NSString *)noteId todo:(void(^)(BOOL isSuccessful, NSError *error)) todo;

+ (NSMutableArray *)querySharedNotesInTable:(NSString *)tableName withLimitCont:(int) limicount;

+ (void)deleteBookmarkNoteInTable:(NSString *)tableName withNoteId:(NSString *)noteId todo:(void(^)(BOOL isSuccessful, NSError *error)) todo;

#pragma mark - 查询收藏的日记
+ (NSMutableArray *)queryMarkedNotesInTable:(NSString *)tableName withUserId:(NSString *)userId andUsername:(NSString *)username withLimitCount:(int) limitCount;

@end
