//
//  ExchangeViewController.m
//  CabbageNet
//
//  Created by MacAir on 2017/4/7.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import "ExchangeViewController.h"
#import "ExchangeCell.h"
#import "LogistiscInfoViewController.h"
#import "SQMenuShowView.h"
#import "ExchangeModel.h"
#import "IntegralDetailViewController.h"
#import "AddressModel.h"
#import "EditAddressViewController.h"
#import "ExchangeAlertController.h"
#import "VerificationViewController.h"
#import "AlertBtnViewController.h"
#import "AddressViewController.h"

@interface ExchangeViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UISearchBar *searBar;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic)  SQMenuShowView *showView;
@property (nonatomic , strong) NSMutableArray *dataArr;

@end

@implementation ExchangeViewController{
    BOOL _showing;
    NSInteger _currPage;
    NSInteger _currTag;
    AddressModel *_selectedAddress;
}

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (SQMenuShowView *)showView{
    
    if (!_showView) {
        _showView = [[SQMenuShowView alloc]initWithFrame:CGRectMake(mScreenWidth - 110, 44, 100, 0)
                                                   items:@[@"全部",@"虚拟礼品",@"实物礼品"]
                                               showPoint:(CGPoint){mScreenWidth - 30,80}];
        
        _showView.sq_backGroundColor = toPCcolor(@"#505050");
        _showView.itemTextColor = [UIColor whiteColor];
        [self.view addSubview:_showView];
    }
    return _showView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"积分兑换";
    _currTag = 0;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"已兑换" style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnClick)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    
    self.topView.backgroundColor = mAppMainColor;

    [self.selectBtn setTitle:@"全部" forState:UIControlStateNormal];
    
    self.searBar.placeholder = @"搜索";
    [self.searBar setImage:[UIImage imageNamed:@"搜索"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    
    UITextField * searchField = [self.searBar valueForKey:@"_searchField"];
    searchField.textColor = [UIColor whiteColor];
    [searchField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    self.myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        _currPage = 1;
        [self requestData];
    }];
    
    self.myTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        
        _currPage ++;
        [self requestData];
    }];
    
    [self.myTableView.mj_header beginRefreshing];
    
}

- (void)requestExchange:(NSString *)goodsId andAddress:(AddressModel *)address{
    
    NSMutableDictionary * infoDic = [[NSMutableDictionary alloc]init];
    setDickeyobj(infoDic, @"ec", @"api");
    UserInfoModel *model = [UserInfoModel sharedUserData];
    setDickeyobj(infoDic, model.userid, @"userid");
    setDickeyobj(infoDic, goodsId, @"scoreid");
    setDickeyobj(infoDic, @"1", @"num");
    
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
        [self.myTableView reloadData];
    } failure:^(NSError *erro) {
        NSLog(@"%@",erro);
    } showHUD:nil];

}

- (void)requestData{
    
    NSMutableDictionary * infoDic = [[NSMutableDictionary alloc]init];
    setDickeyobj(infoDic, @"scorelist", @"api");
    NSString *currPageStr = [NSString stringWithFormat:@"%ld",_currPage];
    setDickeyobj(infoDic, currPageStr, @"page");
    
    if (_currTag == 1){
        setDickeyobj(infoDic, @"1", @"type");
    }else if (_currTag == 2){
        setDickeyobj(infoDic, @"0 ", @"type");
    }
    if (self.searBar.text.length) setDickeyobj(infoDic, self.searBar.text, @"title");
    
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    setDickeyobj(param, infoDic, @"reqBody");
    
    [CKHttpCommunicate createRequest:HTTP_USER_API WithParam:param withMethod:POST success:^(id result) {
        [self.myTableView.mj_header endRefreshing];
        [self.myTableView.mj_footer endRefreshing];
        if (_currPage == 1) {
            [self.dataArr removeAllObjects];
        }
        if (SUCCESS_REQUEST(result)) {
            
            for (NSDictionary *dic in result[@"data"]) {
                
                ExchangeModel *model = [[ExchangeModel alloc] init];
                [model mj_setKeyValues:dic];
                model.Exchangeid = dic[@"id"];
                [self.dataArr addObject:model];
            }
            
            
        }else{
            [MBProgressHUD showError:result[@"msg"] toView:nil];
        }
        [self.myTableView reloadData];
    } failure:^(NSError *erro) {
        [self.myTableView.mj_header endRefreshing];
        [self.myTableView.mj_footer endRefreshing];
        NSLog(@"%@",erro);
    } showHUD:nil];
}

- (void)rightBtnClick{
    
    if (_showing) {
        [self.showView dismissView];
    }
    
    LogistiscInfoViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"logistiscInfoViewController"];
    controller.title = @"已兑换";
    controller.logOrChange = IS_EXCHANGE;
    [self.navigationController pushViewController:controller animated:YES];
    
}

- (IBAction)selectBtnclick:(UIButton *)sender {
    
    if (_showing) {
        _showing = NO;
        [self.showView dismissView];
        return;
    }
    _showing = YES;
    [self.showView showView];
    
    [self.showView selectBlock:^(SQMenuShowView *view, NSInteger index) {
        if (index == 0){
            _currTag = 0;
            [sender setTitle:@"全部" forState:UIControlStateNormal];
            [self.myTableView.mj_header beginRefreshing];
        }else if (index == 1){
            _currTag = 1;
            [sender setTitle:@"虚拟礼品" forState:UIControlStateNormal];
            [self.myTableView.mj_header beginRefreshing];
        }else if (index == 2){
            _currTag = 2;
            [sender setTitle:@"实物礼品" forState:UIControlStateNormal];
            [self.myTableView.mj_header beginRefreshing];
        }
    }];
    
}

#pragma mark -- searBar delegate
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar endEditing:YES];
    [self.myTableView.mj_header beginRefreshing];
    NSLog(@"%@",searchBar.text);
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    searchBar.showsCancelButton = YES;
    for(UIView *view in  [[[_searBar subviews] objectAtIndex:0] subviews]) {
        if([view isKindOfClass:[NSClassFromString(@"UINavigationButton") class]]) {
            UIButton * cancel =(UIButton *)view;
            [cancel setTitle:@"取消" forState:UIControlStateNormal];
            cancel.titleLabel.font = [UIFont systemFontOfSize:14];
            [cancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [cancel addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
            CGRect frame = cancel.frame;
            frame.size.width = 40;
            cancel.frame = frame;
            
        }
    }
    [searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}

- (void)cancelBtnClick{
    self.searBar.text = @"";
    [self.myTableView.mj_header beginRefreshing];
    [self.searBar endEditing:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:NO animated:YES];
}

#pragma mark tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ExchangeCell *cell = [ExchangeCell getExchangeCell];
    ExchangeModel *model = self.dataArr[indexPath.row];
    cell.model = model;
    cell.block = ^{
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
        if (_currTag == 1){//虚拟礼品兑换
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:model.title message:[NSString stringWithFormat:@"兑换此商品需要%ld金币%ld积分。是否立即兑换？",model.coin,model.score] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消兑换" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"立即兑换" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self requestExchange:model.Exchangeid andAddress:nil];
            }];
            [alert addAction:cancle];
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
            
            
        }else{//实物兑换
            
            
            [self showAlert:model andAddress:nil];
        
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
//                        ExchangeAlertController *alert = [ExchangeAlertController alertPickerWithTitle:model.title Separator:[NSString stringWithFormat:@"兑换此商品需要%ld金币。是否立即兑换？",model.score] SourceArr:dataArr];
//                        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确认兑换" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
////                            NSLog(@"----------%ld",alert.currRow);
//                            [self requestExchange:model.Exchangeid andAddress:dataArr[alert.currRow]];
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
    return cell;
    
}

- (void)showAlert:(ExchangeModel *)model andAddress:(AddressModel *)addressModel{
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确认兑换" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (_selectedAddress) {
            [self requestExchange:model.Exchangeid andAddress:addressModel];
        }else{
            [MBProgressHUD showError:@"您未选择收获地址" toView:nil];
        }
    }];
    [ok setValue:mAppMainColor forKey:@"_titleTextColor"];
    if (addressModel) {
        
        AlertBtnViewController *alert = [AlertBtnViewController alertPickerWithTitle:model.title Separator:[NSString stringWithFormat:@"兑换此商品需要%ld金币。是否立即兑换？",model.score] andAddress:[NSString stringWithFormat:@"%@-%@-%@-%@",addressModel.consignee,addressModel.mobile,addressModel.zip,addressModel.address]];
        __weak typeof(alert) weakAlert = alert;
        
        alert.block = ^{
            
            [weakAlert dismissViewControllerAnimated:YES completion:nil];
            AddressViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"addressViewController"];
            controller.tag = 1;
            
            controller.block = ^(AddressModel *selectedAddressModel) {
                _selectedAddress = selectedAddressModel;
                [self showAlert:model andAddress:selectedAddressModel];
                
            };
            [self.navigationController pushViewController:controller animated:YES];
        };
        
        
        [alert addCompletionAction:ok];
        [self presentViewController:alert animated:YES completion:nil];

    }else{
    
        AlertBtnViewController *alert = [AlertBtnViewController alertPickerWithTitle:model.title Separator:[NSString stringWithFormat:@"兑换此商品需要%ld金币。是否立即兑换？",model.score] andAddress:nil];
        __weak typeof(alert) weakAlert = alert;
        
        alert.block = ^{
            
            [weakAlert dismissViewControllerAnimated:YES completion:nil];
            AddressViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"addressViewController"];
            controller.tag = 1;

            controller.block = ^(AddressModel *selectedAddressModel) {
                
                _selectedAddress = selectedAddressModel;
                [self showAlert:model andAddress:selectedAddressModel];
                
            };
            [self.navigationController pushViewController:controller animated:YES];
        };
        
        
        [alert addCompletionAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.showView dismissView];
    IntegralDetailViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"integralDetailViewController"];
    ExchangeModel *model = self.dataArr[indexPath.row];
    controller.scoreid = model.Exchangeid;
    controller.superCurrTag = _currTag;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.showView dismissView];
}

@end
