//
//  Common.h
//  lawChat2
//
//  Created by lawchat on 14/12/25.
//  Copyright (c) 2014年 lawchat. All rights reserved.
//

#ifndef lawChat2_CommonDefine_h
#define lawChat2_CommonDefine_h

// 判断是否为iOS7
#define iOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)
// 获取系统版本
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define CurrentSystemVersion [[UIDevice currentDevice] systemVersion]
// 应用版本号
#define App_Version [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

//rgb颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//获取RGB颜色
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)

// 自定义Log
#ifdef DEBUG
#define LQLog(...) NSLog(__VA_ARGS__)
#else
#define LQLog(...)
#endif

// 是否为Iphone4
// 320 480
#define iPhone4 ([UIScreen mainScreen].bounds.size.height == 480)
// 以iphone6 为基准

// 是否为Iphone5
// 320 568
#define iPhone5 ([UIScreen mainScreen].bounds.size.height == 568)

// 是否为Iphone6
// 375 667
#define iPhone6 ([UIScreen mainScreen].bounds.size.height == 667)


// 是否为Iphone6 plus
// 414 736
#define iPhone6Plus ([UIScreen mainScreen].bounds.size.height == 736)

/**
 *  屏幕各个部分尺寸
 */
// 状态栏高度
#define STATUS_BAR_HEIGHT 20
// TabBar高度
#define TAB_BAR_HEIGHT 49
// NavBar高度
#define NAVIGATION_BAR_HEIGHT 44
// 状态栏 ＋ 导航栏 高度
#define STATUS_AND_NAVIGATION_HEIGHT  ((STATUS_BAR_HEIGHT) + (NAVIGATION_BAR_HEIGHT))

// 屏幕 rect
#define SCREEN_RECT ([UIScreen mainScreen].bounds)
// 屏幕宽度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
// 屏幕高度
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define CONTENT_HEIGHT (SCREEN_HEIGHT - NAVIGATION_BAR_HEIGHT - STATUS_BAR_HEIGHT)
// 屏幕分辨率
#define SCREEN_RESOLUTION (SCREEN_WIDTH * SCREEN_HEIGHT * ([UIScreen mainScreen].scale))

#define SCREEN_HEIGHTSCALE [UIScreen mainScreen].bounds.size.height/480 //高比例
#define SCREEN_WIDTHSCALE [UIScreen mainScreen].bounds.size.width/320 //高比例

#define LQ_SCREEN_HEIGHTSCALE [UIScreen mainScreen].bounds.size.height/568 //高比例
#define LQ_SCREEN_WIDTHSCALE [UIScreen mainScreen].bounds.size.width/320 //宽比例

//应用中常用颜色
#define MyColor_NavigationBar UIColorFromRGB(0x222F46)
#define MyColor_BackgroudView UIColorFromRGB(0xF8F8F8)
#define MyColor_HudBackground RGBA(34,47,70,0.8)
//按钮色（蓝色）
#define MyColor_Button_Normal [UIColor colorWithRed:58/255.0 green:151/255.0 blue:255/255.0    alpha:1.0]
#define MyColor_Button_Disable  [UIColor colorWithRed:136.0/255.0 green:178.0/255.0 blue:250.0/255.0 alpha:1.0]
//成功色 (绿色)
#define MyColor_Green UIColorFromRGB(0x5FD072)
//警示色（红色）
#define MyColor_Red [UIColor colorWithRed:221.0/255.0 green:72.0/255.0 blue:71.0/255.0              alpha:1.0]
//文本色（不同灰度色）
#define MyColor_Text_333 [UIColor colorWithRed:54.0/255.0 green:54.0/255.0 blue:54.0/255.0          alpha:1.0]
#define MyColor_Text_5a [UIColor colorWithRed:91.0/255.0 green:91.0/255.0 blue:91.0/255.0           alpha:1.0]
#define MyColor_Text_aaa [UIColor colorWithRed:168.0/255.0 green:168.0/255.0 blue:168.0/255.0       alpha:1.0]
#define MyColor_Text_f9 [UIColor colorWithRed:203.0/255.0 green:203.0/255.0 blue:203.0/255.0        alpha:1.0]
#define MyColor_Text_ccc UIColorFromRGB(0xCCCCCC)
//线条色（线条灰色）
#define MyColor_Line_ddd  [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0       alpha:1.0]
#define MyColor_Line_eee  [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0       alpha:1.0]


//主要单例
#define UserDefaults [NSUserDefaults standardUserDefaults]
#define NotificationCenter [NSNotificationCenter defaultCenter]
#define SharedApplication [UIApplication sharedApplication]
#define App_Delegate (AppDelegate *)[[UIApplication sharedApplication]delegate]
#define Bundle [NSBundle mainBundle]
#define MainScreen [UIScreen mainScreen]

// 获取系统时间戳
#define getCurentTime [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]]

/**
 Synthsize a weak or strong reference.
 
 Example:
 @weakify(self)
 [self doSomething^{
 @strongify(self)
 if (!self) return;
 ...
 }];
 
 */
//解决循环引用问题
#ifndef weakify
#if DEBUG
#if __has_feature(objc_arc)
#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

#ifndef strongify
#if DEBUG
#if __has_feature(objc_arc)
#define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif



#endif
