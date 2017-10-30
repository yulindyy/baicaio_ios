//
//  WealthViewController.m
//  CabbageNet
//
//  Created by MacAir on 2017/4/6.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import "WealthViewController.h"
#import "WealthSignCell.h"
#import "WealthRecordCell.h"
#import "MyWealthModel.h"
#import "RuleViewController.h"
#import "TopBtnView.h"
#import "GoLinkWebViewController.h"

#define btnTitleArray @[@"积分",@"金币",@"贡献值",@"经验"]
#define btnCodeArray @[@"score",@"coin",@"offer",@"exp"]
@interface WealthViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic , strong)UserInfoModel *model;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic,strong)TopBtnView *topBtnView;
@property (nonatomic, strong) NSMutableArray *integralList;


@end

@implementation WealthViewController{
    NSInteger _currTag;
    NSString *_grade;
}

- (TopBtnView *)topBtnView{
    if (!_topBtnView) {
        _topBtnView = [[TopBtnView alloc] initWithFrame:CGRectMake(0, 0, mScreenWidth, 44) titleBtnArr:btnTitleArray];
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _currTag = 1;
    self.integralList = [NSMutableArray arrayWithCapacity:16];
    
    [self requestDate];
    
    self.myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 1;
        [self requestDate];
        
    }];
    self.myTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        
        _page ++;
        [self requestDate];
    }];
    _page = 1;
    [self requestDate];
    
}

- (void)requestDate{
    
    NSMutableDictionary * infoDic = [[NSMutableDictionary alloc]init];
    setDickeyobj(infoDic, @"grade", @"api");
    setDickeyobj(infoDic, self.model.userid, @"userid");
    NSString *pageStr = [NSString stringWithFormat:@"%ld", _page];
    setDickeyobj(infoDic, pageStr, @"page")
    setDickeyobj(infoDic, btnCodeArray[_currTag - 1], @"type")
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    setDickeyobj(param, infoDic, @"reqBody");
    
    [CKHttpCommunicate createRequest:HTTP_USER_API WithParam:param withMethod:POST success:^(id result) {
        
        [self.myTableView.mj_header endRefreshing];
        [self.myTableView.mj_footer endRefreshing];
        if (_page == 1) {
            [self.integralList removeAllObjects];
            [self.myTableView reloadData];
        }
        
        if (SUCCESS_REQUEST(result)) {
            
            MyWealthModel *model = [[MyWealthModel alloc] init];
            [model mj_setKeyValues:result[@"data"]];
            
            _grade = result[@"data"][@"grade"];
            
            [self.integralList addObjectsFromArray: model.list];
            [self.myTableView reloadData];
            
            NSLog(@"%ld", self.integralList.count);
            
        }else{
            
            [MBProgressHUD showError:result[@"msg"] toView:nil];
        }

        
        
    } failure:^(NSError *erro) {
        [self.myTableView.mj_header endRefreshing];
        [self.myTableView.mj_footer endRefreshing];
        NSLog(@"%@", erro);
    } showHUD:nil];
    
}

#pragma mark tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.integralList.count + 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        WealthSignCell *cell = [tableView dequeueReusableCellWithIdentifier:@"wealthSignCell"];
    cell.gradeLabel.text = [NSString stringWithFormat:@"我的等级:LV.%@", _grade];
        if (self.model.is_sign == 1) {
            cell.signBtn.enabled = NO;
            [cell.signBtn setTitle:@"已签到" forState:UIControlStateDisabled];
            cell.signBtn.backgroundColor = [UIColor lightGrayColor];
        }
        cell.block = ^{
//            RuleViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ruleViewController"];
            GoLinkWebViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"goLinkWebViewController"];
            controller.webUrl = @"http://www.baicaio.com/page-index-id-6";
            controller.myWebView.scalesPageToFit = NO;
            controller.title = @"晋级规则";
            [self.navigationController pushViewController:controller animated:YES];
        };
        return cell;
    }else if (indexPath.row == 1){
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView addSubview:self.topBtnView];
        return cell;
    }
    WealthRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"wealthRecordCell"];
    
    IntegralListModel *model = self.integralList[indexPath.row - 2];
    cell.titleLabel.text = model.action;
    cell.timeLabel.text = model.add_time ? [self timestampSwitchTime:[model.add_time integerValue]] : @"";
    NSString *string = @"";
    switch (_currTag) {
        case 1:
            string = model.score;
            break;
        case 2:
            string = model.coin;
            break;
        case 3:
            string = model.offer;
            break;
        case 4:
            string = model.exp;
            break;
        default:
            break;
    }
    if ([string hasPrefix:@"-"]) {
        cell.numLabel.text = model.score;
    } else {
        cell.numLabel.text = [NSString stringWithFormat:@"+%@", string];
    }
    
    return cell;
}

-(NSString *)timestampSwitchTime:(NSInteger)timestamp{
    //更具时间差获取的时间
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timestamp];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) return 250;
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

@end
