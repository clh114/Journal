//
//  BookMarkNoteDetailViewController.h
//  Journal
//
//  Created by cailihang on 2017/5/6.
//  Copyright © 2017年 cailihang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookMarkNoteDetailViewController : UIViewController

@property(nonatomic,copy) NSString *noteId;
@property(nonatomic,copy) NSString *noteText;
@property(nonatomic,strong) NSIndexPath *indexPath;

@end
