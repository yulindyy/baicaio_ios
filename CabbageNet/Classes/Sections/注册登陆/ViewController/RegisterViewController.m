//
//  RegisterViewController.m
//  CabbageNet
//
//  Created by MacAir on 2017/4/6.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import "RegisterViewController.h"
#import "TopBtnView.h"
#import "RegisterBtnCell.h"
#import "RegisterImageCell.h"
#import "RegisterFinishCell.h"
#import "PhoneRegisterNextViewController.h"

@interface RegisterViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)TopBtnView *topBtnView;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation RegisterViewController{
    NSInteger _timernum;
    NSTimer *_timer;
    NSInteger _currTag;
    NSString *_phoneNum;
    NSString *_codeNum;
}

- (TopBtnView *)topBtnView{
    if (!_topBtnView) {
        _topBtnView = [[TopBtnView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, 44) titleBtnArr:@[@"手机注册",@"普通注册"]];
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
    return 5;
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
            cell.agreeBtn.selected = YES;
            [cell.nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
            cell.block = ^(NSInteger tag) {
                if (tag == 1) {
                    RegisterImageCell *phoneCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                    if (!phoneCell.textField.text.length || ![phoneCell.textField.text isEqualToString:_phoneNum]){
                        [MBProgressHUD showError:@"请核对手机号！" toView:nil];
                        return ;
                    }
                    RegisterBtnCell *codeCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
                    NSString *codeStr = codeCell.textField.text;
                    if (codeStr.length != 6 || [codeStr integerValue] != [_codeNum integerValue]) {
                        
                        [MBProgressHUD showError:@"请核对验证码！" toView:nil];
                        return;
                    }
                    
                    PhoneRegisterNextViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"phoneRegisterNextViewController"];
                    controller.phone = _phoneNum;
                    controller.code = _codeNum;
                    [self.navigationController pushViewController:controller animated:YES];
                }else{
                    
                }
            };
            return cell;
        }
    }
    
    if (indexPath.row == 0) {
        
        RegisterImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"registerImageCell"];
        cell.textField.secureTextEntry = NO;
        cell.headImageView.image = [UIImage imageNamed:@"手机"];
        cell.textField.placeholder = @"请输入昵称";
        cell.textField.text = @"";
        cell.textField.keyboardType = UIKeyboardTypeDefault;
        return cell;
    }else if (indexPath.row == 1){
        
        RegisterImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"registerImageCell"];
        cell.headImageView.image = [UIImage imageNamed:@"验证码"];
        cell.textField.placeholder = @"请输入邮箱";
        cell.textField.keyboardType = UIKeyboardTypeEmailAddress;
        cell.textField.secureTextEntry = NO;
        return cell;
        
    }else if (indexPath.row == 2){
        RegisterImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"registerImageCell"];
        cell.headImageView.image = [UIImage imageNamed:@"密码"];
        cell.textField.placeholder = @"请输入密码";
        cell.textField.secureTextEntry = YES;
        return cell;
    }else if (indexPath.row == 3){
        RegisterImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"registerImageCell"];
        cell.headImageView.image = [UIImage imageNamed:@"密码"];
        cell.textField.placeholder = @"请再次输入密码";
        cell.textField.secureTextEntry = YES;
        return cell;
    }
    RegisterFinishCell *cell = [tableView dequeueReusableCellWithIdentifier:@"registerFinishCell"];
    cell.agreeBtn.selected = YES;
    cell.block = ^(NSInteger tag) {
        if (tag == 1) {
            [self registBtnClick];
        }else{
            
        }
    };
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 2 && _currTag == 1) return 100;
    if (indexPath.row == 3) return 100;
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}


- (void)getCodeBtnClick:(UIButton *)sender {
    
    RegisterImageCell *cell = [self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if (![self isMobileNumberClassification:cell.textField.text]) {
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
    setDickeyobj(infoDic, cell.textField.text, @"mobile");
    setDickeyobj(infoDic, @"register", @"type")
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    setDickeyobj(param, infoDic, @"reqBody");
    
    _phoneNum = cell.textField.text;
    _codeNum = @"";
    [CKHttpCommunicate createRequest:HTTP_USER_API WithParam:param withMethod:POST success:^(id result) {

        if (SUCCESS_REQUEST(result)) {
            [MBProgressHUD showError:@"验证码已发送至您的手机" toView:nil];
            _codeNum = result[@"data"][@"code"];
        }else {
            [MBProgressHUD showError:result[@"msg"] toView:nil];
        }
        
    } failure:^(NSError *erro) {
        NSLog(@"%@",erro);
    } showHUD:nil];
    
    
}


- (void)registBtnClick {
    
    RegisterFinishCell *fourCell = [self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    if (!fourCell.agreeBtn.selected) {
        [MBProgressHUD showError:@"请阅读白菜网平台协议！" toView:nil];
        return;
    }
    
    NSMutableDictionary * infoDic = [[NSMutableDictionary alloc]init];
    
    RegisterImageCell *oneCell = [self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if (!oneCell.textField.text.length) {
        if (_currTag == 1 || ![self isMobileNumberClassification:oneCell.textField.text]) [MBProgressHUD showError:@"请输入正确的手机号" toView:nil];
        else [MBProgressHUD showError:@"请输入昵称" toView:nil];
        return;
    }
    if (_currTag == 1){
        RegisterBtnCell *twoCell = [self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        setDickeyobj(infoDic, twoCell.textField.text, @"captcha");
        if (!twoCell.textField.text.length) {
            [MBProgressHUD showError:@"请输入验证码" toView:nil];
            return;
        }
    }else{
        RegisterImageCell *twoCell = [self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        setDickeyobj(infoDic, twoCell.textField.text, @"email");
        if (![self isValidateEmail: twoCell.textField.text]) {
            [MBProgressHUD showError:@"请输入正确的邮箱号" toView:nil];
            return;
        }
    }
    
    RegisterImageCell *threeCell = [self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    RegisterImageCell *fiveCell = [self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    if (![threeCell.textField.text isEqualToString:fiveCell.textField.text]){
        [MBProgressHUD showError:@"请核对密码" toView:nil];
        return;
    }
    if (!threeCell.textField.text.length ) {
        [MBProgressHUD showError:@"请输入密码" toView:nil];
        return;
    }
    
    
    if (_currTag == 1) {
        setDickeyobj(infoDic, @"register", @"api");
        setDickeyobj(infoDic, oneCell.textField.text, @"mobile");
        setDickeyobj(infoDic, threeCell.textField.text, @"password");
    }else{
        setDickeyobj(infoDic, @"register_open", @"api");
        setDickeyobj(infoDic, oneCell.textField.text, @"username");
        setDickeyobj(infoDic, threeCell.textField.text, @"password");
        setDickeyobj(infoDic, @"0", @"gender");

    }

    
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    setDickeyobj(param, infoDic, @"reqBody");
    [CKHttpCommunicate createRequest:HTTP_USER_API WithParam:param withMethod:POST success:^(id result) {
        
        if (SUCCESS_REQUEST(result)) {
            [MBProgressHUD showError:@"重置信息已经发送至您的邮箱" toView:nil];
            [self bindEmail];
        }else {
            [MBProgressHUD showError:result[@"msg"] toView:nil];
        }
        
    } failure:^(NSError *erro) {
        NSLog(@"%@",erro);
    } showHUD:nil];
    
}

#pragma mark -- 绑定邮箱
- (void)bindEmail{
    
    NSMutableDictionary * infoDic = [[NSMutableDictionary alloc]init];
    setDickeyobj(infoDic, @"bindinfo", @"api")
    UserInfoModel *model = [UserInfoModel sharedUserData];
    setDickeyobj(infoDic, model.userid, @"userid")
    RegisterImageCell *twoCell = [self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    setDickeyobj(infoDic, twoCell.textField.text, @"email");
    
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    setDickeyobj(param, infoDic, @"reqBody");
    
    [CKHttpCommunicate createRequest:HTTP_USER_API WithParam:param withMethod:POST success:^(id result) {
        
        if (SUCCESS_REQUEST(result)) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            
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
