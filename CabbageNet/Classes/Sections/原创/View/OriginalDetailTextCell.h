//
//  OriginalDetailTextCell.h
//  CabbageNet
//
//  Created by MacAir on 2017/4/10.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OriginalDetailTextCell : UITableViewCell

@property (nonatomic , strong)NSString *htmlString;
@property (nonatomic , copy)void(^block)(CGFloat webViewHeight);
@property (nonatomic , copy)void(^urlBlock)(NSString *url);

@end

