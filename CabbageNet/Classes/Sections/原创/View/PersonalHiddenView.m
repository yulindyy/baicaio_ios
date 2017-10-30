//
//  PersonalHiddenView.m
//  CabbageNet
//
//  Created by MacAir on 2017/5/9.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import "PersonalHiddenView.h"

@implementation PersonalHiddenView

+ (instancetype)getPersonalHiddenView{
    return [[[NSBundle mainBundle]loadNibNamed:@"PersonalHiddenView" owner:nil options:nil]lastObject];
}

@end
