//
//  DiscountDetailModel.h
//  CabbageNet
//
//  Created by MacAir on 2017/4/14.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DiscountDetailModel : NSObject

@property (nonatomic , strong)NSString *add_time;       //添加时间
@property (nonatomic , assign)NSInteger comments;       //评论数
@property (nonatomic , strong)NSString *content;        //详情
@property (nonatomic , strong)NSString *fenxiang;       //分享url
@property (nonatomic , strong)NSDictionary *go_link;         //直达链接，有多个元素说明里面还有其他链接
@property (nonatomic , strong)NSString *img;            //
@property (nonatomic , strong)NSString *intro;          //商品简介

@property (nonatomic , assign)NSInteger likes;         //喜欢数
@property (nonatomic , assign)BOOL mylike;          //是否收藏 0 未收藏 1已收藏
@property (nonatomic , strong)NSDictionary *orig;       //来源商城
@property (nonatomic , strong)NSString *price;          //商品价格

@property (nonatomic , assign)NSInteger status;        //
@property (nonatomic , strong)NSString *tag_cache;
@property (nonatomic , strong)NSString *title;          //商品标题
@property (nonatomic , assign)NSInteger zan;           //点赞数

@end
