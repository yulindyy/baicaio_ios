//
//  SelectedAddressView.m
//  CabbageNet
//
//  Created by xiang fu on 2017/6/28.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import "SelectedAddressView.h"

@interface SelectedAddressView ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cenLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;


@end

@implementation SelectedAddressView

- (void)setModel:(AddressModel *)model{
    
    self.nameLabel.text = model.consignee;
    self.cenLabel.text = model.zip;
    self.phoneLabel.text = model.mobile;
    self.addressLabel.text = model.address;
}

+ (instancetype)getSelectedAddressView{
    return [[[NSBundle mainBundle] loadNibNamed:@"SelectedAddressView" owner:nil options:nil]lastObject];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



@end
