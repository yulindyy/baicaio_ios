//
//  ShareView.m
//  CabbageNet
//
//  Created by xiang fu on 2017/7/10.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import "ShareView.h"

@implementation ShareView

+ (instancetype)getShareView{
    return [[[NSBundle mainBundle] loadNibNamed:@"ShareView" owner:nil options:nil] lastObject];
}


- (IBAction)btnClick:(UIButton *)sender {
    if (self.block) self.block(sender.tag);
}

- (IBAction)hidenViewBtnclick {
    self.ishidenView = YES;
}

- (void)setIshidenView:(BOOL)ishidenView{
    CGRect frame = self.frame;
    frame.origin.y = ishidenView ? mScreenHeight : 0;
    [UIView animateWithDuration:0.01 animations:^{
        self.frame = frame;
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.ishidenView = YES;
}

@end
