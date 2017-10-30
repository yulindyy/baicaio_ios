//
//  PersonalBtnCell.h
//  CabbageNet
//
//  Created by MacAir on 2017/4/5.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalBtnCell : UITableViewCell

@property (nonatomic , strong)NSArray *btnTitleArray;
@property (nonatomic , copy)void(^block)(NSInteger tag);

@end
