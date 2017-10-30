//
//  SettingNameOrSexViewController.m
//  CabbageNet
//
//  Created by MacAir on 2017/4/6.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import "SettingNameOrSexViewController.h"
#import "SettingNameCell.h"
#import "SettingSexCell.h"

@interface SettingNameOrSexViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation SettingNameOrSexViewController{
    NSString *_setSex;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UserInfoModel *model = [UserInfoModel sharedUserData];
    
    _setSex = [NSString stringWithFormat:@"%ld", model.gender];
    
    if (self.nameOrSex == EDIT_NAME) {
        self.title = @"修改昵称";
    }else if (self.nameOrSex == EDIT_SEX){
        self.title = @"修改性别";
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存"  style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnClick)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    
}

- (void)rightBtnClick{
    
    NSMutableDictionary * infoDic = [[NSMutableDictionary alloc]init];
    setDickeyobj(infoDic, @"updatesex", @"api");
    UserInfoModel *model = [UserInfoModel sharedUserData];
    setDickeyobj(infoDic, model.userid, @"userid");
    setDickeyobj(infoDic, _setSex, @"gender");
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    setDickeyobj(param, infoDic, @"reqBody");
    
    [CKHttpCommunicate createRequest:HTTP_USER_API WithParam:param withMethod:POST success:^(id result) {
        
        if (SUCCESS_REQUEST(result)) {
            
            model.gender = [_setSex integerValue];
            [UserInfoModel storeUserWithModel:model];
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        else{
            
            [MBProgressHUD showError:result[@"msg"] toView:nil];
        }
        
    } failure:^(NSError *erro) {
        NSLog(@"%@", erro);
    } showHUD:nil];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.nameOrSex == EDIT_NAME) return 1;
    if (self.nameOrSex == EDIT_SEX) return 2;
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.nameOrSex == EDIT_NAME) {
        SettingNameCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingNameCell"];
        return cell;
    }else if (self.nameOrSex == EDIT_SEX){
        SettingSexCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingSexCell"];
        cell.block = ^{
            if (indexPath.row == 0) {
                _setSex = @"1";
            }else{
                _setSex = @"0";
            }
            [tableView reloadData];
        };
        if (indexPath.row == 0) {
            cell.sexLabel.text = @"男";
            if ([_setSex isEqualToString:@"1"]) {
                [cell.selectedBtn setImage:[UIImage imageNamed:@"sex选择"] forState:UIControlStateNormal];
            }else{
                [cell.selectedBtn setImage:[UIImage imageNamed:@"sex未选"] forState:UIControlStateNormal];
            }
        }else{
            cell.sexLabel.text = @"女";
            if ([_setSex isEqualToString:@"0"]) {
                [cell.selectedBtn setImage:[UIImage imageNamed:@"sex选择"] forState:UIControlStateNormal];
            }else{
                [cell.selectedBtn setImage:[UIImage imageNamed:@"sex未选"] forState:UIControlStateNormal];
                
            }
        }
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

@end
