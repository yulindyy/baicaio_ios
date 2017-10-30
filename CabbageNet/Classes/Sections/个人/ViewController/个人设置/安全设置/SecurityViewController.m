//
//  SecurityViewController.m
//  CabbageNet
//
//  Created by MacAir on 2017/4/6.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import "SecurityViewController.h"
#import "SecurityCell.h"
#import "ChangePWDViewController.h"
#import "VerificationViewController.h"
#import "VerificationSuccessViewController.h"
#import "BindCompleteViewController.h"
#import <UMSocialCore/UMSocialCore.h>
#import "SecurityModel.h"

@interface SecurityViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic , strong)NSMutableArray *dataArr;

@end

@implementation SecurityViewController

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self requestData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


- (void)requestData{
    NSMutableDictionary * infoDic = [[NSMutableDictionary alloc]init];
    setDickeyobj(infoDic, @"getbind", @"api");
    UserInfoModel *model = [UserInfoModel sharedUserData];
    setDickeyobj(infoDic, model.userid, @"userid");
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    setDickeyobj(param, infoDic, @"reqBody");
    
    [CKHttpCommunicate createRequest:HTTP_USER_API WithParam:param withMethod:POST success:^(id result) {
        [self.dataArr removeAllObjects];
        if (SUCCESS_REQUEST(result)) {
            
            
            for (NSDictionary *dic in result[@"data"]) {
                SecurityModel *model = [[SecurityModel alloc] init];
                [model mj_setKeyValues:dic];
                [self.dataArr addObject:model];
                
            }
            
        }
        else{
            
//            [MBProgressHUD showError:result[@"msg"] toView:nil];
        }
        [self.myTableView reloadData];
    } failure:^(NSError *erro) {
        NSLog(@"%@", erro);
    } showHUD:nil];
}

#pragma mark - tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) return 2;
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SecurityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"securityCell"];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.titleLabel.text = @"绑定微信帐号";
            cell.infoLabel.text = @"未绑定";
            for (SecurityModel *model in self.dataArr) {
                if ([model.type isEqualToString:@"wechat"]) {
                    cell.infoLabel.text = @"已绑定";
                    break;
                }
            }
            
        }else if (indexPath.row == 1){
            cell.titleLabel.text = @"绑定QQ帐号";
            cell.infoLabel.text = @"未绑定";
            for (SecurityModel *model in self.dataArr) {
                if ([model.type isEqualToString:@"qq"]) {
                    cell.infoLabel.text = @"已绑定";
                    break;
                }
            }
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            cell.titleLabel.text = @"修改登录密码";
            cell.infoLabel.text = @"";
        }else if (indexPath.row == 1){
            UserInfoModel *model = [UserInfoModel sharedUserData];
            cell.titleLabel.text = @"邮箱验证";
            if ([self isValidateEmail:model.email]) cell.infoLabel.text = model.email;
            else cell.infoLabel.text = @"未验证";
        }else if (indexPath.row == 2){
            UserInfoModel *model = [UserInfoModel sharedUserData];
            cell.titleLabel.text = @"手机验证";
            if (model.mobile.length) cell.infoLabel.text = model.mobile;
            else cell.infoLabel.text = @"未验证";
        }
        
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
       
        if (indexPath.row == 0) {
            for (SecurityModel *model in self.dataArr) {
                if ([model.type isEqualToString:@"wechat"]) {
                    BindCompleteViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"bindCompleteViewController"];
                    controller.classtype = WECHAT_TYPE;
                    [self.navigationController pushViewController:controller animated:YES];
                    return;
                }
            }
            [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:nil completion:^(id result, NSError *error) {
                if (error) {
                    return ;
                } else {
                    UMSocialUserInfoResponse *resp = result;

                    NSMutableDictionary * infoDic = [[NSMutableDictionary alloc]init];
                    setDickeyobj(infoDic, @"bind", @"api");
                    UserInfoModel *model = [UserInfoModel sharedUserData];
                    setDickeyobj(infoDic, model.userid, @"userid");
                    setDickeyobj(infoDic, @"wechat", @"type");
                    setDickeyobj(infoDic, resp.unionId, @"keyid");
                    setDickeyobj(infoDic, resp.accessToken, @"info");
                    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
                    setDickeyobj(param, infoDic, @"reqBody");
                    [CKHttpCommunicate createRequest:HTTP_USER_API WithParam:param withMethod:POST success:^(id result) {
                        
                        if (SUCCESS_REQUEST(result)) {
//                            BindCompleteViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"bindCompleteViewController"];
//                            controller.classtype = WECHAT_TYPE;
//                            [self.navigationController pushViewController:controller animated:YES];
                            [self requestData];
                            [MBProgressHUD showError:@"绑定成功。" toView:nil];
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
            }];

        }else if (indexPath.row == 1){
            for (SecurityModel *model in self.dataArr) {
                if ([model.type isEqualToString:@"qq"]) {
                    BindCompleteViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"bindCompleteViewController"];
                    controller.classtype = QQ_TYPE;
                    [self.navigationController pushViewController:controller animated:YES];
                    return;
                }
            }
            [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_QQ currentViewController:nil completion:^(id result, NSError *error) {
                if (error) {
                    return ;
                } else {
                    UMSocialUserInfoResponse *resp = result;

                    NSMutableDictionary * infoDic = [[NSMutableDictionary alloc]init];
                    setDickeyobj(infoDic, @"bind", @"api");
                    UserInfoModel *model = [UserInfoModel sharedUserData];
                    setDickeyobj(infoDic, model.userid, @"userid");
                    setDickeyobj(infoDic, @"qq", @"type");
                    setDickeyobj(infoDic, resp.unionId, @"keyid");
                    setDickeyobj(infoDic, resp.accessToken, @"info");
                    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
                    setDickeyobj(param, infoDic, @"reqBody");
                    [CKHttpCommunicate createRequest:HTTP_USER_API WithParam:param withMethod:POST success:^(id result) {
                        
                        if (SUCCESS_REQUEST(result)) {
//                            BindCompleteViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"bindCompleteViewController"];
//                            controller.classtype = QQ_TYPE;
//                            [self.navigationController pushViewController:controller animated:YES];
                            [self requestData];
                            [MBProgressHUD showError:@"绑定成功。" toView:nil];
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
            }];
            
        }
        
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            
            ChangePWDViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"changePWDViewController"];
            controller.title = @"修改密码";
            [self.navigationController pushViewController:controller animated:YES];
            
        }else if (indexPath.row == 1){
            UserInfoModel *model = [UserInfoModel sharedUserData];
            if ([self isValidateEmail:model.email]) {
                VerificationSuccessViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"verificationSuccessViewController"];
                controller.tag = 2;
                [self.navigationController pushViewController:controller animated:YES];
            }else{
                VerificationViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"verificationViewController"];
                controller.title = @"邮箱验证";
                [self.navigationController pushViewController:controller animated:YES];
            }
            
            
        }else if (indexPath.row == 2){
            UserInfoModel *model = [UserInfoModel sharedUserData];
            if (model.mobile.length) {
                VerificationSuccessViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"verificationSuccessViewController"];
                controller.tag = 1;
                [self.navigationController pushViewController:controller animated:YES];
            }else {
                VerificationViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"verificationViewController"];
                controller.title = @"手机验证";
                [self.navigationController pushViewController:controller animated:YES];
            }
        }
    }
}

-(BOOL)isValidateEmail:(NSString *)email

{
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailRegex];
    
    return [emailTest evaluateWithObject:email];
    
}


@end
