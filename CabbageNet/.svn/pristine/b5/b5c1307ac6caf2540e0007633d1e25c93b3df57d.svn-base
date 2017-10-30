//
//  MyBrokeViewController.m
//  CabbageNet
//
//  Created by MacAir on 2017/4/7.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import "MyBrokeViewController.h"
#import "OriginalInfoCell.h"
#import "SendArticleViewController.h"
#import "TopBtnView.h"
#import "OriginalModel.h"
#import "OriginalDetailViewController.h"

@interface MyBrokeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)TopBtnView *topBtnView;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic , strong)NSMutableArray *dataArr;

@end

@implementation MyBrokeViewController{
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
        _topBtnView = [[TopBtnView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, 44) titleBtnArr:@[@"攻略",@"晒单",@"爆料"]];
        __weak typeof(self)weakSelf = self;
        _topBtnView.block = ^(NSInteger tag){
            _currTag = tag;
            [weakSelf.myTableView.mj_header beginRefreshing];
        };
        [_topBtnView btnActionChange:1];
    }
    return _topBtnView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的文章";
    _currPage = 1;
    _currTag = 1;
    [self.view addSubview:self.topBtnView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnClick)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
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
    setDickeyobj(infoDic, @"new_publish", @"api");
    NSString *currPageStr = [NSString stringWithFormat:@"%ld",_currPage];
    setDickeyobj(infoDic, currPageStr, @"page");
    UserInfoModel *model = [UserInfoModel sharedUserData];
    setDickeyobj(infoDic, model.userid, @"userid");
    if (_currTag == 1) {
        setDickeyobj(infoDic, @"gl", @"type");
    }else if (_currTag == 2){
        setDickeyobj(infoDic, @"sd", @"type");
    }else if (_currTag == 3){
        setDickeyobj(infoDic, @"qb", @"type");
    }
//    else if (_currTag == 4){
//        setDickeyobj(infoDic, @"gn", @"type");
//    }
    
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
                OriginalModel *model = [[OriginalModel alloc] init];
                [model mj_setKeyValues:dic];
                model.uid = dic[@"id"];
                [self.dataArr addObject:model];
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

#pragma mark -- 发布按钮实现
- (void)rightBtnClick{
    
    SendArticleViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"sendArticleViewController"];
    controller.articleOrBroke = IS_BROKE;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark -- tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OriginalInfoCell *cell = [OriginalInfoCell getOriginalInfoCell];
    cell.model = self.dataArr[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return (mScreenWidth - 30)/ 2 + 120;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    OriginalModel *model = self.dataArr[indexPath.row];
    if (model.status == 1) {
        OriginalDetailViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"originalDetailViewController"];
        controller.articleid = model.articleid;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

@end
