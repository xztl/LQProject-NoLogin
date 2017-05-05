
#import "CYLTabBarControllerConfig.h"


@import Foundation;
@import UIKit;
@interface CYLBaseNavigationController : UINavigationController
@end
@implementation CYLBaseNavigationController

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

@end

//View Controllers


@interface CYLTabBarControllerConfig ()

@property (nonatomic, readwrite, strong) CYLTabBarController *tabBarController;

@end

@implementation CYLTabBarControllerConfig

/**
 *  lazy load tabBarController
 *
 *  @return CYLTabBarController
 */
- (CYLTabBarController *)tabBarController {
    if (_tabBarController == nil) {

        CYLTabBarController *tabBarController = [CYLTabBarController tabBarControllerWithViewControllers:self.viewControllers tabBarItemsAttributes:self.tabBarItemsAttributesForController];
        // 更多TabBar自定义设置：比如：tabBarItem 的选中和不选中文字和背景图片属性、tabbar 背景图片属性
        [self customizeTabBarAppearance:tabBarController];
        [tabBarController.tabBar setTranslucent:NO];
        _tabBarController = tabBarController;
        

    }
    return _tabBarController;
}

- (NSArray *)viewControllers {
    
    UIViewController *firstNavigationController = [[CYLBaseNavigationController alloc]
                                                   initWithRootViewController:[UtilsApi initViewControllerWithClassName:@"HomeTVC" inStoryboard:@"Home"]];
    
//    UIViewController *secondNavigationController = [[CYLBaseNavigationController alloc]
//                                                    initWithRootViewController:[[UIViewController alloc] init]];
//    
//    
//    UIViewController *thirdNavigationController = [[CYLBaseNavigationController alloc]
//                                                   initWithRootViewController:[[UIViewController alloc] init]];
    
    UIViewController *fourthNavigationController = [[CYLBaseNavigationController alloc]
                                                    initWithRootViewController:[UtilsApi initViewControllerWithClassName:@"MineTVC" inStoryboard:@"Mine"]];

    NSArray *viewControllers = @[
                                           firstNavigationController,
//                                           secondNavigationController,
//                                           thirdNavigationController,
                                           fourthNavigationController
                                           ];
    //退出登录时重新init了TabBarController,所以这里要将customNavVC重新赋值
    AppDelegate *apd = App_Delegate;
    apd.customNavVC = (UINavigationController *)firstNavigationController;
    return viewControllers;
}


/**
 *  在`-setViewControllers:`之前设置TabBar的属性，设置TabBarItem的属性，包括 title、Image、selectedImage。
 */
- (NSArray *)tabBarItemsAttributesForController {
    
    NSDictionary *dict1 = @{
                            CYLTabBarItemTitle : @"首页",
                            CYLTabBarItemImage : @"sy",
                            CYLTabBarItemSelectedImage : @"syax",
                            };
//    NSDictionary *dict2 = @{
//                            CYLTabBarItemTitle : @"发现",
//                            CYLTabBarItemImage : @"fx",
//                            CYLTabBarItemSelectedImage : @"fxax",
//                            };
//    NSDictionary *dict3 = @{
//                            CYLTabBarItemTitle : @"门店",
//                            CYLTabBarItemImage : @"md",
//                            CYLTabBarItemSelectedImage : @"mdax",
//                            };
    NSDictionary *dict4 = @{
                            CYLTabBarItemTitle : @"我的",
                            CYLTabBarItemImage : @"wd",
                            CYLTabBarItemSelectedImage : @"wdax",
                            };
    NSArray *tabBarItemsAttributes = @[
                                       dict1,
//                                       dict2,
//                                       dict3,
                                       dict4
                                       ];
    return tabBarItemsAttributes;
}

/**
 *  更多TabBar自定义设置：比如：tabBarItem 的选中和不选中文字和背景图片属性、tabbar 背景图片属性
 */
- (void)customizeTabBarAppearance:(CYLTabBarController *)tabBarController {

    // set the text color for unselected state
    // 普通状态下的文字属性
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSForegroundColorAttributeName] = RGB(148,148,148);
    
    // set the text color for selected state
    // 选中状态下的文字属性
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSForegroundColorAttributeName] = MyColor_Red;
    
    // set the text Attributes
    // 设置文字属性
    UITabBarItem *tabBar = [UITabBarItem appearance];
    [tabBar setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    [tabBar setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    
    // Set the dark color to selected tab (the dimmed background)
    // TabBarItem选中后的背景颜色
    //    [self customizeTabBarSelectionIndicatorImage];
    
    // update TabBar when TabBarItem width did update
    // If your app need support UIDeviceOrientationLandscapeLeft or UIDeviceOrientationLandscapeRight， remove the comment '//'
    //如果你的App需要支持横竖屏，请使用该方法移除注释 '//'
    //    [self updateTabBarCustomizationWhenTabBarItemWidthDidUpdate];
    
    // set the bar shadow image
    // This shadow image attribute is ignored if the tab bar does not also have a custom background image.So at least set somthing.
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc] init]];
    [[UITabBar appearance] setBackgroundColor:[UIColor whiteColor]];
//    [[UITabBar appearance] setShadowImage:[UIImage imageNamed:@"tapbar_top_line"]];
    [[UITabBar appearance] setShadowImage:[UIImage new]];
    // set the bar background image
    // 设置背景图片
    //     UITabBar *tabBarAppearance = [UITabBar appearance];
    //     [tabBarAppearance setBackgroundImage:[UIImage imageNamed:@"tabbar_background"]];
    
    //remove the bar system shadow image
    //去除 TabBar 自带的顶部阴影
    //    [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
}

- (void)updateTabBarCustomizationWhenTabBarItemWidthDidUpdate {
    void (^deviceOrientationDidChangeBlock)(NSNotification *) = ^(NSNotification *notification) {
        UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
        if ((orientation == UIDeviceOrientationLandscapeLeft) || (orientation == UIDeviceOrientationLandscapeRight)) {

        } else if (orientation == UIDeviceOrientationPortrait){

        }
        [self customizeTabBarSelectionIndicatorImage];
    };
    [[NSNotificationCenter defaultCenter] addObserverForName:CYLTabBarItemWidthDidChangeNotification
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:deviceOrientationDidChangeBlock];
}

- (void)customizeTabBarSelectionIndicatorImage {
    ///Get initialized TabBar Height if exists, otherwise get Default TabBar Height.
    UITabBarController *tabBarController = [self cyl_tabBarController] ?: [[UITabBarController alloc] init];
    CGFloat tabBarHeight = tabBarController.tabBar.frame.size.height;
    CGSize selectionIndicatorImageSize = CGSizeMake(CYLTabBarItemWidth, tabBarHeight);
    //Get initialized TabBar if exists.
    UITabBar *tabBar = [self cyl_tabBarController].tabBar ?: [UITabBar appearance];
    [tabBar setSelectionIndicatorImage:
     [[self class] imageWithColor:[UIColor redColor]
                             size:selectionIndicatorImageSize]];
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    if (!color || size.width <= 0 || size.height <= 0) return nil;
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width + 1, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



@end
