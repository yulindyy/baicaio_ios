//
//  AddressSelectedCell.m
//  CabbageNet
//
//  Created by xiang fu on 2017/6/29.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import "AddressSelectedCell.h"

@interface AddressSelectedCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectImageCell;

@end

@implementation AddressSelectedCell

- (void)setModel:(AddressModel *)model{
    
    _nameLabel.text = model.consignee;
    _numLabel.text = model.zip;
    _numLabel.text = model.mobile;
    _addressLabel.text = model.address;
    _selectImageCell.image = model.isSelected ? [UIImage imageNamed:@"选择"]:[UIImage imageNamed:@"未选"];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
