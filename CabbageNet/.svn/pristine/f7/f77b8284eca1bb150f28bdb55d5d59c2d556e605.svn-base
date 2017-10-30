//
//  AlreadyExchangeCell.m
//  CabbageNet
//
//  Created by xiang fu on 2017/6/16.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import "AlreadyExchangeCell.h"

@interface AlreadyExchangeCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;

@end

@implementation AlreadyExchangeCell

- (void)setModel:(LogistisInfoModel *)model{
    
    _titleLabel.text = model.item_name;
    _numLabel.text = [NSString stringWithFormat:@"数量：%ld",model.item_num];
    _remarkLabel.text = model.remark;
    _timeLabel.text = [self timestampSwitchTime:[model.add_time integerValue]];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(NSString *)timestampSwitchTime:(NSInteger)timestamp{
    //更具时间差获取的时间
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timestamp];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"MM-dd  HH:mm"];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
