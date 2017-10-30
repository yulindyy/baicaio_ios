//
//  DetailCommentCell.m
//  CabbageNet
//
//  Created by MacAir on 2017/4/8.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import "DetailCommentCell.h"

@interface DetailCommentCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *zanNumLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moreHeight;
@property (weak, nonatomic) IBOutlet UIView *moreCommentView;

@end

@implementation DetailCommentCell

- (void)setModel:(AllCommentModel *)model{
    
    [self requestHeadImage:model.uid];
    self.nameLabel.text = model.uname;
    self.timeLabel.text = [self timestampSwitchTime:[model.add_time integerValue]];
    NSString *infoText = model.info;
    if ([model.info containsString:@"|"]) {
        NSRange range = [model.info rangeOfString:@"|"];
        infoText = [model.info substringToIndex:range.location];
    }
//    self.infoLabel.text = infoText;
    self.infoLabel.attributedText = [self replaceEmotion:infoText];
    self.numLabel.text = [NSString stringWithFormat:@"%ld楼",model.lc];
    self.zanNumLabel.text = [NSString stringWithFormat:@"%ld",model.zan];
    
    CGFloat height = 0.01;
    CGFloat margin = 5;
    CGFloat labW = mScreenWidth - 40;
    CGFloat labelY = margin;
    for (UILabel *label in self.moreCommentView.subviews) {
        if (label.tag > 100) {
            [label removeFromSuperview];
        }
    }
    for (int i = 0; i < model.list.count; i ++) {
        
        CommentListModel *listmodel = model.list[i];
        NSString *string = [NSString stringWithFormat:@"%@回复:%@",listmodel.uname,listmodel.info];
        CGRect rect = [string boundingRectWithSize:CGSizeMake(mScreenWidth - 40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13]} context:nil];
        height += rect.size.height + margin * 2;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, labelY, labW, rect.size.height)];
        label.tag = i + 101;
        if ([string containsString:@"|"]) {
            NSRange range = [string rangeOfString:@"|"];
            string = [string substringToIndex:range.location];
        }
        label.attributedText = [self replaceEmotion:string];
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = toPCcolor(@"333333");
        label.numberOfLines = 0;
        [self.moreCommentView addSubview:label];
        
        labelY += rect.size.height + margin;
    }
    _moreHeight.constant = height;
    
    
    
}

- (NSAttributedString *)replaceEmotion:(NSString *)infoText{
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"allEmotion" ofType:@"plist"];
    NSArray *face = [NSArray arrayWithContentsOfFile:filePath];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:infoText];
    NSString *regex_emoji = @"\\[(\\S+?)\\]";//@"\\[[a-zA-Z0-9\\/\\u4e00-\\u9fa5]+\\]";//匹配表情
    NSError *error =nil;
    NSRegularExpression *re = [NSRegularExpression regularExpressionWithPattern:regex_emoji options:NSRegularExpressionCaseInsensitive error:&error];
    if(!re) {
        NSLog(@"%@", [error localizedDescription]);
        return attributeString;
    }
    NSArray *resultArray = [re matchesInString:infoText options:0 range:NSMakeRange(0, infoText.length)];
    NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:resultArray.count];
    //根据匹配范围来用图片进行相应的替换
    for(NSTextCheckingResult *match in resultArray) {
        //获取数组元素中得到range
        NSRange range = [match range];
        //获取原字符串中对应的值
        NSString *subStr = [infoText substringWithRange:range];
        for(int i =0; i < face.count; i ++) {
            if([face[i][@"cht"] isEqualToString:subStr]) {
                //face[i][@"png"]就是我们要加载的图片
                //新建文字附件来存放我们的图片,iOS7才新加的对象
                NSTextAttachment *textAttachment = [[NSTextAttachment alloc]init];
                //给附件添加图片
                textAttachment.image= [UIImage imageNamed:face[i][@"png"]];
                //调整一下图片的位置,如果你的图片偏上或者偏下，调整一下bounds的y值即可
                textAttachment.bounds=CGRectMake(0, -3, textAttachment.image.size.width - 8, textAttachment.image.size.height - 8);
                //把附件转换成可变字符串，用于替换掉源字符串中的表情文字
                NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:textAttachment];
                //把图片和图片对应的位置存入字典中
                NSMutableDictionary *imageDic = [NSMutableDictionary dictionaryWithCapacity:2];
                [imageDic setObject:imageStr forKey:@"image"];
                [imageDic setObject:[NSValue valueWithRange:range]forKey:@"range"];
                //把字典存入数组中
                [imageArray addObject:imageDic];
                break;
            }
        }
    }
    //4、从后往前替换，否则会引起位置问题
    for(int i = (int)imageArray.count-1; i >=0; i--) {
        NSRange range;
        [imageArray[i][@"range"] getValue:&range];
        //进行替换
        [attributeString replaceCharactersInRange:range withAttributedString:imageArray[i][@"image"]];
    }
    return attributeString;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)zanBtnClick:(UIButton *)sender {
    if (self.block) self.block(sender);
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


@end
