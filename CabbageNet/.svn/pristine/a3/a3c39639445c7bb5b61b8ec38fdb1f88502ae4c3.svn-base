//
//  TopBtnScrollView.h
//  EnergyUnion
//
//  Created by MacAir on 2017/3/24.
//  Copyright © 2017年 xxb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopBtnScrollView : UIScrollView

@property (nonatomic, copy)void (^block)(NSInteger tag);
/**
 *  初始化方法
 *
 *  @param frame 坐标
 *  @param arr   标题数组
 *
 *  @return UIView
 */
- (instancetype)initWithFrame:(CGRect)frame titleBtnArr:(NSArray *)arr;

/**
 *  初始化方法
 *
 *  @param tag 按钮标记
 *
 */
- (void)btnActionChange:(NSInteger)tag;

@end
