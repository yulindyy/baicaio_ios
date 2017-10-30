//
//  ExchangeCell.h
//  CabbageNet
//
//  Created by MacAir on 2017/4/7.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExchangeModel.h"

@interface ExchangeCell : UITableViewCell

@property (nonatomic , strong)ExchangeModel *model;
@property (nonatomic , copy)void(^block)();
+ (instancetype)getExchangeCell;
- (void)changeColor;

@end
