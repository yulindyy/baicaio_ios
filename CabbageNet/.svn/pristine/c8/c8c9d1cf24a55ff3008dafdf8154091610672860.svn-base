//
//  ChangePWDViewController.m
//  CabbageNet
//
//  Created by xiang fu on 2017/7/9.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import "ChangePWDViewController.h"
#import "LoginViewController.h"

@interface ChangePWDViewController ()

@property (weak, nonatomic) IBOutlet UITextField *pastPWSField;
@property (weak, nonatomic) IBOutlet UITextField *newsPWDField;
@property (weak, nonatomic) IBOutlet UITextField *newsPWDagainField;

@end

@implementation ChangePWDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)finishBtnClick {
    
    if (!_pastPWSField.text.length) {
        [MBProgressHUD showError:@"请输入旧密码！" toView:nil];
        return;
    }
    if (!_newsPWDField.text.length) {
        [MBProgressHUD showError:@"请输入新密码！" toView:nil];
        return;
    }
    if (![_newsPWDagainField.text isEqualToString:_newsPWDField.text]) {
        [MBProgressHUD showError:@"新密码两次输入不一致！" toView:nil];
        return;
    }
    
    NSMutableDictionary * infoDic = [[NSMutableDictionary alloc]init];
    setDickeyobj(infoDic, @"resetpassword", @"api");
    UserInfoModel *model = [UserInfoModel sharedUserData];
    setDickeyobj(infoDic, model.userid, @"userid");
    setDickeyobj(infoDic, _pastPWSField.text, @"password");
    setDickeyobj(infoDic, _newsPWDField.text, @"new_password");
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    
    setDickeyobj(param, infoDic, @"reqBody");
    [CKHttpCommunicate createRequest:HTTP_USER_API WithParam:param withMethod:POST success:^(id result) {
        
        if (SUCCESS_REQUEST(result)) {
            
            LoginViewController *controller  = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"loginViewController"];
            [self.navigationController pushViewController:controller animated:YES];
        }else{
            
            [MBProgressHUD showError:result[@"msg"] toView:nil];
        }
        
    } failure:^(NSError *erro) {
        NSLog(@"%@",erro);
    } showHUD:nil];

}

@end
