//
//  NoteViewController.h
//  Journal
//
//  Created by cailihang on 15/03/2017.
//  Copyright © 2017 cailihang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoteViewController : UITableViewController

@property(nonatomic,copy) NSString* tempTitle;
@property(nonatomic,copy) NSString* tempText;
@property(nonatomic,strong) NSIndexPath* tempIndexPath;

@end
