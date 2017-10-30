//
//  MyCollectionViewController.m
//  CabbageNet
//
//  Created by MacAir on 2017/4/7.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import "MyCollectionViewController.h"
#import "OriginalInfoCell.h"
#import "TopBtnView.h"
#import "ExchangeCell.h"
#import "DiscountCell.h"
#import "GoLinkWebViewController.h"
#import "MYCollectionModel.h"
#import "MYCollectionCell.h"
#import "DetailInfoViewController.h"
#import "OriginalDetailViewController.h"

@interface MyCollectionViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)TopBtnView *topBtnView;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic , strong)NSMutableArray *dataArr;


@end

@implementation MyCollectionViewController{
    NSInteger _currPage;
    NSInteger _currTag;
}

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (TopBtnView *)topBtnView{
    if (!_topBtnView) {
        _topBtnView = [[TopBtnView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, 44) titleBtnArr:@[@"国内",@"海淘",@"攻略",@"晒单"]];
        __weak typeof(self)weakSelf = self;
        _topBtnView.block = ^(NSInteger tag){
            _currTag = tag;
            [weakSelf.myTableView.mj_header beginRefreshing];
        };
        [_topBtnView btnActionChange:1];
    }
    return _topBtnView;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.myTableView.mj_header beginRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _currPage = 1;
    _currTag = 1;
    [self.view addSubview:self.topBtnView];
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

- (void)requestData{
    
    NSMutableDictionary * infoDic = [[NSMutableDictionary alloc]init];
    setDickeyobj(infoDic, @"likes", @"api");
    NSString *currPageStr = [NSString stringWithFormat:@"%ld",_currPage];
    setDickeyobj(infoDic, currPageStr, @"page");
    UserInfoModel *model = [UserInfoModel sharedUserData];
    setDickeyobj(infoDic, model.userid, @"userid");
    if (_currTag == 1) {
        setDickeyobj(infoDic, @"gn", @"type");
    }else if (_currTag == 2){
        setDickeyobj(infoDic, @"ht", @"type");
    }else if (_currTag == 3){
        setDickeyobj(infoDic, @"gl", @"type");
    }else if (_currTag == 4){
        setDickeyobj(infoDic, @"sd", @"type");
    }
    
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    setDickeyobj(param, infoDic, @"reqBody");
    
    [CKHttpCommunicate createRequest:HTTP_USER_API WithParam:param withMethod:POST success:^(id result) {
        [self.myTableView.mj_header endRefreshing];
        [self.myTableView.mj_footer endRefreshing];
        if (_currPage == 1) {
            [self.dataArr removeAllObjects];
            [self.myTableView reloadData];
        }
        if (SUCCESS_REQUEST(result)) {
            for (NSDictionary *dic in result[@"data"]) {
                MYCollectionModel *model = [[MYCollectionModel alloc]init];
                [model mj_setKeyValues:dic];
                model.shopid = dic[@"id"];
                [self.dataArr addObject:model];
            }
            
//            if (_currTag == 1) {
//                for (NSDictionary *dic in result[@"data"]) {
//                    OriginalModel *model = [[OriginalModel alloc] init];
//                    [model mj_setKeyValues:dic];
//                    [self.dataArr addObject:model];
//                }
//            }else if (_currTag == 2){
//                for (NSDictionary *dic in result[@"data"]) {
//                    MYArticleModel *model = [[MYArticleModel alloc] init];
//                    [model mj_setKeyValues:dic];
//                    model.publishid = dic[@"id"];
//                    [self.dataArr addObject:model];
//                }
//            }else{
//                for (NSDictionary *dic in result[@"data"]) {
//                    ExchangeModel *model = [[ExchangeModel alloc] init];
//                    [model mj_setKeyValues:dic];
//                    model.Exchangeid = dic[@"id"];
//                    [self.dataArr addObject:model];
//                }
//            }
//            
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MYCollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mYCollectionCell"];
    MYCollectionModel *model = self.dataArr[indexPath.section];
    cell.model = model;
    cell.Block = ^{
        NSMutableDictionary * infoDic = [[NSMutableDictionary alloc]init];
        setDickeyobj(infoDic, @"setlikes", @"api");
        UserInfoModel *usermodel = [UserInfoModel sharedUserData];
        setDickeyobj(infoDic, usermodel.userid, @"userid");
        setDickeyobj(infoDic, model.shopid, @"id");
        if (_currTag == 3 || _currTag == 4) setDickeyobj(infoDic, @"3", @"xid")
        else setDickeyobj(infoDic, @"1", @"xid")
        NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
        setDickeyobj(param, infoDic, @"reqBody");
        [CKHttpCommunicate createRequest:HTTP_USER_API WithParam:param withMethod:POST success:^(id result) {
            
            NSLog(@"%@------%@", result[@"data"], result[@"msg"]);
            if (SUCCESS_REQUEST(result)) {
                
                [self.dataArr removeObjectAtIndex:indexPath.section];
                [tableView reloadData];
                
            }else{
                [MBProgressHUD showError:result[@"msg"] toView:nil];
            }
        } failure:^(NSError *erro) {
            NSLog(@"%@", erro);
        } showHUD:nil];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (_currTag == 1) return 130;
//    if (_currTag == 2) return (mScreenWidth - 30)/2 + 120;
//    return 70;
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MYCollectionModel *model = self.dataArr[indexPath.section];
    if (_currTag == 3 || _currTag == 4) {
        OriginalDetailViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"originalDetailViewController"];
        controller.articleid = model.shopid;
        [self.navigationController pushViewController:controller animated:YES];
    }else {
        DetailInfoViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"detailInfoViewController"];
        controller.shopid = model.shopid;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

@end
