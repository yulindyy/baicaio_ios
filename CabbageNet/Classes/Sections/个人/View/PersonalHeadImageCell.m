//
//  PersonalHeadImageCell.m
//  CabbageNet
//
//  Created by MacAir on 2017/4/5.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import "PersonalHeadImageCell.h"

@interface PersonalHeadImageCell ()
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIView *circlebgView;
//@property (weak, nonatomic) IBOutlet UIButton *headImageBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *goldImage;

@property (weak, nonatomic) IBOutlet UILabel *integralLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *circleconstraint;

@end

@implementation PersonalHeadImageCell

- (void)setModel:(UserInfoModel *)model{
    _model = model;
    if ([UserDefaultsGetSynchronize(@"login") isEqualToString:@"10001"]){
        self.goldLabel.text = [NSString stringWithFormat:@"%ld", model.score];
        self.nameLabel.text = model.username;
        self.signBtn.userInteractionEnabled = YES;
        if (model.is_sign == 1) {
            
            self.signBtn.userInteractionEnabled = NO;
            [self.signBtn setTitle:@"已签到" forState:UIControlStateNormal];
            self.signBtn.backgroundColor = [UIColor grayColor];
            self.signBtn.layer.borderWidth = 1;
            self.signBtn.layer.borderColor = mAppMainColor.CGColor;
            
        }
        else{
            self.signBtn.userInteractionEnabled = YES;
            self.signBtn.backgroundColor = mAppMainColor;
            [self.signBtn setTitle:@"签到" forState:UIControlStateNormal];
        }
        [self requestHeadImage];
        NSLog(@"-------------");
    }else{
        self.signBtn.userInteractionEnabled = YES;
        self.goldLabel.text = @"0";
        self.nameLabel.text = @"未登录";
        [_userHeadImage setBackgroundImage:[UIImage imageNamed:@"头像"] forState:UIControlStateNormal];
        self.signBtn.backgroundColor = mAppMainColor;
        [self.signBtn setTitle:@"签到" forState:UIControlStateNormal];
        NSLog(@"+++++++++++++");
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    CGFloat height = mScreenWidth * 90 / 375;
    
    self.circleconstraint.constant = height;
    
    self.circlebgView.layer.cornerRadius = (height)/2;
    self.circlebgView.layer.masksToBounds = YES;
    self.circlebgView.layer.borderWidth = 1;
    self.circlebgView.layer.borderColor = mAppMainColor.CGColor;
    
    self.userHeadImage.layer.cornerRadius = (height - 8)/2;
    self.userHeadImage.layer.masksToBounds = YES;
    
    self.signBtn.layer.cornerRadius = 5;
    self.signBtn.layer.masksToBounds = YES;
    
    self.goldLabel.textColor = mAppMainColor;
    self.signBtn.backgroundColor = mAppMainColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)headImageBtnClick:(UIButton *)sender {
    
    if (self.block) {
        self.block(1);
    }
}

- (IBAction)signBtnClick:(UIButton *)sender {
    if ([UserDefaultsGetSynchronize(@"login") isEqualToString:@"10001"]) {
        if ([sender.currentTitle isEqualToString:@"签到"]){
            
            
            NSMutableDictionary * infoDic = [[NSMutableDictionary alloc]init];
            setDickeyobj(infoDic, @"sign", @"api");
            UserInfoModel *model = [UserInfoModel sharedUserData];
            setDickeyobj(infoDic, model.userid, @"userid");
            NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
            setDickeyobj(param, infoDic, @"reqBody");
            
            [CKHttpCommunicate createRequest:HTTP_USER_API WithParam:param withMethod:POST success:^(id result) {
                if (SUCCESS_REQUEST(result)) {
                    if (self.block) {
                        self.block(3);
                    }
                    UserInfoModel *model = [UserInfoModel sharedUserData];
                    model.is_sign = 1;
                    [UserInfoModel storeUserWithModel:model];
                
                    sender.layer.borderWidth = 1;
                    sender.layer.borderColor = mAppMainColor.CGColor;
                    [sender setTitle:@"已签到" forState:UIControlStateNormal];
                    sender.backgroundColor = [UIColor grayColor];
                    sender.userInteractionEnabled = NO;
                    
                    [MBProgressHUD showError:@"签到成功。" toView:nil];
                    
                }else{
                    [sender setTitle:@"签到" forState:UIControlStateDisabled];
                    sender.backgroundColor = mAppMainColor;
                    sender.userInteractionEnabled = YES;
                    [MBProgressHUD showError:result[@"data"] toView:nil];
                }
            } failure:^(NSError *erro) {
                [sender setTitle:@"签到" forState:UIControlStateDisabled];
                sender.backgroundColor = mAppMainColor;
                sender.userInteractionEnabled = YES;
                NSLog(@"%@", erro);
            } showHUD:nil];
        }
    }else{
        if (self.block) {
            self.block(2);
        }
    }
}


- (void)requestHeadImage{
    
    NSMutableDictionary * infoDic = [[NSMutableDictionary alloc]init];
    setDickeyobj(infoDic, @"getimg", @"api");
    setDickeyobj(infoDic, self.model.userid, @"userid");
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    setDickeyobj(param, infoDic, @"reqBody");
    
    [CKHttpCommunicate createRequest:HTTP_USER_API WithParam:param withMethod:POST success:^(id result) {
        
        if (SUCCESS_REQUEST(result)) {
            
            if (![result[@"data"] hasPrefix:@"http://"]) {
                
                NSString *headImageUrl = [NSString stringWithFormat:@"http://www.baicaio.com%@",result[@"data"]];
                [self setHeadImage:headImageUrl];
                
            }else{
                [self setHeadImage:result[@"data"]];
                
            }
            
        }
        else{
            
            [MBProgressHUD showError:result[@"msg"] toView:nil];
        }
        
    } failure:^(NSError *erro) {
        NSLog(@"%@", erro);
    } showHUD:nil];
    
}

- (void)setHeadImage:(NSString *)img{
    
    [self.userHeadImage sd_setBackgroundImageWithURL:[NSURL URLWithString:img] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"头像"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (error) {
            NSLog(@"XXXX%@",error);
            
            [self setHeadImage:img];
        }
    }];
    
}


@end
