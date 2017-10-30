//
//  OriginalInfoCell.m
//  CabbageNet
//
//  Created by MacAir on 2017/4/5.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import "OriginalInfoCell.h"

@interface OriginalInfoCell ()

@property (weak, nonatomic) IBOutlet UIImageView *bigImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *browseBtn;
@property (weak, nonatomic) IBOutlet UIButton *likesBtn;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;

@end

@implementation OriginalInfoCell

+ (instancetype)getOriginalInfoCell{
    
    return [[[NSBundle mainBundle] loadNibNamed:@"OriginalInfoCell" owner:nil options:nil] lastObject];
}

- (void)setModel:(OriginalModel *)model{
    if (![model.img hasPrefix:@"http://"]) {
        NSString *headImageUrl = [NSString stringWithFormat:@"http://www.baicaio.com%@",model.img];
        
        [self.bigImageView sd_setImageWithURL:[NSURL URLWithString:headImageUrl] placeholderImage:[UIImage imageNamed:@"占位图片21"]];
    }else {
        [self.bigImageView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:@"占位图片21"]];
    }
    self.titleLabel.text = model.title;
    self.infoLabel.text = model.intro;
    [self requestHeadImage:model.uid];
    self.nameLable.text = model.author;
    
    self.timeLabel.text = [self timestampSwitchTime:[model.add_time integerValue]];
    
    [self.browseBtn setTitle:[NSString stringWithFormat:@"%ld",model.zan] forState:UIControlStateNormal];
    [self.likesBtn setTitle:[NSString stringWithFormat:@"%ld",model.likes]  forState:UIControlStateNormal];
    [self.commentBtn setTitle:[NSString stringWithFormat:@"%ld",model.comments] forState:UIControlStateNormal];
    
    switch (model.status) {
        case 0:
            _signLabel.text = @"待审";
            break;
        case 1:
            _signLabel.text = @"通过";
            break;
        case 2:
            _signLabel.text = @"草稿";
            break;
        case 3:
            _signLabel.text = @"退回";
            break;
        case 4:
            _signLabel.text = @"通过";
            break;
        default:
            break;
    }
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
    
    self.headImageView.layer.cornerRadius = self.headImageView.width/2;
    self.headImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
