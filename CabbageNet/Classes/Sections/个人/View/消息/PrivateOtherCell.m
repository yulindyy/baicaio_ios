//
//  PrivateOtherCell.m
//  CabbageNet
//
//  Created by xiang fu on 2017/8/29.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import "PrivateOtherCell.h"

@interface PrivateOtherCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeWidth;
@property (weak, nonatomic) IBOutlet UIImageView *bgImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *infoWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgImageHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgImageWidht;

@end

@implementation PrivateOtherCell

- (void)setModel:(PrivateLetterModel *)model{
    
    _timeLabel.text = [self timestampSwitchTime:[model.add_time integerValue]];
    _infoLabel.text = model.info;
    [self requestHeadImage:model.from_id];
    _nameLabel.text = model.from_name;
    
    CGFloat timeWidth = [_timeLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}].width + 5;
    _timeWidth.constant = timeWidth;
    CGRect inforect = [model.info boundingRectWithSize:CGSizeMake(mScreenWidth - 100 - timeWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil];
    _infoWidth.constant = inforect.size.width + 2;
    
    _bgImageHeight.constant = inforect.size.height + 20;
    _bgImageWidht.constant = inforect.size.width + 15;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIImage *image = _bgImage.image;
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(30, 30, 30, 15) resizingMode:UIImageResizingModeStretch];
    _bgImage.image = image;
    
    _bgImageWidht.constant = 200;
    _bgImageHeight.constant = 50;
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
