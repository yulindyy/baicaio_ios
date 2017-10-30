//
//  SignModel.h
//  CabbageNet
//
//  Created by xiang fu on 2017/8/7.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SignModel : NSObject

@property (nonatomic , assign)BOOL f_sign;//1表示已关注，0表示未关注
@property (nonatomic , copy)NSString *signID;
@property (nonatomic , assign)BOOL p_sign; //1表示推送，0表示不推送
@property (nonatomic , copy)NSString *tag;
@property (nonatomic , copy)NSString *uid;

@end
