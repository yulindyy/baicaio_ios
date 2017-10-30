//
//  PrivateLatterCell.m
//  CabbageNet
//
//  Created by xiang fu on 2017/8/29.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import "PrivateLatterCell.h"

@interface PrivateLatterCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;

@end

@implementation PrivateLatterCell

- (void)setModel:(PrivateLetterModel *)model{
    
    _nameLabel.text = model.ta_name;
    UserInfoModel *userInfo = [UserInfoModel sharedUserData];
    if ([userInfo.userid isEqualToString:model.from_id]) {
       _infoLabel.text = [NSString stringWithFormat:@"我对Ta说:%@",model.info];
    }else{
       _infoLabel.text = [NSString stringWithFormat:@"Ta对我说:%@",model.info];
    }
    _timeLabel.text = [self timestampSwitchTime:[model.add_time integerValue]];
    _numLabel.text = [NSString stringWithFormat:@"共%@条私信",model.num];
    [self requestHeadImage:model.ta_id];
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

- (void)requestHeadImage:(NSString *)userid{
    
    NSMutableDictionary * infoDic = [[NSMutableDictionary alloc]init];
    setDickeyobj(infoDic, @"getimg", @"api");
    setDickeyobj(infoDic, userid, @"userid");
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    setDickeyobj(param, infoDic, @"reqBody");
    
    [CKHttpCommunicate createRequest:HTTP_USER_API WithParam:param withMethod:POST success:^(id result) {
        
        if (SUCCESS_REQUEST(result)) {
            
            if (![result[@"data"] hasPrefix:@"http://"]) {
                NSString *headImageUrl = [NSString stringWithFormat:@"http://www.baicaio.com%@",result[@"data"]];
                
                [self.headImageView sd_setImageWithURL:[NSURL URLWithString:headImageUrl] placeholderImage:[UIImage imageNamed:@"头像"]];
                
            }else{
                
                [self.headImageView sd_setImageWithURL:[NSURL URLWithString:result[@"data"]]  placeholderImage:[UIImage imageNamed:@"头像"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                    NSLog(@"%@",error);
                }];
            }
            
        }
        else{
            
            [MBProgressHUD showError:result[@"msg"] toView:nil];
        }
        
    } failure:^(NSError *erro) {
        NSLog(@"%@", erro);
    } showHUD:nil];
    
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
