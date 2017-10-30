//
//  IntegralDetailModel.h
//  CabbageNet
//
//  Created by xiang fu on 2017/6/9.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IntegralDetailModel : NSObject

@property (nonatomic , strong)NSString *title;       //标题
@property (nonatomic , strong)NSString *img;       //图片（有可能会出现相对路径）
@property (nonatomic , assign)NSInteger coin;       //兑换所需要的金币
@property (nonatomic , assign)NSInteger buy_num;       //已兑换数
@property (nonatomic , assign)NSInteger user_num;       //限制兑换数
@property (nonatomic , assign)NSInteger stock;       //库存数
@property (nonatomic , assign)NSInteger score;
@property (nonatomic , strong)NSString *desc;       //详情
@property (nonatomic , strong)NSString *modelId;    //
@property (nonatomic , strong)NSMutableArray *list;        //

@end
