//
//  HistoryCell.h
//  CabbageNet
//
//  Created by xiang fu on 2017/8/7.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic , copy) void(^Block)();

@end
