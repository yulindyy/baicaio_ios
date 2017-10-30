//
//  ScreenBtnCell.m
//  CabbageNet
//
//  Created by MacAir on 2017/4/8.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import "ScreenBtnCell.h"
#define btnCidArray @[@"",@"333",@"334",@"336",@"116",@"338",@"335",@"1",@"115",@"339",@"340",@"50",@"102",@"114",@"337",@"341",@"342"]
@implementation ScreenBtnCell{
    UIButton *currBtn;
}

- (void)setArray:(NSArray *)array{
    
    int count = 4;
    CGFloat btnW = 60;
    CGFloat btnH = 25;
    CGFloat marginW = (mScreenWidth - 4 * btnW)/(count + 1);
    CGFloat marginH = 10;
    for (UIButton *btn in self.subviews) {
        if (btn.tag > 0) {
            [btn removeFromSuperview];
        }
    }
    for (int i = 0; i < array.count; i ++) {
        CGFloat btnX = marginW + (btnW + marginW) * (i % count);
        CGFloat btnY = marginH + (btnH + marginH) * (i / count);
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(btnX, btnY, btnW ,btnH)];
        
        [btn setTitle:array[i] forState:UIControlStateNormal];
        [btn setTitleColor:toPCcolor(@"333333") forState:UIControlStateNormal];
        
        btn.backgroundColor = [UIColor whiteColor];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        
        btn.tag = i + 1;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if ([btnCidArray[i] isEqualToString:self.selectedCid]) {
            btn.backgroundColor = mAppMainColor;
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            currBtn = btn;
        }
        [self addSubview:btn];
    }
}

- (void)btnClick:(UIButton *)sender{
    
    currBtn.backgroundColor = [UIColor whiteColor];
    [currBtn setTitleColor:toPCcolor(@"333333") forState:UIControlStateNormal];
    
    sender.backgroundColor = mAppMainColor;
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    currBtn = sender;
    
    if (self.block) {
        self.block(sender.tag - 1);
    }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    currBtn = [[UIButton alloc] init];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
