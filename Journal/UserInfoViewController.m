//
//  UserInfoViewController.m
//  Journal
//
//  Created by cailihang on 2017/4/2.
//  Copyright © 2017年 cailihang. All rights reserved.
//

#import "UserInfoViewController.h"
#import "UserInfoModel.h"



@interface UserInfoViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *usernameTF;
@property (weak, nonatomic) IBOutlet UITextField *PSTF;
@property (weak, nonatomic) IBOutlet UITextField *websiteTF;
@property (weak, nonatomic) IBOutlet UITextField *emailTF;

@end

@implementation UserInfoViewController

- (IBAction)save:(id)sender {
    BmobUser *buser = [BmobUser currentUser];
    NSString *username = self.usernameTF.text;
    NSString *userId = buser.objectId;
    NSString *PS = self.PSTF.text;
    NSString *website = self.websiteTF.text;
    
    if (![UserInfoModel isUsernameRepeated:username withUserId:userId]) {
        [UserInfoModel updateUserInfo:USER_TABLE withUserId:userId andUserName:username andPS:PS andWebsite:website todo:^(BOOL isSuccessful, NSError *error) {
            if (isSuccessful) {
                NSLog(@"更新成功！");
                [AllUtils showPromptDialog:@"提示" andMessage:@"更新成功！" OKButton:@"确定" OKButtonAction:nil cancelButton:@"" cancelButtonAction:nil contextViewController:self];
            } else if (error){
                NSLog(@"%@", [error description]);
                [AllUtils showPromptDialog:@"提示" andMessage:@"该用户名已被占用" OKButton:@"确定" OKButtonAction:nil cancelButton:@"" cancelButtonAction:nil contextViewController:self];
            }
        }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    BmobUser *buser = [BmobUser currentUser];
    self.usernameTF.text = buser.username;
    self.PSTF.text = [buser objectForKey:@"PS"];
    self.websiteTF.text = [buser objectForKey:@"website"];
    self.emailTF.text = buser.email;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
