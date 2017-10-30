//
//  XXBHeader.m
//  NewOnlineShop
//
//  Created by masha on 16/4/7.
//  Copyright © 2016年 Hunan new online Technology Co., Ltd. All rights reserved.
//

#import "XXBHeader.h"

@implementation XXBHeader
#pragma mark - 重写方法
#pragma mark 基本设置

-(void)prepare{
    [super prepare];
    
    //设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray new];
//    for (NSUInteger i = 54; i<=97; i++) {
//        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"ic_loading_%ld", i]];
//        [idleImages addObject:image];
//    }
    [self setImages:idleImages forState:MJRefreshStateIdle];
    
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    [self setImages:idleImages forState:MJRefreshStatePulling];
    
    // 设置正在刷新状态的动画图片
    [self setImages:idleImages forState:MJRefreshStateRefreshing];
}

@end
