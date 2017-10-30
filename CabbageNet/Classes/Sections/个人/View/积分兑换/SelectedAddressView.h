//
//  SelectedAddressView.h
//  CabbageNet
//
//  Created by xiang fu on 2017/6/28.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressModel.h"

@interface SelectedAddressView : UIView

@property (nonatomic , strong)AddressModel *model;
+ (instancetype)getSelectedAddressView;

@end
