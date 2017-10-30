//
//  BrokeReasonCell.h
//  CabbageNet
//
//  Created by MacAir on 2017/4/10.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrokeReasonCell : UITableViewCell

@property (nonatomic , copy)void(^block)(NSString *reason);

@end
