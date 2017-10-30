//
//  UtilsMacro.h
//  AErShopingMall
//
//  Created by masha on 16/6/7.
//  Copyright © 2016年 xxb. All rights reserved.
//

#ifndef UtilsMacro_h
#define UtilsMacro_h

UIKIT_STATIC_INLINE UIColor *toPCcolor(NSString *pcColorstr)
{
    unsigned int c;
    
    if ([pcColorstr characterAtIndex:0] == '#') {
        
        [[NSScanner scannerWithString:[pcColorstr substringFromIndex:1]] scanHexInt:&c];
        
    } else {
        
        [[NSScanner scannerWithString:pcColorstr] scanHexInt:&c];
        
    }
    
    return [UIColor colorWithRed:((c & 0xff0000) >> 16)/255.0 green:((c & 0xff00) >> 8)/255.0 blue:(c & 0xff)/255.0 alpha:1.0];
}

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

#endif /* UtilsMacro_h */
