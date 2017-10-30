//
//  ExchangeCell.m
//  CabbageNet
//
//  Created by MacAir on 2017/4/7.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import "ExchangeCell.h"

@interface ExchangeCell ()

@property (weak, nonatomic) IBOutlet UIImageView *infoImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *integralLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIButton *exchangeBtn;

@end

@implementation ExchangeCell

- (void)setModel:(ExchangeModel *)model{
    //http://www.baicaio.com/
    if ([model.img hasPrefix:@"http://"]){
        [self.infoImageView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:@"正方形占位图"]];
    }else{
        [self.infoImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.baicaio.com/%@",model.img]] placeholderImage:[UIImage imageNamed:@"正方形占位图"]];
    }
    self.titleLabel.text = model.title;
    self.integralLabel.text = [NSString stringWithFormat:@"%ld", model.score];
    self.scoreLabel.text = [NSString stringWithFormat:@"%ld", model.coin];
    
}

+ (instancetype)getExchangeCell{
    
    return [[[NSBundle mainBundle]loadNibNamed:@"ExchangeCell" owner:nil options:nil]lastObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.exchangeBtn.layer.cornerRadius = 4;
    self.exchangeBtn.layer.masksToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)changeColor{
    [self.exchangeBtn setTitleColor:self.exchangeBtn.backgroundColor forState:UIControlStateNormal];
    self.exchangeBtn.backgroundColor = [UIColor whiteColor];
}

- (IBAction)exchangeBtnClick:(UIButton *)sender {
    if (self.block) self.block();
}

@end
