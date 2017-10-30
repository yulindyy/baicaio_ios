//
//  PhoneRegisterNextViewController.m
//  CabbageNet
//
//  Created by xiang fu on 2017/7/9.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import "PhoneRegisterNextViewController.h"
#import "LoginViewController.h"

@interface PhoneRegisterNextViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (weak, nonatomic) IBOutlet UITextField *pwdAgainField;

@end

@implementation PhoneRegisterNextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

#pragma mark -- 注册用户
- (IBAction)finishBtnClick {
    
    if (!_nameField.text.length) {
        [MBProgressHUD showError:@"请输入昵称！" toView:nil];
        return;
    }
    if (!_pwdField.text.length || ![_pwdField.text isEqualToString:_pwdAgainField.text]){
        [MBProgressHUD showError:@"请核对登录密码！" toView:nil];
        return;
    }
    NSMutableDictionary * infoDic = [[NSMutableDictionary alloc]init];
    setDickeyobj(infoDic, @"register", @"api");
    setDickeyobj(infoDic, _nameField.text, @"username");
    setDickeyobj(infoDic, _pwdField.text, @"password");
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    setDickeyobj(param, infoDic, @"reqBody");
    [CKHttpCommunicate createRequest:HTTP_USER_API WithParam:param withMethod:POST success:^(id result) {
        
        if (SUCCESS_REQUEST(result)) {
            [self requestData:result[@"data"]];
            
        }else{
            [MBProgressHUD showError:result[@"msg"] toView:nil];
        }
        
    } failure:^(NSError *erro) {
        NSLog(@"%@",erro);
    } showHUD:nil];
    
}

#pragma mark -- 绑定手机
- (void)requestData:(NSString *)uid{
    NSMutableDictionary * infoDic = [[NSMutableDictionary alloc]init];
    setDickeyobj(infoDic, @"bindinfo", @"api")
    setDickeyobj(infoDic, uid, @"userid")
    setDickeyobj(infoDic, self.code, @"captcha")
    setDickeyobj(infoDic, self.phone, @"mobile")
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    setDickeyobj(param, infoDic, @"reqBody");
    [CKHttpCommunicate createRequest:HTTP_USER_API WithParam:param withMethod:POST success:^(id result) {
        if (SUCCESS_REQUEST(result)) {
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[LoginViewController class]]) {
                    LoginViewController *vc = (LoginViewController *)controller;
                    [self.navigationController popToViewController:vc animated:YES];
                }
            }
        }else{
            [MBProgressHUD showError:result[@"msg"] toView:nil];
        }
        
    } failure:^(NSError *erro) {
        NSLog(@"%@",erro);
    } showHUD:nil];
}

@end
