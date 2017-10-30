//
//  AttentionCell.m
//  CabbageNet
//
//  Created by xiang fu on 2017/8/7.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import "AttentionCell.h"

@implementation AttentionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)pushBtnClick:(UIButton *)sender {
    sender.selected =!sender.selected;
    if (self.PushBlock) self.PushBlock(sender.selected);
}

- (IBAction)delBtnClick {
    if (self.Block) self.Block();
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
