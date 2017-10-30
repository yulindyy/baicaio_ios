//
//  BindCompleteViewController.h
//  CabbageNet
//
//  Created by xiang fu on 2017/6/12.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, classType) {
    QQ_TYPE = 1,
    WECHAT_TYPE
};

@interface BindCompleteViewController : BaseViewController

@property (nonatomic , assign)classType classtype;

@end
