//
//  TopBtnView.m
//  CabbageNet
//
//  Created by MacAir on 2017/3/22.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import "TopBtnView.h"

@implementation TopBtnView{
    UIView *bottomLine;
    CGFloat BtnX;
}

#pragma mark -- 初始化
- (instancetype)initWithFrame:(CGRect)frame titleBtnArr:(NSArray *)arr{
    if (self = [super init]) {
        self.frame = frame;
        self.backgroundColor = [UIColor whiteColor];
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

//    CGFloat btnW = (mScreenWidth - arr.count + 1)/arr.count;
    CGFloat btnH = self.height;
    BtnX = 0;
    
    for (int i = 0; i < arr.count; i ++) {
        
        NSString *title = arr[i];
        CGSize titleSize = [title sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
        
        CGFloat btnW = (mScreenWidth - arr.count + 1 - allStringSize.width)/arr.count + titleSize.width;
        
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
                
//                bottomLine.frame = CGRectMake(CGRectGetCenter(btn.frame).x - 20, self.height - 5, 40, 2);
                bottomLine.frame = CGRectMake(CGRectGetCenter(btn.frame).x - btn.width*2/5, self.height - 5, btn.width*4/5, 2);
                
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
