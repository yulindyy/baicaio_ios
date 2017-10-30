//
//  CouponImageCell.h
//  CabbageNet
//
//  Created by MacAir on 2017/4/7.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CouponModel.h"


@interface CouponImageCell : UITableViewCell

@property (nonatomic , strong)CouponModel *model;
@property (nonatomic , assign)NSInteger type;

@end
