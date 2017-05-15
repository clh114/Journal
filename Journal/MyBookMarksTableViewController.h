//
//  MyBookMarksTableViewController.h
//  Journal
//
//  Created by cailihang on 2017/5/6.
//  Copyright © 2017年 cailihang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyBookMarksTableViewController : UITableViewController

@property(nonatomic,copy) NSString* tempTitle;
@property(nonatomic,copy) NSString* tempText;
@property(nonatomic,strong) NSIndexPath* tempIndexPath;

@end
