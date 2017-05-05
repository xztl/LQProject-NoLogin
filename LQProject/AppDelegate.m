//
//  AppDelegate.m
//  PublicLawyerChat
//
//  Created by   on 15/5/20.
//  Copyright (c) 2015   jackli. All rights reserved.
//
#import "AppDelegate.h"


#import "GuideViewController.h"


#import "MMDrawerVisualState.h"

#import "CYLTabBarControllerConfig.h"
#import "CYLPlusButtonSubclass.h"

#import "LoginVC.h"


//振动
#import <AudioToolbox/AudioToolbox.h>

@interface AppDelegate ()

/**
 *  抽屉效果
 */
@property (nonatomic,strong) MMDrawerController * drawerController;

@end

@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 向苹果注册推送，获取deviceToken并上报
    [self registerAPNS:application];
    
    
    [self _initAPPWithOptions:launchOptions];
    
    
    
    return YES;
}

/**
 *  初始化应用配置
 */
- (void)_initAPPWithOptions:(NSDictionary *)launchOptions{

    
    [self initSVProgressHUD];
    
    [self _initNav];
    
    
    [self _initThirdSDKWithOptions:launchOptions];
    
    [self _initWindow];
    
    [self _initWebUserAgent];
    
    
    [Tool requestLoginMethodWithCompletedBlock:nil noConnet:nil];
    
}

- (void)initSVProgressHUD {
    [SVProgressHUD setMinimumDismissTimeInterval:1.0];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    //    背景图层的颜色
    
    [SVProgressHUD setBackgroundColor:MyColor_HudBackground];
    //    文字的颜色
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
}

/**
 *  初始化导航栏
 */
- (void)_initNav{
    //设置导航的颜色
    [[UINavigationBar appearance] setBarTintColor:MyColor_NavigationBar];
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    //全局返回按钮
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    //状态栏文字白色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
}

/**
 *  初始化启动窗口
 */
- (void)_initWindow{
    

    [self _initRootViewController];

    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"ifFirstOpen"] isEqualToString:App_Version])
    {
        GuideViewController *vc = [[GuideViewController alloc] init];
        
        self.window.rootViewController = vc;
        [[NSUserDefaults standardUserDefaults] setObject:App_Version forKey:@"ifFirstOpen"];
    } else {
        
        self.window.rootViewController = _rootViewController;
    }
    
    
    [self.window makeKeyAndVisible];
}

/**
 *  设置webView 的 userAgent
 */
- (void)_initWebUserAgent {
//    NSString *newAgent = [NSString stringWithFormat:@"Mozilla/5.0 (iPhone; CPU iPhone OS %@ like Mac OS X ; LawChat Build/%@) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13B143 Safari/601.1",CurrentSystemVersion,App_Version];
//    
//    NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:newAgent, @"UserAgent", nil];
//    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
}


/**
 *  初始化主界面
 */
- (void)_initRootViewController {
    
    //tabbar(3个主视图创建)
    [CYLPlusButtonSubclass registerPlusButton];
    CYLTabBarControllerConfig *tabBarControllerConfig = [[CYLTabBarControllerConfig alloc] init];
    
    /**
     *  个人中心视图
     */
    
    UIViewController *letfVC = [[UIViewController alloc] init];
    letfVC.view.backgroundColor = FlatSand;
    
    //抽屉效果视图创建
    self.drawerController = [[MMDrawerController alloc]
                             initWithCenterViewController:tabBarControllerConfig.tabBarController
                             leftDrawerViewController:letfVC];
    [self.drawerController setShowsShadow:NO];
    [self.drawerController setRestorationIdentifier:@"MMDrawer"];
    [self.drawerController setMaximumRightDrawerWidth:200.0];
    [self.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [self.drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    [self.drawerController
     setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
         MMDrawerControllerDrawerVisualStateBlock block = [MMDrawerVisualState parallaxVisualStateBlockWithParallaxFactor:2.0];
         if(block){
             block(drawerController, drawerSide, percentVisible);
         }
     }];
    
    //创建window
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.window.backgroundColor = MyColor_BackgroudView;
    
    _rootViewController = self.drawerController;
    
}

/**
 *  初始化第三方SDK
 *
 *  @param launchOptions 启动options
 */
- (void)_initThirdSDKWithOptions:(NSDictionary *)launchOptions{
    
    
}


#pragma mark APNs Register
/**
 *    @brief    注册苹果推送，获取deviceToken用于推送
 *
 *    @param     application
 */
- (void)registerAPNS:(UIApplication *)application {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        // iOS 8 Notifications
        [application registerUserNotificationSettings:
         [UIUserNotificationSettings settingsForTypes:
          (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge)
                                           categories:nil]];
        [application registerForRemoteNotifications];
    }
    else {
        // iOS < 8 Notifications
//        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
//         (UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
    }
}

/*
 *  苹果推送注册成功回调，将苹果返回的deviceToken上传到CloudPush服务器
 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {

}

/*
 *  苹果推送注册失败回调
 */
//如果deviceToken获取不到会进入此事件
- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
    //如果注册不成功，打印错误信息，可以在网上找到对应的解决方案
    //如果注册成功，可以删掉这个方法
    LQLog(@"application:didFailToRegisterForRemoteNotificationsWithError: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    

    if (_isRunning) {
        return;
    }
    
    NSMutableDictionary *jsonDict = [NSMutableDictionary dictionaryWithDictionary:userInfo];
    jsonDict[@"title"] = userInfo[@"aps"][@"alert"];
    switch ([jsonDict[@"type"] intValue]) {
        case 1:
        {
            //强制下线
            if ([UserCenter checkIsLogin]) {
                [self exitLoginGotoRoot];
            }
        }
            break;
        default:
            break;
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    _isRunning = NO;
    [UserCenter save];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    [Tool requestLoginMethodWithCompletedBlock:nil noConnet:nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    _isRunning = YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
}



- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {

    
    return YES;
}

#pragma mark - 退出登录返回主页
- (void)exitLoginGotoRoot {
    /**
     *  清除数据返回主页面
     */
    //    [Tool unbindAccountToAliPush:^(bool isSuccess) {
    //
    //    }];

    [UserCenter clearUserCenter];
    
    [self _initWindow];
}


@end
