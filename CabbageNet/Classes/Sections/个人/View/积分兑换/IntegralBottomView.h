//
//  IntegralBottomView.h
//  CabbageNet
//
//  Created by xiang fu on 2017/6/9.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IntegralBottomView : UIView

@property (nonatomic , copy)void(^block)(NSInteger num);
+ (instancetype)getIntegralBottomView;
- (void)setBase;

@end
