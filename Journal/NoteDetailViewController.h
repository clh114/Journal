//
//  NoteDetailViewController.h
//  Journal
//
//  Created by cailihang on 25/03/2017.
//  Copyright © 2017 cailihang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoteDetailViewController : UIViewController

@property(nonatomic,copy) NSString *noteId;
//@property(nonatomic,copy) NSString *noteTitle;
@property(nonatomic,copy) NSString *noteText;
@property(nonatomic,strong) NSIndexPath *indexPath;

@end
