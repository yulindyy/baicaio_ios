//
//  MYCouponViewController.m
//  CabbageNet
//
//  Created by xiang fu on 2017/7/9.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import "MYCouponViewController.h"
#import "CouponImageCell.h"
#import "CouponModel.h"
#import "GoLinkWebViewController.h"
#import "CouponViewController.h"

@interface MYCouponViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic , strong)NSMutableArray *dataArray;

@end

@implementation MYCouponViewController{
    NSInteger _currPage;
}


- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _currPage = 1;
    
    self.myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        _currPage = 1;
        [self requestData];
    }];
    
    self.myTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        
        _currPage ++;
        [self requestData];
    }];
    
    [self requestData];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"去兑换" style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnClick)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
}

- (void)rightBtnClick{
    
    NSArray *array = self.navigationController.viewControllers;
    NSInteger arrayCount = array.count;
    if (arrayCount > 2) {
        UIViewController *controller = array[arrayCount - 2];
        if ([controller.class isSubclassOfClass:[CouponViewController class]]) {
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
    }
    CouponViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"couponViewController"];
    [self.navigationController pushViewController:controller animated:YES];
    
}

#pragma  mark -- 我的优惠券
- (void)requestData{
    NSMutableDictionary * infoDic = [[NSMutableDictionary alloc]init];
    setDickeyobj(infoDic, @"tick", @"api");
    UserInfoModel *model = [UserInfoModel sharedUserData];
    setDickeyobj(infoDic, model.userid, @"userid");
    NSString *currPageStr = [NSString stringWithFormat:@"%ld",_currPage];
    setDickeyobj(infoDic, currPageStr, @"page");
    setDickeyobj(infoDic, @"0", @"gq");
    
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    setDickeyobj(param, infoDic, @"reqBody");
    
    [CKHttpCommunicate createRequest:HTTP_USER_API WithParam:param withMethod:POST success:^(id result) {
        [self.myTableView.mj_header endRefreshing];
        [self.myTableView.mj_footer endRefreshing];
        if (SUCCESS_REQUEST(result)) {
            
            if (_currPage == 1) {
                [self.dataArray removeAllObjects];
            }
            for (NSDictionary *dic in result[@"data"]) {
                
                CouponModel *model = [[CouponModel alloc] init];
                [model mj_setKeyValues:dic];
                [self.dataArray addObject:model];
            }
            [self.myTableView reloadData];
            
        }else{
            [MBProgressHUD showError:result[@"msg"] toView:nil];
        }
        
    } failure:^(NSError *erro) {
        [self.myTableView.mj_header endRefreshing];
        [self.myTableView.mj_footer endRefreshing];
        NSLog(@"%@",erro);
    } showHUD:nil];
}

#pragma mark -- tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CouponImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"couponImageCell"];
    cell.contentView.backgroundColor = tableView.backgroundColor;
    cell.model = self.dataArray[indexPath.section];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return (mScreenWidth - 20) / 63 * 19;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CouponModel *model = self.dataArray[indexPath.section];
    GoLinkWebViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"goLinkWebViewController"];
    controller.webUrl = model.ljdz;
    controller.title = @"使用优惠券";
    [self.navigationController pushViewController:controller animated:YES];
}

@end
