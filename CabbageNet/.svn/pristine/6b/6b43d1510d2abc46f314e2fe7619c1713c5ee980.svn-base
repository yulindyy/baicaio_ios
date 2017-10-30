//
//  DetailInfoCell.m
//  CabbageNet
//
//  Created by MacAir on 2017/4/8.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import "DetailInfoCell.h"

@interface DetailInfoCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *freeShippingLabel;
@property (weak, nonatomic) IBOutlet UILabel *haveGoodsLabel;

@end

@implementation DetailInfoCell

- (void)setModel:(DiscountDetailModel *)model{
    if (model.title.length){
        NSString *strUrl = [model.title stringByReplacingOccurrencesOfString:@"<span>" withString:@"<span style=\"color:#ff4444\">"];//替换字符
        NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[strUrl dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        self.titleLabel.attributedText = attrStr;
    }else{
        self.titleLabel.text = @"";
    }
    self.addressLabel.text = model.orig[@"name"];
    self.timeLabel.text = [self timestampSwitchTime:[model.add_time integerValue]];
    if (model.price.length)self.priceLabel.text = model.price;
    else self.priceLabel.text = @"";
//    self.freeShippingLabel.text =
//    self.haveGoodsLabel.text = 
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
        [formatter setDateFormat:@"MM-dd  HH:mm"];
        NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
        [formatter setTimeZone:timeZone];
        NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
        return confromTimespStr;
    }
    
    return nil;
    
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
