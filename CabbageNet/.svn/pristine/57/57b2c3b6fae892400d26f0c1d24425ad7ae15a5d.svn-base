//
//  ScreenViewController.m
//  CabbageNet
//
//  Created by MacAir on 2017/4/8.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import "ScreenViewController.h"
#import "ScreenPriceCell.h"
#import "ScreenBtnCell.h"
#import "ScreenModel.h"
#import "ScreenCollectionCell.h"

#define btnCidArray @[@"",@"333",@"334",@"336",@"116",@"338",@"335",@"1",@"115",@"339",@"340",@"50",@"102",@"114",@"337",@"341",@"342"]
@interface ScreenViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong)NSMutableArray *array;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic , strong)NSMutableArray *screenArr;

@end

@implementation ScreenViewController{
    NSString *_cid;
    NSString *_cidTitle;
    CGFloat _rowHeight;
    NSString *_orig_id;
    NSString *_origName;
}

- (NSMutableArray *)screenArr{
    if (!_screenArr) {
        _screenArr = [NSMutableArray array];
    }
    return _screenArr;
}

- (NSMutableArray *)array{
    if (!_array) {
        
        _array = [NSMutableArray array];
        _array = [NSMutableArray arrayWithObjects:@"全部",@"个护化妆",@"保健养生",@"图书音像",@"数码家电",@"旅游休闲",@"日用百货",@"服装鞋帽",@"母婴玩具",@"电影资讯",@"眼镜配饰",@"箱包手袋",@"运动户外",@"钟表首饰",@"食品酒饮",@"杂七杂八",@"活动公告", nil];
    }
    return _array;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _cid = self.selectedCid;
    _cidTitle = self.selectedCidName;
    _orig_id = self.selectedOrig;
    _origName = self.selectedOrigName;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定"  style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnClick)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    
    [self requestData];
    
}

- (void)requestData{
    NSMutableDictionary * infoDic = [[NSMutableDictionary alloc]init];
    setDickeyobj(infoDic, @"getorig", @"api");
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    setDickeyobj(param, infoDic, @"reqBody");
    
    [CKHttpCommunicate createRequest:HTTP_SHOP_API WithParam:param withMethod:POST success:^(id result) {
        
        if (SUCCESS_REQUEST(result)) {
            ScreenModel *model = [[ScreenModel alloc] init];
            model.name = @"全部";
            model.screenID = @"";
            [self.screenArr addObject:model];
            for (NSDictionary *dic in result[@"data"]) {
                ScreenModel *model = [[ScreenModel alloc] init];
                [model mj_setKeyValues:dic];
                model.screenID = dic[@"id"];
                [self.screenArr addObject:model];
            }
            [self.myTableView reloadData];
        }else{
            [MBProgressHUD showError:result[@"msg"] toView:nil];
        }
        
    } failure:^(NSError *erro) {
        NSLog(@"%@",erro);
    } showHUD:nil];

}

- (void)rightBtnClick{
    if (self.block) {
        self.block(_cid,_cidTitle,_orig_id,_origName);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    if (indexPath.section == 0) {
//        ScreenPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"screenPriceCell"];
//        return cell;
//    }
    if (indexPath.section == 0) {
        ScreenBtnCell *cell = [tableView dequeueReusableCellWithIdentifier:@"screenBtnCell"];
        cell.selectedCid = self.selectedCid;
        cell.array = self.array;
        cell.block = ^(NSInteger tag) {
            _cid = btnCidArray[tag];
            _cidTitle = self.array[tag];
        };
        return cell;
    }
    ScreenCollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"screenCollectionCell"];
    cell.selectedOrig  = self.selectedOrig;
    cell.array = self.screenArr;
    cell.backHeight = ^(CGFloat height) {
        if (_rowHeight != height) {
            _rowHeight = height;
            [tableView reloadData];
        }
    };
    cell.block = ^(NSInteger tag) {
        NSLog(@"-------%ld",tag);
        ScreenModel *screen = self.screenArr[tag];
        _orig_id = screen.screenID;
        _origName = screen.name;
    };
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = tableView.backgroundColor;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 30)];
    label.font = [UIFont systemFontOfSize:14];
    if (section == 0) {
        label.text = @"种类";
    }else{
        label.text = @"商城";
    }
    
    [view addSubview:label];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1) return MAX(0.01, _rowHeight + 30);

    return 10 + (self.array.count / 4 + (self.array.count % 4 == 0 ? 0 : 1)) * 35;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

@end
