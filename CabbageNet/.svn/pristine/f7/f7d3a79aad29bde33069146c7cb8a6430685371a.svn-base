//
//  AlertBtnViewController.m
//  CabbageNet
//
//  Created by xiang fu on 2017/6/29.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import "AlertBtnViewController.h"
#import "Masonry.h"

@interface AlertBtnViewController ()

@end

@implementation AlertBtnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.FF5A15
}


+ (instancetype)alertPickerWithTitle:(NSString *)title Separator:(NSString *)separator andAddress:(NSString *)address{
    
    
    if (address) {
        NSString *infoString = [NSString stringWithFormat:@"%@\n\n%@\n",separator,address];
        AlertBtnViewController *alert = [self alertControllerWithTitle:title message:infoString preferredStyle:UIAlertControllerStyleAlert];
        
        UIButton *btn = [[UIButton alloc] init];
        [btn setTitle:@"" forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor clearColor];
        [btn addTarget:alert action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
        [alert.view addSubview:btn];
        [btn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(alert.view.mas_left).offset(20);
            make.right.equalTo(alert.view.mas_right).offset(-20);
            make.bottom.equalTo(alert.view.mas_bottom).offset(-40);
            make.top.equalTo(alert.view.mas_top).offset(40);
        }];

        NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:infoString];
        [alertControllerMessageStr addAttribute:NSForegroundColorAttributeName value:toPCcolor(@"FF5A15") range:NSMakeRange(separator.length, infoString.length-separator.length)];
        [alertControllerMessageStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, infoString.length)];
        [alert setValue:alertControllerMessageStr forKey:@"attributedMessage"];
        
        return alert;
    }
    NSString *infoString = [NSString stringWithFormat:@"%@\n\n选择地址\n",separator];
    AlertBtnViewController *alert = [self alertControllerWithTitle:title message:infoString preferredStyle:UIAlertControllerStyleAlert];
    
    UIButton *btn = [[UIButton alloc] init];
    [btn setTitle:@"" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor clearColor];
    [btn addTarget:alert action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [alert.view addSubview:btn];
    [btn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(alert.view.mas_left).offset(20);
        make.right.equalTo(alert.view.mas_right).offset(-20);
        make.bottom.equalTo(alert.view.mas_bottom).offset(-40);
        make.top.equalTo(alert.view.mas_top).offset(40);
    }];
    
    NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:infoString];
    [alertControllerMessageStr addAttribute:NSForegroundColorAttributeName value:toPCcolor(@"FF5A15") range:NSMakeRange(separator.length, infoString.length-separator.length)];
    [alertControllerMessageStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, infoString.length)];
    [alert setValue:alertControllerMessageStr forKey:@"attributedMessage"];
    
    return alert;
}

- (void)btnClick{
    NSLog(@"0000000000");
    if (self.block) self.block();
}



- (void)addCompletionAction:(UIAlertAction *)action{
    [self addAction:action];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消兑换" style:UIAlertActionStyleDefault handler:nil];
    //修改按钮
    [cancelAction setValue:mAppMainColor forKey:@"_titleTextColor"];
    [self addAction:cancelAction];
}


@end
