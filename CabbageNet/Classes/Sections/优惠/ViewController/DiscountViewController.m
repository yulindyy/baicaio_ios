//
//  DiscountViewController.m
//  CabbageNet
//
//  Created by MacAir on 2017/4/7.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import "DiscountViewController.h"
#import "HotGoodsCell.h"
#import "DiscountCollectionCell.h"
//#import "TopBtnScrollView.h"
#import "DetailInfoViewController.h"
#import "ScreenViewController.h"
#import "DiscountModel.h"
#import "SearchCellTableViewCell.h"
#import "GoLinkWebViewController.h"
#import "Masonry.h"
#import "SearchViewController.h"
#import "TopBtnView.h"

@interface DiscountViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UISearchBarDelegate>

//@property (nonatomic , strong)TopBtnScrollView *topBtnView;
@property (nonatomic , strong)TopBtnView *topBtnView;
@property (nonatomic , strong)NSMutableArray *array;
@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;
@property(nonatomic,strong)NSMutableArray * searchResuletArr;
@property (nonatomic,strong)  UIButton *leftBtn;

@end

@implementation DiscountViewController{
    NSInteger _curPage;
    BOOL _jumpRefresh;
    NSString *_cid;
    NSString *_cidName;
    NSString *_orig_id;
    NSString *_origName;
}

- (NSMutableArray *)array{
    if (!_array) {
        _array = [NSMutableArray array];
    }
    return _array;
}

//- (TopBtnScrollView *)topBtnView{
//    
//    if (!_topBtnView) {
//        _topBtnView = [[TopBtnScrollView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, 44) titleBtnArr:@[@"全部",@"国内",@"海淘",@"9.9元包邮"/*,@"白菜价"*/,@"爆料"]];
//        
//        __weak typeof(self)weakSelf = self;
//        _topBtnView.block = ^(NSInteger tag){
//            
//            weakSelf.topBtnTag = tag;
//            [weakSelf.myCollectionView.mj_header beginRefreshing];
//            
//        };
//        
//    }
//    return _topBtnView;
//}
- (TopBtnView *)topBtnView{
    if (!_topBtnView) {
        _topBtnView = [[TopBtnView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, 44) titleBtnArr:@[@"全部",@"国内",@"海淘",@"9.9元包邮",@"爆料"]];
        
        __weak typeof(self)weakSelf = self;
        _topBtnView.block = ^(NSInteger tag){
            
            weakSelf.topBtnTag = tag;
            [weakSelf.myCollectionView.mj_header beginRefreshing];
            
        };
    }
    return _topBtnView;
}

- (UISearchBar *)searchBar{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] init];
        
        _searchBar.delegate = self;
        _searchBar.searchBarStyle = UISearchBarStyleMinimal;
        _searchBar.placeholder = @"请输入想要搜索的商品";
        [_searchBar setImage:[UIImage imageNamed:@"搜索"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
        [_searchBar setImage:[UIImage imageNamed:@"删除编辑"] forSearchBarIcon:UISearchBarIconClear state:UIControlStateNormal];
        
        UITextField * searchField = [_searchBar valueForKey:@"_searchField"];
        searchField.textColor = [UIColor whiteColor];
        [searchField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
        
    }
    return _searchBar;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
    if (!_jumpRefresh) {
        [self.topBtnView btnActionChange:self.topBtnTag];
    }
    _jumpRefresh = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [self.searchBar endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _cid = @"";
    _orig_id = @"";
    
    self.navigationItem.titleView = self.searchBar;
    [self.view addSubview:self.topBtnView];
     self.searchResuletArr = [[NSMutableArray alloc]init];
    if (self.topBtnTag < 1) self.topBtnTag = 1;
    _curPage = 1;
//    [self.leftBtn addSubview:self.contiditionLabel];
//    [self.contiditionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.offset(40);
//        make.top.offset(0);
//        make.height.mas_equalTo(22);
//    }];
//    [self.leftBtn addSubview:self.editBtn];
//    [self.editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.contiditionLabel.mas_right).offset(5);
//        make.top.offset(3);
//        make.height.mas_equalTo(16);
//        make.width.mas_equalTo(16);
//    }];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftBtn];
    
    
    self.myCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        _curPage = 1;
        [self requestDate:self.topBtnTag];
    }];
    
    self.myCollectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        _curPage ++;
        [self requestDate:self.topBtnTag];
    }];
    
}

-(UIButton *)leftBtn{
    if (!_leftBtn) {
        _leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
        //    leftBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        //    UIImage *image = [UIImage imageNamed:@"筛选"];
        [_leftBtn setTitle:@"筛选" forState:UIControlStateNormal];
        _leftBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        _leftBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        
        //    [leftBtn setImage:image forState:UIControlStateNormal];
        [_leftBtn addTarget:self action:@selector(screenBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBtn;
}

/*
//-(UILabel *)contiditionLabel
//{
//    if (!_contiditionLabel) {
//        _contiditionLabel = [[UILabel alloc]init];
////        _contiditionLabel.text = @"232";
//        _contiditionLabel.font = [UIFont systemFontOfSize:12];
//        _contiditionLabel.textColor = [UIColor whiteColor];
//        _contiditionLabel.backgroundColor = toPCcolor(@"#31AE88");
//        _contiditionLabel.layer.masksToBounds = YES;
//        _contiditionLabel.layer.cornerRadius = 11;
//        _contiditionLabel.textAlignment = NSTextAlignmentCenter;
//    }
//    return _contiditionLabel;
//}
//-(UIButton *)editBtn
//{
//    if (!_editBtn) {
//        _editBtn = [[UIButton alloc]init];
////        _editBtn.backgroundColor = [UIColor redColor];
//        [_editBtn setBackgroundImage:[UIImage imageNamed:@"ic_cancel"] forState:UIControlStateNormal];
//        [_editBtn addTarget:self action:@selector(editDel) forControlEvents:UIControlEventTouchUpInside];
//        _editBtn.hidden = YES;
//    }
//    return _editBtn;
//}
//-(void)editDel
//{
//    self.editBtn.hidden = YES;
//    self.contiditionLabel.text = @"";
//    self.leftBtn.width = 44;
//    [self.leftBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
//    [self.navigationController.navigationBar layoutSubviews];
//    _cid = @"";
//    [self.myTableView.mj_header beginRefreshing];
//}
 */
- (void)screenBtnClick:(UIButton *)sender{
    
    ScreenViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"screenViewController"];
    controller.selectedCid = _cid;
    controller.selectedCidName = _cidName;
    controller.selectedOrig = _orig_id;
    controller.selectedOrigName = _origName;
    controller.block = ^(NSString *cid , NSString * title , NSString *orig_id,NSString *origName) {
        [sender setTitle:@"筛选" forState:UIControlStateNormal];
        _cid = cid;
        _cidName = title;
        _orig_id = orig_id;
        _origName = origName;
        if (cid.length) {
            
            [sender setTitle:title forState:UIControlStateNormal];
        }
        if (orig_id.length) {
            
            [sender setTitle:origName forState:UIControlStateNormal];
        }
    };
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark -- 请求数据
- (void)requestDate:(NSInteger)tag{
    
    NSMutableDictionary * infoDic = [[NSMutableDictionary alloc]init];
    
    if (tag < 4 && tag > 0){
        setDickeyobj(infoDic, @"shoplist", @"api");
        if (tag == 1) setDickeyobj(infoDic, @"2", @"tp");//0 国内 1国外 2 不限制
        if (tag == 2) setDickeyobj(infoDic, @"0", @"tp");
        if (tag == 3) setDickeyobj(infoDic, @"1", @"tp");
        
        
    }else if (tag == 4){
        setDickeyobj(infoDic, @"tagsearch", @"api");
        setDickeyobj(infoDic, @"9.9包邮", @"tag");
        
    }else if (tag == 5){
        setDickeyobj(infoDic, @"shoplist", @"api");
        setDickeyobj(infoDic, @"2", @"tp");
        setDickeyobj(infoDic, @"1", @"isbao");
    }else {
        return;
    }
    if (_cid.length) {
        setDickeyobj(infoDic, _cid, @"cid");//筛选分类ID，如果此项不为空则tp请设置为2
    }
    
    if (_orig_id.length) {
        setDickeyobj(infoDic, _orig_id, @"orig_id");
    }

    if (self.searchBar.text.length) {
        setDickeyobj(infoDic, self.searchBar.text, @"key");//可空;模糊搜索标题
    }
    NSString *pageStr = [NSString stringWithFormat:@"%ld",_curPage];
    setDickeyobj(infoDic, pageStr , @"page");
    setDickeyobj(infoDic, @"10", @"pagesize");//分页条数， 即几条为一页，不填则默认为 10
    
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    setDickeyobj(param, infoDic, @"reqBody");
    
    if (_curPage == 1) {
        [self.array removeAllObjects];
        [self.myCollectionView reloadData];
    }
    self.topBtnView.userInteractionEnabled = NO;
    [CKHttpCommunicate createRequest:HTTP_SHOP_API WithParam:param withMethod:POST success:^(id result) {
        
        [self.myCollectionView.mj_header endRefreshing];
        [self.myCollectionView.mj_footer endRefreshing];
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
        self.topBtnView.userInteractionEnabled = YES;
    } failure:^(NSError *erro) {
        
        [self.myCollectionView.mj_header endRefreshing];
        [self.myCollectionView.mj_footer endRefreshing];
        self.topBtnView.userInteractionEnabled = YES;
        [self.array removeAllObjects];
        [self.myCollectionView reloadData];
        
        NSLog(@"%@",erro);
    } showHUD:nil];

}

#pragma mark -- searBar delegate
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar endEditing:YES];
    if (self.topBtnTag < 4) [self.topBtnView btnActionChange:1];
    else [self.topBtnView btnActionChange:self.topBtnTag];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    
    SearchViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"searchViewController"];
    [self.navigationController pushViewController:controller animated:YES];
    return NO;
}

- (void)cancelBtnClick{
    self.searchBar.text = @"";
    [self.searchBar endEditing:YES];
   
    [self.myCollectionView.mj_header beginRefreshing];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:NO animated:YES];
}

#pragma  mark -- collectionView delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.array.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.topBtnTag == 5){
        DiscountCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"discountCollectionCell" forIndexPath:indexPath];
        DiscountModel * model = self.array[indexPath.row];
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
            _jumpRefresh = YES;
            GoLinkWebViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"goLinkWebViewController"];
            controller.webUrl = model.go_link[@"link"];
            controller.title = @"返回白菜哦";
            [self.navigationController pushViewController:controller animated:YES];
            }
        };
        return cell;
    }
    HotGoodsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"hotGoodsCell" forIndexPath:indexPath];
    DiscountModel * model = self.array[indexPath.row];
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
        _jumpRefresh = YES;
        GoLinkWebViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"goLinkWebViewController"];
        controller.webUrl = model.go_link[@"link"];
        controller.title = @"返回白菜哦";
        [self.navigationController pushViewController:controller animated:YES];
        }
    };
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.topBtnTag == 5) return CGSizeMake((mScreenWidth - 15)/2, (mScreenWidth - 15)/2 + 115);
    return CGSizeMake(mScreenWidth, 125);
}

//这个是两行cell之间的间距（上下行cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
   
    return 5;
}

//两个cell之间的间距（同一行的cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    if (self.topBtnTag == 5) return 5;
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 0 && self.topBtnTag == 5) return UIEdgeInsetsMake(5, 5, 0, 5);
    return UIEdgeInsetsMake(5, 0, 0, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    DetailInfoViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"detailInfoViewController"];
    DiscountModel *model = self.array[indexPath.row];
    controller.shopid = model.shopid;
    if (self.topBtnTag == 5) controller.type = @"bl";
    _jumpRefresh = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

@end
