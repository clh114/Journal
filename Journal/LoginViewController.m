//
//  ViewController.m
//  Journal
//
//  Created by cailihang on 2017/3/5.
//  Copyright © 2017年 cailihang. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginModel.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic)LoginModel *loginmodel;

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
    [self.loginmodel loginwithAcount:self.usernameTextField.text andPassword:self.passwordTextField.text contextViewController:self];
}
- (IBAction)modifyPWbt:(id)sender {
    [AllUtils jumpToViewController:@"forgetPWViewController" contextViewController:self handler:nil];
}

@end
