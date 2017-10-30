//
//  TopBtnScrollView.m
//  EnergyUnion
//
//  Created by MacAir on 2017/3/24.
//  Copyright © 2017年 xxb. All rights reserved.
//

#define with 80

#import "TopBtnScrollView.h"

@implementation TopBtnScrollView{
    UIView *bottomLine;
    CGFloat BtnX;
}

- (instancetype)initWithFrame:(CGRect)frame titleBtnArr:(NSArray *)arr{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.contentSize = CGSizeMake(with * arr.count, 0);
        self.showsHorizontalScrollIndicator = NO;
        [self createSubBtn:arr];
    }
    return self;
}

- (void)createSubBtn:(NSArray *)arr{
    
    NSMutableString *string = [NSMutableString string];
    for (NSString *str in arr) {
        [string appendString: str];
    }
    
    CGSize allStringSize = [string sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    
    self.contentSize = CGSizeMake(mScreenWidth + arr.count + 1 + 80, 0);
    CGFloat btnH = self.height;
    BtnX = 0;
    
    for (int i = 0; i < arr.count; i ++) {
        
        NSString *title = arr[i];
        CGSize titleSize = [title sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
        
        CGFloat btnW = (mScreenWidth + arr.count + 1 + 80 - allStringSize.width)/arr.count + titleSize.width;
        
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(BtnX, 0, btnW, btnH)];
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [btn setTitleColor:toPCcolor(@"333333") forState:UIControlStateNormal];
        [btn setTitleColor:mAppMainColor forState:UIControlStateSelected];
        btn.tag = i + 1;
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        if (i != arr.count - 1) {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btn.frame), 15, 1, self.height - 30)];
            line.backgroundColor = [UIColor grayColor];
            [self addSubview:line];
        }
        BtnX = CGRectGetMaxX(btn.frame) + 1;

    }
    bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = mAppMainColor;
    [self addSubview:bottomLine];
    
}

- (void)btnAction:(UIButton *)sender{
    
    [self btnActionChange:sender.tag];
    
}

- (void)btnActionChange:(NSInteger)tag{
    for (UIButton *btn in self.subviews) {
        if (btn.tag == tag) {
            btn.selected = YES;
            
            [UIView animateWithDuration:0.1 animations:^{
                
                bottomLine.frame = CGRectMake(btn.frame.origin.x + btn.width/10, self.height - 5,btn.width*4/5, 2);
                if (CGRectGetMidX(btn.frame) > mScreenWidth) {
                    self.contentOffset = CGPointMake(CGRectGetMaxX(btn.frame) - mScreenWidth, 0);
                }else if (btn.origin.x < self.contentOffset.x){
                    self.contentOffset = CGPointMake(btn.origin.x, 0);
                }
                
            }];
        }else if (btn.tag > 0){
            btn.selected = NO;
        }
    }
    
    if (self.block) {
        self.block(tag);
    }
}

@end
