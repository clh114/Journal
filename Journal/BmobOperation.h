//
//  BmobOperation.h
//  Journal
//
//  Created by cailihang on 20/03/2017.
//  Copyright © 2017 cailihang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BmobSDK/Bmob.h>
#import "Note.h"

@interface BmobOperation : NSObject

+ (void)addNoteToNoteTable:(NSString*)tableName userId:(NSString*)userId  username:(NSString*)username  noteTitle:(NSString*)noteTitle noteText:(NSString*)noteText todo:(void(^)(BOOL isSuccessful, NSError *error)) todo;

+ (void)deleteNoteFromDatabase:(NSString*)tableName noteId:(NSString*)noteId;

@end
