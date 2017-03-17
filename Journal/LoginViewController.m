//
//  ViewController.m
//  Journal
//
//  Created by cailihang on 2017/3/5.
//  Copyright © 2017年 cailihang. All rights reserved.
//

#import "LoginViewController.h"
#import "AllUtils.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    self.usernameTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.passwordTextField.borderStyle = UITextBorderStyleRoundedRect;

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//点击登录按钮
- (IBAction)loginbt:(id)sender {
    NSString *username = [self.usernameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.passwordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    [BmobUser loginInbackgroundWithAccount:username andPassword:password block:^(BmobUser *user, NSError *error){
        if (user) {
            NSLog(@"login success");
            [AllUtils jumpToViewController:@"homeViewController" contextViewController:self handler:nil];
        } else {
            NSLog(@"%@", error);
            [AllUtils showPromptDialog:@"提示" andMessage:@"用户名或密码错误！" OKButton:@"确定" OKButtonAction:nil cancelButton:@"" cancelButtonAction:nil contextViewController:self];
        }
    }];
    
}
- (IBAction)modifyPWbt:(id)sender {
    [AllUtils jumpToViewController:@"forgetPWViewController" contextViewController:self handler:nil];
}

@end
