//
//  CouponCell.m
//  CabbageNet
//
//  Created by xiang fu on 2017/7/9.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import "CouponCell.h"

@interface CouponCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *aboutNunLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *haveNumLabel;

@end

@implementation CouponCell

- (void)setModel:(CouponListModel *)model{
    
    if ([model.img hasPrefix:@"http:"]) {
        [_headImageView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:@"正方形占位图"]];
    }else {
        [_headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.baicaio.com/%@",model.img]] placeholderImage:[UIImage imageNamed:@"正方形占位图"]];
    }
    _titleLabel.text = model.name;
    _aboutNunLabel.text = [NSString stringWithFormat:@"截至时间：%@",model.end_time];
    _lastNumLabel.text = [NSString stringWithFormat:@"剩余：%ld张",model.sy];
    _haveNumLabel.text = [NSString stringWithFormat:@"已领：%ld张",model.yl];
    
}

- (IBAction)getBtnClick:(UIButton *)sender {
    if (self.block) self.block();
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
