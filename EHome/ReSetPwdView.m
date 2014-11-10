//
//  ReSetPwdView.m
//  BeautyLife
//
//  Created by Seven on 14-9-16.
//  Copyright (c) 2014年 Seven. All rights reserved.
//

#import "ReSetPwdView.h"
#import "SMS_SDK/SMS_SDK.h"

@interface ReSetPwdView ()

@end

@implementation ReSetPwdView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
        titleLabel.font = [UIFont boldSystemFontOfSize:18];
        titleLabel.text = @"重置密码";
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = UITextAlignmentCenter;
        self.navigationItem.titleView = titleLabel;
        
        UIButton *lBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
        [lBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [lBtn setImage:[UIImage imageNamed:@"backBtn"] forState:UIControlStateNormal];
        UIBarButtonItem *btnBack = [[UIBarButtonItem alloc]initWithCustomView:lBtn];
        self.navigationItem.leftBarButtonItem = btnBack;
    }
    return self;
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.securityCodeTf.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

-(int)getRandomNumber:(int)start to:(int)end
{
    return (int)(start + (arc4random() % (end - start + 1)));
}

-(void)securityCodeVerify
{
    [SMS_SDK commitVerifyCode:self.securityCodeTf.text result:^(enum SMS_ResponseState state) {
        if (1==state) {
            NSLog(@"block 验证成功");
            [Tool showCustomHUD:@"验证成功" andView:self.view  andImage:@"37x-Checkmark.png" andAfterDelay:3];
            self.resetBtn.enabled = YES;
        }
        else if(0==state)
        {
            NSLog(@"block 验证失败");
            [Tool showCustomHUD:@"验证码错误" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:3];
            self.resetBtn.enabled = NO;
        }
    }];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField.text length] > 0) {
        [self securityCodeVerify];
    }
}

- (IBAction)sendSecurityCodeAction:(id)sender
{
    NSString *mobileStr = self.mobileTf.text;
    self.securityCodeBtn.enabled = NO;
    self.mobileTf.enabled = NO;
    if (![mobileStr isValidPhoneNum]) {
        [Tool showCustomHUD:@"手机号错误" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
        return;
    }
    [SMS_SDK getVerifyCodeByPhoneNumber:mobileStr AndZone:@"86" result:^(enum SMS_GetVerifyCodeResponseState state) {
        if (1==state) {
            NSLog(@"block 获取验证码成功");
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"获取成功"
                                                         message:@"验证码获取成功，接受短信大约需要60秒。"
                                                        delegate:nil
                                               cancelButtonTitle:@"确定"
                                               otherButtonTitles:nil];
            [av show];
        }
        else if(0==state)
        {
            NSLog(@"block 获取验证码失败");
            NSString* str=@"验证码发送失败 请稍后重试";
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"发送失败" message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            self.securityCodeBtn.enabled = YES;
            self.mobileTf.enabled = YES;
        }
        else if (SMS_ResponseStateMaxVerifyCode==state)
        {
            NSString* str=@"请求验证码超上限 请稍后重试";
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"超过上限" message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            self.securityCodeBtn.enabled = YES;
            self.mobileTf.enabled = YES;
        }
        else if(SMS_ResponseStateGetVerifyCodeTooOften==state)
        {
            NSString* str=@"客户端请求发送短信验证过于频繁";
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            self.securityCodeBtn.enabled = YES;
            self.mobileTf.enabled = YES;
        }
    }];
}

- (IBAction)resetAction:(id)sender
{
    NSString *pwdStr = self.pwdTf.text;
    NSString *pwdAgainStr = self.pwdAgainTf.text;
    if (pwdStr == nil || [pwdStr length] == 0) {
        [Tool showCustomHUD:@"请输入新密码" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
        return;
    }
    if (![pwdStr isEqualToString:pwdAgainStr]) {
        [Tool showCustomHUD:@"密码确认不一致" andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:1];
        self.pwdAgainTf.text = @"";
        return;
    }
    [self.pwdTf resignFirstResponder];
    [self.pwdAgainTf resignFirstResponder];
    self.resetBtn.enabled = NO;
    NSString *changeUrl = [NSString stringWithFormat:@"%@%@", api_base_url, api_resetpwd];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:changeUrl]];
    [request setUseCookiePersistence:NO];
    [request setPostValue:appkey forKey:@"APPKey"];
    [request setPostValue:[[UserModel Instance] getUserValueForKey:@"tel"] forKey:@"userid"];
    [request setPostValue:pwdStr forKey:@"newpwd"];
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestFailed:)];
    [request setDidFinishSelector:@selector(requestChange:)];
    [request startAsynchronous];
    
    request.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [Tool showHUD:@"正在提交" andView:self.view andHUD:request.hud];
}

- (void)requestChange:(ASIHTTPRequest *)request
{
    if (request.hud) {
        [request.hud hide:YES];
    }
    
    [request setUseCookiePersistence:YES];
    NSData *data = [request.responseString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (!json) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"错误提示"
                                                     message:request.responseString
                                                    delegate:nil
                                           cancelButtonTitle:@"确定"
                                           otherButtonTitles:nil];
        [av show];
        return;
    }
    User *user = [Tool readJsonStrToUser:request.responseString];
    int errorCode = [user.status intValue];
    NSString *errorMessage = user.info;
    switch (errorCode) {
        case 1:
        {
            self.pwdTf.text = @"";
            self.pwdAgainTf.text = @"";
            [Tool showCustomHUD:errorMessage andView:self.view  andImage:@"37x-Checkmark.png" andAfterDelay:3];
        }
            break;
        case 0:
        {
            [Tool showCustomHUD:errorMessage andView:self.view  andImage:@"37x-Failure.png" andAfterDelay:3];
            self.resetBtn.enabled = YES;
        }
            break;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
