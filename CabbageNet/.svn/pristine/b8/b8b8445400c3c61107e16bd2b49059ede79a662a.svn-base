//
//  BaseViewController.m
//  CabbageNet
//
//  Created by MacAir on 2017/4/5.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import "BaseViewController.h"
#import "MyFollowViewController.h"
#import "LoginViewController.h"

@interface BaseViewController ()<UITabBarControllerDelegate>

@end

@implementation BaseViewController

- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UIView *topBackView = [[UIView alloc] initWithFrame:CGRectMake(0, -64, mScreenWidth, 64)];
    topBackView.backgroundColor = mAppMainColor;
    [self.view addSubview:topBackView];
    
    if (self.navigationController.childViewControllers.count > 1){
        UIButton *backBtn = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, 44, 44)];
        [backBtn setImage:[UIImage imageNamed:@"返回"]  forState:UIControlStateNormal];
        backBtn.imageEdgeInsets = UIEdgeInsetsMake(12, 0, 12, 24);
        [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];

    }
    // 添加返回手势
    self.navigationController.interactivePopGestureRecognizer.delegate=(id)self;
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    NSLog(@"====%@",viewController.childViewControllers.firstObject.class);
    if ([viewController.childViewControllers.firstObject isKindOfClass:[MyFollowViewController class]]) {
        if ([UserDefaultsGetSynchronize(@"login") isEqualToString:@"10001"]) return YES;
        
        LoginViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"loginViewController"];
        controller.Block = ^{
            if ([UserDefaultsGetSynchronize(@"login") isEqualToString:@"10001"]){
                self.tabBarController.selectedIndex = 2;
            }
        };
        [self.tabBarController.childViewControllers[self.tabBarController.selectedIndex].childViewControllers[0].navigationController pushViewController:controller animated:YES];
        return NO;
    }
    return YES;
}



- (void)backBtnClick{
//    [self.navigationController popViewControllerAnimated:YES];
    if (self.presentingViewController){
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
