
//
//  HomeViewController.m
//  CabbageNet
//
//  Created by MacAir on 2017/4/7.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import "HomeViewController.h"
#import "AdvertisementCell.h"
#import "HomeBtnCell.h"
#import "NewsInfoCell.h"
#import "HeadNewsCell.h"
#import "HotGoodsCell.h"
#import "SendBtn.h"
#import "ExchangeViewController.h"
#import "CouponViewController.h"
#import "DetailInfoViewController.h"
#import "BaseNavigationController.h"
#import "DiscountViewController.h"
#import "OriginalViewController.h"
#import "DiscountModel.h"
#import "SearchCellTableViewCell.h"
#import "GoLinkWebViewController.h"
#import "SearchViewController.h"
#import "LoginViewController.h"
#import "StartView.h"

#define btnTitleArray @[@"国内",@"海淘",@"积分兑换",@"9.9元包邮",@"热门晒单",@"热门攻略",@"热门爆料",@"优惠券"]

@interface HomeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UISearchBarDelegate>

@property (nonatomic , strong)UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic , strong)NSMutableArray *array;
@property (nonatomic , strong)NSMutableArray *hourHotArray;
@property (nonatomic , strong)NSMutableArray *dayHotArray;
@property (nonatomic , strong)NSArray * adData;

@end

@implementation HomeViewController{
    NSInteger _curPage;
    StartView *startView;
    NSTimer *_timer;
}

- (UISearchBar *)searchBar{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.delegate = self;
        _searchBar.searchBarStyle = UISearchBarStyleMinimal;
        _searchBar.placeholder = @"请输入想要搜索的商品";
        [_searchBar setImage:[UIImage imageNamed:@"搜索"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
        [_searchBar setImage:[UIImage imageNamed:@"删除编辑"] forSearchBarIcon:UISearchBarIconClear state:UIControlStateNormal];
        
        _searchBar.barTintColor  = [UIColor redColor];
        
        UITextField * searchField = [_searchBar valueForKey:@"_searchField"];
        searchField.textColor = toPCcolor(@"#999999");
        [searchField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    }
    return _searchBar;
}

- (NSMutableArray *)array{
    if (!_array) {
        _array = [NSMutableArray array];
    }
    return _array;
}
- (NSMutableArray *)hourHotArray{
    if (!_hourHotArray) {
        _hourHotArray = [NSMutableArray array];
    }
    return _hourHotArray;
}
- (NSMutableArray *)dayHotArray{
    if (!_dayHotArray) {
        _dayHotArray = [NSMutableArray array];
    }
    return _dayHotArray;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    if ([UserDefaultsGetSynchronize(@"showStart") isEqualToString:@"10001"]) {
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        startView = [StartView getStartView];
        startView.frame = [UIScreen mainScreen].bounds;
        __weak typeof(startView)weakStart = startView;
        __weak typeof(self)weakSelf = self;
        startView.Block = ^{
            
            DetailInfoViewController * VC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"detailInfoViewController"];
            VC.shopid = @"275535";
          //  BaseNavigationController * Nav = [[BaseNavigationController alloc]initWithRootViewController:VC];
           // [self.window.rootViewController presentViewController:Nav animated:YES completion:nil];
            
     //       GoLinkWebViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"goLinkWebViewController"];
  //          controller.webUrl = @"http://www.baicaio.com/item/275535.html";
            [weakSelf.navigationController pushViewController:VC animated:YES];
            [weakStart removeFromSuperview];
            UserDefaultsSynchronize(@"9999", @"showStart");
        };
        [window addSubview:startView];
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        _timer = [NSTimer timerWithTimeInterval:3.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
            [_timer invalidate];
            _timer = nil;
            [startView removeFromSuperview];
            UserDefaultsSynchronize(@"9999", @"showStart");
        }];
        
        NSRunLoop *loop = [NSRunLoop currentRunLoop];
        [loop addTimer:_timer forMode:NSRunLoopCommonModes];
    }else{
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
//    self.navigationController.navigationBar.hidden = NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.titleView = self.searchBar;
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _curPage = 1;
        [self requestDate];
        [self requestHourHot];
        [self requestdayHot];
        [self requestADdata];
    }];
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        
        _curPage ++;
        [self requestDate];
    }];
    [self.collectionView.mj_header beginRefreshing];
}

#pragma mark -- 当前最热数据
-(void)requestHourHot
{
    NSMutableDictionary * infoDic = [[NSMutableDictionary alloc]init];
    setDickeyobj(infoDic, @"hourday", @"api");
    setDickeyobj(infoDic, @"1", @"type");
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    setDickeyobj(param, infoDic, @"reqBody");
    [CKHttpCommunicate createRequest:HTTP_SHOP_API WithParam:param withMethod:POST success:^(id result) {
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        if (SUCCESS_REQUEST(result)) {
            [self.hourHotArray removeAllObjects];
            for (NSDictionary *dic in result[@"data"]) {
                DiscountModel *model = [[DiscountModel alloc] init];
                [model mj_setKeyValues:dic];
                [self.hourHotArray addObject:model];
            }
            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:3]];
        }else{
//            [MBProgressHUD showError:result[@"msg"] toView:nil];
        }
        
    } failure:^(NSError *erro) {
        [self.collectionView.mj_footer endRefreshing];
        [self.collectionView.mj_header endRefreshing];
        NSLog(@"%@",erro);
    } showHUD:nil];
}
#pragma mark -- 广告
-(void)requestADdata
{
    NSMutableDictionary * infoDic = [[NSMutableDictionary alloc]init];
    setDickeyobj(infoDic, @"adb", @"api");
    setDickeyobj(infoDic, @"16", @"adid");
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    setDickeyobj(param, infoDic, @"reqBody");
    [CKHttpCommunicate createRequest:HTTP_SHOP_API WithParam:param withMethod:POST success:^(id result) {
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        if (SUCCESS_REQUEST(result)) {
            self.adData = result[@"data"];
            NSLog(@"%@----%@",self.adData,result[@"data"]);
            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
        }else{
            self.adData = [NSMutableArray array];
//            [MBProgressHUD showError:result[@"msg"] toView:nil];
        }
        
    } failure:^(NSError *erro) {
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        NSLog(@"%@",erro);
    } showHUD:nil];
}
#pragma mark -- 24小时最热数据
-(void)requestdayHot
{
    NSMutableDictionary * infoDic = [[NSMutableDictionary alloc]init];
    setDickeyobj(infoDic, @"hourday", @"api");
    setDickeyobj(infoDic, @"0", @"type");
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    setDickeyobj(param, infoDic, @"reqBody");
    [CKHttpCommunicate createRequest:HTTP_SHOP_API WithParam:param withMethod:POST success:^(id result) {
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        if (SUCCESS_REQUEST(result)) {
            [self.dayHotArray removeAllObjects];
            for (NSDictionary *dic in result[@"data"]) {
                DiscountModel *model = [[DiscountModel alloc] init];
                [model mj_setKeyValues:dic];

                [self.dayHotArray addObject:model];
            }
            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:5]];
        }else{
//            [MBProgressHUD showError:result[@"msg"] toView:nil];
        }
        
    } failure:^(NSError *erro) {
        [self.collectionView.mj_footer endRefreshing];
        [self.collectionView.mj_header endRefreshing];
        NSLog(@"%@",erro);
    } showHUD:nil];
}
#pragma mark -- 请求数据
- (void)requestDate{
    
    NSMutableDictionary * infoDic = [[NSMutableDictionary alloc]init];
    setDickeyobj(infoDic, @"shoplist", @"api");
    setDickeyobj(infoDic, @"2", @"tp");

    NSString *pageStr = [NSString stringWithFormat:@"%ld",_curPage];
    setDickeyobj(infoDic, pageStr , @"page");
//    setDickeyobj(infoDic, @"14", @"pagesize");//分页条数， 即几条为一页，不填则默认为 10
    
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    setDickeyobj(param, infoDic, @"reqBody");
    [CKHttpCommunicate createRequest:HTTP_SHOP_API WithParam:param withMethod:POST success:^(id result) {
        
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        
        if (SUCCESS_REQUEST(result)) {
            
            if (_curPage == 1) {
                [self.array removeAllObjects];
            }
            for (NSDictionary *dic in result[@"data"]) {
                
                DiscountModel *model = [[DiscountModel alloc] init];
                [model mj_setKeyValues:dic];
                [self.array addObject:model];
                
            }
            
            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:7]];
            
        }else{
//            [MBProgressHUD showError:result[@"msg"] toView:nil];
        }
        
    } failure:^(NSError *erro) {
        [self.collectionView.mj_footer endRefreshing];
        [self.collectionView.mj_header endRefreshing];
        [self.array removeAllObjects];
        [self.collectionView reloadData];
        
        NSLog(@"%@",erro);
    } showHUD:nil];
    
}

#pragma mark -- searchBar delegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{

    SearchViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"searchViewController"];
    [self.navigationController pushViewController:controller animated:YES];
    return NO;
}

#pragma  mark -- collectionView delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 8;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (section == 0) return 1;
    if (section == 1) return 8;
    if (section == 2) return 1;
    if (section == 3) return MIN(5, self.hourHotArray.count);
    if (section == 4) return 1;
    if (section == 5) return MIN(5, self.dayHotArray.count);
    if (section == 6) return 1;
    if (section == 7) return self.array.count;
    return 1;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        AdvertisementCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"advertisementCell" forIndexPath:indexPath];
        if (self.adData.count) {
             cell.array = self.adData;
        }
        cell.returnTapAdIndex = ^(NSInteger index) {
            if (self.adData.count) {
                GoLinkWebViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"goLinkWebViewController"];
                controller.webUrl =self.adData[index][@"url"];
                controller.title = @"广告链接";
                [self.navigationController pushViewController:controller animated:YES];
            }
        };
        return cell;
    }else if (indexPath.section == 1){
        HomeBtnCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"homeBtnCell" forIndexPath:indexPath];
        cell.imageView.image = [UIImage imageNamed:btnTitleArray[indexPath.row]];
        cell.titleLabel.text = btnTitleArray[indexPath.row];
        return cell;
    }else if(indexPath.section == 2){
        
        HeadNewsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"headNewsCell" forIndexPath:indexPath];
        cell.statusImage.image = [UIImage imageNamed:@"ic_home_hot_1"];
        return cell;
        
    }else if (indexPath.section == 3){
        
        HotGoodsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"hotGoodsCell" forIndexPath:indexPath];
        DiscountModel * model = self.hourHotArray[indexPath.row];
        cell.model = self.hourHotArray[indexPath.row];
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
            controller.title = @"返回白菜哦";//model.go_link[@"name"];
            [self.navigationController pushViewController:controller animated:YES];
            
        }
        };
        return cell;
        
    }else if (indexPath.section == 4){
        
        HeadNewsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"headNewsCell" forIndexPath:indexPath];
        cell.statusImage.image = [UIImage imageNamed:@"ic_home_hot_2"];
        return cell;
        
    }else if(indexPath.section == 5){
        
        HotGoodsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"hotGoodsCell" forIndexPath:indexPath];
        DiscountModel * model = self.dayHotArray[indexPath.row];
        cell.model = self.dayHotArray[indexPath.row];
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
            controller.title = @"返回白菜哦";//model.go_link[@"name"];
            [self.navigationController pushViewController:controller animated:YES];
            }
        };
        return cell;
        
        
    }else if(indexPath.section == 6){
        NSLog(@"====");
        HeadNewsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"headNewsCell" forIndexPath:indexPath];
        cell.statusImage.image = [UIImage imageNamed:@"ic_home_hot_3"];
        return cell;
        
    }else if (indexPath.section == 7){
        
        HotGoodsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"hotGoodsCell" forIndexPath:indexPath];
        DiscountModel * model = self.array[indexPath.row];
        cell.model = self.array[indexPath.row];
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
            controller.title = @"返回白菜哦";//model.go_link[@"name"];
            [self.navigationController pushViewController:controller animated:YES];
            }
        };
        return cell;
        
    }
    return nil;

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0 && self.adData.count) return CGSizeMake(mScreenWidth, mScreenWidth/3);
    else if (indexPath.section == 1) return CGSizeMake(mScreenWidth/4, 110);
    else if (indexPath.section == 2) return CGSizeMake(mScreenWidth, 30);
    else if (indexPath.section == 3) return CGSizeMake(mScreenWidth, 125);
    else if (indexPath.section == 4) return CGSizeMake(mScreenWidth, 30);
    else if (indexPath.section == 5) return CGSizeMake(mScreenWidth, 125);
    else if (indexPath.section == 6) return CGSizeMake(mScreenWidth, 30);
    else if (indexPath.section == 7) return CGSizeMake(mScreenWidth, 125);
    return CGSizeMake(mScreenWidth, 0.01);

}
//这个是两行cell之间的间距（上下行cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    if (section == 1) return -20;
    if (section > 1) return 5;
    return 0;
}
//两个cell之间的间距（同一行的cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 2) {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            self.tabBarController.selectedIndex = 1;
            BaseNavigationController *nav = self.tabBarController.viewControllers[1];
            DiscountViewController *controller = nav.childViewControllers[0];
            controller.topBtnTag = 2;
        }else if (indexPath.row == 1){
            self.tabBarController.selectedIndex = 1;
            BaseNavigationController *nav = self.tabBarController.viewControllers[1];
            DiscountViewController *controller = nav.childViewControllers[0];
            controller.topBtnTag = 3;
        }else if (indexPath.row == 2){
            if ([self isLogin]) {
                ExchangeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"exchangeViewController"];
                [self.navigationController pushViewController:controller animated:YES];
            }
        }else if (indexPath.row == 3){
            self.tabBarController.selectedIndex = 1;
            BaseNavigationController *nav = self.tabBarController.viewControllers[1];
            DiscountViewController *controller = nav.childViewControllers[0];
            controller.topBtnTag = 4;
        }else if (indexPath.row == 4){
            OriginalViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"originalViewController"];
            controller.selectTopBtnTag = 2;
            [self.navigationController pushViewController:controller animated:YES];
          }else if (indexPath.row == 5){
              OriginalViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"originalViewController"];
              controller.selectTopBtnTag = 1;
              [self.navigationController pushViewController:controller animated:YES];
        }else if (indexPath.row == 6){
            self.tabBarController.selectedIndex = 1;
            BaseNavigationController *nav = self.tabBarController.viewControllers[1];
            DiscountViewController *controller = nav.childViewControllers[0];
            controller.topBtnTag = 5;
        }else if (indexPath.row == 7){
            if ([self isLogin]) {
                CouponViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"couponViewController"];
                [self.navigationController pushViewController:controller animated:YES];
            }
        }
    }
    if (!self.array.count) {
        return;
    }
    if (indexPath.section == 3 || indexPath.section == 5 || indexPath.section == 7) {
        DetailInfoViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"detailInfoViewController"];
        DiscountModel *model = [[DiscountModel alloc] init];
        if (indexPath.section == 3) model = self.hourHotArray[indexPath.row];
        if (indexPath.section == 5) model = self.dayHotArray[indexPath.row];
        if (indexPath.section == 7) model = self.array[indexPath.row];
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

@end
