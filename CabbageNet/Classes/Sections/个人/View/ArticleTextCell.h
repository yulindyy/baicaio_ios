//
//  ArticleTextCell.h
//  CabbageNet
//
//  Created by MacAir on 2017/4/10.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArticleTextCell : UITableViewCell

@property (nonatomic , copy)void(^textViewChangeBlock)(NSString *text, CGFloat height);
@property (nonatomic , copy)void(^addImage)();
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end
