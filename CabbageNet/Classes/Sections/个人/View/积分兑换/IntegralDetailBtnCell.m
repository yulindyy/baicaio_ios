//
//  IntegralDetailBtnCell.m
//  CabbageNet
//
//  Created by xiang fu on 2017/6/8.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import "IntegralDetailBtnCell.h"

@interface IntegralDetailBtnCell ()

@property (weak, nonatomic) IBOutlet UILabel *bottomLineLabel;

@end

@implementation IntegralDetailBtnCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)leftBtnClick:(UIButton *)sender {
    
    CGRect frame = self.bottomLineLabel.frame;
    frame.origin.x = 0;
    self.bottomLineLabel.frame = frame;
    NSLog(@"-----===%lf",self.bottomLineLabel.frame.origin.x);
    [self.leftBtn setTitleColor:mAppMainColor forState:UIControlStateNormal];
    [self.reightBtn setTitleColor:toPCcolor(@"333333") forState:UIControlStateNormal];
    
}

- (IBAction)reightBtnClick:(UIButton *)sender {
    
    CGRect frame = self.bottomLineLabel.frame;
    frame.origin.x = mScreenWidth/2;
    
    self.bottomLineLabel.frame = frame;
    NSLog(@"-----%lf",self.bottomLineLabel.frame.origin.x);
    
    [self.reightBtn setTitleColor:mAppMainColor forState:UIControlStateNormal];
    [self.leftBtn setTitleColor:toPCcolor(@"333333") forState:UIControlStateNormal];

}

@end
