//
//  ProblemEditCell.h
//  CabbageNet
//
//  Created by MacAir on 2017/4/8.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProblemEditCell : UITableViewCell

@property (nonatomic , copy)void(^block)(NSString *string);

@end
