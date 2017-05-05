//
//  HomeTVC.m
//  LQProject
//
//  Created by JW on 2016/12/1.
//  Copyright © 2016年 jacli. All rights reserved.
//

#import "HomeTVC.h"

#import "ADView.h"
#import "RxWebViewController.h"

@interface HomeTVC ()<UITabBarControllerDelegate>

@end

@implementation HomeTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"home";
    
    self.navigationController.tabBarController.delegate = self;
    
    //设置显示广告
//    if (!Url_Json.isShowedAd) {
//        [self setupADView];
//        Url_Json.isShowedAd = YES;
//    }
    [self setNavLeftBar];
}
#pragma mark - 设置左上角按钮
- (void)setNavLeftBar{
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"左菜单" style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemClicked)];
    
}

#pragma mark - 打开侧滑栏
- (void)leftBarButtonItemClicked {
    AppDelegate *apd = App_Delegate;
    [apd.rootViewController openDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    AppDelegate *apd = App_Delegate;
    apd.customNavVC = self.navigationController;
}


- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if(viewController == [tabBarController.viewControllers objectAtIndex:1])
    {
        //未登录或者未绑定手机号判断
        if ([UserCenter checkIsLogin]) {
            return YES;
        } else if (User_Center.openId.length > 0) {
            return YES;
        } else {
            [Tool gotoLoginVC];
            return NO;
        }
    }
    return YES;
}


- (void)setupADView {
    NSString *imageUrl = @"";
    NSString *adURL = @"";
    ADView *adView = [[ADView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds withImageUrl:imageUrl withADUrl:adURL withClickBlock:^(NSString *clikADUrl) {
        
        [Tool gotoWebWithUrl:clikADUrl inNavigationVC:self.navigationController];
        
    }];
    
    [adView show];
}
@end
