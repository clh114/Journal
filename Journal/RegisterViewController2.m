//
//  RegisterViewController2.m
//  Journal
//
//  Created by cailihang on 09/03/2017.
//  Copyright © 2017 cailihang. All rights reserved.
//

#import "RegisterViewController2.h"
#import "RegisterModel.h"
#import <IQKeyboardManager.h>

@interface RegisterViewController2 ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTF;
@property (weak, nonatomic) IBOutlet UITextField *emailTF;
@property (strong, nonatomic)RegisterModel *registermodel;

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

- (IBAction)okBT:(id)sender {
    [self.registermodel registerWithUsername:self.usernameTF.text andEmail:self.emailTF.text ContextViewController:self];
}
@end
