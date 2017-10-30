//
//  AddressModel.h
//  CabbageNet
//
//  Created by 周佳鑫 on 2017/6/6.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressModel : NSObject

@property (nonatomic, strong) NSString *userid;
@property (nonatomic, strong) NSString *addressid;  //收货地址id ，查改需要使用（缓存时请以 addressid为名缓存）
@property (nonatomic, strong) NSString *consignee;  //收货人姓名
@property (nonatomic, strong) NSString *address;    //收货地址
@property (nonatomic, strong) NSString *zip;      //邮编
@property (nonatomic, strong) NSString *mobile; //收货手机号码

@property (nonatomic , assign) BOOL isSelected;

@end
