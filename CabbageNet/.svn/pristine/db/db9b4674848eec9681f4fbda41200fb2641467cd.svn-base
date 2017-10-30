//
//  MyWealthModel.m
//  CabbageNet
//
//  Created by 周佳鑫 on 2017/6/5.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import "MyWealthModel.h"

@implementation MyWealthModel

- (void)setList:(NSArray<IntegralListModel *> *)list{
    
    NSMutableArray *arr = [NSMutableArray array];
    
    for (int i = 0; i < list.count; i++) {
        IntegralListModel *model = [[IntegralListModel alloc] init];
        [model mj_setKeyValues:list[i]];
        [arr addObject:model];
    }
    _list = arr;
}

@end
