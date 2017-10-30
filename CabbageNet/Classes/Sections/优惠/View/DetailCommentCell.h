//
//  DetailCommentCell.h
//  CabbageNet
//
//  Created by MacAir on 2017/4/8.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AllCommentModel.h"

@interface DetailCommentCell : UITableViewCell

@property (nonatomic , strong)AllCommentModel *model;
@property (nonatomic , copy)void(^block)(UIButton *sender);
@property (weak, nonatomic) IBOutlet UIButton *zanBtn;

@end
