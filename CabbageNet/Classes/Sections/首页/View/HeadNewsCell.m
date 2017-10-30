//
//  HeadNewsCell.m
//  CabbageNet
//
//  Created by MacAir on 2017/4/7.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import "HeadNewsCell.h"
#import "DiscountModel.h"

@interface HeadNewsCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView1;
@property (weak, nonatomic) IBOutlet UIView *bgView2;
@property (weak, nonatomic) IBOutlet UIView *bgView3;
@property (weak, nonatomic) IBOutlet UIView *bgView4;
@property (weak, nonatomic) IBOutlet UIImageView *firstImageView;
@property (weak, nonatomic) IBOutlet UILabel *firstTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstPriceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *secondImageView;
@property (weak, nonatomic) IBOutlet UILabel *secondTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondPriceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *threedImageView;
@property (weak, nonatomic) IBOutlet UILabel *ThreedTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *threedPriceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *fourImageView;
@property (weak, nonatomic) IBOutlet UILabel *fourTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *fourPriceLabel;

@end

@implementation HeadNewsCell

- (void)setArray:(NSArray *)array{
    
    if (array.count == 0) return;
    for (int i = 0; i < 4; i ++) {
        DiscountModel *model = array[i];
        if (i == 0) {
            
            [self.firstImageView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:@"正方形占位图"]];
            self.firstTitleLabel.text = model.title;
            self.firstPriceLabel.text = model.price;
            
        }else if (i == 1){
            
            [self.secondImageView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:@"正方形占位图"]];
            self.secondTitleLabel.text = model.title;
            self.secondPriceLabel.text = model.price;
            
        }else if (i == 2){
            
            [self.fourImageView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:@"正方形占位图"]];
            self.fourTitleLabel.text = model.title;
            self.fourPriceLabel.text = model.price;
            
        }else if (i == 3){
            
            [self.threedImageView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:@"正方形占位图"]];
            self.ThreedTitleLabel.text = model.title;
            self.threedPriceLabel.text = model.price;
            
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = touches.anyObject;
    CGPoint touchPoint = [touch locationInView:self];
//    NSLog(@"%lf  %lf  ===%lf %lf",touchPoint.x,touchPoint.y,self.width,self.height);
    
    if (touchPoint.y > self.bgView1.frame.origin.y && touchPoint.y < self.bgView1.frame.origin.y + self.bgView1.height) {
        
        if (touchPoint.x < self.bgView1.width) {
            if (self.block) {
                self.block(1);
            }
            return;
        }else if (touchPoint.y < self.bgView2.origin.y + self.bgView2.height) {
            if (self.block) {
                self.block(2);
            }
            return;
        }else if (touchPoint.x < self.bgView4.width + self.bgView1.width) {
            if (self.block) {
                self.block(3);
            }
            return;
        }else{
            if (self.block) {
                self.block(4);
            }
            return;
        }
    }
    return;

}

@end
