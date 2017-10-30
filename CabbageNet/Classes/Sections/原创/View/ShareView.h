//
//  ShareView.h
//  CabbageNet
//
//  Created by xiang fu on 2017/7/10.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareView : UIView

@property (nonatomic , assign)BOOL ishidenView;
@property (nonatomic , copy)void(^block)(NSInteger tag);
+ (instancetype)getShareView;

@end
