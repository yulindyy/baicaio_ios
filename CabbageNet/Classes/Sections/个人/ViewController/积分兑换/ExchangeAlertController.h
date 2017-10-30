//
//  ExchangeAlertController.h
//  CabbageNet
//
//  Created by xiang fu on 2017/6/28.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExchangeAlertController : UIAlertController

@property (nonatomic , assign)NSInteger currRow;
+ (instancetype)alertPickerWithTitle:(NSString *)title Separator:(NSString *)separator SourceArr:(NSArray *)sourceArr;
- (void)addCompletionAction:(UIAlertAction *)action;

@end
