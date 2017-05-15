//
//  SettingTableViewController.m
//  Journal
//
//  Created by cailihang on 30/03/2017.
//  Copyright © 2017 cailihang. All rights reserved.
//

#import "SettingTableViewController.h"
#import "AllUtils.h"
#import <BmobSDK/Bmob.h>

@interface SettingTableViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation SettingTableViewController


- (IBAction)backBt:(id)sender {
    [AllUtils jumpToViewController:@"homeViewController" contextViewController:self handler:nil];
}

- (IBAction)logoutBt:(id)sender {
    [BmobUser logout];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:NO forKey:@"switch_status"];
    [AllUtils jumpToViewController:@"loginViewController" contextViewController:self handler:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    switch (indexPath.row) {
        case 0:
            [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"userInfoViewController"] animated:YES];
            break;
        case 1:
            [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"touchIDViewController"] animated:YES];
            break;
            
        default:
            break;
    }
}

@end
