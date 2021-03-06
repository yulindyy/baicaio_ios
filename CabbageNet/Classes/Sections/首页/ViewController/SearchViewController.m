//
//  SearchViewController.m
//  CabbageNet
//
//  Created by xiang fu on 2017/8/7.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchCellTableViewCell.h"
#import "DiscountPrise.h"
#import "HistoryCell.h"
#import "SignListViewController.h"
#import "GoLinkWebViewController.h"
#import "DetailInfoViewController.h"
// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用idfa功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>
#import "FollowCell.h"
#import "SignModel.h"
#import "LoginViewController.h"

@interface SearchViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic , assign)BOOL isHistory;
@property (nonatomic , strong)NSMutableArray *dataList;
@property (nonatomic , strong)NSArray *historyList;

@end

@implementation SearchViewController{
    NSInteger _curPage;
    BOOL _isFollow;//是否关注
    BOOL _allow;//是否允许添加关注
    SignModel *_followModel;
}
- (NSArray *)historyList{
    return [DiscountPrise selectedHistory];
}

- (NSMutableArray *)dataList{
    if (!_dataList) _dataList = [NSMutableArray array]; return _dataList;
}

- (UISearchBar *)searchBar{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, -20, mScreenWidth - 88, 44)];
        _searchBar.searchBarStyle = UISearchBarStyleMinimal;
        _searchBar.delegate = self;
        _searchBar.placeholder = @"请输入想要搜索的商品";
        [_searchBar setImage:[UIImage imageNamed:@"删除编辑"] forSearchBarIcon:UISearchBarIconClear state:UIControlStateNormal];
        [_searchBar setImage:[UIImage imageNamed:@"搜索"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
        
        UITextField * searchField = [_searchBar valueForKey:@"_searchField"];
        searchField.textColor = [UIColor whiteColor];
        [searchField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
        
    }
    return _searchBar;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    if (self.searchBar.text.length) {
        self.isHistory = NO;
        if (![self.historyList containsObject:self.searchBar.text]) {
            [DiscountPrise insertHistory:self.searchBar.text];
        }
        [self.myTableView.mj_header beginRefreshing];
    }else{
        self.isHistory = YES;
        [self.myTableView reloadData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _curPage = 1;
    self.navigationItem.titleView = self.searchBar;
    
    _followModel = [[SignModel alloc] init];
//    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 44)];
    [rightBtn setTitle:@"搜索" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [rightView addSubview:rightBtn];
//    UIImageView *rightImage = [[UIImageView alloc] initWithFrame:CGRectMake(39, 5, 15, 15)];
//    if (self.isJump) rightImage.image = [UIImage imageNamed:@"关注设置"];
//    else rightImage.image = [UIImage imageNamed:@"关注加"];
//    [rightView addSubview:rightImage];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, 22, 44)];
    [backBtn setImage:[UIImage imageNamed:@"返回"]  forState:UIControlStateNormal];
    backBtn.imageEdgeInsets = UIEdgeInsetsMake(12, 0, 12, 4);
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    self.isHistory = YES;
    
    
    self.myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _curPage = 1;
        [self searchData:self.searchBar.text];
    }];
    self.myTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        
        _curPage ++;
        [self searchData:self.searchBar.text];
    }];
}

- (void)backBtnClick{
    if (self.presentingViewController){
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark -- 请求关注列表
- (void)requestData{
    
    if (![UserDefaultsGetSynchronize(@"login") isEqualToString:@"10001"]) return;
   
    NSMutableDictionary * infoDic = [[NSMutableDictionary alloc]init];
    setDickeyobj(infoDic, @"notify_tag_byuser", @"api");
    UserInfoModel *model = [UserInfoModel sharedUserData];
    setDickeyobj(infoDic, model.userid, @"userid");
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    setDickeyobj(param, infoDic, @"reqBody");
    [CKHttpCommunicate createRequest:HTTP_USER_API WithParam:param withMethod:POST success:^(id result) {
        if (SUCCESS_REQUEST(result)) {
            _isFollow = NO;
            NSArray *array = result[@"data"];
            _allow = array.count < 14;
            for (NSDictionary *dic in array) {
                NSString *tagStr = [dic valueForKey:@"tag"];
                if ([tagStr.lowercaseString isEqualToString:self.searchBar.text.lowercaseString]) {
                    _isFollow = YES;
                    [_followModel mj_setKeyValues:dic];
                    _followModel.signID = dic[@"id"];
                    break;
                }else{
                    _followModel = [[SignModel alloc]init];
                }
            }
            [self.myTableView reloadData];
        }else{
            _allow = YES;
        }
    } failure:^(NSError *erro) {
        NSLog(@"%@",erro);
    } showHUD:nil];
}

#pragma mark -- 请求搜索列表
- (void)searchData:(NSString *)string{
    
    if (self.isHistory){
        [self.myTableView.mj_header endRefreshing];
        [self.myTableView.mj_footer endRefreshing];
        [self.myTableView reloadData];
        return;
    }
    NSMutableDictionary * infoDic = [[NSMutableDictionary alloc]init];
    setDickeyobj(infoDic, @"shoplist", @"api");
    setDickeyobj(infoDic, @"2", @"tp");
    NSString *pageStr = [NSString stringWithFormat:@"%ld",_curPage];
    setDickeyobj(infoDic, pageStr , @"page");
    setDickeyobj(infoDic, @"14", @"pagesize");//分页条数， 即几条为一页，不填则默认为 10
    setDickeyobj(infoDic, string, @"key");
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    setDickeyobj(param, infoDic, @"reqBody");
    [CKHttpCommunicate createRequest:HTTP_SHOP_API WithParam:param withMethod:POST success:^(id result) {
        [self.myTableView.mj_header endRefreshing];
        [self.myTableView.mj_footer endRefreshing];
        if (_curPage == 1) {
            [self.dataList removeAllObjects];
            [self requestData];
        }
        if (SUCCESS_REQUEST(result)) {
            
            for (NSDictionary *dic in result[@"data"]) {
                DiscountModel *model = [[DiscountModel alloc] init];
                [model mj_setKeyValues:dic];
                [self.dataList addObject:model];
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

#pragma mark -- 请求关注和取消关注
- (void)requestFollow:(UIButton *)sender{
    
    if (![self isLogin]) {
        return;
    }
    
    if (!_allow) {
        [MBProgressHUD showError:@"关注数量最多14条" toView:nil];
        return;
    }
    
    sender.selected = !sender.selected;
    NSMutableDictionary * infoDic = [[NSMutableDictionary alloc]init];
    if (sender.selected) {//关注
        sender.backgroundColor = [UIColor lightGrayColor];
        setDickeyobj(infoDic, @"follow_tag_create", @"api");
        UserInfoModel *model = [UserInfoModel sharedUserData];
        setDickeyobj(infoDic, model.userid, @"userid");
        FollowCell *cell = [self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        NSString *string = cell.nameLabel.text;
        setDickeyobj(infoDic, string, @"tag");
    //添加推送
    }else{//取消关注
        setDickeyobj(infoDic, @"follow_tag_del", @"api");
        UserInfoModel *model = [UserInfoModel sharedUserData];
        setDickeyobj(infoDic, model.userid, @"userid");
        FollowCell *cell = [self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        NSString *string = cell.nameLabel.text;
        setDickeyobj(infoDic, string, @"tag");
    }
    
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    setDickeyobj(param, infoDic, @"reqBody");
    
    [CKHttpCommunicate createRequest:HTTP_USER_API WithParam:param withMethod:POST success:^(id result) {
        [self requestData];
        if (SUCCESS_REQUEST(result)){
            if (sender.selected) {//关注
                [MBProgressHUD showError:@"关注成功" toView:nil];
            }else{
                [self addTag:NO];
                [MBProgressHUD showError:@"取消关注成功" toView:nil];
            }
        }else{
            [MBProgressHUD showError:result[@"msg"] toView:nil];
        }
    } failure:^(NSError *erro) {
        NSLog(@"%@",erro);
    } showHUD:nil];
}

#pragma mark -- 添加关闭推送
- (void)requestPush:(UIButton *)sender{
    
    if (![self isLogin]) {
        return;
    }
    
    if (!_allow) {
        [MBProgressHUD showError:@"关注数量最多14条" toView:nil];
        return;
    }
    
    sender.selected = !sender.selected;
    NSMutableDictionary * infoDic = [[NSMutableDictionary alloc]init];
    if (sender.selected) {
        setDickeyobj(infoDic, @"notify_tag_create", @"api");
        FollowCell *cell = [self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        NSString *string = cell.nameLabel.text;
        setDickeyobj(infoDic, string , @"tag");
    }else{
        setDickeyobj(infoDic, @"notify_tag_del", @"api");
        if (_followModel.signID) setDickeyobj(infoDic, _followModel.signID, @"id");
    }
    UserInfoModel *model = [UserInfoModel sharedUserData];
    setDickeyobj(infoDic, model.userid, @"userid");
    
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    setDickeyobj(param, infoDic, @"reqBody");
    [CKHttpCommunicate createRequest:HTTP_USER_API WithParam:param withMethod:POST success:^(id result) {
        if (SUCCESS_REQUEST(result)){
            NSLog(@"%@",result[@"msg"]);
            [self requestData];
            if (sender.selected){
                if (![UserDefaultsGetSynchronize(@"openjpush") isEqualToString:@"9999"]) {
                    [self addTag:YES];
                }
                [MBProgressHUD showError:@"添加推送成功" toView:nil];
            }else{
                [self addTag:NO];
                [MBProgressHUD showError:@"取消推送成功" toView:nil];
            }
        }else{
//            NSLog(@"%@",result[@"data"]);
            [MBProgressHUD showError:result[@"msg"] toView:nil];
        }
    } failure:^(NSError *erro) {
        [self requestData];
        NSLog(@"%@",erro);
    } showHUD:nil];
}

- (void)rightBtnClick{
    [self.searchBar endEditing:YES];
    if (self.searchBar.text.length) {
        self.isHistory = NO;
        if (![self.historyList containsObject:self.searchBar.text]) {
            [DiscountPrise insertHistory:self.searchBar.text];
        }
        [self.myTableView.mj_header beginRefreshing];
    }else{
        self.isHistory = YES;
        [self.myTableView reloadData];
    }
}

#pragma mark -- searBar delegate
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar endEditing:YES];
//    [self.topBtnView btnActionChange:1];
    if (searchBar.text.length) {
        self.isHistory = NO;
        if (![self.historyList containsObject:searchBar.text]) {
            [DiscountPrise insertHistory:searchBar.text];
        }
        [self.myTableView.mj_header beginRefreshing];
    }else{
        self.isHistory = YES;
    }
    [self.myTableView reloadData];
    NSLog(@"%@",searchBar.text);
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
//    searchBar.showsCancelButton = YES;
//    for(UIView *view in  [[[_searchBar subviews] objectAtIndex:0] subviews]) {
//        if([view isKindOfClass:[NSClassFromString(@"UINavigationButton") class]]) {
//            UIButton * cancel =(UIButton *)view;
//            [cancel setTitle:@"取消" forState:UIControlStateNormal];
//            cancel.titleLabel.font = [UIFont systemFontOfSize:14];
//            [cancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            [cancel addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
//            CGRect frame = cancel.frame;
//            frame.size.width = 40;
//            cancel.frame = frame;
//            
//        }
//    }
//    [searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}

//- (void)cancelBtnClick{
//    self.searchBar.text = @"";
//    [self.myTableView.mj_header beginRefreshing];
//    [self.searchBar endEditing:YES];
//}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
//    [searchBar setShowsCancelButton:NO animated:YES];
    if (searchBar.text.length) {
        self.isHistory = NO;
    }else{
        self.isHistory = YES;
    }
    [self.myTableView reloadData];
    
}

#pragma mark -- tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.isHistory) return 1;
    return self.dataList.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.isHistory) return self.historyList.count;
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isHistory) {
        HistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"historyCell"];
        cell.nameLabel.text = self.historyList[self.historyList.count - 1 - indexPath.row];
        cell.Block = ^{
            [DiscountPrise deletedHistory:self.historyList[self.historyList.count - 1 - indexPath.row]];
            [tableView reloadData];
        };
        return cell;
    }
    if (indexPath.section == 0) {
        FollowCell *cell = [tableView dequeueReusableCellWithIdentifier:@"followCell"];
        cell.nameLabel.text = self.searchBar.text;
        cell.followBtn.selected = _isFollow;
        cell.followBtn.backgroundColor = _isFollow ? [UIColor lightGrayColor] : mAppMainColor;
        cell.pushBtn.selected = _followModel.p_sign;
        [cell.pushBtn addTarget:self action:@selector(requestPush:) forControlEvents:UIControlEventTouchUpInside];
        [cell.followBtn addTarget:self action:@selector(requestFollow:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    SearchCellTableViewCell * cell = [[[NSBundle mainBundle]loadNibNamed:@"SearchCellTableViewCell" owner:nil options:nil] lastObject];
    DiscountModel * model = self.dataList[indexPath.section - 1];
    cell.model = model;
    cell.goLinkBlock = ^{
        if([model.go_link[@"link"] rangeOfString:@"taobao.com"].location != NSNotFound || [model.go_link[@"link"] rangeOfString:@"tmall.com"].location != NSNotFound){
            NSString *taobao_schema = model.go_link[@"link"];
            if([taobao_schema rangeOfString:@"https"].location != NSNotFound){
                taobao_schema = [taobao_schema stringByReplacingOccurrencesOfString:@"https" withString:@"taobao"];
            }
            if([taobao_schema rangeOfString:@"http"].location != NSNotFound){
                taobao_schema = [taobao_schema stringByReplacingOccurrencesOfString:@"http" withString:@"taobao"];
            }
            if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:(taobao_schema)]]){
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:(taobao_schema)]];
            }
            else{
                GoLinkWebViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"goLinkWebViewController"];
                controller.webUrl = model.go_link[@"link"];
                controller.title = @"返回白菜哦";//model.go_link[@"name"];
                [self.navigationController pushViewController:controller animated:YES];
            }
        }
        else{
        GoLinkWebViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"goLinkWebViewController"];
        controller.webUrl = model.go_link[@"link"];
        controller.title = @"返回白菜哦";
        [self.navigationController pushViewController:controller animated:YES];
        }
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isHistory) return 44;
    if (indexPath.section == 0) return 44;
    return 130;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.isHistory) return 0.01;
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isHistory) {
        self.isHistory = NO;
        self.searchBar.text = self.historyList[self.historyList.count - 1 - indexPath.row];
        [tableView.mj_header beginRefreshing];
    }else{
        if (indexPath.section == 0) return;
        DetailInfoViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"detailInfoViewController"];
        DiscountModel *model = self.dataList[indexPath.section - 1];
        controller.shopid = model.shopid;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (BOOL)isLogin{
    if ([UserDefaultsGetSynchronize(@"login") isEqualToString:@"10001"]) return YES;
    
    LoginViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"loginViewController"];
    [self.navigationController pushViewController:controller animated:YES];
    return NO;
    
}

- (void)addTag:(BOOL)isAddTag{
    NSMutableSet *pushSet = [NSMutableSet set];
    for (int i = 0; i < 24; i ++) {
        FollowCell *cell = [self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        NSString *newTag = cell.nameLabel.text;
        if ([UserDefaultsGetSynchronize(@"opensettime") isEqualToString:@"10001"]){
            int start = 0;
            int end = 0;
            if (UserDefaultsGetSynchronize(@"startTime")) start  = [UserDefaultsGetSynchronize(@"startTime") intValue];
            if (UserDefaultsGetSynchronize(@"endTime")) end = [UserDefaultsGetSynchronize(@"endTime") intValue];
            if (i < start || i >= end) {
                if ([UserDefaultsGetSynchronize(@"opensound") isEqualToString:@"9999"]){
                    newTag = [NSString stringWithFormat:@"%@_silent_%d",newTag,i];
                }else{
                    newTag = [NSString stringWithFormat:@"%@_%d",newTag,i];
                }
            }else{
                newTag = @"";
            }
        }else{
            if ([UserDefaultsGetSynchronize(@"opensound") isEqualToString:@"9999"]){
                newTag = [NSString stringWithFormat:@"%@_silent_%d",newTag,i];
                
            }else{
                
            }
        }
        if (newTag.length) {
            newTag = [[newTag stringByReplacingOccurrencesOfString:@" " withString:@"|"] stringByReplacingOccurrencesOfString:@"-" withString:@"|"];
            [pushSet addObject:newTag];
        }
    }
    for (NSString *string in pushSet) {
        NSLog(@"%@",string);
    }
    NSLog(@"%ld",pushSet.count);
    self.view.userInteractionEnabled = NO;
    if (isAddTag) {
        [JPUSHService addTags:pushSet completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
            NSLog(@"%ld--%@--%ld",iResCode,iTags,seq);
            self.view.userInteractionEnabled = YES;
        } seq:1];
    }else{
        [JPUSHService deleteTags:pushSet completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
            NSLog(@"%ld--%@--%ld",iResCode,iTags,seq);
            self.view.userInteractionEnabled = YES;
        } seq:1];
    }
}

@end
