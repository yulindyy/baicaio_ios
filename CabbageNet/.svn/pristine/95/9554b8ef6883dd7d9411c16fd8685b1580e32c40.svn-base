//
//  MessageViewController.m
//  CabbageNet
//
//  Created by MacAir on 2017/4/6.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageCell.h"
#import "LogistiscInfoViewController.h"
#import "TopBtnView.h"
#import "PrivateLetterModel.h"
#import "PrivateLatterCell.h"
#import "PrivateViewController.h"

@interface MessageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic, strong) UserInfoModel *model;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *mArr;
@property (nonatomic,strong)TopBtnView *topBtnView;

@end

@implementation MessageViewController{
    NSInteger _currTag;
}
- (TopBtnView *)topBtnView{
    if (!_topBtnView) {
        _topBtnView = [[TopBtnView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, 44) titleBtnArr:@[@"系统消息",@"私信"]];
        __weak typeof(self)weakSelf = self;
        _topBtnView.block = ^(NSInteger tag){
            _currTag = tag;
            [weakSelf.myTableView.mj_header beginRefreshing];
        };
        [_topBtnView btnActionChange:1];
    }
    return _topBtnView;
}

- (UserInfoModel *)model{
    return [UserInfoModel sharedUserData];
}

- (NSMutableArray *)mArr{
    
    if (_mArr == nil) {
        _mArr = [NSMutableArray arrayWithCapacity:8];
    }
    return _mArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.topBtnView];
    
    self.page = 1;
    [self requestData];
    self.myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 1;
        [self requestData];
    }];
    self.myTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _page ++;
        [self requestData];
    }];
    [self requestData];
}

- (void)requestData{
    
    NSMutableDictionary * infoDic = [[NSMutableDictionary alloc]init];
    if (_currTag == 1){
        setDickeyobj(infoDic, @"getmsg", @"api");
    }else{
        setDickeyobj(infoDic, @"msglist", @"api");
    }
    setDickeyobj(infoDic, self.model.userid, @"userid");
    NSString *str = [NSString stringWithFormat:@"%ld", self.page];
    setDickeyobj(infoDic, str, @"page");
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    setDickeyobj(param, infoDic, @"reqBody");
    [CKHttpCommunicate createRequest:HTTP_USER_API WithParam:param withMethod:POST success:^(id result) {
        [self.myTableView.mj_header endRefreshing];
        [self.myTableView.mj_footer endRefreshing];
        if (_page == 1) {
            [self.mArr removeAllObjects];
        }
        if(SUCCESS_REQUEST(result)){
            if (_currTag == 1){
                for (NSDictionary *dic in result[@"data"]) {
                    MessageModel *mModel = [[MessageModel alloc] init];
                    [mModel mj_setKeyValues:dic];
                    mModel.messageID = dic[@"id"];
                    [self.mArr addObject:mModel];
                }
            }else{
                for (NSDictionary *dic in result[@"data"]) {
                    PrivateLetterModel *mModel = [[PrivateLetterModel alloc] init];
                    [mModel mj_setKeyValues:dic];
                    mModel.privateID = dic[@"id"];
                    [self.mArr addObject:mModel];
                }
            }
        }else{
            [MBProgressHUD showError:result[@"msg"] toView:nil];
        }
        [self.myTableView reloadData];
    } failure:^(NSError *erro) {
        NSLog(@"%@", erro);
        [self.myTableView.mj_header endRefreshing];
        [self.myTableView.mj_footer endRefreshing];
    } showHUD:nil];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.mArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_currTag == 1) {
        MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"messageCell"];
        cell.model = self.mArr[indexPath.row];
        return cell;
    }
    PrivateLatterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"privateLatterCell"];
    cell.model = self.mArr[indexPath.row];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    LogistiscInfoViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"logistiscInfoViewController"];
//    controller.logOrChange = IS_LOGISTISC;
//    [self.navigationController pushViewController:controller animated:YES];
    if (_currTag == 2) {
        PrivateViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"privateViewController"];
        controller.model = self.mArr[indexPath.row];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

// 设置 cell 是否允许左滑
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return true;
}
// 设置默认的左滑按钮的title
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}
// 点击左滑出现的按钮时触发
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"点击左滑出现的按钮时触发");
    NSMutableDictionary * infoDic = [[NSMutableDictionary alloc]init];
    
    if (_currTag == 1){
        setDickeyobj(infoDic, @"msgdel", @"api");
        MessageModel *messageModel = self.mArr[indexPath.row];
        setDickeyobj(infoDic, messageModel.messageID, @"mid");
        
    }else{
        setDickeyobj(infoDic, @"msgdelall", @"api");
        PrivateLetterModel *messageModel = self.mArr[indexPath.row];
        setDickeyobj(infoDic, messageModel.ftid, @"ftid");
    }
    setDickeyobj(infoDic, self.model.userid, @"userid");
    
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    setDickeyobj(param, infoDic, @"reqBody");
    
    [CKHttpCommunicate createRequest:HTTP_USER_API WithParam:param withMethod:POST success:^(id result) {
        
        if (SUCCESS_REQUEST(result)) {
            [self.mArr removeObjectAtIndex:indexPath.row];
            [MBProgressHUD showError:@"删除成功" toView:nil];
        }else {
            [MBProgressHUD showError:result[@"msg"] toView:nil];
        }
        
        [self.myTableView reloadData];
        
    } failure:^(NSError *erro) {
        [MBProgressHUD showError:@"删除失败！" toView:nil];
        NSLog(@"%@",erro);
    } showHUD:nil];
}
// 左滑结束时调用(只对默认的左滑按钮有效，自定义按钮时这个方法无效)
-(void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"左滑结束");
}

@end
