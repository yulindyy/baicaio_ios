//
//  SignSearchViewController.h
//  CabbageNet
//
//  Created by xiang fu on 2017/7/11.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import "BaseViewController.h"

@interface SignSearchViewController : BaseViewController

@property (nonatomic , assign)NSInteger type;
@property (nonatomic , strong)NSString *orig_id;
@property (nonatomic , copy)void(^block)(NSString *shopid);

@end
