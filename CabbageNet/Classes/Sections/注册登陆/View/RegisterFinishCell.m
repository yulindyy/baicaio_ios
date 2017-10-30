//
//  RegisterFinishCell.m
//  CabbageNet
//
//  Created by xiang fu on 2017/6/21.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import "RegisterFinishCell.h"

@implementation RegisterFinishCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)regestBtnClick:(UIButton *)sender {
    
    if (self.block) self.block(1);
}

- (IBAction)agreeBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
}

- (IBAction)protolBtnClick:(UIButton *)sender {
    if (self.block) self.block(2);
}

@end
