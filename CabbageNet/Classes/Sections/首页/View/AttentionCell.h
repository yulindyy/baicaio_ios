//
//  AttentionCell.h
//  CabbageNet
//
//  Created by xiang fu on 2017/8/7.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttentionCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *pushBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic , copy)void(^Block)();
@property (nonatomic , copy)void(^PushBlock)(BOOL isPus);

@end
