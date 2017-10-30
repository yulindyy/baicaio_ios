//
//  ArticleTextCell.m
//  CabbageNet
//
//  Created by MacAir on 2017/4/10.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import "ArticleTextCell.h"

@interface ArticleTextCell ()<UITextFieldDelegate,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;
@property (nonatomic ,strong) UIButton *addImageBtn;

@end

@implementation ArticleTextCell

- (UIButton *)addImageBtn{
    if (!_addImageBtn) {
        _addImageBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.height, self.scrollView.height)];
        [_addImageBtn setImage:[UIImage imageNamed:@"添加144"] forState:UIControlStateNormal];
        [_addImageBtn addTarget:self action:@selector(addImageBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addImageBtn;
}

- (void)addImageBtnClick{
    
    
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    [self.scrollView addSubview:self.addImageBtn];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"--%@---",textField.text);
}

- (void)textViewDidChange:(UITextView *)textView{
    
    CGFloat curheight = 0;
    if (textView.text.length == 0) {
        self.placeholderLabel.hidden = NO;
    }else{
        self.placeholderLabel.hidden = YES;

    }
    if (self.textViewChangeBlock) {
        self.textViewChangeBlock(textView.text,curheight + 70);
        
    }
}

@end
