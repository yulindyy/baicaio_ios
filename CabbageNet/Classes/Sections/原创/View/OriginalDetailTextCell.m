//
//  OriginalDetailTextCell.m
//  CabbageNet
//
//  Created by MacAir on 2017/4/10.
//  Copyright © 2017年 MacAir. All rights reserved.
//

#import "OriginalDetailTextCell.h"

@interface OriginalDetailTextCell ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation OriginalDetailTextCell

- (void)setHtmlString:(NSString *)htmlString{
    if ( [_htmlString isEqualToString:htmlString] || !htmlString.length) return;
    _htmlString = htmlString;
    NSString *strUrl = [htmlString stringByReplacingOccurrencesOfString:@"<p>" withString:@"<p style=\"color:#807d80;font-size:14px;letter-spacing:1px; font-family:'Times New Roman';font-weight:200\">"];//替换字符
    NSLog(@"strurl = %@",strUrl);
    NSString * resuleURL = [strUrl stringByReplacingOccurrencesOfString:@"<a" withString:@"<a style=\"text-decoration:none;color:#3dc399\""];
    
    NSString *regular = @"<img[^>]+src\\s*=\\s*\"?(.*?)(\"|>|\\s+)";
    NSRegularExpression *expression = [[NSRegularExpression alloc] initWithPattern:regular options:0 error:nil];
    NSArray *arrayOfAllMatches = [expression matchesInString:resuleURL options:0 range:NSMakeRange(0, resuleURL.length)];
    NSString *string1 = [NSString stringWithFormat:@"<img src=\"http://www.baicaio.com/"];
    NSInteger len1 = string1.length;
    NSString *string2 = [NSString stringWithFormat:@"<img src=\""];
    NSInteger len2 = string2.length;
    int i = 0;
    for (NSTextCheckingResult *match in arrayOfAllMatches){
        
        NSString* substringForMatch = [resuleURL substringWithRange:NSMakeRange(match.range.location + i * (len1 - len2) , match.range.length)];
        NSLog(@"匹配---%@",substringForMatch);
        if ([substringForMatch hasPrefix:@"<img src=\"http://"]) {
            NSLog(@"匹配+++%@",substringForMatch);
        }else{
            
            resuleURL = [resuleURL stringByReplacingCharactersInRange:NSMakeRange(match.range.location + i * (len1 - len2) , len2) withString:string1];
            NSLog(@"have head");//http://www.baicaio.com/
            i ++;
        }
        
        
    }
    
    [self.webView loadHTMLString: resuleURL baseURL:nil];
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //判断是否是单击
    if (navigationType == UIWebViewNavigationTypeLinkClicked)
    {
        NSURL *url = [request URL];
        NSLog(@"---%@",url );
        if([[UIApplication sharedApplication]canOpenURL:url])
        {
            //            [[UIApplication sharedApplication]openURL:url];
            if (self.urlBlock) {
                
                self.urlBlock([NSString stringWithFormat:@"%@",url]);
            }
        }
        return NO;
    }
    return YES;
}


- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    NSString *js = @"function imgAutoFit() { \
    var imgs = document.getElementsByTagName('img'); \
    for (var i = 0; i < imgs.length; ++i) {\
    var img = imgs[i];   \
    img.style.maxWidth = %f;   \
    } \
    }";
    js = [NSString stringWithFormat:js, mScreenWidth- 15 ];
    [webView stringByEvaluatingJavaScriptFromString:js];
    [webView stringByEvaluatingJavaScriptFromString:@"imgAutoFit()"];
    
    
    CGFloat webViewHeight =[[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
    if (self.block) {
        self.block(/*webView.scrollView.contentSize.height*/webViewHeight);
    }
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.webView.scrollView.scrollEnabled = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
