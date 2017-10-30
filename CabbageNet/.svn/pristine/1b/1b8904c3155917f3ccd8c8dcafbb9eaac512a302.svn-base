//
//  VerificationViewController.m
//  CabbageNet
//
//  Created by MacAir on 2017/4/10.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import "VerificationViewController.h"
#import "VerificationSuccessViewController.h"
#import "SecurityViewController.h"

@interface VerificationViewController ()

@property (weak, nonatomic) IBOutlet UITextField *codeField;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIView *whitView;

@end

@implementation VerificationViewController{
    NSInteger _timernum;
    NSTimer *_timer;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.codeField.text = @"";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _timernum = 60;
    
    
    if ([self.title isEqualToString:@"邮箱验证"]){
        self.phoneField.placeholder = @"请输入邮箱";
        self.phoneLabel.text = @"邮箱：";
    }else if ([self.title isEqualToString:@"手机验证"]){
        self.codeField.placeholder = @"请输入手机号";
        [self.whitView removeFromSuperview];
    }
}

- (void)backBtnClick{
    if (_successPop == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    for (UIViewController *controller in self.navigationController.viewControllers) {
        
        if ([controller isKindOfClass:[SecurityViewController class]]) {
            
            SecurityViewController *vc = (SecurityViewController *)controller;
            
            [self.navigationController popToViewController:vc animated:YES];
            
        }
        
    }
}

- (IBAction)getCodeBtnClick:(UIButton *)sender {
    
//    if ([self.title isEqualToString:@"邮箱验证"]){
//        
//    }else if ([self.title isEqualToString:@"手机验证"]){
//        
//    }
    if ([self.title isEqualToString:@"邮箱验证"]){
        return;
    }else if ([self.title isEqualToString:@"手机验证"]){
        if (![self isMobileNumberClassification:self.phoneField.text]) {
            [MBProgressHUD showError:@"请输入正确的手机号" toView:nil];
            return;
        }
    }
    
    
    _timer = [NSTimer timerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
        if (_timernum != 0) {
            _timernum--;
            [sender setTitle:[NSString stringWithFormat:@"%lds",_timernum] forState:UIControlStateNormal];
            sender.userInteractionEnabled = NO;
        }else{
            _timernum = 60;
            [_timer invalidate];
            _timer = nil;
            [sender setTitle:@"获取验证码" forState:UIControlStateNormal];
            sender.userInteractionEnabled = YES;
        }
    }];
    
    NSRunLoop *loop = [NSRunLoop currentRunLoop];
    [loop addTimer:_timer forMode:NSRunLoopCommonModes];
    
    NSMutableDictionary * infoDic = [[NSMutableDictionary alloc]init];
    setDickeyobj(infoDic, @"smscode", @"api");
    if ([self.title isEqualToString:@"邮箱验证"]){

    }else if ([self.title isEqualToString:@"手机验证"]){
        setDickeyobj(infoDic, self.phoneField.text, @"mobile");
    }
    
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    setDickeyobj(param, infoDic, @"reqBody");
    [CKHttpCommunicate createRequest:HTTP_USER_API WithParam:param withMethod:POST success:^(id result) {
        
        if (SUCCESS_REQUEST(result)) {
            
            [MBProgressHUD showError:@"已发送验证码至您的手机" toView:nil];
        }else{
            
            [MBProgressHUD showError:result[@"msg"] toView:nil];
        }
        
    } failure:^(NSError *erro) {
        NSLog(@"%@",erro);
    } showHUD:nil];

}

- (IBAction)nextBtnClick:(id)sender {
    
    [self.view endEditing:YES];
    
    NSMutableDictionary * infoDic = [[NSMutableDictionary alloc]init];
    setDickeyobj(infoDic, @"bindinfo", @"api")
    UserInfoModel *model = [UserInfoModel sharedUserData];
    setDickeyobj(infoDic, model.userid, @"userid")
    
    if ([self.title isEqualToString:@"邮箱验证"]){
        
        if ([self isValidateEmail:self.phoneField.text]){
            setDickeyobj(infoDic, self.phoneField.text, @"email");
        }else {
            [MBProgressHUD showError:@"请输入正确的邮箱！" toView:nil];
            return;
        }
    }else if ([self.title isEqualToString:@"手机验证"]){
        if ([self isMobileNumberClassification:self.phoneField.text]){
            setDickeyobj(infoDic, self.phoneField.text, @"mobile");
        }else {
            [MBProgressHUD showError:@"请输入正确的手机号码！" toView:nil];
            return;
        }
        if (self.codeField.text.length) {
            setDickeyobj(infoDic, self.codeField.text, @"captcha");
        }else{
            [MBProgressHUD showError:@"请输入验证码！" toView:nil];
            return;
        }
    }
    
    
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    setDickeyobj(param, infoDic, @"reqBody");
    
    [CKHttpCommunicate createRequest:HTTP_USER_API WithParam:param withMethod:POST success:^(id result) {

        if (SUCCESS_REQUEST(result)) {
            UserInfoModel *model = [UserInfoModel sharedUserData];
            if ([self.title isEqualToString:@"邮箱验证"]){
               model.email = self.phoneField.text;
            }else if ([self.title isEqualToString:@"手机验证"]){
                model.mobile = self.phoneField.text;
            }
            [UserInfoModel storeUserWithModel:model];
            if (_successPop == 1) {
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                VerificationSuccessViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"verificationSuccessViewController"];
                if ([self.title isEqualToString:@"邮箱验证"]){
                    controller.tag = 2;
                }else if ([self.title isEqualToString:@"手机验证"]){
                    controller.tag = 1;
                }
                [self.navigationController pushViewController:controller animated:YES];
            }
        }
        else{
            
            [MBProgressHUD showError:result[@"msg"] toView:nil];
        }
        
    } failure:^(NSError *erro) {
        NSLog(@"%@", erro);
    } showHUD:nil];

}

-(BOOL)isValidateEmail:(NSString *)email

{
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailRegex];
    
    return [emailTest evaluateWithObject:email];
    
}

//是否为手机号
- (BOOL)isMobileNumberClassification:(NSString *)string{
    
    NSString * MOBIL = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    
    
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[2378])\\d)\\d{7}$";
    
    
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    
    
    
    NSString * CT = @"^1((33|53|8[019])[0-9]|349)\\d{7}$";
    
    
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBIL];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    
    if (([regextestmobile evaluateWithObject:string]
         || [regextestcm evaluateWithObject:string]
         || [regextestct evaluateWithObject:string]
         || [regextestcu evaluateWithObject:string])) {
        return YES;
    }else{
        return NO;
    }
}

@end
