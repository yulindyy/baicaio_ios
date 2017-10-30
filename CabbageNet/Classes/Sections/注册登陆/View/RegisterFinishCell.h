//
//  RegisterFinishCell.h
//  CabbageNet
//
//  Created by xiang fu on 2017/6/21.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterFinishCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (nonatomic , copy)void(^block)(NSInteger tag);
@property (weak, nonatomic) IBOutlet UIButton *protolBtn;


@end
