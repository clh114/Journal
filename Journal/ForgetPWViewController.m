//
//  ForgetPWViewController.m
//  Journal
//
//  Created by cailihang on 09/03/2017.
//  Copyright © 2017 cailihang. All rights reserved.
//

#import "ForgetPWViewController.h"
#import "AllUtils.h"
#import <BmobSDK/Bmob.h>
#import <IQKeyboardManager.h>

@interface ForgetPWViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailTF;
- (IBAction)modifyPassWordbt:(id)sender;
- (IBAction)loginbt:(id)sender;

@end

@implementation ForgetPWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)modifyPassWordbt:(id)sender {
    NSString *email = self.emailTF.text;
    BmobQuery *query = [BmobUser query];
    __block BOOL isRegistered = false;
    if (![email isEqualToString:@""]) {
        [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            if (!error) {
                for (BmobObject *obj in array) {
                    if ([(NSString*)[obj objectForKey:@"email"] isEqualToString:email]) {
                        isRegistered = true;
                        break;
                    }
                }
            } else {
                            [AllUtils showPromptDialog:@"提示" andMessage:@"网络异常，请稍候重试！" OKButton:@"确定" OKButtonAction:nil cancelButton:@"" cancelButtonAction:nil contextViewController:self];
            }
            if (isRegistered) {
                [BmobUser requestPasswordResetInBackgroundWithEmail:email];
                [AllUtils showPromptDialog:@"提示" andMessage:@"已发送重置密码邮件，请查看邮箱" OKButton:@"确定" OKButtonAction:nil cancelButton:@"" cancelButtonAction:nil contextViewController:self];
                [AllUtils jumpToViewController:@"loginViewController" contextViewController:self handler:nil];
            } else {
                [AllUtils showPromptDialog:@"提示" andMessage:@"该邮箱地址未注册" OKButton:@"确定" OKButtonAction:nil cancelButton:@"" cancelButtonAction:nil contextViewController:self];
            }
        }];
    }
}

- (IBAction)loginbt:(id)sender {
    [AllUtils jumpToViewController:@"loginViewController" contextViewController:self handler:nil];
}
@end
