

#import <Foundation/Foundation.h>

@interface UtilsApi : NSObject

#pragma mark - 根据时间戳得到日期字符串
+ (NSString *)dateStringWithTimeStamp:(NSString *)timeStamp formatString:(NSString *)formatStr;

#pragma mark - 显示警示框（一个按钮）
+ (void)showAlertWithMessage:(NSString*)message inViewController:(UIViewController*)viewControoler okBlock:(void(^)())okBlock;

#pragma mark - 显示警示框（两个按钮）
+ (void)showAlertWithTitle:(NSString *)title withMessage:(NSString *)message inViewController:(UIViewController *)viewController cancelBlock:(void (^) ())cancelBlock okBlock:(void (^) ())okBlock;

#pragma mark - 通过Storyboard获得vc
+ (UIViewController *)initViewControllerWithClassName:(NSString*)vcClassName inStoryboard:(NSString*)storyboardName;

#pragma mark - 获取到当前界面处于的viewController
+ (UIViewController *)getCurrentVC;

#pragma mark - 得到具体的设备型号
+ (NSString *)getConcreteDeviceModel;

@end
