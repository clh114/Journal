//
//  TouchIDViewController.m
//  Journal
//
//  Created by cailihang on 2017/4/6.
//  Copyright © 2017年 cailihang. All rights reserved.
//

#import "TouchIDViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "AllUtils.h"

@interface TouchIDViewController () <UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UISwitch *switchBt;

@end

@implementation TouchIDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL switch_status = [defaults boolForKey:@"switch_status"];
    [self.switchBt setOn:switch_status animated:NO];
    [self.switchBt addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
}

- (void)switchAction:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn]; //get the status of switch
    //touchID validate
    if (isButtonOn) {
        //create LAContext
        LAContext* context = [[LAContext alloc] init];
        NSError* error = nil;
        NSString* result = @"请验证已有指纹";
        
        //首先使用canEvaluatePolicy 判断设备支持状态
        if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
            //支持指纹验证
            [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:result reply:^(BOOL success, NSError *error) {
                if (success) {
                    //验证成功，主线程处理UI
                    [defaults setBool:YES forKey:@"switch_status"];
                    NSLog(@"指纹识别状态：%@", [defaults objectForKey:@"switch_status"]);
                    [AllUtils showPromptDialog:@"提示" andMessage:@"指纹验证开启成功！" OKButton:@"确定" OKButtonAction:nil cancelButton:@"" cancelButtonAction:nil contextViewController:self];
                }
                else
                {
                    //在主线程改变SWITCH状态
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        [switchButton setOn:NO];
                    }];
                    [defaults setBool:NO forKey:@"switch_status"];
                    NSLog(@"指纹识别状态：%@", [defaults objectForKey:@"switch_status"]);
                    NSLog(@"%@",error.localizedDescription);
                }
            }];
        }
        else
        {
            //不支持指纹识别，LOG出错误详情
            NSLog(@"不支持指纹识别");
            NSLog(@"%@",error.localizedDescription);
        }
        
    }
    
    else {
        //创建LAContext
        LAContext* context = [[LAContext alloc] init];
        NSError* error = nil;
        NSString* result = @"请验证已有指纹";
        
        //首先使用canEvaluatePolicy 判断设备支持状态
        if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
            //支持指纹验证
            [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:result reply:^(BOOL success, NSError *error) {
                if (success) {
                    [defaults setBool:NO forKey:@"switch_status"];
                    NSLog(@"指纹识别状态：%@", [defaults objectForKey:@"switch_status"]);
                }
                else
                {
                    //在主线程改变SWITCH状态
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        [switchButton setOn:YES];
                    }];
                    [defaults setBool:YES forKey:@"switch_status"];
                    NSLog(@"指纹识别状态：%@", [defaults objectForKey:@"switch_status"]);
                    NSLog(@"%@",error.localizedDescription);
                    
                }
            }];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}



@end