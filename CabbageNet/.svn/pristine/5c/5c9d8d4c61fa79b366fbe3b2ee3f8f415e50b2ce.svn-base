//
//  IntegralDetailViewController.m
//  CabbageNet
//
//  Created by xiang fu on 2017/6/8.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import "IntegralDetailViewController.h"
#import "IntegralDetailImageCell.h"
#import "IntegralDetailInfoCell.h"
#import "IntegralDetailBtnCell.h"
#import "TopBtnView.h"
#import "IntegralBottomView.h"
#import "IntegralDetailModel.h"
#import "AttributedStringCell.h"
#import "GoLinkWebViewController.h"
#import "AddressModel.h"
#import "EditAddressViewController.h"
#import "ExchangeAlertController.h"
#import "VerificationViewController.h"
#import "AlertBtnViewController.h"
#import "AddressViewController.h"


@interface IntegralDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *mytableView;
@property (nonatomic,strong)TopBtnView *topBtnView;
@property (nonatomic , strong)IntegralDetailModel *model;

@end

@implementation IntegralDetailViewController{
    NSInteger _currTag;
    CGFloat _webViewHeight;
    CGFloat _imageheight;
    AddressModel *_selectedAddress;
}

- (IntegralDetailModel *)model{
    if (!_model) {
        _model = [[IntegralDetailModel alloc] init];
    }
    return _model;
}

- (TopBtnView *)topBtnView{
    if (!_topBtnView) {
        _topBtnView = [[TopBtnView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, 44) titleBtnArr:@[@"兑换须知",@"兑换记录"]];
        __weak typeof(self)weakSelf = self;
        _topBtnView.block = ^(NSInteger tag){
            _currTag = tag;
            [weakSelf.mytableView reloadData];
        };
        [_topBtnView btnActionChange:1];
    }
    return _topBtnView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _webViewHeight = 0.01;
    _currTag = 1;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    
    IntegralBottomView *bottomView = [IntegralBottomView getIntegralBottomView];
    bottomView.frame = CGRectMake(0, mScreenHeight - 108, mScreenWidth, 44);
    [bottomView setBase];

    bottomView.block = ^(NSInteger num) {

        if (![UserInfoModel sharedUserData].mobile.length) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"兑换商品需要验证手机号。是否立即前往验证？" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                VerificationViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"verificationViewController"];
                controller.title = @"手机验证";
                controller.successPop = 1;
                [self.navigationController pushViewController:controller animated:YES];
            }];
            [alert addAction:cancle];
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
            
            return ;
        }
        
        if (self.superCurrTag == 1) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:self.model.title message:[NSString stringWithFormat:@"兑换此商品需要%ld金币%ld积分。是否立即兑换？",self.model.coin * num,self.model.score * num] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消兑换" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"立即兑换" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self requestExchange:self.model.modelId and:num andAddress:nil];
            }];
            [alert addAction:cancle];
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
            
        }else if (self.superCurrTag == 2){//实物兑换
            
            [self showAlert:nil and:num];
//            NSMutableDictionary * infoDic = [[NSMutableDictionary alloc]init];
//            setDickeyobj(infoDic, @"getaddress", @"api");
//            UserInfoModel *usermodel = [UserInfoModel sharedUserData];
//            setDickeyobj(infoDic, usermodel.userid, @"userid");
//            NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
//            setDickeyobj(param, infoDic, @"reqBody");
//            [CKHttpCommunicate createRequest:HTTP_USER_API WithParam:param withMethod:POST success:^(id result) {
//                
//                if (SUCCESS_REQUEST(result)) {
//                    NSMutableArray *dataArr = [NSMutableArray array];
//                    NSArray *arr = result[@"data"];
//                    if (arr  && ![arr isKindOfClass:[NSNull class]]) {
//                        for (int i = 0; i < arr.count; i++) {
//                            AddressModel *model = [[AddressModel alloc] init];
//                            [model mj_setKeyValues:arr[i]];
//                            model.userid = model.userid;
//                            model.addressid = arr[i][@"id"];
//                            [dataArr addObject:model];
//                            
//                        }
//                    }
//                    if (dataArr.count == 0) {//没有地址
//                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示！" message:@"兑换实物商品需要添加收货地址，是否立即前往添加？" preferredStyle:UIAlertControllerStyleAlert];
//                        UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//                        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"立即添加" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                            EditAddressViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"editAddressViewController"];
//                            controller.title = @"添加新地址";
//                            [self.navigationController pushViewController:controller animated:YES];
//                        }];
//                        [alert addAction:cancle];
//                        [alert addAction:ok];
//                        [self presentViewController:alert animated:YES completion:nil];
//                    }else {//有地址
//                        ExchangeAlertController *alert = [ExchangeAlertController alertPickerWithTitle:self.model.title Separator:[NSString stringWithFormat:@"兑换此商品需要%ld金币。是否立即兑换？",self.model.coin * num] SourceArr:dataArr];
//                        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确认兑换" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                            //                            NSLog(@"----------%ld",alert.currRow);
////                            [self requestExchange:model.Exchangeid andAddress:dataArr[alert.currRow]];
//                            [self requestExchange:self.model.modelId and:num andAddress:dataArr[alert.currRow]];
//                        }];
//                        [alert addCompletionAction:ok];
//                        [self presentViewController:alert animated:YES completion:nil];
//                    }
//                    
//                }
//                else{
//                    [MBProgressHUD showError:result[@"msg"] toView:nil];
//                }
//                //        NSLog(@"%@", result[@"msg"]);
//                
//            } failure:^(NSError *erro) {
//                NSLog(@"%@", erro);
//            } showHUD:nil];
        }
        
    };
    [self.view addSubview:bottomView];
    
    [self requestData];
}

- (void)showAlert:(AddressModel *)addressModel and:(NSInteger)num{
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确认兑换" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (_selectedAddress) {
            [self requestExchange:self.model.modelId and:num andAddress:addressModel];
        }else{
            [MBProgressHUD showError:@"您未选择收获地址" toView:nil];
        }
    }];
    
    if (addressModel) {
        
        AlertBtnViewController *alert = [AlertBtnViewController alertPickerWithTitle:self.model.title Separator:[NSString stringWithFormat:@"兑换此商品需要%ld金币。是否立即兑换？",self.model.coin * num] andAddress:[NSString stringWithFormat:@"%@-%@-%@-%@",addressModel.consignee,addressModel.mobile,addressModel.zip,addressModel.address]];
        __weak typeof(alert) weakAlert = alert;
        
        alert.block = ^{
            
            [weakAlert dismissViewControllerAnimated:YES completion:nil];
            AddressViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"addressViewController"];
            controller.tag = 1;
            
            controller.block = ^(AddressModel *selectedAddressModel) {
                _selectedAddress = selectedAddressModel;
                [self showAlert:selectedAddressModel and:num];
                
            };
            [self.navigationController pushViewController:controller animated:YES];
        };
        
        
        [alert addCompletionAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
        
    }else{
        
        AlertBtnViewController *alert = [AlertBtnViewController alertPickerWithTitle:self.model.title Separator:[NSString stringWithFormat:@"兑换此商品需要%ld金币。是否立即兑换？",self.model.coin] andAddress:nil];
        __weak typeof(alert) weakAlert = alert;
        
        alert.block = ^{
            
            [weakAlert dismissViewControllerAnimated:YES completion:nil];
            AddressViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"addressViewController"];
            controller.tag = 1;
            
            controller.block = ^(AddressModel *selectedAddressModel) {
                
                _selectedAddress = selectedAddressModel;
                [self showAlert:selectedAddressModel and:num];
                
            };
            [self.navigationController pushViewController:controller animated:YES];
        };
        
        
        [alert addCompletionAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }
}


- (void)requestExchange:(NSString *)goodsId and:(NSInteger)num andAddress:(AddressModel *)address{
    
    NSMutableDictionary * infoDic = [[NSMutableDictionary alloc]init];
    setDickeyobj(infoDic, @"ec", @"api");
    UserInfoModel *model = [UserInfoModel sharedUserData];
    setDickeyobj(infoDic, model.userid, @"userid");
    setDickeyobj(infoDic, goodsId, @"scoreid");
    NSString *numstr = [NSString stringWithFormat:@"%ld",num];
    setDickeyobj(infoDic, numstr, @"num");
    
    if (address) {
        
        if (address.mobile) setDickeyobj(infoDic, address.mobile, @"mobile");
        if (address.consignee) setDickeyobj(infoDic, address.consignee, @"consignee");
        if (address.zip) setDickeyobj(infoDic, address.zip, @"zip");
        if (address.address) setDickeyobj(infoDic, address.address, @"address");
        
    }
    
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    setDickeyobj(param, infoDic, @"reqBody");
    [CKHttpCommunicate createRequest:HTTP_USER_API WithParam:param withMethod:POST success:^(id result) {
        
        
        if (SUCCESS_REQUEST(result)) {
            
            [MBProgressHUD showError:result[@"data"] toView:nil];
            
        }else{
            [MBProgressHUD showError:result[@"msg"] toView:nil];
        }
        
    } failure:^(NSError *erro) {
        NSLog(@"%@",erro);
    } showHUD:nil];
    
}

- (void)requestData{
    
    NSMutableDictionary * infoDic = [[NSMutableDictionary alloc]init];
    setDickeyobj(infoDic, @"scoredetails", @"api");
    setDickeyobj(infoDic, self.scoreid, @"scoreid");
    
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    setDickeyobj(param, infoDic, @"reqBody");
    
    [CKHttpCommunicate createRequest:HTTP_USER_API WithParam:param withMethod:POST success:^(id result) {

        if (SUCCESS_REQUEST(result)) {
            
            [self.model mj_setKeyValues:result[@"data"]];
            self.model.modelId = result[@"data"][@"id"];
            [self.mytableView reloadData];
            
        }else{
            [MBProgressHUD showError:result[@"msg"] toView:nil];
        }
        
    } failure:^(NSError *erro) {
        
        NSLog(@"%@",erro);
    } showHUD:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) return 1;
    if (_currTag == 1){
        if (self.model.desc.length) return 2;
        else return 1;
    }
    
    return self.model.list.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        IntegralDetailImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"integralDetailImageCell"];
        cell.model = self.model;
//        cell.block = ^(CGFloat imageHeight) {
//            if (_imageheight != imageHeight) {
//                
//                _imageheight = imageHeight;
//                [tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
//            }
//        };
        return cell;
    }
    if (indexPath.row == 0) {
        IntegralDetailBtnCell *cell = [tableView dequeueReusableCellWithIdentifier:@"integralDetailBtnCell"];
        [cell addSubview:self.topBtnView];
        return cell;
    }else{
        if (_currTag == 1) {
            AttributedStringCell *cell = [tableView dequeueReusableCellWithIdentifier:@"attributedStringCell"];
            cell.htmlString = self.model.desc;
            
            cell.block = ^(CGFloat webViewHeight){
                
                if (_webViewHeight != webViewHeight) {
                    _webViewHeight = webViewHeight;
                    [UIView animateWithDuration:0.2 animations:^{
                        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                    }];
                    
                }
            };
            cell.urlBlock = ^(NSString *url) {
                GoLinkWebViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"goLinkWebViewController"];
                controller.webUrl = url;
                [self.navigationController pushViewController:controller animated:YES];
            };
            return cell;

        }else{
            IntegralDetailInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"integralDetailInfoCell"];
            cell.model = self.model.list[indexPath.row - 1];
            return cell;
        }
    }
    return nil;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){

//        if (_imageheight > 0) return 102 + _imageheight;
        return 102 + mScreenWidth;
    }
    if (_currTag == 1){
        if (indexPath.row == 1) {
            return _webViewHeight;
        }
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) return 5;
    return 0.01;
}

@end
