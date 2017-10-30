//
//  VerificationSuccessViewController.m
//  CabbageNet
//
//  Created by MacAir on 2017/4/10.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import "VerificationSuccessViewController.h"
#import "VerificationViewController.h"
#import "SecurityViewController.h"

@interface VerificationSuccessViewController ()

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIButton *successBtn;

@end

@implementation VerificationSuccessViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    UserInfoModel *model = [UserInfoModel sharedUserData];
    if (self.tag == 1) {
        
        self.infoLabel.text = [NSString stringWithFormat:@"已验证：%@",model.mobile];
    }else if (self.tag == 2){
       self.infoLabel.text = [NSString stringWithFormat:@"已验证：%@",model.email];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.successBtn.backgroundColor = mAppMainColor;
    self.successBtn.layer.cornerRadius = 4;
    self.successBtn.layer.masksToBounds = YES;
    [self.successBtn setTitle:@"重新验证" forState:UIControlStateNormal];
    
}

- (void)backBtnClick{
    
    for (UIViewController *controller in self.navigationController.viewControllers) {
        
        if ([controller isKindOfClass:[SecurityViewController class]]) {
            
            SecurityViewController *vc = (SecurityViewController *)controller;
            
            [self.navigationController popToViewController:vc animated:YES];
            
        }
        
    }
}

- (IBAction)successBtnClick {
    
    NSInteger count = self.navigationController.viewControllers.count;
    if ([self.navigationController.viewControllers[count - 2] isKindOfClass:[VerificationViewController class]]) {
        
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    VerificationViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"verificationViewController"];
    if (self.tag == 1) {
        controller.title = @"手机验证";
    }else if (self.tag == 2){
        controller.title = @"邮箱验证";
    }
    
    [self.navigationController pushViewController:controller animated:YES];
    
}


@end
