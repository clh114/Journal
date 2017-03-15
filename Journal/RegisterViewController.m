//
//  ViewController.m
//  Journal
//
//  Created by cailihang on 2017/3/5.
//  Copyright © 2017年 cailihang. All rights reserved.
//

#import "RegisterViewController.h"
#import "LoginViewController.h"
#import "AllUtils.h"
#import <BmobSDK/Bmob.h>


@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *validateCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

- (IBAction)returnbt:(id)sender;
- (IBAction)registerbt:(id)sender;
//- (IBAction)getValidCodebt:(id)sender;


@end

@implementation RegisterViewController

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

- (IBAction)returnbt:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"点击返回按钮，关闭模态视图");
    }];
}

- (IBAction)registerbt:(id)sender {
    NSString *mobilePhoneNumber = self.phoneNumberTextField.text;
    NSString *smsCode = self.validateCodeTextField.text;
    NSString *passWord = self.passwordTextField.text;

    BmobUser *user = [[BmobUser alloc] init];
    user.mobilePhoneNumber = mobilePhoneNumber;
    user.password = passWord;
    [user signUpOrLoginInbackgroundWithSMSCode:smsCode block:^(BOOL isSuccessful, NSError *error){
        if (error) {
            NSLog(@"%@", error);
            [AllUtils showPromptDialog:@"提示" andMessage:@"验证码错误！" OKButton:@"确定" OKButtonAction:nil cancelButton:@"" cancelButtonAction:nil contextViewController:self];
        } else {
            BmobUser *buser = [BmobUser currentUser];
            NSLog(@"%@", buser);
            [AllUtils jumpToViewController:@"registerViewController2" contextViewController:self handler:nil];
        }
    }];
}


- (IBAction)getValidCodebt:(id)sender {
    //获取手机号
    NSString *mobilePhoneNumber = self.phoneNumberTextField.text;
    
    //验证手机号是否已经注册
    __block BOOL isRepeatPhoneNumber = false;
    BmobQuery *query = [BmobUser query];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (!error) {
            for (BmobObject *obj in array) {
                if ([(NSString*)[obj objectForKey:@"mobilePhoneNumber"] isEqualToString:mobilePhoneNumber]) {
                    isRepeatPhoneNumber = true;
                    break;
                }
            }
        } else {
            [AllUtils showPromptDialog:@"提示" andMessage:@"网络异常，请稍候重试！" OKButton:@"确定" OKButtonAction:nil cancelButton:@"" cancelButtonAction:nil contextViewController:self];
        }
        if (isRepeatPhoneNumber) {
            [AllUtils showPromptDialog:@"提示" andMessage:@"该手机号已经注册，请直接登录！" OKButton:@"确定" OKButtonAction:nil cancelButton:@"" cancelButtonAction:nil contextViewController:self];
        } else {
            //请求验证码
            [BmobSMS requestSMSCodeInBackgroundWithPhoneNumber:mobilePhoneNumber andTemplate:@"test" resultBlock:^(int number, NSError *error){
                if (error) {
                    NSLog(@"%@", error);
                    [AllUtils showPromptDialog:@"提示" andMessage:@"请输入正确的手机号码" OKButton:@"确定" OKButtonAction:nil cancelButton:@"" cancelButtonAction:nil contextViewController:self];
                } else {
                    //获得smsID
                    NSLog(@"sms ID:%d", number);
                    [AllUtils showPromptDialog:@"提示" andMessage:@"验证码已发送，请稍等！" OKButton:@"确定" OKButtonAction:nil cancelButton:@"" cancelButtonAction:nil contextViewController:self];
                    
                }
            }];
        }
    }];
}
@end

