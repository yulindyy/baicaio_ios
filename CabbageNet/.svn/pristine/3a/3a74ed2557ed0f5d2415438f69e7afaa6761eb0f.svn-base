//
//  LogistiscInfoViewController.m
//  CabbageNet
//
//  Created by MacAir on 2017/4/8.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import "LogistiscInfoViewController.h"
#import "LogistiscInfoCell.h"
#import "AlreadyExchangeCell.h"
#import "LogistisInfoModel.h"

@interface LogistiscInfoViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *mytableView;
@property (nonatomic , strong)NSMutableArray *dataArr;

@end

@implementation LogistiscInfoViewController{
    NSInteger _currPage;
}

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _currPage = 1;
    
    if (self.logOrChange == IS_EXCHANGE) {
        self.mytableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    self.mytableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        _currPage = 1;
        [self requestData];
    }];
    
    self.mytableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        _currPage ++;
        [self requestData];
    }];

    [self requestData];
}

- (void)requestData{
    
    NSMutableDictionary * infoDic = [[NSMutableDictionary alloc]init];
    if (self.logOrChange == IS_EXCHANGE) {
        setDickeyobj(infoDic, @"myscore", @"api");
        UserInfoModel *model = [UserInfoModel sharedUserData];
        setDickeyobj(infoDic, model.userid, @"userid");
        NSString *currPageStr = [NSString stringWithFormat:@"%ld",_currPage];
        setDickeyobj(infoDic, currPageStr, @"page");
    }else{
        return;
    }
//    setDickeyobj(infoDic, self.model.userid, @"userid");
//    NSString *str = [NSString stringWithFormat:@"%ld", self.page];
//    setDickeyobj(infoDic, str, @"page");
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    setDickeyobj(param, infoDic, @"reqBody");
    
    [CKHttpCommunicate createRequest:HTTP_USER_API WithParam:param withMethod:POST success:^(id result) {
        [self.mytableView.mj_header endRefreshing];
        [self.mytableView.mj_footer endRefreshing];
        if(SUCCESS_REQUEST(result)){
            if (self.logOrChange == IS_EXCHANGE) {
                for (NSDictionary *dic in result[@"data"]) {
                    LogistisInfoModel *model = [[LogistisInfoModel alloc] init];
                    [model mj_setKeyValues:dic];
                    [self.dataArr addObject:model];
                }
            }else{
                
            }
            [self.mytableView reloadData];
        }else{
            [MBProgressHUD showError:result[@"msg"] toView:nil];
        }
        
    } failure:^(NSError *erro) {
        NSLog(@"%@", erro);
        [self.mytableView.mj_header endRefreshing];
        [self.mytableView.mj_footer endRefreshing];
    } showHUD:nil];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.logOrChange == IS_EXCHANGE) return self.dataArr.count;
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.logOrChange == IS_EXCHANGE) {
        
        AlreadyExchangeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"alreadyExchangeCell"];
        cell.model = self.dataArr[indexPath.row];
        return cell;
    }
    
    LogistiscInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"logistiscInfoCell"];
    cell.contentView.backgroundColor = tableView.backgroundColor;
    return cell;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = tableView.backgroundColor;
    
    if (self.logOrChange == IS_LOGISTISC) {
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((mScreenWidth - 80)/2, 10, 100, 20)];
        
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = NSTextAlignmentCenter;
        
        label.backgroundColor = [UIColor lightGrayColor];
        label.textColor = [UIColor whiteColor];
        
        label.layer.cornerRadius = 5;
        label.layer.masksToBounds = YES;
        
        label.text = @"2017-03-29";
        [view addSubview:label];
    }
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.logOrChange == IS_EXCHANGE) return 85;
    return 110;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.logOrChange == IS_EXCHANGE) return 10;
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (self.logOrChange == IS_EXCHANGE) return 0.01;
    return 0.01;
}

@end
