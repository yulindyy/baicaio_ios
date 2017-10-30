//
//  CouponCell.h
//  CabbageNet
//
//  Created by xiang fu on 2017/7/9.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CouponListModel.h"

@interface CouponCell : UITableViewCell

@property (nonatomic , strong)CouponListModel *model;
@property (nonatomic , copy)void(^block)();

@end
