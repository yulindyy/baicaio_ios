//
//  MessageCell.m
//  CabbageNet
//
//  Created by MacAir on 2017/4/6.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import "MessageCell.h"

@interface MessageCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@end

@implementation MessageCell

- (void)setModel:(MessageModel *)model{
    
    _model = model;
    _titleLabel.text = @"系统消息";
    _timeLabel.text = [self timestampSwitchTime:[model.add_time integerValue]];
    self.infoLabel.text = model.info;
    
}

-(NSString *)timestampSwitchTime:(NSInteger)timestamp{
    if (timestamp == 0) return @"刚刚";
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
