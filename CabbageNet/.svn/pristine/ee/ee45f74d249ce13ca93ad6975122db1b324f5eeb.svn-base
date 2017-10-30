//
//  BindCompleteViewController.m
//  CabbageNet
//
//  Created by xiang fu on 2017/6/12.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import "BindCompleteViewController.h"

@interface BindCompleteViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *centerImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *clearBindBtn;

@end

@implementation BindCompleteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.classtype == QQ_TYPE) {
        self.title = @"绑定QQ";
        self.centerImageView.image = [UIImage imageNamed:@"QQ大图"];
        self.titleLabel.text = @"QQ账户：";
    }else{
        self.title = @"绑定微信";
        self.titleLabel.text = @"微信账户：";
        self.centerImageView.image = [UIImage imageNamed:@"微信大图"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clearBindBtnClick {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"是否立即解除绑定？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSMutableDictionary * infoDic = [[NSMutableDictionary alloc]init];
        setDickeyobj(infoDic, @"removebind", @"api");
        UserInfoModel *model = [UserInfoModel sharedUserData];
        setDickeyobj(infoDic, model.userid, @"userid");
        
        if (self.classtype == QQ_TYPE) {
            setDickeyobj(infoDic, @"qq", @"type");
        }else{
            setDickeyobj(infoDic, @"wechat", @"type");
        }
        NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
        setDickeyobj(param, infoDic, @"reqBody");
        [CKHttpCommunicate createRequest:HTTP_USER_API WithParam:param withMethod:POST success:^(id result) {
            
            if (SUCCESS_REQUEST(result)) {
                [self.navigationController popViewControllerAnimated:YES];
            }
            else{
                
                [MBProgressHUD showError:result[@"msg"] toView:nil];
                return ;
            }
            
        } failure:^(NSError *erro) {
            NSLog(@"%@", erro);
            return ;
        } showHUD:nil];
    }];
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"手滑了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:ok];
    [alert addAction:cancle];
    
    [self presentViewController:alert animated:YES completion:nil];

    
}

@end
