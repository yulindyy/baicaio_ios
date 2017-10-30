//
//  ForgetViewController.m
//  CabbageNet
//
//  Created by MacAir on 2017/4/6.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import "ForgetViewController.h"
#import "LoginViewController.h"
#import "TopBtnView.h"
#import "RegisterImageCell.h"
#import "RegisterFinishCell.h"
#import "RegisterBtnCell.h"
#import "ForgetPwdViewController.h"

@interface ForgetViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)TopBtnView *topBtnView;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation ForgetViewController{
    NSTimer *_timer;
    NSInteger _timernum;
    NSInteger _currTag;
    NSString *_codeStr;
}

- (TopBtnView *)topBtnView{
    if (!_topBtnView) {
        _topBtnView = [[TopBtnView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, 44) titleBtnArr:@[@"手机找回",@"邮箱/昵称找回"]];
        __weak typeof(self)weakSelf = self;
        _topBtnView.block = ^(NSInteger tag){
            _currTag = tag;
            [weakSelf.myTableView reloadData];
        };
        [_topBtnView btnActionChange:1];
    }
    return _topBtnView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _timernum = 60;
    _currTag = 1;
    [self.view addSubview:self.topBtnView];
    
}

#pragma mark -- tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_currTag == 1) return 3;
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_currTag == 1) {
        if (indexPath.row == 0) {
            RegisterImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"registerImageCell"];
            cell.textField.secureTextEntry = NO;
            cell.headImageView.image = [UIImage imageNamed:@"手机"];
            cell.textField.placeholder = @"请输入手机号";
            cell.textField.text = @"";
            cell.textField.keyboardType = UIKeyboardTypePhonePad;
            return cell;
        }else if (indexPath.row == 1){
            RegisterBtnCell *cell = [tableView dequeueReusableCellWithIdentifier:@"registerBtnCell"];
            cell.headImageView.image = [UIImage imageNamed:@"验证码"];
            cell.textField.placeholder = @"请输入验证码";
            cell.textField.keyboardType = UIKeyboardTypeNumberPad;
            [cell.getCodeBtn addTarget:self action:@selector(getCodeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }else if (indexPath.row == 2){
            RegisterFinishCell *cell = [tableView dequeueReusableCellWithIdentifier:@"registerFinishCell"];
            cell.agreeBtn.hidden = YES;
            cell.protolBtn.hidden = YES;
            [cell.nextBtn setTitle:@"提交" forState:UIControlStateNormal];
            cell.block = ^(NSInteger tag) {
                [self finishBtnClick];
            };
            return cell;
        }
    }else if (_currTag == 2){
        if (indexPath.row == 0) {
            RegisterImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"registerImageCell"];
            cell.textField.secureTextEntry = NO;
            cell.headImageView.image = [UIImage imageNamed:@"手机"];
            cell.textField.placeholder = @"请输入邮箱／昵称";
            cell.textField.text = @"";
            cell.textField.keyboardType = UIKeyboardTypeEmailAddress;
            return cell;
        }
        RegisterFinishCell *cell = [tableView dequeueReusableCellWithIdentifier:@"registerFinishCell"];
        cell.agreeBtn.hidden = YES;
        cell.protolBtn.hidden = YES;
        [cell.nextBtn setTitle:@"提交" forState:UIControlStateNormal];
        cell.block = ^(NSInteger tag) {
            [self finishEmainClick];
        };
        return cell;
    }
    if (indexPath.row == 0) {
        RegisterImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"registerImageCell"];
        cell.textField.secureTextEntry = NO;
        cell.headImageView.image = [UIImage imageNamed:@"手机"];
        cell.textField.placeholder = @"请输入昵称";
        cell.textField.text = @"";
        cell.textField.keyboardType = UIKeyboardTypeDefault;
        return cell;
    }
    RegisterFinishCell *cell = [tableView dequeueReusableCellWithIdentifier:@"registerFinishCell"];
    cell.agreeBtn.hidden = YES;
    cell.protolBtn.hidden = YES;
    [cell.nextBtn setTitle:@"提交" forState:UIControlStateNormal];
    cell.block = ^(NSInteger tag) {
        [self finishEmainClick];
    };
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 2 && _currTag == 1) return 100;
    if (indexPath.row == 1 && _currTag != 1) return 100;
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (void)getCodeBtnClick:(UIButton *)sender {
    
    RegisterBtnCell *phoneCell = [self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if (![self isMobileNumberClassification:phoneCell.textField.text]) {
        [MBProgressHUD showError:@"请输入正确的手机号" toView:nil];
        return;
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
    setDickeyobj(infoDic, phoneCell.textField.text, @"mobile");
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    
    setDickeyobj(param, infoDic, @"reqBody");
    [CKHttpCommunicate createRequest:HTTP_USER_API WithParam:param withMethod:POST success:^(id result) {
        
        if (SUCCESS_REQUEST(result)) {
            [MBProgressHUD showError:@"已发送验证码至您的手机" toView:nil];
            _codeStr = result[@"data"][@"code"];
        }else{
            [MBProgressHUD showError:result[@"msg"] toView:nil];
        }
        
    } failure:^(NSError *erro) {
        NSLog(@"%@",erro);
    } showHUD:nil];
   
}

- (void)finishEmainClick{
    
    RegisterImageCell *phoneCell = [self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    if (!phoneCell.textField.text.length){
        [MBProgressHUD showError:@"请输入邮箱／昵称" toView:nil];
        return;
    }
    NSMutableDictionary * infoDic = [[NSMutableDictionary alloc]init];
    setDickeyobj(infoDic, @"findpwd", @"api");
    setDickeyobj(infoDic, phoneCell.textField.text, @"username");
    
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    setDickeyobj(param, infoDic, @"reqBody");
    self.view.userInteractionEnabled = NO;
    [CKHttpCommunicate createRequest:HTTP_USER_API WithParam:param withMethod:POST success:^(id result) {
        
        if (SUCCESS_REQUEST(result)) {
            
            [MBProgressHUD showError:@"已发送验证邮件，请到邮箱查看" toView:self.view];
            [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.5f];
            
        }else {
            self.view.userInteractionEnabled = YES;
            [MBProgressHUD showError:result[@"msg"] toView:nil];
        }
        
    } failure:^(NSError *erro) {
        self.view.userInteractionEnabled = YES;
        NSLog(@"%@",erro);
    } showHUD:nil];

}

- (void)delayMethod {
    self.view.userInteractionEnabled = YES;
    LoginViewController *controller  = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"loginViewController"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)finishBtnClick {
    
    RegisterImageCell *phoneCell = [self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    RegisterBtnCell *codeCell = [self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    if (![self isMobileNumberClassification:phoneCell.textField.text]) {
        [MBProgressHUD showError:@"请输入正确的手机号" toView:nil];
        return;
    }
    NSString *codeText = codeCell.textField.text;
    if ([codeText integerValue] != [_codeStr integerValue]) {
        [MBProgressHUD showError:@"请输入正确的验证码" toView:nil];
        return;
    }
    
    ForgetPwdViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"forgetPwdViewController"];
    controller.phone = phoneCell.textField.text;
    controller.code = codeCell.textField.text;
    [self.navigationController pushViewController:controller animated:YES];

}

-(BOOL)isValidateEmail:(NSString *)email{
    
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
