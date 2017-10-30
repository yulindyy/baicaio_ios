//
//  PrivateLetterModel.h
//  CabbageNet
//
//  Created by xiang fu on 2017/8/29.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PrivateLetterModel : NSObject

@property (nonatomic , copy)NSString *add_time;//时间
@property (nonatomic , copy)NSString *ck_status;//
@property (nonatomic , copy)NSString *from_id;//和自己的id一样则是 我对Ta说：
@property (nonatomic , copy)NSString *from_name;//
@property (nonatomic , copy)NSString *ftid;//
@property (nonatomic , copy)NSString *privateID;//
@property (nonatomic , copy)NSString *info;//私信
@property (nonatomic , copy)NSString *num;//共多少私信
@property (nonatomic , copy)NSString *status;//
@property (nonatomic , copy)NSString *sx_json;//
@property (nonatomic , copy)NSString *ta_id;//头像
@property (nonatomic , copy)NSString *ta_name;//名称
@property (nonatomic , copy)NSString *to_id;//
@property (nonatomic , copy)NSString *to_name;//

@end
