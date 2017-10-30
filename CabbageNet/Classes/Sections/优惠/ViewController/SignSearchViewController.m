//
//  SignSearchViewController.m
//  CabbageNet
//
//  Created by xiang fu on 2017/7/11.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import "SignSearchViewController.h"
#import "HotGoodsCell.h"
#import "GoLinkWebViewController.h"
#import "DetailInfoViewController.h"
#import "FollowCollectionCell.h"
#import "SignModel.h"
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

@interface SignSearchViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;
@property (nonatomic , strong)NSMutableArray *array;

@end

@implementation SignSearchViewController{
    NSInteger _curPage;
    BOOL _isFollow;
    BOOL _allow;//是否允许添加关注
    SignModel *_followModel;
}


- (NSMutableArray *)array{
    if (!_array) {
        _array = [NSMutableArray array];
    }
    return _array;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _curPage = 1;
    self.myCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _curPage = 1;
        [self requestData];
    }];
    
    self.myCollectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        _curPage ++;
        [self requestData];
    }];
    [self requestData];
}

#pragma mark -- 请求关注列表
- (void)requestFollowData{
    
    if (![UserDefaultsGetSynchronize(@"login") isEqualToString:@"10001"]) return ;
    
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
                if ([tagStr.lowercaseString isEqualToString:self.title.lowercaseString]) {
                    _isFollow = YES;
                    _followModel = [[SignModel alloc] init];
                    [_followModel mj_setKeyValues:dic];
                    _followModel.signID = dic[@"id"];
                    break;
                }else{
                    _followModel = [[SignModel alloc]init];
                }
            }
            [self.myCollectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]]];
        }else{
            _allow = YES;
        }
    } failure:^(NSError *erro) {
        NSLog(@"%@",erro);
    } showHUD:nil];
}

#pragma mark -- 请求搜索数据
- (void)requestData{
    
    NSMutableDictionary * infoDic = [[NSMutableDictionary alloc]init];
    if (self.orig_id.length) {
        setDickeyobj(infoDic, @"shoplist", @"api");
        setDickeyobj(infoDic, @"2", @"tp");
        setDickeyobj(infoDic, self.orig_id, @"orig_id");
    }else {
        setDickeyobj(infoDic, @"tagsearch", @"api");
        setDickeyobj(infoDic, self.title, @"tag");
    }
    
    
    NSString *pageStr = [NSString stringWithFormat:@"%ld",_curPage];
    setDickeyobj(infoDic, pageStr , @"page");
    setDickeyobj(infoDic, @"10", @"pagesize");//分页条数， 即几条为一页，不填则默认为 10
    
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    setDickeyobj(param, infoDic, @"reqBody");
    [CKHttpCommunicate createRequest:HTTP_SHOP_API WithParam:param withMethod:POST success:^(id result) {
        
        [self.myCollectionView.mj_header endRefreshing];
        [self.myCollectionView.mj_footer endRefreshing];
        
        if (_curPage == 1) {
            [self.array removeAllObjects];
            [self.myCollectionView reloadData];
            [self requestFollowData];
        }
        if (SUCCESS_REQUEST(result)) {
            for (NSDictionary *dic in result[@"data"]) {
                DiscountModel *model = [[DiscountModel alloc] init];
                [model mj_setKeyValues:dic];
                [self.array addObject:model];
            }
            [self.myCollectionView reloadData];
            
        }else{
            [MBProgressHUD showError:result[@"msg"] toView:nil];
        }
        
    } failure:^(NSError *erro) {
        [self.myCollectionView.mj_header endRefreshing];
        [self.myCollectionView.mj_footer endRefreshing];
        [self.array removeAllObjects];
        [self.myCollectionView reloadData];
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
        setDickeyobj(infoDic, self.title, @"tag");
    }else{//取消关注
        setDickeyobj(infoDic, @"follow_tag_del", @"api");
        UserInfoModel *model = [UserInfoModel sharedUserData];
        setDickeyobj(infoDic, model.userid, @"userid");
        setDickeyobj(infoDic, self.title, @"tag");
    }
    
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    setDickeyobj(param, infoDic, @"reqBody");
    
    [CKHttpCommunicate createRequest:HTTP_USER_API WithParam:param withMethod:POST success:^(id result) {
        [self requestFollowData];
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
        setDickeyobj(infoDic, self.title, @"tag");
    }else{
        setDickeyobj(infoDic, @"notify_tag_del", @"api");
        setDickeyobj(infoDic, _followModel.signID, @"id");
    }
    UserInfoModel *model = [UserInfoModel sharedUserData];
    setDickeyobj(infoDic, model.userid, @"userid");
    
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    setDickeyobj(param, infoDic, @"reqBody");
    [CKHttpCommunicate createRequest:HTTP_USER_API WithParam:param withMethod:POST success:^(id result) {
        if (SUCCESS_REQUEST(result)){
            if (sender.selected){
                if (![UserDefaultsGetSynchronize(@"openjpush") isEqualToString:@"9999"]) {
                    [self addTag:YES];
                }
                [MBProgressHUD showError:@"添加推送成功" toView:nil];
            }else{
                [self addTag:NO];
                [MBProgressHUD showError:@"取消推送成功" toView:nil];
            }
            NSLog(@"%@",result[@"msg"]);
            [self requestFollowData];
        }else{
            [MBProgressHUD showError:result[@"msg"] toView:nil];
        }
    } failure:^(NSError *erro) {
        NSLog(@"%@",erro);
    } showHUD:nil];
}

#pragma  mark -- collectionView delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.array.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        FollowCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"followCollectionCell" forIndexPath:indexPath];
        cell.nameLabel.text = self.title;
        cell.followBtn.selected = _isFollow;
        cell.followBtn.backgroundColor = _isFollow ? [UIColor lightGrayColor] : mAppMainColor;
        cell.pushBtn.selected = _followModel.p_sign;
        [cell.followBtn  addTarget:self action:@selector(requestFollow:) forControlEvents:UIControlEventTouchUpInside];
        [cell.pushBtn addTarget:self action:@selector(requestPush:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    
    HotGoodsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"hotGoodsCell" forIndexPath:indexPath];
    DiscountModel * model = self.array[indexPath.row - 1];
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
        if (model.go_link[@"name"]) controller.title = model.go_link[@"name"];
        [self.navigationController pushViewController:controller animated:YES];
        }
    };
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) return CGSizeMake(mScreenWidth, 44);
    return CGSizeMake(mScreenWidth, 125);
}

//这个是两行cell之间的间距（上下行cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 5;
}

//两个cell之间的间距（同一行的cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 0, 0, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == 0) return;
    DiscountModel *model = self.array[indexPath.row];
    if (self.block) self.block(model.shopid);
    [self.navigationController popViewControllerAnimated:YES];
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
        NSString *newTag = self.title;
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
