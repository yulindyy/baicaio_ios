//
//  AddressManagerCell.m
//  CabbageNet
//
//  Created by MacAir on 2017/4/6.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import "AddressManagerCell.h"

@interface AddressManagerCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameWidthConstraint;
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

@end

@implementation AddressManagerCell

- (void)setModel:(AddressModel *)model{
    
    _model = model;
    _nameLabel.text = model.consignee;
    _codeLabel.text = model.zip;
    _phoneLabel.text = model.mobile;
    _addressLabel.text = model.address;
    
    _selectBtn.selected = model.isSelected;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)editBtnClick:(UIButton *)sender {
    
    if (self.editBlock) {
        self.editBlock(1);
    }
    
}

- (IBAction)deletedBtnClick:(UIButton *)sender {
    if (self.editBlock) {
        self.editBlock(2);
    }
    
}

- (IBAction)selectedBtnClick {
    if (_selectBtn.selected){
        if (self.editBlock) self.editBlock(4);
    }else{
        if (self.editBlock) self.editBlock(3);
    }
}


@end
