//
//  HomeBtn.m
//  CabbageNet
//
//  Created by MacAir on 2017/4/12.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import "HomeBtn.h"

#define title_Size [@"字长度" sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}]
#define Icon_Width title_Size.width

@implementation HomeBtn

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.imageView.contentMode = UIViewContentModeCenter;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        // 设置字体型号和大小
        self.titleLabel.font = [UIFont systemFontOfSize:12];
        
    }
    return self;
}

/**
 *  重新布局图片控件的frame
 */
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    
    CGFloat imageY = 15;
    CGFloat imageW = Icon_Width;
    CGFloat imageH = Icon_Width;
    CGFloat imageX = (self.frame.size.width - Icon_Width)/2;
    
    return CGRectMake(imageX, imageY, imageW, imageH);
}


/**
 *  重新布局标题控件的frame
 */
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleX = 0;
    CGFloat titleY = Icon_Width + 10;
    CGFloat titleW = self.frame.size.width;
    CGFloat titleH = self.frame.size.height-Icon_Width;
    
    return CGRectMake(titleX, titleY, titleW, titleH);
}


#pragma mark - 重写的方法
- (void)setBgImage:(NSString *)bgImage{
    
    [self setImage:[UIImage imageNamed:bgImage]  forState:UIControlStateNormal];
}

- (void)setTitles:(NSString *)titles
{
    // 文字颜色
    [self setTitleColor:toPCcolor(@"333333") forState:UIControlStateNormal];
    [self setTitle:titles forState:UIControlStateNormal];
}

@end
