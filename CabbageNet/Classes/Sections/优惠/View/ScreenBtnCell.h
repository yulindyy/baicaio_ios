//
//  ScreenBtnCell.h
//  CabbageNet
//
//  Created by MacAir on 2017/4/8.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScreenBtnCell : UITableViewCell

@property (nonatomic , copy)void(^block)(NSInteger tag);
@property (nonatomic , strong)NSArray *array;
@property (nonatomic , strong)NSString *selectedCid;

@end
