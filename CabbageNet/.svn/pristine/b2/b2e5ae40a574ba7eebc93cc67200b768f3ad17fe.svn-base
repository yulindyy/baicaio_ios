//
//  PushViewController.m
//  CabbageNet
//
//  Created by xiang fu on 2017/8/4.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import "PushViewController.h"
#import "PushCell.h"
#import "PushMoreCell.h"
// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用idfa功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>
#import "PushDateView.h"
#import <AudioToolbox/AudioToolbox.h>

#import "SignModel.h"

@interface PushViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic, strong)UIView *coverView;
@property (nonatomic, strong)PushDateView *pushDateView;
@property (nonatomic , strong)NSMutableArray *pushTagArr;

@end

@implementation PushViewController{
    NSString *_pushTime;
}
- (NSMutableArray *)pushTagArr{
    if (!_pushTagArr) _pushTagArr = [NSMutableArray array]; return _pushTagArr;
}

- (PushDateView *)pushDateView{
    if (!_pushDateView) {
        _pushDateView = [PushDateView getPushDateView];
        _pushDateView.frame = CGRectMake(0, mScreenHeight, mScreenWidth, 226);
        __weak typeof(self)weakSelf = self;
        _pushDateView.Block = ^(NSString *tag) {
            [weakSelf setPushTime:tag];
            NSArray *array = [tag componentsSeparatedByString:@","];
            NSLog(@"%@--%@--%ld--%d",array[0],array[1],[array[0] integerValue],[array[0] intValue]);
            if (array.count == 2){
                [weakSelf clearAndAddTag:[array[0] integerValue] and:[array[1] integerValue]];
            }else{
                [weakSelf clearAndAddTag:0 and:0];
            }
        };
        [self.view addSubview:_pushDateView];
    }
    return _pushDateView;
}

- (UIView *)coverView{
    if (!_coverView) {
        _coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, mScreenWidth, mScreenHeight)];
        _coverView.alpha = 0.5;
        _coverView.backgroundColor = [UIColor blackColor];
        _coverView.hidden = YES;
        [self.view addSubview:_coverView];
    }
    return _coverView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([UserDefaultsGetSynchronize(@"openjpush") isEqualToString:@"9999"]){
        self.coverView.hidden = NO;
    }else{
        self.coverView.hidden = YES;
    }
    [self getPushTime];
    [self requestData];
}

#pragma mark -- 请求安静时间段设置
- (void)getPushTime{
    NSMutableDictionary * infoDic = [[NSMutableDictionary alloc]init];
    setDickeyobj(infoDic, @"push_range_byuser", @"api");
    UserInfoModel *model = [UserInfoModel sharedUserData];
    setDickeyobj(infoDic, model.userid, @"userid");
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    setDickeyobj(param, infoDic, @"reqBody");
    [MBProgressHUD showMessag:@"加载中..." toView:self.view];
    [CKHttpCommunicate createRequest:HTTP_USER_API WithParam:param withMethod:POST success:^(id result) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (SUCCESS_REQUEST(result)) {
            NSArray *array = result[@"data"];
            NSDictionary *dic = array.firstObject;
            _pushTime = dic[@"push_range"];
            [self.myTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }else
            [MBProgressHUD showError:result[@"msg"] toView:nil];
        
    } failure:^(NSError *erro) {
        NSLog(@"%@", erro);
    } showHUD:nil];
}

- (void)requestData{
    
    NSMutableDictionary * infoDic = [[NSMutableDictionary alloc]init];
    setDickeyobj(infoDic, @"notify_tag_byuser", @"api");
    UserInfoModel *model = [UserInfoModel sharedUserData];
    setDickeyobj(infoDic, model.userid, @"userid");
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    setDickeyobj(param, infoDic, @"reqBody");
    [CKHttpCommunicate createRequest:HTTP_USER_API WithParam:param withMethod:POST success:^(id result) {
        if (SUCCESS_REQUEST(result)) {
            
            for (NSDictionary *dic in result[@"data"]) {
                SignModel *model = [[SignModel alloc] init];
                [model mj_setKeyValues:dic];
                model.signID = dic[@"id"];
                [self.pushTagArr addObject:model];
            }
            
        }else{
            [MBProgressHUD showError:result[@"msg"] toView:nil];
        }
    } failure:^(NSError *erro) {
        NSLog(@"%@",erro);
    } showHUD:nil];
}

- (void)setPushTime:(NSString *)tag{
    NSMutableDictionary * infoDic = [[NSMutableDictionary alloc]init];
    setDickeyobj(infoDic, @"push_range_modify", @"api");
    UserInfoModel *model = [UserInfoModel sharedUserData];
    setDickeyobj(infoDic, model.userid, @"userid");
    setDickeyobj(infoDic, tag, @"push_range");
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    setDickeyobj(param, infoDic, @"reqBody");
//    [MBProgressHUD showMessag:@"加载中..." toView:self.view];
    [CKHttpCommunicate createRequest:HTTP_USER_API WithParam:param withMethod:POST success:^(id result) {
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (SUCCESS_REQUEST(result)) {
            _pushTime = tag;
            NSArray *array = [_pushTime componentsSeparatedByString:@","];
//            if (array.count == 2){
//                [self clearAndAddTag:[array[0] integerValue] and:[array[1] integerValue]];
//            }else{
//                [self clearAndAddTag:0 and:0];
//            }
            UserDefaultsSynchronize(array[0], @"startTime");
            UserDefaultsSynchronize(array[1], @"endTime");
            [self.myTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }else{
            [MBProgressHUD showError:result[@"msg"] toView:nil];
        }
    } failure:^(NSError *erro) {
        NSLog(@"%@", erro);
    } showHUD:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        
        PushCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pushCell"];
        cell.nameLabel.text = @"开启关注推送";
        if ([UserDefaultsGetSynchronize(@"openjpush") isEqualToString:@"9999"]){
            [cell.cellSwitch setOn:NO];
        }else{
            [cell.cellSwitch setOn:YES];
        }
        cell.Block = ^(BOOL isON) {
            if (isON) {
                self.coverView.hidden = YES;
                UserDefaultsSynchronize(@"10001", @"openjpush");
//                NSArray *array = [_pushTime componentsSeparatedByString:@","];
//                if (array.count == 2){
//                    [self clearAndAddTag:[array[0] integerValue] and:[array[1] integerValue]];
//                }else{
//                    [self clearAndAddTag:0 and:0];
//                }
                if (![UserDefaultsGetSynchronize(@"opensettime") isEqualToString:@"10001"]){
                    [self clearAndAddTag:0 and:0];
                    [self setPushTime:@"0,24"];
                }else{
                    [self clearAndAddTag:0 and:7];
                    [self setPushTime:@"0,7"];
                }
            }else{
                self.coverView.hidden = NO;
                UserDefaultsSynchronize(@"9999", @"openjpush");
                [self clearAndAddTag:0 and:24];
            }
            [tableView reloadData];
        };
        return cell;
    }else if (indexPath.row == 1){
        
        PushCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pushCell"];
        cell.nameLabel.text = @"声音";
        if ([UserDefaultsGetSynchronize(@"openjpush") isEqualToString:@"9999"]){
            [cell.cellSwitch setOn:NO];
        }else{
            if ([UserDefaultsGetSynchronize(@"opensound") isEqualToString:@"9999"]){
                [cell.cellSwitch setOn:NO];
            }else{
                [cell.cellSwitch setOn:YES];
                
            }
        }
        cell.Block = ^(BOOL isON) {
            if(isON) {
                UserDefaultsSynchronize(@"10001", @"opensound");
            }else{
                UserDefaultsSynchronize(@"9999", @"opensound");
            }
            NSArray *array = [_pushTime componentsSeparatedByString:@","];
            NSLog(@"%@--%@--%ld--%d",array[0],array[1],[array[0] integerValue],[array[0] intValue]);
            if (array.count == 2){
                [self clearAndAddTag:[array[0] integerValue] and:[array[1] integerValue]];
            }else{
                [self clearAndAddTag:0 and:0];
            }
        };
        return cell;
    }else if (indexPath.row == 2){
        
//        PushCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pushCell"];
//        cell.nameLabel.text = @"震动";
//        if ([UserDefaultsGetSynchronize(@"openjpush") isEqualToString:@"9999"]){
//            [cell.cellSwitch setOn:NO];
//        }else{
//            if ([UserDefaultsGetSynchronize(@"openshock") isEqualToString:@"9999"]){
//                [cell.cellSwitch setOn:NO];
//            }else{
//                [cell.cellSwitch setOn:YES];
//            }
//        }
//        cell.Block = ^(BOOL isON) {
//            if(isON) {
//                UserDefaultsSynchronize(@"10001", @"openshock");
//            }else{
//                UserDefaultsSynchronize(@"9999", @"openshock");
//            }
//        };
//        return cell;
//    }else if (indexPath.row == 3){
        PushCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pushCell"];
        cell.nameLabel.text = @"安静时段";
        if ([UserDefaultsGetSynchronize(@"openjpush") isEqualToString:@"9999"]){
            [cell.cellSwitch setOn:NO];
        }else{
            if (![UserDefaultsGetSynchronize(@"opensettime") isEqualToString:@"10001"]){
                [cell.cellSwitch setOn:NO];
            }else{
                [cell.cellSwitch setOn:YES];
            }
        }
        cell.Block = ^(BOOL isON) {
            if(isON) {
                UserDefaultsSynchronize(@"10001", @"opensettime");
                [self clearAndAddTag:0 and:7];
                [self setPushTime:@"0,7"];
                
            }else{
                UserDefaultsSynchronize(@"9999", @"opensettime");
                [self clearAndAddTag:0 and:24];
                [self setPushTime:@"0,24"];
            }
//            NSArray *array = [_pushTime componentsSeparatedByString:@","];
//            if (array.count == 2){
//                [self clearAndAddTag:[array[0] integerValue] and:[array[1] integerValue]];
//            }else{
//                [self clearAndAddTag:0 and:0];
//            }
        };
        return cell;
    }
    PushMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pushMoreCell"];
    if ([UserDefaultsGetSynchronize(@"openjpush") isEqualToString:@"9999"]){
        cell.nameLabel.text = @"从0点到7点";
    }else{
        if (![UserDefaultsGetSynchronize(@"opensettime") isEqualToString:@"10001"]){
            cell.nameLabel.text = @"从0点到7点";
        }else{
            NSArray *array = [_pushTime componentsSeparatedByString:@","];
            if (array.count == 2){
                cell.nameLabel.text = [NSString stringWithFormat:@"从%@点到%@点",array[0],array[1]];
            }else{
                cell.nameLabel.text = @"从0点到7点";
            }
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 3 && [UserDefaultsGetSynchronize(@"opensettime") isEqualToString:@"10001"]){
        self.pushDateView.hidenView = NO;
        NSArray *array = [_pushTime componentsSeparatedByString:@","];
        if (array.count == 2){
            [self.pushDateView setSelected:[array[0] integerValue] andRow:[array[1] integerValue]];
        }else{
            [self.pushDateView setSelected:0 andRow:7];
        }
        
    }
}

- (void)clearAndAddTag:(NSInteger)slientMin and:(NSInteger)slientMax{

    [MBProgressHUD showMessag:@"加载中..." toView:self.view];
    NSLog(@"%ld---%ld",slientMin,slientMax);
    if ([UserDefaultsGetSynchronize(@"openjpush") isEqualToString:@"9999"]) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [JPUSHService cleanTags:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
            NSLog(@"%ld--%@--%ld",iResCode,iTags,seq);
        } seq:1];
        return;
    }
    NSMutableSet *pushSet = [NSMutableSet set];
    for (SignModel *model in self.pushTagArr) {
        if (model.p_sign) {
            for (int i = 0; i < 24; i ++) {
                NSString *newTag = model.tag;
                if ([UserDefaultsGetSynchronize(@"opensettime") isEqualToString:@"10001"]){
                    if (i < slientMin || i >= slientMax) {
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
                        NSLog(@"------------");
                    }
                }
                if (newTag.length) {
                    newTag = [[newTag stringByReplacingOccurrencesOfString:@" " withString:@"|"] stringByReplacingOccurrencesOfString:@"-" withString:@"|"];
                    [pushSet addObject:newTag];
                }
            }
        }
    }
    if (pushSet.count == 0) {
        [JPUSHService cleanTags:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
            NSLog(@"%ld--%@--%ld",iResCode,iTags,seq);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        } seq:1];
        return;
    }
    [JPUSHService setTags:pushSet completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
        NSLog(@"%ld--%@--%ld",iResCode,iTags,seq);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } seq:1];
    for (NSString *string in pushSet) {
        NSLog(@"%@",string);
    }
    NSLog(@"%ld",pushSet.count);
}

@end
