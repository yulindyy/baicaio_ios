//
//  AllCommentModel.m
//  CabbageNet
//
//  Created by xiang fu on 2017/6/12.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import "AllCommentModel.h"

@implementation AllCommentModel

- (void)setList:(NSMutableArray *)list{
    _list = [NSMutableArray array];
    for (NSDictionary *dic in list) {
        CommentListModel *model = [[CommentListModel alloc] init];
        [model mj_setKeyValues:dic];
        model.listID = dic[@"id"];
        [_list addObject:model];
    }
}

@end


@implementation CommentListModel


@end
