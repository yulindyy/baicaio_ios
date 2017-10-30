//
//  StartView.h
//  CabbageNet
//
//  Created by xiang fu on 2017/8/23.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StartView : UIView

@property (nonatomic , copy)void(^Block)();
+ (instancetype)getStartView;

@end
