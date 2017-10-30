//
//  IntegralDetailImageCell.m
//  CabbageNet
//
//  Created by xiang fu on 2017/6/8.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import "IntegralDetailImageCell.h"

@interface IntegralDetailImageCell ()

@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *goldLabel;
@property (weak, nonatomic) IBOutlet UILabel *stockLabel;
@property (weak, nonatomic) IBOutlet UILabel *buyNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNumLabel;


@end

@implementation IntegralDetailImageCell

- (void)setModel:(IntegralDetailModel *)model{
    //http://www.baicaio.com/
    if (![model.img hasPrefix:@"http://"]) {
        NSString *headImageUrl = [NSString stringWithFormat:@"http://www.baicaio.com/%@",model.img];
//        [self.topImageView sd_setImageWithURL:[NSURL URLWithString:headImageUrl] placeholderImage:[UIImage imageNamed:@"占位图片21"]];
        [self.topImageView sd_setImageWithURL:[NSURL URLWithString:headImageUrl] placeholderImage:[UIImage imageNamed:@"占位图片21"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (!error) {

//                if (self.block) self.block(mScreenWidth*image.size.height/image.size.width);
            }
        }];
    }else{
//        [self.topImageView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:@"占位图片21"]];
        [self.topImageView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:@"占位图片21"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (!error) {
//                if (self.block) self.block(mScreenWidth*image.size.height/image.size.width);
            }
        }];
    }
    self.infoLabel.text = model.title;
    self.goldLabel.text = [NSString stringWithFormat:@"%ld金币  %ld积分",model.coin,model.score];
    self.stockLabel.text = [NSString stringWithFormat:@"库存：%ld",model.stock];
    self.buyNumLabel.text = [NSString stringWithFormat:@"已兑换数量：%ld",model.buy_num];
    self.userNumLabel.text = [NSString stringWithFormat:@"每人限兑：%ld",model.user_num];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _topImageView.contentMode = UIViewContentModeScaleAspectFit;
    _topImageView.clipsToBounds = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
