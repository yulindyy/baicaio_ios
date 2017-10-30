//
//  StartView.m
//  CabbageNet
//
//  Created by xiang fu on 2017/8/23.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import "StartView.h"

@implementation StartView


+ (instancetype)getStartView{
    return [[[NSBundle mainBundle]loadNibNamed:@"StartView" owner:nil options:nil]lastObject];
}

- (IBAction)btnClick {
    if (self.Block)self.Block();
}

@end
