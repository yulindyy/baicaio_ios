//
//  ArticleClassCell.m
//  CabbageNet
//
//  Created by MacAir on 2017/4/10.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import "ArticleClassCell.h"

@interface ArticleClassCell ()

@property (weak, nonatomic) IBOutlet UIButton *selectClassBtn;

@end

@implementation ArticleClassCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectClassBtn.layer.borderWidth = 2;
    self.selectClassBtn.layer.borderColor = mAppMainColor.CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)selectClassBtnClick:(UIButton *)sender {
}

@end
