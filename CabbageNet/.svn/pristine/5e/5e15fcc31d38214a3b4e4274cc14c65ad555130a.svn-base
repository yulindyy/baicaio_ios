//
//  AttributedStringCell.h
//  CabbageNet
//
//  Created by MacAir on 2017/4/14.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttributedStringCell : UITableViewCell<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic , strong)NSString *htmlString;
@property (nonatomic , copy)void(^block)(CGFloat webViewHeight);
@property (nonatomic , copy)void(^urlBlock)(NSString *url);

@end
