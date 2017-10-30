//
//  PrivateViewController.m
//  CabbageNet
//
//  Created by xiang fu on 2017/8/29.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import "PrivateViewController.h"
#import "PrivateOtherCell.h"
#import "PrivateMeCell.h"
#import "PrivateLetterModel.h"
#import "PrivateInsertView.h"

@interface PrivateViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic , strong)NSMutableArray *dataArr;
@property (nonatomic , strong)PrivateInsertView *insertView;

@end

@implementation PrivateViewController{
    NSInteger _page;
}

- (PrivateInsertView *)insertView{
    if (!_insertView) {
        _insertView = [[PrivateInsertView alloc]initWithFrame:CGRectMake(0, mScreenHeight-108, mScreenWidth, 44)];
        _insertView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        [_insertView setPlaceholderText:@"请输入评论"];
        __weak typeof(self)weakSelf = self;
        _insertView.EwenTextViewBlock = ^(NSString *text) {
            NSLog(@"%@",text);
            [weakSelf backPrivate:text];
        };
    }
    return _insertView;
}

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [self.view addSubview:self.insertView];
    
    self.title = [NSString stringWithFormat:@"我和“%@”对话",self.model.ta_name];
    _page = 1;
    self.myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page ++;
        [self requestData];
    }];
    [self requestData];
}

#pragma mark --请求对话列表
- (void)requestData{
    
    NSMutableDictionary * infoDic = [[NSMutableDictionary alloc]init];
    setDickeyobj(infoDic, @"getmsg_userdetail", @"api");
    UserInfoModel *userinfo = [UserInfoModel sharedUserData];
    setDickeyobj(infoDic, userinfo.userid, @"userid");
    NSString *str = [NSString stringWithFormat:@"%ld", _page];
    setDickeyobj(infoDic, str, @"page");
    setDickeyobj(infoDic, self.model.ftid, @"ftid");
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    setDickeyobj(param, infoDic, @"reqBody");
    [CKHttpCommunicate createRequest:HTTP_USER_API WithParam:param withMethod:POST success:^(id result) {
        [self.myTableView.mj_header endRefreshing];
        if (_page == 1) {
            [self.dataArr removeAllObjects];
        }
        if(SUCCESS_REQUEST(result)){
            for (NSDictionary *dic in result[@"data"]) {
                PrivateLetterModel *model = [[PrivateLetterModel alloc] init];
                [model mj_setKeyValues:dic];
                model.privateID = dic[@"id"];
                [_dataArr insertObject:model atIndex:0];
            }
        }else{
            [MBProgressHUD showError:result[@"msg"] toView:nil];
        }
        [self.myTableView reloadData];
    } failure:^(NSError *erro) {
        NSLog(@"%@", erro);
        [self.myTableView.mj_header endRefreshing];
    } showHUD:nil];
    
}

- (void)backPrivate:(NSString *)content{
    NSMutableDictionary * infoDic = [[NSMutableDictionary alloc]init];
    setDickeyobj(infoDic, @"msgpublish", @"api");
    UserInfoModel *userinfo = [UserInfoModel sharedUserData];
    setDickeyobj(infoDic, userinfo.userid, @"userid");
    setDickeyobj(infoDic, content, @"content");
    setDickeyobj(infoDic, self.model.ta_id, @"to_id");
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    setDickeyobj(param, infoDic, @"reqBody");
    [CKHttpCommunicate createRequest:HTTP_USER_API WithParam:param withMethod:POST success:^(id result) {
        if(SUCCESS_REQUEST(result)){
            [self requestData];
        }else{
            [MBProgressHUD showError:result[@"msg"] toView:nil];
        }
    } failure:^(NSError *erro) {
        NSLog(@"%@", erro);
    } showHUD:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PrivateLetterModel *model = self.dataArr[indexPath.row];
    UserInfoModel *userinfo = [UserInfoModel sharedUserData];
    if (![model.from_id isEqualToString:userinfo.userid]) {
        PrivateOtherCell *cell = [tableView dequeueReusableCellWithIdentifier:@"privateOtherCell"];
        cell.model = self.dataArr[indexPath.row];
        return cell;
    }
    PrivateMeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"privateMeCell"];
    cell.model = self.dataArr[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    PrivateLetterModel *model = self.dataArr[indexPath.row];
    CGFloat timeWidth = [[self timestampSwitchTime:[model.add_time integerValue]] sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}].width + 5;
    CGRect rect = [model.info boundingRectWithSize:CGSizeMake(mScreenWidth - 100 - timeWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil];
    return rect.size.height + 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(NSString *)timestampSwitchTime:(NSInteger)timestamp{
    if (timestamp == 0) return @"刚刚";
    //更具时间差获取的时间
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timestamp];
    //当前时间
    NSDate *newdate = [NSDate date];
    //日历
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDateComponents *datecom = [cal components:unitFlags fromDate:confromTimesp toDate:newdate options:0];
    if ([datecom day] < 1){
        if ([datecom hour] < 1){
            if ([datecom minute] < 1){
                return @"刚刚";
            }else{
                return [NSString stringWithFormat:@"%ld分钟前",[datecom minute]];
            }
        }else{
            return [NSString stringWithFormat:@"%ld小时前",[datecom hour]];
        }
    }else{
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"MM-dd  HH:mm"];
        NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
        [formatter setTimeZone:timeZone];
        NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
        return confromTimespStr;
    }
    return nil;
}

@end
