
//
//  AddressViewController.m
//  CabbageNet
//
//  Created by MacAir on 2017/4/6.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import "AddressViewController.h"
#import "AddressManagerCell.h"
#import "EditAddressViewController.h"
#import "AddressSelectedCell.h"

@interface AddressViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIButton *addAddressBtn;
@property (nonatomic, strong) NSMutableArray *addressArr;
@property (nonatomic, strong) UserInfoModel *model;

@end

@implementation AddressViewController

- (NSMutableArray *)addressArr{
    
    if (_addressArr == nil) {
        _addressArr = [NSMutableArray arrayWithCapacity:16];
    }
    return _addressArr;
}

- (UserInfoModel *)model{
    
    return [UserInfoModel sharedUserData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.addAddressBtn.backgroundColor = mAppMainColor;
    
    if (_tag == 1) {
        self.title = @"选择地址";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确认" style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnClick)];
        [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    }
}

- (void)rightBtnClick{
    if (self.block) {
        for (AddressModel *model in self.addressArr) {
            if (model.isSelected) {
                [self.navigationController popViewControllerAnimated:YES];
                self.block(model);
                return;
            }
        }
    }
}


- (void)requestData{
    NSMutableDictionary * infoDic = [[NSMutableDictionary alloc]init];
    setDickeyobj(infoDic, @"getaddress", @"api");
    setDickeyobj(infoDic, self.model.userid, @"userid");
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    setDickeyobj(param, infoDic, @"reqBody");
    [CKHttpCommunicate createRequest:HTTP_USER_API WithParam:param withMethod:POST success:^(id result) {
        
        if (SUCCESS_REQUEST(result)) {
            [self.addressArr removeAllObjects];
            NSArray *arr = result[@"data"];
            if (arr  && ![arr isKindOfClass:[NSNull class]]) {
                for (int i = 0; i < arr.count; i++) {
                    AddressModel *model = [[AddressModel alloc] init];
                    [model mj_setKeyValues:arr[i]];
                    model.userid = self.model.userid;
                    model.addressid = arr[i][@"id"];
                    if (i == 0) {
                        model.isSelected = 1;
                    }
                    [self.addressArr addObject:model];
                    
                }
                [self.myTableView reloadData];
            }
            
        }
        else{
            [MBProgressHUD showError:result[@"msg"] toView:nil];
        }
        //        NSLog(@"%@", result[@"msg"]);
        
    } failure:^(NSError *erro) {
        NSLog(@"%@", erro);
    } showHUD:nil];
}


- (IBAction)addAddressBtnClick {
    EditAddressViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"editAddressViewController"];
    controller.title = @"添加新地址";
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark --tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.addressArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_tag == 1) {
        AddressSelectedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addressSelectedCell"];
        cell.model = self.addressArr[indexPath.section];
        return cell;
    }
    AddressManagerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addressManagerCell"];
    AddressModel *model = self.addressArr[indexPath.section];
    cell.model = model;
    cell.editBlock = ^(NSInteger tag){
        if (tag == 1) {
            EditAddressViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"editAddressViewController"];
            controller.addressModel = self.addressArr[indexPath.section];
            [self.navigationController pushViewController:controller animated:YES];

        }else if (tag == 2){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"您确定要删除“%@”这条地址信息吗？",model.address] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSMutableDictionary * infoDic = [[NSMutableDictionary alloc]init];
                setDickeyobj(infoDic, @"setaddress", @"api");
                setDickeyobj(infoDic, model.userid, @"userid");
                setDickeyobj(infoDic, @"del", @"type");
                setDickeyobj(infoDic, model.addressid, @"addressid");
                
                NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
                setDickeyobj(param, infoDic, @"reqBody");
                
                [CKHttpCommunicate createRequest:HTTP_USER_API WithParam:param withMethod:POST success:^(id result) {
                    
                    if (SUCCESS_REQUEST(result)) {
                        [self.addressArr removeObjectAtIndex:indexPath.section];
                        [self.myTableView reloadData];
                        [MBProgressHUD showError:result[@"data"] toView:nil];
                    } else {
                        [MBProgressHUD showError:result[@"msg"] toView:nil];
                    }
                    
                } failure:^(NSError *erro) {
                    NSLog(@"%@", erro);
                } showHUD:nil];
                
            }];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"手滑了" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:cancel];
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
            
        }else if (tag == 3){
            for (AddressModel *model in self.addressArr) {
                model.isSelected = NO;
            }
            model.isSelected = YES;
            [tableView reloadData];
        }else if (tag == 4){
            for (AddressModel *model in self.addressArr) {
                model.isSelected = NO;
            }
            [tableView reloadData];
        }
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_tag == 1) return 60;
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_tag == 1) {
        for (int i = 0; i < self.addressArr.count; i ++) {
            
            AddressModel *model = self.addressArr[i];
            model.isSelected = i == indexPath.section ? YES : NO;
            
        }
        [tableView reloadData];
    }
}

@end
