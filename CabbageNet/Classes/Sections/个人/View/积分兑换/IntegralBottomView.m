//
//  IntegralBottomView.m
//  CabbageNet
//
//  Created by xiang fu on 2017/6/9.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import "IntegralBottomView.h"

@interface IntegralBottomView ()<UITextFieldDelegate>

@property (nonatomic , strong)UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation IntegralBottomView{
    NSInteger _num;
}

- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, mScreenHeight, mScreenWidth, mScreenHeight)];
        _backBtn.alpha = 0;
        _backBtn.backgroundColor = [UIColor blackColor];
        [_backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

+ (instancetype)getIntegralBottomView{
    return [[[NSBundle mainBundle] loadNibNamed:@"IntegralBottomView" owner:nil options:nil]lastObject];
}

- (void)setBase{
    _num = 1;
    self.textField.text  = [NSString stringWithFormat:@"%ld",_num];
    //增加监听，当键盘出现或改变时
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)name:UIKeyboardWillShowNotification object:nil];
    //增加监听，当键退出时
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)name:UIKeyboardWillHideNotification object:nil];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    _num = [textField.text integerValue];
}

//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    self.frame = CGRectMake(0, mScreenHeight-height-108,mScreenWidth, 44);
    
    self.backBtn.frame = CGRectMake(0, 0, mScreenWidth, mScreenHeight);
    [self.superview addSubview: self.backBtn];
    [self.superview bringSubviewToFront:self];
    [UIView animateWithDuration:0.2 animations:^{
        
        self.backBtn.alpha = 0.5;
    }];
    
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    self.frame = CGRectMake(0, mScreenHeight - 108, mScreenWidth, 44);
    [UIView animateWithDuration:0.2 animations:^{
        self.backBtn.alpha = 0;
        [self.backBtn removeFromSuperview];
    }];
}

- (void)backBtnClick{
    [self endEditing:YES];
}

- (IBAction)reduceBtnClick {
    if (_num > 1) {
        _num--;
        self.textField.text  = [NSString stringWithFormat:@"%ld",_num];
    }
}

- (IBAction)addBtnClick {
//    if (_num > 0) {
        _num++;
        self.textField.text  = [NSString stringWithFormat:@"%ld",_num];
//    }
}

- (IBAction)finishBtnClic {
    
    if (self.block) self.block(_num);
}

@end
