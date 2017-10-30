//
//  FeelBackViewController.m
//  CabbageNet
//
//  Created by MacAir on 2017/4/8.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import "FeelBackViewController.h"
#import "ProblemEditCell.h"
#import "ContactMethodCell.h"

@interface FeelBackViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation FeelBackViewController{
    NSString *_reason;
    NSString *_method;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnClick)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    
}

- (void)rightBtnClick{
    [self.view endEditing:YES];
    
    if (!_reason.length) [MBProgressHUD showError:@"请输入反馈内容！" toView:nil];
        
    
    NSMutableDictionary * infoDic = [[NSMutableDictionary alloc]init];
    setDickeyobj(infoDic, @"report_bug", @"api");
// mark 发布的时候传192792
    setDickeyobj(infoDic, @"192792", @"to_id");//2
    UserInfoModel *model = [UserInfoModel sharedUserData];
    setDickeyobj(infoDic, model.userid, @"userid");
    NSString *content = [NSString stringWithFormat:@"%@%@",_reason,_method];
    setDickeyobj(infoDic, content, @"content");
    
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    setDickeyobj(param, infoDic, @"reqBody");
    
    [CKHttpCommunicate createRequest:HTTP_USER_API WithParam:param withMethod:POST success:^(id result) {
        
        if (SUCCESS_REQUEST(result)) {
            [MBProgressHUD showError:result[@"data"] toView:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else{
            
            [MBProgressHUD showError:result[@"msg"] toView:nil];
        }
        
    } failure:^(NSError *erro) {
        NSLog(@"%@", erro);
    } showHUD:nil];
//    NSLog(<#NSString * _Nonnull format, ...#>)
//    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        ProblemEditCell *cell = [tableView dequeueReusableCellWithIdentifier:@"problemEditCell"];
        cell.block = ^(NSString *string) {
            _reason = string;
        };
        return cell;
    }
    ContactMethodCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contactMethodCell"];
    cell.block = ^(NSString *string) {
        _method = string;
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 200;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 20;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}


@end
