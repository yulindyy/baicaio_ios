//
//  SendBtn.m
//  CabbageNet
//
//  Created by MacAir on 2017/4/9.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import "SendBtn.h"

#define title_Size [@"长度" sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}]
#define Icon_Width title_Size.width

@implementation SendBtn

/**
 *  重新布局图片控件的frame
 */
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    
    CGFloat imageY = 0;
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
    CGFloat titleY = Icon_Width;
    CGFloat titleW = self.frame.size.width;
    CGFloat titleH = self.frame.size.height-Icon_Width;
    
    return CGRectMake(titleX, titleY, titleW, titleH);
}


@end
