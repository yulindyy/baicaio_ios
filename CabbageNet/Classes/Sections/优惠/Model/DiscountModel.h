//
//  DiscountModel.h
//  CabbageNet
//
//  Created by MacAir on 2017/4/13.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DiscountModel : NSObject

@property (nonatomic , strong)NSString *add_time;     //添加时间
@property (nonatomic , strong)NSString *img;     //商品图片
@property (nonatomic , assign)NSInteger likes;      //喜欢数

@property (nonatomic , strong)NSString *price;      //商品价格
@property (nonatomic , strong)NSString *shopid;     //商品ID
@property (nonatomic , strong)NSString *title;   //商品标题

@property (nonatomic , strong)NSString *name;   //商品来源
@property (nonatomic , assign)NSInteger zan;        //点赞数
@property (nonatomic , strong) NSDictionary * go_link;

@property (nonatomic , assign)NSInteger comments;  //评论数

@end
