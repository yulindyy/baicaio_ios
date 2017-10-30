//
//  ScreenViewController.h
//  CabbageNet
//
//  Created by MacAir on 2017/4/8.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import "BaseViewController.h"

@interface ScreenViewController : BaseViewController

@property (nonatomic , strong)NSString *selectedCid;
@property (nonatomic , strong)NSString *selectedCidName;
@property (nonatomic , strong)NSString *selectedOrig;
@property (nonatomic , strong)NSString *selectedOrigName;
@property (nonatomic , copy)void(^block)(NSString *cid, NSString * cidTitle, NSString *orig_id,NSString *origname);

@end
