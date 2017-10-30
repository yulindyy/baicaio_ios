//
//  PushCell.h
//  CabbageNet
//
//  Created by xiang fu on 2017/8/4.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PushCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UISwitch *cellSwitch;
@property (nonatomic , copy)void(^Block)(BOOL isON);

@end
