//
//  PersonalBtnCell.m
//  CabbageNet
//
//  Created by MacAir on 2017/4/5.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import "PersonalBtnCell.h"
#import "PersonalBtn.h"

@implementation PersonalBtnCell

- (void)setBtnTitleArray:(NSArray *)btnTitleArray{
    
    
    CGFloat btnW = mScreenWidth / btnTitleArray.count;
    CGFloat btnH = self.height;
    
    for (int i = 0; i < btnTitleArray.count; i ++) {
        
        PersonalBtn *btn = [[PersonalBtn alloc] initWithFrame:CGRectMake(i * btnW, 0, btnW, btnH)];
        btn.titles = btnTitleArray[i];
        btn.bgImage = btnTitleArray[i];
        [btn setTitleColor:toPCcolor(@"333333") forState:UIControlStateNormal];
        btn.tag = i + 1;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:btn];
    }
}

- (void)btnClick:(UIButton *)sender{
    
    if (self.block) {
        self.block(sender.tag);
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
