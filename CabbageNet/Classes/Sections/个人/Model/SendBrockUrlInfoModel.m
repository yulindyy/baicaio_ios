//
//  SendBrockUrlInfoModel.m
//  CabbageNet
//
//  Created by xiang fu on 2017/6/10.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import "SendBrockUrlInfoModel.h"

@implementation SendBrockUrlInfoModel

- (void)setImgs:(NSMutableArray *)imgs{
    imgs = [NSMutableArray array];
    for (NSDictionary *dic in imgs) {
        [_imgs addObject:dic];
    }
}
MJCodingImplementation
@end
