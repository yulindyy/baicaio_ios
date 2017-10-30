//
//  HeadNewsCell.h
//  CabbageNet
//
//  Created by MacAir on 2017/4/7.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeadNewsCell : UICollectionViewCell

@property (nonatomic, copy) void(^block)(NSInteger tag);
@property (nonatomic , strong)NSArray *array;
@property (weak, nonatomic) IBOutlet UIImageView *statusImage;

@end
