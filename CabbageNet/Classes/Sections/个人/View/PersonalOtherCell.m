//
//  PersonalOtherCell.m
//  CabbageNet
//
//  Created by MacAir on 2017/4/5.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import "PersonalOtherCell.h"

@interface PersonalOtherCell ()

@property (weak, nonatomic) IBOutlet UILabel *colorLabel;

@end

@implementation PersonalOtherCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.colorLabel.backgroundColor = mAppMainColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
