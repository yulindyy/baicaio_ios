//
//  ForgetPwdViewController.m
//  CabbageNet
//
//  Created by xiang fu on 2017/8/23.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import "ForgetPwdViewController.h"
#import "LoginViewController.h"

@interface ForgetPwdViewController ()

@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (weak, nonatomic) IBOutlet UITextField *pwdAgainField;

@end

@implementation ForgetPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)finishBtnClick:(UIButton *)sender {
    
    if (!_pwdField.text.length || ![_pwdField.text isEqualToString:_pwdAgainField.text]) {
        [MBProgressHUD showError:@"请核对好密码" toView:nil];
        return;
    }
    NSMutableDictionary * infoDic = [[NSMutableDictionary alloc]init];
    setDickeyobj(infoDic, @"forgetpassword", @"api");
    setDickeyobj(infoDic, self.phone, @"mobile");
    setDickeyobj(infoDic, _pwdField.text, @"password");
    setDickeyobj(infoDic, self.code, @"captcha");
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    
    setDickeyobj(param, infoDic, @"reqBody");
    [CKHttpCommunicate createRequest:HTTP_USER_API WithParam:param withMethod:POST success:^(id result) {
        
        
        if (SUCCESS_REQUEST(result)) {
            
            [MBProgressHUD showError:@"密码重置成功" toView:self.view];
            [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.5f];
        }else {
            [MBProgressHUD showError:result[@"msg"] toView:nil];
        }
        
    } failure:^(NSError *erro) {
        NSLog(@"%@",erro);
    } showHUD:nil];

}

- (void)delayMethod {
    self.view.userInteractionEnabled = YES;
    LoginViewController *controller  = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"loginViewController"];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
