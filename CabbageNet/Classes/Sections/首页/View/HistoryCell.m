//
//  HistoryCell.m
//  CabbageNet
//
//  Created by xiang fu on 2017/8/7.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import "HistoryCell.h"

@implementation HistoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)deletedBtnClick {
    if (self.Block) self.Block();
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
