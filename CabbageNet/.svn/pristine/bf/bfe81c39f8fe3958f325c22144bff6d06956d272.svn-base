//
//  DiscountCollectionCell.m
//  CabbageNet
//
//  Created by xiang fu on 2017/7/10.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import "DiscountCollectionCell.h"

@interface DiscountCollectionCell ()

@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *zanBtn;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;

@end

@implementation DiscountCollectionCell

- (void)setModel:(DiscountModel *)model{
    
    [self.topImageView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:@"正方形占位图"]];
    if (model.title.length) {
        NSString *strUrl = [model.title stringByReplacingOccurrencesOfString:@"<span>" withString:@"<span style=\"color:#ff4444\">"];//替换字符
        NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[strUrl dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        self.titleLabel.attributedText = attrStr;
    }else{
        self.titleLabel.text = @"";
    }
    

    //    if (model.price.length) {
    //        self.priceLabel.text = [NSString stringWithFormat:@"¥%@", model.price];
    //    }else{
    self.priceLabel.text = @"";//model.price;
    //    }
    //    self.fromLabel.text = @"京东";
    self.fromLabel.text = model.name;
    NSLog(@"%@",model.add_time);
    self.timeLabel.text = model.add_time ? [self timestampSwitchTime:[model.add_time integerValue]] : @"";
    [self.zanBtn setTitle:[NSString stringWithFormat:@"%ld",model.zan] forState:UIControlStateNormal];
    [self.commitBtn setTitle:[NSString stringWithFormat:@"%ld",model.likes] forState:UIControlStateNormal];
    [self.commentBtn setTitle:[NSString stringWithFormat:@"%ld",model.comments] forState:UIControlStateNormal];
    
}

-(NSString *)timestampSwitchTime:(NSInteger)timestamp{
    //更具时间差获取的时间
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timestamp];
    //当前时间
    NSDate *newdate = [NSDate date];
    //日历
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    unsigned int unitFlags = NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    
    NSDateComponents *datecom = [cal components:unitFlags fromDate:confromTimesp toDate:newdate options:0];
    
    if ([datecom day] < 1){
        if ([datecom hour] < 1){
            if ([datecom minute] < 1){
                return @"刚刚";
            }else{
                return [NSString stringWithFormat:@"%ld分钟前",[datecom minute]];
            }
        }else{
            
            return [NSString stringWithFormat:@"%ld小时前",[datecom hour]];
        }
    }else{
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"MM-dd HH:mm"];
        NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
        [formatter setTimeZone:timeZone];
        NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
        NSLog(@"===========================%@",confromTimespStr);
        return confromTimespStr;
    }
    
    return nil;
    
}
- (IBAction)goLinkAction:(UIButton *)sender {
    self.goLinkBlock();
}

@end
