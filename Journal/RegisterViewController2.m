//
//  RegisterViewController2.m
//  Journal
//
//  Created by cailihang on 09/03/2017.
//  Copyright © 2017 cailihang. All rights reserved.
//

#import "RegisterViewController2.h"
#import "RegisterViewController.h"
#import "AllUtils.h"
#import <BmobSDK/Bmob.h>
#import <IQKeyboardManager.h>

@interface RegisterViewController2 ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTF;
@property (weak, nonatomic) IBOutlet UITextField *emailTF;
- (IBAction)okBT:(id)sender;

@end

@implementation RegisterViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    self.usernameTF.borderStyle = UITextBorderStyleRoundedRect;
    self.emailTF.borderStyle = UITextBorderStyleRoundedRect;
    
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
- (BOOL)isValidateEmail:(NSString *)email{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

- (IBAction)okBT:(id)sender {
    NSString *username = self.usernameTF.text;
    NSString *email = self.emailTF.text;
    
    //对邮箱格式进行检查
    if ([self isValidateEmail:email] == YES) {
        
        __block BOOL isRepeatUsername = false;
        __block BOOL isRepeatEmail = false;
        
        //输入信息不为空才能进行确认
        if (!([username isEqualToString:@""]) && !([email isEqualToString:@""])) {
            //查询用户名和邮箱是否已存在
            BmobQuery *query = [BmobUser query];
            [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                if (!error) {
                    for (BmobObject *obj in array)
                    {
                        if ([(NSString*)[obj objectForKey:@"username"] isEqualToString:username]) {
                            isRepeatUsername = true;
                            break;
                        } else if ([(NSString*)[obj objectForKey:@"email"] isEqualToString:email]) {
                            isRepeatEmail = true;
                            break;
                        }
                    }
                } else {
                    [AllUtils showPromptDialog:@"提示" andMessage:@"网络异常，请稍候重试" OKButton:@"确定" OKButtonAction:nil cancelButton:@"" cancelButtonAction:nil contextViewController:self];
                }
            }];
            if (isRepeatUsername) {
                [AllUtils showPromptDialog:@"提示" andMessage:@"该用户名已被占用" OKButton:@"确定" OKButtonAction:nil cancelButton:@"" cancelButtonAction:nil contextViewController:self];
            } else if (isRepeatEmail){
                [AllUtils showPromptDialog:@"提示" andMessage:@"该邮箱已经注册" OKButton:@"确定" OKButtonAction:nil cancelButton:@"" cancelButtonAction:nil contextViewController:self];
            } else {
                //对账户进行更新
                BmobUser *user = [BmobUser currentUser];
                [user setObject:username forKey:@"username"];
                [user setObject:email forKey:@"email"];
                [user updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                    if (isSuccessful) {
                        NSLog(@"更新后：");
                        NSLog(@"%@", user);
                        [AllUtils jumpToViewController:@"homeViewController" contextViewController:self handler:nil];
                    }
                }];
                
            }
        }
        else {
            [AllUtils showPromptDialog:@"提示" andMessage:@"请输入完整信息！" OKButton:@"确定" OKButtonAction:nil cancelButton:@"" cancelButtonAction:nil contextViewController:self];
        }
    }
    else {
        [AllUtils showPromptDialog:@"提示" andMessage:@"邮箱格式不正确！" OKButton:@"确定" OKButtonAction:nil cancelButton:@"" cancelButtonAction:nil contextViewController:self];
    }
    
}
@end
