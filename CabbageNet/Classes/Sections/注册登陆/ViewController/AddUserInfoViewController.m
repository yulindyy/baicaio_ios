//
//  AddUserInfoViewController.m
//  CabbageNet
//
//  Created by xiang fu on 2017/6/15.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import "AddUserInfoViewController.h"

@interface AddUserInfoViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UIButton *boyBtn;
@property (weak, nonatomic) IBOutlet UIButton *gerBtn;


@end

@implementation AddUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)finishBtnClick {
    if (!self.userNameField.text.length) {
        [MBProgressHUD showError:@"请输入用户名" toView:nil];
        return;
    }else if (!self.pwdField.text.length){
        [MBProgressHUD showError:@"请输入登录密码" toView:nil];
        return;
    }else if (!self.emailField.text.length){
        [MBProgressHUD showError:@"请输入邮箱账号" toView:nil];
        return;
    }
    if (![self isValidateEmail:self.emailField.text]) {
        [MBProgressHUD showError:@"请输入正确的邮箱账号" toView:nil];
        return;
    }
    
    NSMutableDictionary * infoDic = [[NSMutableDictionary alloc]init];
    setDickeyobj(infoDic, @"register_open", @"api");
    setDickeyobj(infoDic, self.userNameField.text, @"username");
    setDickeyobj(infoDic, self.pwdField.text, @"password");
    setDickeyobj(infoDic, self.emailField.text, @"email");
    if (_boyBtn.isSelected){
        setDickeyobj(infoDic, @"1", @"gender");
    }else{
         setDickeyobj(infoDic, @"0", @"gender");
    }
    
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    setDickeyobj(param, infoDic, @"reqBody");
    
    [CKHttpCommunicate createRequest:HTTP_USER_API WithParam:param withMethod:POST success:^(id result) {
        
        
        
        if (SUCCESS_REQUEST(result)) {
            
            UserInfoModel *model = [[UserInfoModel alloc] init];
            [model mj_setKeyValues:result[@"data"]];
            
            model.username = _userNameField.text;
            if (_boyBtn.isSelected){
                model.gender = 1;
            }else{
                model.gender = 0;
            }
            [UserInfoModel storeUserWithModel:model];
            [self bindThrid];
//            UserDefaultsSynchronize(@"10001", @"login");
//            [self.view endEditing:YES];
//            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
            
        }else {
            [MBProgressHUD showError:result[@"msg"] toView:nil];
        }
        
    } failure:^(NSError *erro) {
        NSLog(@"%@",erro);
    } showHUD:nil];
    
}

-(BOOL)isValidateEmail:(NSString *)email

{
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailRegex];
    
    return [emailTest evaluateWithObject:email];
    
}

- (void)bindThrid{
    NSMutableDictionary * infoDic = [[NSMutableDictionary alloc]init];
    setDickeyobj(infoDic, @"bind", @"api");
    UserInfoModel *model = [UserInfoModel sharedUserData];
    setDickeyobj(infoDic, model.userid, @"userid");
    setDickeyobj(infoDic, self.type, @"type");
    setDickeyobj(infoDic, self.keyid, @"keyid");
    setDickeyobj(infoDic, self.info, @"info");
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    setDickeyobj(param, infoDic, @"reqBody");
    [CKHttpCommunicate createRequest:HTTP_USER_API WithParam:param withMethod:POST success:^(id result) {
        
        if (SUCCESS_REQUEST(result)) {
            UserInfoModel *model = [UserInfoModel sharedUserData];
            [model mj_setKeyValues:result[@"data"]];
            [UserInfoModel storeUserWithModel:model];
            UserDefaultsSynchronize(@"10001", @"login");
            [self.view endEditing:YES];
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
            }
        else{
            
            [MBProgressHUD showError:result[@"msg"] toView:nil];
            return ;
        }
        
    } failure:^(NSError *erro) {
        NSLog(@"%@", erro);
        return ;
    } showHUD:nil];
}

- (IBAction)boyBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    _gerBtn.selected = !sender.selected;
}

- (IBAction)gerBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    _boyBtn.selected = !sender.selected;
}



@end
