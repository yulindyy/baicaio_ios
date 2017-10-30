//
//  MYCollectionModel.h
//  CabbageNet
//
//  Created by xiang fu on 2017/6/14.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYCollectionModel : NSObject

@property (nonatomic , assign)NSInteger comments;   //评论数
@property (nonatomic , strong)NSString *shopid;    //商品id ，请缓存为shopid
@property (nonatomic , strong)NSString *img;    //图片
@property (nonatomic , strong)NSString *intro;  //简介
@property (nonatomic , strong)NSString *title;  //标题

@end
