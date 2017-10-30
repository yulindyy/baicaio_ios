//
//  DiscountCell.h
//  CabbageNet
//
//  Created by MacAir on 2017/4/7.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiscountModel.h"

@interface DiscountCell : UITableViewCell

@property (nonatomic , strong)DiscountModel *model;
@property (nonatomic , copy)  void (^goLinkBlock)(void);
@end
