//
//  IntegralDetailModel.m
//  CabbageNet
//
//  Created by xiang fu on 2017/6/9.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import "IntegralDetailModel.h"
#import "IntegralDetailListModel.h"

@implementation IntegralDetailModel

- (void)setList:(NSMutableArray *)list{
    _list = [NSMutableArray array];
    for (NSDictionary *dic in list) {
        IntegralDetailListModel *model = [[IntegralDetailListModel alloc] init];
        [model mj_setKeyValues:dic];
        [_list addObject:model];
    }
}

@end
