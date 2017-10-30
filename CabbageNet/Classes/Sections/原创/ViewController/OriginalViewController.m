//
//  OriginalViewController.m
//  CabbageNet
//
//  Created by MacAir on 2017/4/5.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import "OriginalViewController.h"
#import "OriginalInfoCell.h"
#import "TopBtnView.h"
#import "OriginalDetailViewController.h"
#import "OriginalModel.h"

typedef NS_ENUM(NSInteger , selectedState) {
    SEL_ALL = 1,    //全部
    SEL_BROKE,      //爆料
    SEL_STRATEGY,   //攻略
    SEL_SUN         //晒单
};

@interface OriginalViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic , strong)TopBtnView *topBtnView;
@property (nonatomic , strong)UISearchBar *searchBar;
@property (nonatomic , strong)NSMutableArray *array;

@end

@implementation OriginalViewController{
    UIButton *newBtn;
    UIButton *hotBtn;
    NSInteger _hotOrNew;
    BOOL _jumpRefresh;
    NSInteger _currPage;
}

- (NSMutableArray *)array{
    if (!_array) {
        _array = [NSMutableArray array];
    }
    return _array;
}

- (UISearchBar *)searchBar{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(44, 0, mScreenWidth - 184, 44)];
        _searchBar.searchBarStyle = UISearchBarStyleMinimal;
        _searchBar.delegate = self;
        _searchBar.placeholder = @"请输入关键字";
        [_searchBar setImage:[UIImage imageNamed:@"删除编辑"] forSearchBarIcon:UISearchBarIconClear state:UIControlStateNormal];
        [_searchBar setImage:[UIImage imageNamed:@"搜索"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
        
        UITextField * searchField = [_searchBar valueForKey:@"_searchField"];
        searchField.textColor = [UIColor whiteColor];
        [searchField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
        
    }
    return _searchBar;
}

- (TopBtnView *)topBtnView{
    if (!_topBtnView) {
        _topBtnView = [[TopBtnView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, 44) titleBtnArr:@[/*@"全部",*/@"攻略",@"晒单"]];
        
        __weak typeof(self)weakSelf = self;
        _topBtnView.block = ^(NSInteger tag){
            
            weakSelf.selectTopBtnTag = tag;
            [weakSelf.myTableView.mj_header beginRefreshing];
            
        };
    }
    return _topBtnView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _hotOrNew = 0;
    _currPage = 1;
    

    self.myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        _currPage = 1;
        [self requestDate];
    }];
    
    self.myTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        
        _currPage ++;
        [self requestDate];
    }];
    
    [self.view addSubview:self.topBtnView];
    [self setNav];


}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    if (!_jumpRefresh) {
        if (self.selectTopBtnTag == 0) self.selectTopBtnTag = 1;
        [self.topBtnView btnActionChange:self.selectTopBtnTag];
    }
    _jumpRefresh = NO;
}

- (void)setNav{
    self.navigationItem.titleView = self.searchBar;//[[UIBarButtonItem alloc] initWithCustomView: self.searchBar];
    
    newBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 11, 44, 22)];
    [newBtn setTitle:@"最新" forState:UIControlStateNormal];
    newBtn.backgroundColor = [UIColor whiteColor];
    [newBtn setTitleColor:mAppMainColor forState:UIControlStateNormal];
    newBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    
    newBtn.layer.cornerRadius = 5;
    newBtn.layer.masksToBounds = YES;
    
    newBtn.tag = 1;
    [newBtn addTarget:self action:@selector(newBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *newBtnItem = [[UIBarButtonItem alloc] initWithCustomView:newBtn];
    
    hotBtn = [[UIButton alloc] initWithFrame:CGRectMake(44, 11, 44, 22)];
    [hotBtn setTitle:@"精华" forState:UIControlStateNormal];
    hotBtn.backgroundColor = mAppMainColor;
    hotBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    
    hotBtn.layer.cornerRadius = 5;
    hotBtn.layer.masksToBounds = YES;

    [hotBtn addTarget:self action:@selector(hotBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *hotBtnItem = [[UIBarButtonItem alloc] initWithCustomView:hotBtn];
    
//    self.navigationItem.rightBarButtonItems = @[hotBtnItem,newBtnItem];
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 88, 44)];
    rightView.backgroundColor = [UIColor clearColor];
    [rightView addSubview:newBtn];
    [rightView addSubview:hotBtn];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, 22, 44)];
    [backBtn setImage:[UIImage imageNamed:@"返回"]  forState:UIControlStateNormal];
    backBtn.imageEdgeInsets = UIEdgeInsetsMake(12, 0, 12, 4);
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
}

- (void)backBtnClick{
    if (self.presentingViewController){
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)requestDate{
    NSMutableDictionary * infoDic = [[NSMutableDictionary alloc]init];
    setDickeyobj(infoDic, @"article", @"api");
    
    NSString *hotOrNewStr = [NSString string];
    if (_hotOrNew == 0) hotOrNewStr = @"0";
    if (_hotOrNew == 1) hotOrNewStr = @"1";
    setDickeyobj(infoDic, hotOrNewStr, @"isbest");
    
//    if (self.selectTopBtnTag == 1) topSelectStr = @"0";
    if (self.selectTopBtnTag == 1) setDickeyobj(infoDic, @"9", @"cate_id")
    else if (self.selectTopBtnTag == 2) setDickeyobj(infoDic, @"10", @"cate_id")
    
    if (self.searchBar.text) setDickeyobj(infoDic, self.searchBar.text, @"key");
    
    NSString *pagestr = [NSString stringWithFormat:@"%ld",_currPage];
    setDickeyobj(infoDic, pagestr, @"page");
    
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    
    setDickeyobj(param, infoDic, @"reqBody");
    [CKHttpCommunicate createRequest:HTTP_ORIGINAL_API WithParam:param withMethod:POST success:^(id result) {
        
        [self.myTableView.mj_footer endRefreshing];
        [self.myTableView.mj_header endRefreshing];
    
        if (_currPage == 1) {
            [self.array removeAllObjects];
            [self.myTableView reloadData];
        }
        if (SUCCESS_REQUEST(result)) {
            
            for (NSDictionary *dic in result[@"data"]) {
                
                OriginalModel *model = [[OriginalModel alloc] init];
                [model mj_setKeyValues:dic];
                [self.array addObject:model];
                
            }
            [self.myTableView reloadData];
        
        }else{
            [MBProgressHUD showError:result[@"msg"] toView:nil];
        }
    } failure:^(NSError *erro) {
        
        [self.myTableView.mj_footer endRefreshing];
        [self.myTableView.mj_header endRefreshing];
        [self.array removeAllObjects];
        [self.myTableView reloadData];
        NSLog(@"%@",erro);
    } showHUD:nil];
}

- (void)newBtnClick{
    _hotOrNew = 0;
    
    [self.myTableView.mj_header beginRefreshing];
    [self clickBtn:newBtn andOther:hotBtn];
}

- (void)hotBtnClick{
    _hotOrNew = 1;
    
    [self.myTableView.mj_header beginRefreshing];
    [self clickBtn:hotBtn andOther:newBtn];
}

- (void)clickBtn:(UIButton *)clickBtn andOther:(UIButton *)otherBtn{
    
    clickBtn.backgroundColor = [UIColor whiteColor];
    [clickBtn setTitleColor:mAppMainColor forState:UIControlStateNormal];
    
    otherBtn.backgroundColor = mAppMainColor;
    [otherBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

#pragma mark -- searBar delegate
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar endEditing:YES];
    [self.topBtnView btnActionChange:1];
    NSLog(@"%@",searchBar.text);
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    searchBar.showsCancelButton = YES;
    for(UIView *view in  [[[_searchBar subviews] objectAtIndex:0] subviews]) {
        if([view isKindOfClass:[NSClassFromString(@"UINavigationButton") class]]) {
            UIButton * cancel =(UIButton *)view;
            [cancel setTitle:@"取消" forState:UIControlStateNormal];
            cancel.titleLabel.font = [UIFont systemFontOfSize:14];
            [cancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [cancel addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
            CGRect frame = cancel.frame;
            frame.size.width = 40;
            cancel.frame = frame;
            
        }
    }
    [searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}

- (void)cancelBtnClick{
    self.searchBar.text = @"";
    [self.myTableView.mj_header beginRefreshing];
    [self.searchBar endEditing:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:NO animated:YES];
}


#pragma mark -- tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.array.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OriginalInfoCell *cell = [OriginalInfoCell getOriginalInfoCell];
    cell.model = self.array[indexPath.section];
    cell.signLabel.hidden = YES;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return (mScreenWidth - 30)/2 + 120;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OriginalDetailViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"originalDetailViewController"];
    OriginalModel *model = self.array[indexPath.section];
    controller.articleid = model.articleid;
    _jumpRefresh = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.searchBar endEditing:YES];
}

@end
