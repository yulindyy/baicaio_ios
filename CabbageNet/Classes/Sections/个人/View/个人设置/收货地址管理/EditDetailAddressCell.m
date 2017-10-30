//
//  EditDetailAddressCell.m
//  CabbageNet
//
//  Created by MacAir on 2017/4/6.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import "EditDetailAddressCell.h"

@interface EditDetailAddressCell ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation EditDetailAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.bgView.layer.cornerRadius = 5;
    self.bgView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)textViewDidChangeSelection:(UITextView *)textView{
    
    self.placeholderLabel.hidden = textView.text.length > 0 ? YES : NO;
    
}

@end
