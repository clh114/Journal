//
//  ForgetPWViewController.m
//  Journal
//
//  Created by cailihang on 09/03/2017.
//  Copyright © 2017 cailihang. All rights reserved.
//

#import "ForgetPWViewController.h"
#import "ForgetPassWordModel.h"
#import <IQKeyboardManager.h>

@interface ForgetPWViewController ()

@property (weak, nonatomic) IBOutlet UITextField *emailTF;
@property (strong, nonatomic) ForgetPassWordModel *forgetpasswordmodel;

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

- (IBAction)modifyPassWordbt:(id)sender {
    [self.forgetpasswordmodel findPasswordWithEmail:self.emailTF.text contextViewController:self];
}

- (IBAction)loginbt:(id)sender {
    [AllUtils jumpToViewController:@"loginViewController" contextViewController:self handler:nil];
}
@end
