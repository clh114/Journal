//
//  Note.m
//  Journal
//
//  Created by cailihang on 20/03/2017.
//  Copyright © 2017 cailihang. All rights reserved.
//

#import "Note.h"
#import "AllUtils.h"

@implementation Note

#pragma mark - 往数据库中插入一条笔记
+ (void)addNoteToNoteTable:(NSString*)tableName userId:(NSString*)userId  username:(NSString*)username noteText:(NSString*)noteText todo:(void(^)(BOOL isSuccessful, NSError *error)) todo{
    
    BmobObject *note = [BmobObject objectWithClassName:tableName];
    [note setObject:userId forKey:@"userID"];
    [note setObject:username forKey:@"username"];
    [note setObject:noteText forKey:@"text"];
    [note saveInBackgroundWithResultBlock:todo];
}

#pragma mark - 往数据库中删除一条笔记
+ (void)deleteNoteFromDatabase:(NSString*)tableName noteId:(NSString*)noteId todo:(void(^)(BOOL isSuccessful, NSError *error)) todo{
    
    BmobQuery *delete = [BmobQuery queryWithClassName:tableName];
    [delete getObjectInBackgroundWithId:noteId block:^(BmobObject *object, NSError *error){
        if (error) {
            //进行错误处理
        }
        else{
            if (object) {
                //异步删除object
                [object deleteInBackgroundWithBlock:todo];
            }
        }
    }];
}

#pragma mark - 修改数据库中的一条笔记
+ (void)updateBmobObjectWithTableName:(NSString*)tableName  noteId:(NSString*)noteId noteText:(NSString*)noteText todo:(void(^)(BOOL isSuccessful, NSError *error)) todo{
    
    BmobQuery *bquery = [BmobQuery queryWithClassName:tableName];
    [bquery getObjectInBackgroundWithId:noteId block:^(BmobObject *object, NSError *error) {
        if (!error) {
            if (object) {
                [object setObject:noteText forKey:@"text"];
                //异步更新数据
                [object updateInBackgroundWithResultBlock:todo];
                NSLog(@"更新成功！");
            }
        }else{
            NSLog(@"%@", [error description]);
            
        }
    }];
}

#pragma mark - 查询笔记
+ (NSMutableArray *)queryNote:(NSString*)tableName ByUserId:(NSString *)userId limitCount:(int)limitCount {
    
    NSString* tempText;
    NSIndexPath* tempIndexPath;
    __block NSMutableArray *allNotesArray = [[NSMutableArray alloc] init];

    BmobQuery *queryNote = [BmobQuery queryWithClassName:tableName];
    queryNote.cachePolicy = kBmobCachePolicyCacheThenNetwork;
    [queryNote whereKey:@"userID" equalTo:userId];
    [queryNote orderByDescending:@"createdAt"];
    queryNote.limit = limitCount;
    [queryNote findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (error) {
            NSLog(@"查询笔记错误");
        } else {
            allNotesArray = [[NSMutableArray alloc] init];
            NSLog(@"正在查询笔记。。。");
            for (BmobObject *obj in array) {
                Note *note = [[Note alloc] init];
                note.noteId = [obj objectForKey:@"objectId"];
                note.userId = [obj objectForKey:@"userID"];
                note.username = [obj objectForKey:@"username"];
                note.noteText = [obj objectForKey:@"text"];
                note.noteCreatedAt = [AllUtils getDateFromString:[obj objectForKey:@"createdAt"]];
                [allNotesArray addObject:note];
            }
            
            if (tempText != nil && tempIndexPath != nil) {
                [[allNotesArray objectAtIndex:tempIndexPath.row] setValue:tempText forKey:@"noteText"];
                for (int i = (int)tempIndexPath.row ; i >= 1; i--) {
                    
                    [allNotesArray exchangeObjectAtIndex:i withObjectAtIndex:i-1];
                }
            }
        }
        
    }];
    return allNotesArray;
}

#pragma mark - 查询分享的日记
+ (NSMutableArray *)querySharedNotesInTable:(NSString *)tableName withLimitCont:(int) limicount {
    NSString* tempText;
    NSIndexPath* tempIndexPath;
    __block NSMutableArray *allNotesArray = [[NSMutableArray alloc] init];

    BmobQuery *queryNote = [BmobQuery queryWithClassName:tableName];
    queryNote.cachePolicy = kBmobCachePolicyCacheThenNetwork;
    [queryNote whereKey:@"isShare" equalTo:[NSNumber numberWithBool:YES]];
    [queryNote orderByDescending:@"updatedAt"];
    queryNote.limit = limicount;
    
    [queryNote findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (error) {
            NSLog(@"查询笔记错误");
        } else {
            NSLog(@"正在查询笔记。。。");
            allNotesArray = [[NSMutableArray alloc]init];
            for (BmobObject *obj in array) {
                Note *note = [[Note alloc] init];
                note.noteId = [obj objectForKey:@"objectId"];
                note.noteText = [obj objectForKey:@"text"];
                note.noteCreatedAt = [AllUtils getDateFromString:[obj objectForKey:@"createdAt"]];
                [allNotesArray addObject:note];
            }
            
            if (tempText != nil && tempIndexPath != nil) {
                [[allNotesArray objectAtIndex:tempIndexPath.row] setValue:tempText forKey:@"noteText"];
                for (int i = (int)tempIndexPath.row ; i >= 1; i--) {
                    
                    [allNotesArray exchangeObjectAtIndex:i withObjectAtIndex:i-1];
                }
            }
        }
    }];
    
    return allNotesArray;

}

#pragma mark - 查询收藏的日记
+ (NSMutableArray *)queryMarkedNotesInTable:(NSString *)tableName withUserId:(NSString *)userId andUsername:(NSString *)username withLimitCount:(int) limitCount {
    NSString* tempText;
    NSIndexPath* tempIndexPath;
    __block NSMutableArray *allNotesArray = [[NSMutableArray alloc] init];
    
    BmobQuery *queryNote = [BmobQuery queryWithClassName:tableName];
    //构造约束条件
    BmobQuery *inQuery = [BmobQuery queryWithClassName:USER_TABLE];
    [inQuery whereKey:@"objectId" equalTo:userId];
    
    queryNote.cachePolicy = kBmobCachePolicyCacheThenNetwork;
    [queryNote orderByDescending:@"updatedAt"];
    queryNote.limit = limitCount;
    
    //匹配查询
    [queryNote whereKey:@"likes" matchesQuery:inQuery];
    [queryNote findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
        } else if (array){
            allNotesArray = [[NSMutableArray alloc]init];
            for (BmobObject *obj in array) {
                Note *note = [[Note alloc] init];
                note.noteId = [obj objectForKey:@"objectId"];
                note.userId = [obj objectForKey:@"userID"];
                note.noteText = [obj objectForKey:@"text"];
                note.noteCreatedAt = [AllUtils getDateFromString:[obj objectForKey:@"createdAt"]];
                if (![[obj objectForKey:@"username"] isEqualToString:username]) {
                    note.username = @"火星用户";
                } else {
                    note.username = [obj objectForKey:@"username"];
                }
                [allNotesArray addObject:note];
            }
            
            if (tempText != nil && tempIndexPath != nil) {
                [[allNotesArray objectAtIndex:tempIndexPath.row] setValue:tempText forKey:@"noteText"];
                for (int i = (int)tempIndexPath.row ; i >= 1; i--) {
                    
                    [allNotesArray exchangeObjectAtIndex:i withObjectAtIndex:i-1];
                }
            }
        }
    }];
    return allNotesArray;

}

#pragma mark - 收藏日记
+ (void)addBookmark:(NSString *)noteId todo:(void(^)(BOOL isSuccessful, NSError *error)) todo{
    //获取要添加关联关系的note
    BmobObject *note = [BmobObject objectWithoutDataWithClassName:NOTE_TABLE objectId:noteId];
    
    //新建relation对象
    BmobRelation *relation = [[BmobRelation alloc] init];
    BmobUser *buser = [BmobUser currentUser];
    [relation addObject:[BmobObject objectWithoutDataWithClassName:USER_TABLE objectId:buser.objectId]];
    
    //添加关联关系到likes列中
    [note addRelation:relation forKey:@"likes"];
    //异步更新obj的数据
    [note updateInBackgroundWithResultBlock:todo];
}

#pragma mark - 删除收藏的日记
+ (void)deleteBookmarkNoteInTable:(NSString *)tableName withNoteId:(NSString *)noteId todo:(void(^)(BOOL isSuccessful, NSError *error)) todo{
    BmobObject *post = [BmobObject objectWithoutDataWithClassName:tableName objectId:noteId];
    
    //新建relation对象
    BmobRelation *relation = [[BmobRelation alloc] init];
    [relation removeObject:[BmobObject objectWithoutDataWithClassName:USER_TABLE objectId:[BmobUser currentUser].objectId]];
    
    //添加关联关系到likes列中
    [post addRelation:relation forKey:@"likes"];
    
    //异步更新obj的数据
    [post updateInBackgroundWithResultBlock:todo];

}

#pragma mark - 分享日记
+ (void)shareNoteWithNoteId:(NSString *)noteId todo:(void(^)(BOOL isSuccessful, NSError *error)) todo{
    BmobQuery *bquery = [BmobQuery queryWithClassName:NOTE_TABLE];
    [bquery getObjectInBackgroundWithId:noteId block:^(BmobObject *object,NSError *error){
        if (!error) {
            if (object) {
                [object setObject:[NSNumber numberWithBool:YES] forKey:@"isShare"];
                //异步更新数据
                [object updateInBackgroundWithResultBlock:todo];
            }
        }
    }];
}


@end
