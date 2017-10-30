//
//  AppMacro.h
//  AErShopingMall
//
//  Created by masha on 16/6/7.
//  Copyright © 2016年 xxb. All rights reserved.
//

#ifndef AppMacro_h
#define AppMacro_h

#define Max(x,y)          (((x)>(y)?(x):(y)))

#define mNavBarHeight         44
#define mTabBarHeight         49
#define mScreenWidth          ([UIScreen mainScreen].bounds.size.width)
#define mScreenHeight         ([UIScreen mainScreen].bounds.size.height)

#define mSystemVersion   ([[UIDevice currentDevice] systemVersion])
#define mCurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])
#define mAPPVersion      [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]

#define mFirstLaunch     mAPPVersion     //以系统版本来判断是否是第一次启动，包括升级后启动。
#define mFirstRun        @"firstRun"     //判断是否为第一次运行，升级后启动不算是第一次运行

#define  MMLastLongitude @"MMLastLongitude"
#define  MMLastLatitude  @"MMLastLatitude"
#define  MMLastCity      @"MMLastCity"
#define  MMLastProvince  @"MMLastProvince"
#define  MMLastArea      @"MMLastArea"
#define  MMLastDetail    @"MMLastDetail"

//----------方法简写-------
#define mAppDelegate        (AppDelegate *)[[UIApplication sharedApplication] delegate]
#define mWindow             [[[UIApplication sharedApplication] windows] lastObject]
#define mKeyWindow          [[UIApplication sharedApplication] keyWindow]
#define kDocuments  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]
#define mNavitationTitle(Title)  self.navigationItem.title = Title
#define setDickeyobj(dic,obj,key)     [dic setObject:obj forKey:key];
#define dicforkey(dic,key)      [dic objectForKey:key];
#define UserDefaultsSynchronize(uname,key)  \
{ \
[[NSUserDefaults standardUserDefaults] setObject:uname forKey:key]; \
[[NSUserDefaults standardUserDefaults] synchronize];\
}
#define UserDefaultsGetSynchronize(key)  [[NSUserDefaults standardUserDefaults] objectForKey:key]
#define VIEW_TX(view) (view.frame.origin.x)
#define VIEW_TY(view) (view.frame.origin.y)
#define VIEW_W(view)  (view.frame.size.width)
#define VIEW_H(view)  (view.frame.size.height)
#define VIEW_BX(view) (view.frame.origin.x + view.frame.size.width)
#define VIEW_BY(view) (view.frame.origin.y + view.frame.size.height )

/*---------------------------------程序界面配置信息-------------------------------------*/


//自定义字体
#define UIFONT_SC_MEDIUM(fontSize)    [UIFont fontWithName:@"bn_list_card_icon_font" size:fontSize]

//设置应用的页面背景色
#define mAppMainColor  toPCcolor(@"#3dc399")
//获取文字尺寸
#define sizeFromString(string,size) [string sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:size]}]


//-------------------打印日志-------------------------
//DEBUG  模式下打印日志,当前行
#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif

//重写NSLog,Debug模式下打印日志和当前行数
#if DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"\nfunction:%s line:%d content:%s\n", __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(FORMAT, ...) nil
#endif

//DEBUG  模式下打印日志,当前行 并弹出一个警告
#ifdef DEBUG
#   define ULog(fmt, ...)  { UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%s\n [Line %d] ", __PRETTY_FUNCTION__, __LINE__] message:[NSString stringWithFormat:fmt, ##__VA_ARGS__]  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alert show]; }
#else
#   define ULog(...)
#endif

#endif /* AppMacro_h */
