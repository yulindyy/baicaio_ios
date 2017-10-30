//
//  CouponModel.h
//  CabbageNet
//
//  Created by xiang fu on 2017/6/5.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CouponModel : NSObject

@property (nonatomic , strong)NSString *name;      //优惠券名称
@property (nonatomic , strong)NSString *end_time;   //有效时间
@property (nonatomic , strong)NSString *tk_code;    //券码
@property (nonatomic , strong)NSString *tk_psw;     //密码（可能为空
@property (nonatomic , strong)NSString *ljdz;       //跳转地址（可能为空

@end
