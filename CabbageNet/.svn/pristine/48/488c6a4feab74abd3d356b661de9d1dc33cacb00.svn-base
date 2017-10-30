//
//  MyCommentsViewController.m
//  CabbageNet
//
//  Created by MacAir on 2017/4/7.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import "MyCommentsViewController.h"
#import "CommentInfoCell.h"
#import "TopBtnView.h"
#import "DetailInfoViewController.h"
#import "MYCommentsModel.h"
#import "DetailInfoViewController.h"
#import "OriginalDetailViewController.h"

@interface MyCommentsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)TopBtnView *topBtnView;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic , strong)NSMutableArray *dataArr;

@end

@implementation MyCommentsViewController{
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
        _topBtnView = [[TopBtnView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, 44) titleBtnArr:@[@"全部",@"近期"/*,@"国内",@"海淘",@"晒单",@"攻略"*/]];
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
    setDickeyobj(infoDic, @"comments", @"api");
    NSString *currPageStr = [NSString stringWithFormat:@"%ld",_currPage];
    setDickeyobj(infoDic, currPageStr, @"page");
    UserInfoModel *model = [UserInfoModel sharedUserData];
    setDickeyobj(infoDic, model.userid, @"userid");
    if (_currTag == 1) {
        setDickeyobj(infoDic, @"0", @"t");
    }else if (_currTag == 2){
        setDickeyobj(infoDic, @"1", @"t");
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
                MYCommentsModel *model = [[MYCommentsModel alloc] init];
                [model mj_setKeyValues:dic];
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

- (void)deletedComment:(NSInteger)index{
    NSMutableDictionary * infoDic = [[NSMutableDictionary alloc]init];
    setDickeyobj(infoDic, @"del_comment", @"api");
    MYCommentsModel *model = self.dataArr[index];
    setDickeyobj(infoDic, model.commentid, @"commentid");
    
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    setDickeyobj(param, infoDic, @"reqBody");
    
    [CKHttpCommunicate createRequest:HTTP_USER_API WithParam:param withMethod:POST success:^(id result) {
    
        if (SUCCESS_REQUEST(result)) {
            
            [self.dataArr removeObjectAtIndex:index];
            [self.myTableView reloadData];
            
        }else{
            [MBProgressHUD showError:result[@"msg"] toView:nil];
        }
        
    } failure:^(NSError *erro) {
        
        NSLog(@"%@",erro);
    } showHUD:nil];
}

#pragma mark -- tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CommentInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentInfoCell"];
    cell.model = self.dataArr[indexPath.row];
    cell.block = ^(NSInteger tag) {
        for (MYCommentsModel *model in self.dataArr) {
            model.showing = NO;
        }
        [tableView reloadData];
        if (tag == 0) {
            MYCommentsModel *model = self.dataArr[indexPath.row];
            model.showing = YES;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }else if (tag == 1) {//分享
            
            
        }else if (tag == 2){//删除
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"您确定要删除该条评论吗？"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self deletedComment:indexPath.row];
            }];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"手滑了" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:cancel];
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];

            
            
        }else if (tag == 3){//详情
            MYCommentsModel *model = self.dataArr[indexPath.row];
            if (model.xid == 1 && model.itemid){//商品
                
                DetailInfoViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"detailInfoViewController"];
                controller.shopid = model.itemid;
                [self.navigationController pushViewController:controller animated:YES];
                
            }else if (model.xid == 2 && model.itemid){//转让
                
            }else if (model.xid == 3 && model.itemid){//文章
                OriginalDetailViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"originalDetailViewController"];
                controller.articleid = model.itemid;
                [self.navigationController pushViewController:controller animated:YES];
            }
        }
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 180;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}


@end
