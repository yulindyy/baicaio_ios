//
//  CouponImageCell.m
//  CabbageNet
//
//  Created by MacAir on 2017/4/7.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import "CouponImageCell.h"

@interface CouponImageCell ()

@property (weak, nonatomic) IBOutlet UIImageView *couponImage;
@property (weak, nonatomic) IBOutlet UIImageView *circleImageView;
@property (weak, nonatomic) IBOutlet UILabel *titlelabel;
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (weak, nonatomic) IBOutlet UILabel *pwdLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation CouponImageCell

- (void)setModel:(CouponModel *)model{
    _model = model;
    self.titlelabel.text = model.name;
    if (model.tk_code){
        self.codeLabel.text = [NSString stringWithFormat:@"券码：%@",model.tk_code];
    }else{
        self.codeLabel.text = @"";
    }
    
    if (model.tk_psw) {
        self.pwdLabel.text = [NSString stringWithFormat:@"密码：%@",model.tk_code];
    }else{
        self.pwdLabel.text = @"";
    }
    self.timeLabel.text = model.end_time;//[self timestampSwitchTime:[model.end_time integerValue]];

}

- (void)setType:(NSInteger)type{
    if (type == 1){
        [self.couponImage setImage:[UIImage imageNamed:@"普通优惠券"]];
        [self.circleImageView setImage:[UIImage imageNamed:@"优惠券黄"]];
    }else if (type == 2){
        [self.couponImage setImage:[UIImage imageNamed:@"已过期优惠券"]];
        [self.circleImageView setImage:[UIImage imageNamed:@"优惠券灰"]];
    }
}

-(NSString *)timestampSwitchTime:(NSInteger)timestamp{
    //更具时间差获取的时间
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timestamp];
//    //当前时间
//    NSDate *newdate = [NSDate date];
//    //日历
//    NSCalendar *cal = [NSCalendar currentCalendar];
//    
//    unsigned int unitFlags = NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
//    
//    NSDateComponents *datecom = [cal components:unitFlags fromDate:confromTimesp toDate:newdate options:0];
//    
//    if ([datecom day] < 1){
//        if ([datecom hour] < 1){
//            if ([datecom minute] < 1){
//                return @"刚刚";
//            }else{
//                return [NSString stringWithFormat:@"%ld分钟前",[datecom minute]];
//            }
//        }else{
//            
//            return [NSString stringWithFormat:@"%ld小时前",[datecom hour]];
//        }
//    }else{
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"MM-dd  HH:mm"];
        NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
        [formatter setTimeZone:timeZone];
        NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
        return confromTimespStr;
//    }
//    
//    return nil;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];

    UILongPressGestureRecognizer *longPressGR = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(lpGR:)];
    //设定最小的长按时间 按不够这个时间不响应手势
    longPressGR.minimumPressDuration = 1;
    [self addGestureRecognizer:longPressGR];
}

//实现手势对应的功能
-(void)lpGR:(UILongPressGestureRecognizer *)lpGR{
    if (lpGR.state == UIGestureRecognizerStateBegan) {//手势开始
//        CGPoint point = [lpGR locationInView:self.tbFirst];
//        
//        self.index = [self.tbFirst indexPathForRowAtPoint:point]; // 可以获取我们在哪个cell上长按
//        
//        self.indexNum = self.index.row;
        NSLog(@"长按开始");
    }
    
    if (lpGR.state == UIGestureRecognizerStateEnded){//手势结束
        UIPasteboard *pab = [UIPasteboard generalPasteboard];
        pab.string = self.model.tk_code;
        [MBProgressHUD showError:@"券码复制成功" toView:nil];
        
        NSLog(@"长按结束");
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
