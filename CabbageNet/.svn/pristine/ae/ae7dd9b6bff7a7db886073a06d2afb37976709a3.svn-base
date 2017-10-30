//
//  WealthSignCell.m
//  CabbageNet
//
//  Created by MacAir on 2017/4/6.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import "WealthSignCell.h"

@interface WealthSignCell ()



@property (weak, nonatomic) IBOutlet UIButton *ruleBtn;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *offerLabel;
@property (weak, nonatomic) IBOutlet UILabel *expLabel;
@property (weak, nonatomic) IBOutlet UILabel *coinLabel;

@property (nonatomic , strong)UserInfoModel *model;

@end

@implementation WealthSignCell

- (UserInfoModel *)model{
    return [UserInfoModel sharedUserData];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.signBtn.layer.cornerRadius = self.signBtn.height/2;
    self.signBtn.layer.masksToBounds = YES;
    self.signBtn.backgroundColor = mAppMainColor;
    [self.ruleBtn setTitleColor:mAppMainColor forState:UIControlStateNormal];
    self.detailLabel.textColor = mAppMainColor;
    
    
    UserInfoModel *userinfoModle = [UserInfoModel sharedUserData];
    _coinLabel.text = [NSString stringWithFormat:@"金币：%ld",userinfoModle.coin];
    _expLabel.text = [NSString stringWithFormat:@"经验：%ld",userinfoModle.exp];
    _offerLabel.text = [NSString stringWithFormat:@"贡献：%ld",userinfoModle.offer];
    _integralLabel.text = [NSString stringWithFormat:@"当前积分:%ld",userinfoModle.score];

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


//签到
- (IBAction)signButtonClick:(UIButton *)sender {
    NSLog(@"签到");
    
    NSMutableDictionary * infoDic = [[NSMutableDictionary alloc]init];
    setDickeyobj(infoDic, @"sign", @"api");
    setDickeyobj(infoDic, self.model.userid, @"userid");
    NSMutableDictionary * param = [[NSMutableDictionary alloc]init];
    setDickeyobj(param, infoDic, @"reqBody");
    
    [CKHttpCommunicate createRequest:HTTP_USER_API WithParam:param withMethod:POST success:^(id result) {
        
        if (SUCCESS_REQUEST(result)) {

            UserInfoModel *model = [UserInfoModel sharedUserData];
            model.is_sign = 1;
            [UserInfoModel storeUserWithModel:model];
            
            [sender setTitle:@"已签到" forState:UIControlStateDisabled];
            sender.backgroundColor = [UIColor lightGrayColor];
            sender.enabled = NO;

        } else {
            [MBProgressHUD showError:result[@"msg"] toView:nil];
        }
        
        
    } failure:^(NSError *erro) {
        NSLog(@"%@", erro);
    } showHUD:nil];

}




- (IBAction)ruleBtnClick {
    
    if (self.block) {
        self.block();
    }
    
}

@end
