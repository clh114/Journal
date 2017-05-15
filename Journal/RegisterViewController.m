//
//  ViewController.m
//  Journal
//
//  Created by cailihang on 2017/3/5.
//  Copyright © 2017年 cailihang. All rights reserved.
//

#import "RegisterViewController.h"
#import "LoginViewController.h"
#import "RegisterModel.h"


@interface RegisterViewController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *validateCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) RegisterModel *registermodel;

- (IBAction)returnbt:(id)sender;
- (IBAction)registerbt:(id)sender;
- (IBAction)getValidCodebt:(id)sender;


@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    self.phoneNumberTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.validateCodeTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.passwordTextField.borderStyle = UITextBorderStyleRoundedRect;
    
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

//返回登录
- (IBAction)returnbt:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"点击返回按钮，关闭模态视图");
    }];
}


//创建账户
- (IBAction)registerbt:(id)sender {
    [self.registermodel registerWithPhoneNumber:self.phoneNumberTextField.text andSMSCode:self.validateCodeTextField.text andPassword:self.passwordTextField.text contextViewController:self];
}


//获取验证码
- (IBAction)getValidCodebt:(id)sender {
    [self.registermodel getSmsCodeWithPhoneNumber:self.phoneNumberTextField.text andContextViewController:self];
}

@end

