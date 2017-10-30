//
//  EditAddressViewController.m
//  CabbageNet
//
//  Created by MacAir on 2017/4/6.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import "EditAddressViewController.h"
#import "EditConsigneeCell.h"
#import "EditAddressCell.h"
#import "EditDetailAddressCell.h"
#import "EditDefaultCell.h"

@interface EditAddressViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UserInfoModel *model;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation EditAddressViewController

- (UserInfoModel *)model{
    
    return [UserInfoModel sharedUserData];
}

- (void)setAddressModel:(AddressModel *)addressModel{
    
    _addressModel = addressModel;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnClick)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
}

//保存
- (void)rightBtnClick{
    
    [self.view endEditing:YES];
    
    NSMutableDictionary * infoDic = [[NSMutableDictionary alloc]init];
    setDickeyobj(infoDic, @"setaddress", @"api");
    setDickeyobj(infoDic, self.model.userid, @"userid");
    
    NSIndexPath *consigneePath = [NSIndexPath indexPathForRow:0 inSection:0];
    EditConsigneeCell *consigneeCell = [self.myTableView cellForRowAtIndexPath:consigneePath];
    
    NSIndexPath *mobilePath = [NSIndexPath indexPathForRow:1 inSection:0];
    EditConsigneeCell *mobileCell = [self.myTableView cellForRowAtIndexPath:mobilePath];
    
    NSIndexPath *zipPath = [NSIndexPath indexPathForRow:2 inSection:0];
    EditConsigneeCell *zipCell = [self.myTableView cellForRowAtIndexPath:zipPath];
    
    NSIndexPath *addressPath = [NSIndexPath indexPathForRow:3 inSection:0];
    EditDetailAddressCell *addressCell = [self.myTableView cellForRowAtIndexPath:addressPath];
    
    if ([self.title isEqualToString:@"添加新地址"]) {

        setDickeyobj(infoDic, @"add", @"type");
        setDickeyobj(infoDic, @"0", @"addressid");
        
    }else{
        setDickeyobj(infoDic, @"edit", @"type");
        setDickeyobj(infoDic, _addressModel.addressid, @"addressid");
        
    }
    if (consigneeCell.contentTF.text.length){
        
        setDickeyobj(infoDic, consigneeCell.contentTF.text, @"consignee");
    }else{
        [MBProgressHUD showError:@"请输入收货人" toView:nil];
        return;
    }
    if (mobileCell.contentTF.text.length) {
        if ([self isMobileNumberClassification:mobileCell.contentTF.text]) {
            setDickeyobj(infoDic, mobileCell.contentTF.text, @"mobile");
        }else{
            [MBProgressHUD showError:@"请输入正确的手机号码" toView:nil];
            return;
        }
    }else {
        [MBProgressHUD showError:@"请输入手机号码" toView:nil];
        return;
    }
    if (zipCell.contentTF.text.length) {//邮编
        if ([self isValidPostalcode:zipCell.contentTF.text]) {
            setDickeyobj(infoDic, zipCell.contentTF.text, @"zip");
        }else{
            [MBProgressHUD showError:@"请输入正确的邮编" toView:nil];
            return;
        }
    }else {
        [MBProgressHUD showError:@"请输入邮编" toView:nil];
        return;
    }
    
    
    if (addressCell.addressTextView.text.length){
        setDickeyobj(infoDic, addressCell.addressTextView.text, @"address");
    }else{
        [MBProgressHUD showError:@"请输入地址信息" toView:nil];
        return;
    }
    
    
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    setDickeyobj(param, infoDic, @"reqBody");
    
    [CKHttpCommunicate createRequest:HTTP_USER_API WithParam:param withMethod:POST success:^(id result) {
        
        if (SUCCESS_REQUEST(result)) {
            [self.navigationController popViewControllerAnimated:YES];
            [MBProgressHUD showError:result[@"data"] toView:nil];
        } else {
            [MBProgressHUD showError:result[@"msg"] toView:nil];
        }
        
    } failure:^(NSError *erro) {
        NSLog(@"%@", erro);
    } showHUD:nil];
    
    
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

//是否邮政编码
- (BOOL)isValidPostalcode:(NSString *)string {
    
    NSString *postalRegex = @"^[1-9][0-9]{5}$";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",postalRegex];
    
    return [emailTest evaluateWithObject:string];
    
}

#pragma mark --tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        EditConsigneeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"editConsigneeCell"];
        cell.titleLabel.text = @"收货人：";
        cell.backgroundColor = tableView.backgroundColor;
        if (_addressModel) {
            cell.contentTF.text = _addressModel.consignee;
        }
        return cell;
    }else if (indexPath.row == 1){
        EditConsigneeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"editConsigneeCell"];
        cell.titleLabel.text = @"联系电话：";
        cell.contentTF.keyboardType = UIKeyboardTypePhonePad;
        cell.backgroundColor = tableView.backgroundColor;
        if (_addressModel) {
            cell.contentTF.text = _addressModel.mobile;
        }
        return cell;
    }else if (indexPath.row == 2){
        EditConsigneeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"editConsigneeCell"];
        cell.titleLabel.text = @"邮编：";
        cell.contentTF.keyboardType = UIKeyboardTypeNumberPad;
        cell.backgroundColor = tableView.backgroundColor;
        if (_addressModel) {
            cell.contentTF.text = _addressModel.zip;
        }
        return cell;
    }else if (indexPath.row == 3){
        EditDetailAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"editDetailAddressCell"];
        cell.backgroundColor = tableView.backgroundColor;
        if (_addressModel) {
            cell.addressTextView.text = _addressModel.address;
        }
        return cell;
    }
    EditDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"editDefaultCell"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 3) return 125;
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
@end
