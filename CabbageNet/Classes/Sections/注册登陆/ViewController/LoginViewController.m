//
//  LoginViewController.m
//  CabbageNet
//
//  Created by MacAir on 2017/4/6.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "ForgetViewController.h"
#import "BaseTabBarController.h"
#import <UMSocialCore/UMSocialCore.h>
#import "AddUserInfoViewController.h"
#import "DiscountPrise.h"
// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用idfa功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>
#import "SignModel.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _phoneField.placeholder = @"请输入用户名／邮箱／手机号";
    self.loginBtn.layer.cornerRadius = 5;
    self.loginBtn.layer.masksToBounds = YES;
    self.loginBtn.backgroundColor = mAppMainColor;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    if (self.Block) {
        self.Block();
    }
}

- (IBAction)loginBtnClick {
    
    NSMutableDictionary * infoDic = [[NSMutableDictionary alloc]init];
//    setDickeyobj(infoDic, @"login", @"api");
    setDickeyobj(infoDic, @"mobilelogin", @"api");
    setDickeyobj(infoDic, self.phoneField.text, @"mobile");
    setDickeyobj(infoDic, self.pwdField.text, @"password");
    
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    setDickeyobj(param, infoDic, @"reqBody");
    
    [CKHttpCommunicate createRequest:HTTP_USER_API WithParam:param withMethod:POST success:^(id result) {
        
        if (SUCCESS_REQUEST(result)) {
            
            UserInfoModel *model = [[UserInfoModel alloc] init];
            [model mj_setKeyValues:result[@"data"]];
            [UserInfoModel storeUserWithModel:model];
            
            [self requestData];
            
            UserDefaultsSynchronize(@"10001", @"login");
            [self.view endEditing:YES];
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
            
        }else {
            [MBProgressHUD showError:result[@"data"] toView:nil];
        }
        
    } failure:^(NSError *erro) {
        NSLog(@"%@",erro);
    } showHUD:nil];
    
    
}

- (IBAction)registerBtnClick {
    
    RegisterViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"registerViewController"];
    [self.navigationController pushViewController:controller animated:YES];
    
}

- (IBAction)forgetBtnClick {
    
    ForgetViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"forgetViewController"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)qqLogin {
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_QQ currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
        } else {
            UMSocialUserInfoResponse *resp = result;
            
            NSMutableDictionary * infoDic = [[NSMutableDictionary alloc]init];
            setDickeyobj(infoDic, @"checkbind", @"api");
            setDickeyobj(infoDic, @"qq", @"type");
            setDickeyobj(infoDic, resp.unionId, @"keyid");
            
            NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
            setDickeyobj(param, infoDic, @"reqBody");
            
            [CKHttpCommunicate createRequest:HTTP_USER_API WithParam:param withMethod:POST success:^(id result) {

                if (SUCCESS_REQUEST(result)) {
                    id resultdata = result[@"data"];
                    if ([[resultdata class] isSubclassOfClass:[NSDictionary class]]) {
                        UserInfoModel *model = [[UserInfoModel alloc] init];
                        [model mj_setKeyValues:result[@"data"]];
                        [UserInfoModel storeUserWithModel:model];
                        
                        UserDefaultsSynchronize(@"10001", @"login");
                        [self requestData];
                        [self.view endEditing:YES];
                        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
                    }else{
                        AddUserInfoViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"addUserInfoViewController"];
                        controller.type = @"qq";
                        controller.keyid = resp.openid;
                        controller.info = resp.accessToken;
                        [self.navigationController pushViewController:controller animated:YES];
                    }
                }else {
                    [MBProgressHUD showError:result[@"msg"] toView:nil];
                }
                
            } failure:^(NSError *erro) {
                NSLog(@"%@",erro);
            } showHUD:nil];
        }
    }];
}

- (IBAction)weixinLogin {
    
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            NSLog(@"----%@",error);
        } else {
            UMSocialUserInfoResponse *resp = result;
        
            NSMutableDictionary * infoDic = [[NSMutableDictionary alloc]init];
            setDickeyobj(infoDic, @"checkbind", @"api");
            setDickeyobj(infoDic, @"wechat", @"type");
            setDickeyobj(infoDic, resp.unionId, @"keyid");
            
            NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
            setDickeyobj(param, infoDic, @"reqBody");
            
            [CKHttpCommunicate createRequest:HTTP_USER_API WithParam:param withMethod:POST success:^(id result) {
                
                if (SUCCESS_REQUEST(result)) {
                    id resultdata = result[@"data"];
                    if ([[resultdata class] isSubclassOfClass:[NSDictionary class]]) {
                        UserInfoModel *model = [[UserInfoModel alloc] init];
                        [model mj_setKeyValues:result[@"data"]];
                        [UserInfoModel storeUserWithModel:model];
                        
                        UserDefaultsSynchronize(@"10001", @"login");
                        [self requestData];
                        [self.view endEditing:YES];
                        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
                    }else{
                        AddUserInfoViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"addUserInfoViewController"];
                        controller.type = @"wechat";
                        controller.keyid = resp.openid;
                        controller.info = resp.accessToken;
                        [self.navigationController pushViewController:controller animated:YES];
                        

                    }
                    
                }else {
                    [MBProgressHUD showError:result[@"msg"] toView:nil];
                }
                
            } failure:^(NSError *erro) {
                NSLog(@"%@",erro);
            } showHUD:nil];
        }
    }];
}

- (IBAction)weiboLogin{
    
    
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_Sina currentViewController:self completion:^(id result, NSError *error) {
        if (error) {
            NSLog(@"----%@",error);
        } else {
            UMSocialUserInfoResponse *resp = result;

            // 授权信息
            NSLog(@"Sina uid: %@", resp.uid);
            NSLog(@"Sina accessToken: %@", resp.accessToken);
            NSLog(@"Sina refreshToken: %@", resp.refreshToken);
            NSLog(@"Sina expiration: %@", resp.expiration);
            
            // 用户信息
            NSLog(@"Sina name: %@", resp.name);
            NSLog(@"Sina iconurl: %@", resp.iconurl);
            NSLog(@"Sina gender: %@", resp.unionGender);
            
            // 第三方平台SDK源数据
            NSLog(@"Sina originalResponse: %@", resp.originalResponse);
            
            NSMutableDictionary * infoDic = [[NSMutableDictionary alloc]init];
            setDickeyobj(infoDic, @"checkbind", @"api");
            setDickeyobj(infoDic, @"sina", @"type");
            setDickeyobj(infoDic, resp.uid, @"keyid");
            
            NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
            setDickeyobj(param, infoDic, @"reqBody");
            
            [CKHttpCommunicate createRequest:HTTP_USER_API WithParam:param withMethod:POST success:^(id result) {
                
                if (SUCCESS_REQUEST(result)) {
                    id resultdata = result[@"data"];
                    if ([[resultdata class] isSubclassOfClass:[NSDictionary class]]) {
                        UserInfoModel *model = [[UserInfoModel alloc] init];
                        [model mj_setKeyValues:result[@"data"]];
                        [UserInfoModel storeUserWithModel:model];
                        
                        UserDefaultsSynchronize(@"10001", @"login");
                        [self requestData];
                        [self.view endEditing:YES];
                        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
                    }else{
                        AddUserInfoViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"addUserInfoViewController"];
                        controller.type = @"sina";
                        controller.keyid = resp.openid;
                        controller.info = resp.accessToken;
                        [self.navigationController pushViewController:controller animated:YES];

                    }
                    
                }else {
                    [MBProgressHUD showError:result[@"msg"] toView:nil];
                }
        
            } failure:^(NSError *erro) {
                NSLog(@"%@",erro);
            } showHUD:nil];
        }
    }];
}

#pragma mark -- 请求关注列表
- (void)requestData{
    
    NSMutableDictionary * infoDic = [[NSMutableDictionary alloc]init];
    setDickeyobj(infoDic, @"notify_tag_byuser", @"api");
    UserInfoModel *model = [UserInfoModel sharedUserData];
    setDickeyobj(infoDic, model.userid, @"userid");
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    setDickeyobj(param, infoDic, @"reqBody");
    [CKHttpCommunicate createRequest:HTTP_USER_API WithParam:param withMethod:POST success:^(id result) {
//        UserInfoModel *userInfo = [UserInfoModel sharedUserData];
        if (SUCCESS_REQUEST(result)) {
//            NSArray *array = result[@"data"];
            
//            BOOL haveUser = NO;
//            for (NSString *user in [DiscountPrise selectedUser]) {
//                if ([user isEqualToString:userInfo.userid]) {
//                    haveUser = YES;
//                    break;
//                }
//            }
//            if (!array.count && !haveUser) {
//                [DiscountPrise insertUser:userInfo.userid];
//                NSArray *pushArr = @[@"白菜",@"BUG",@"手快有",@"神价格"];
//                for (NSString *string in pushArr) {
//                    [self requestPush:string];
//                }
//            }else{
                NSMutableArray *pushArr = [NSMutableArray array];
                for (NSDictionary *dic in result[@"data"]) {
                    SignModel *model = [[SignModel alloc] init];
                    [model mj_setKeyValues:dic];
                    model.signID = dic[@"id"];
                    [pushArr addObject:model];
                }
                [self getPushTime:pushArr];
//            }
        }else{
//            BOOL haveUser = NO;
//            for (NSString *user in [DiscountPrise selectedUser]) {
//                if ([user isEqualToString:userInfo.userid]) {
//                    haveUser = YES;
//                    break;
//                }
//            }
//            if (!haveUser) {
//                [DiscountPrise insertUser:userInfo.userid];
//                NSArray *pushArr = @[@"白菜",@"BUG",@"手快有",@"神价格"];
//                for (NSString *string in pushArr) {
//                    [self requestPush:string];
//                }
//            }
        }
    } failure:^(NSError *erro) {
        NSLog(@"%@",erro);
    } showHUD:nil];
}

//#pragma mark -- 添加关闭推送
//- (void)requestPush:(NSString *)string{
//    
//    NSMutableDictionary * infoDic = [[NSMutableDictionary alloc]init];
//    setDickeyobj(infoDic, @"notify_tag_create", @"api");
//    setDickeyobj(infoDic, string , @"tag");
//    UserInfoModel *model = [UserInfoModel sharedUserData];
//    setDickeyobj(infoDic, model.userid, @"userid");
//    
//    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
//    setDickeyobj(param, infoDic, @"reqBody");
//    [CKHttpCommunicate createRequest:HTTP_USER_API WithParam:param withMethod:POST success:^(id result) {
//        if (SUCCESS_REQUEST(result)) {
//            [JPUSHService addTags:[NSSet setWithObject:string] completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
//            } seq:1];
//        }
//    } failure:^(NSError *erro) {
//        NSLog(@"%@",erro);
//    } showHUD:nil];
//}

#pragma mark -- 请求安静时间段设置
- (void)getPushTime:(NSArray *)pushArr{
    NSMutableDictionary * infoDic = [[NSMutableDictionary alloc]init];
    setDickeyobj(infoDic, @"push_range_byuser", @"api");
    UserInfoModel *model = [UserInfoModel sharedUserData];
    setDickeyobj(infoDic, model.userid, @"userid");
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    setDickeyobj(param, infoDic, @"reqBody");
    [MBProgressHUD showMessag:@"加载中..." toView:self.view];
    [CKHttpCommunicate createRequest:HTTP_USER_API WithParam:param withMethod:POST success:^(id result) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (SUCCESS_REQUEST(result)) {
            NSArray *array = result[@"data"];
            NSDictionary *dic = array.firstObject;
            NSString *pushTime = dic[@"push_range"];
            NSArray *timeArray = [pushTime componentsSeparatedByString:@","];
            if (timeArray.count == 2){
//                cell.nameLabel.text = [NSString stringWithFormat:@"从%@点到%@点",array[0],array[1]];
                [self clearAndAddTag:[timeArray[0] integerValue] and:[timeArray[1] integerValue] andPushArr:pushArr];
            }else{
//                cell.nameLabel.text = @"从0点到7点";
            }
        }else
            [MBProgressHUD showError:result[@"msg"] toView:nil];
        
    } failure:^(NSError *erro) {
        NSLog(@"%@", erro);
    } showHUD:nil];
}

- (void)clearAndAddTag:(NSInteger)slientMin and:(NSInteger)slientMax andPushArr:(NSArray *)pushArr{
    [MBProgressHUD showMessag:@"加载中..." toView:self.view];
    NSLog(@"%ld---%ld",slientMin,slientMax);
    if ([UserDefaultsGetSynchronize(@"openjpush") isEqualToString:@"9999"]) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        return;
    }
    NSMutableSet *pushSet = [NSMutableSet set];
    for (SignModel *model in pushArr) {
        if (model.p_sign) {
            for (int i = 0; i < 24; i ++) {
                NSString *newTag = model.tag;
                if ([UserDefaultsGetSynchronize(@"opensettime") isEqualToString:@"10001"]){
                    if (i < slientMin || i >= slientMax) {
                        if ([UserDefaultsGetSynchronize(@"opensound") isEqualToString:@"9999"]){
                            newTag = [NSString stringWithFormat:@"%@_slient_%d",newTag,i];
                        }else{
                            newTag = [NSString stringWithFormat:@"%@_%d",newTag,i];
                        }
                    }else{
                        newTag = @"";
                    }
                }else{
                    if ([UserDefaultsGetSynchronize(@"opensound") isEqualToString:@"9999"]){
                        newTag = [NSString stringWithFormat:@"%@_slient_%d",newTag,i];
                        
                    }else{
                        
                    }
                }
                if (newTag.length) {
                    newTag = [[newTag stringByReplacingOccurrencesOfString:@" " withString:@"|"] stringByReplacingOccurrencesOfString:@"-" withString:@"|"];
                    [pushSet addObject:newTag];
                }
            }
        }
    }
    
    [JPUSHService setTags:pushSet completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
        NSLog(@"%ld--%@--%ld",iResCode,iTags,seq);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } seq:1];
    for (NSString *string in pushSet) {
        NSLog(@"%@",string);
    }
    NSLog(@"%ld",pushSet.count);
}


@end
