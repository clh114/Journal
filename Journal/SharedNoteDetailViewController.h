//
//  SharedNoteDetailViewController.h
//  Journal
//
//  Created by cailihang on 2017/4/29.
//  Copyright © 2017年 cailihang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SharedNoteDetailViewController : UIViewController

@property(nonatomic,copy) NSString *noteId;
@property(nonatomic,copy) NSString *noteText;
@property(nonatomic,strong) NSIndexPath *indexPath;

@end
