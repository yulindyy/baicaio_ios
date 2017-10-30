//
//  ProblemEditCell.m
//  CabbageNet
//
//  Created by MacAir on 2017/4/8.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import "ProblemEditCell.h"

@interface ProblemEditCell ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;

@end

@implementation ProblemEditCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.placeholderLabel.text = @"请在这里填写您对白菜哦的建议，我们将不断努力改进，感谢支持";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];


}

- (void)textViewDidChange:(UITextView *)textView{
    
    self.placeholderLabel.hidden = textView.text.length == 0 ? NO :YES;
    if (textView.text.length){
        if (self.block) self.block(textView.text);
    }
    
}

@end
