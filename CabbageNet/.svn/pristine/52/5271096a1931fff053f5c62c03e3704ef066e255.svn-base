//
//  UserInfoModel.h
//  CabbageNet
//
//  Created by MacAir on 2017/4/12.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoModel : NSObject

@property (nonatomic , assign)NSInteger coin;   //
@property (nonatomic , strong)NSString *email;
@property (nonatomic , assign)NSInteger exp;
@property (nonatomic , assign)NSInteger offer;
@property (nonatomic , assign)NSInteger gender;     //修改后的性别，1男 0女
@property (nonatomic , assign)NSInteger score;      //积分
@property (nonatomic , strong)NSString *userid;     //用户ID
@property (nonatomic , strong)NSString *username;   //用户名
@property (nonatomic , assign)NSInteger is_sign;    //是否已经签到
@property (nonatomic , strong)NSString *mobile;     //用户手机
@property (nonatomic , strong)NSString *headImageUrl;//用户头像
@property (nonatomic , strong)NSString *imageBase64Code;//头像编码

+ (UserInfoModel *)sharedUserData;
+ (void)storeUserWithModel:(UserInfoModel *)model;

@end
