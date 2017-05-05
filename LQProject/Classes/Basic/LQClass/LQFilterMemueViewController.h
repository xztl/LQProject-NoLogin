//
//  LQFilterMemueViewController.h
//  LQFilterMenue
//
//  Created by lawchat on 16/5/20.
//  Copyright © 2016年 jacli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LQFilterMemueViewController : UIViewController

/**
 *  菜单栏高度
 */
@property(nonatomic,assign) NSInteger menueHeight;

/**
 *  主VC
 */
@property(nonatomic,strong) UIViewController *mainViewController;


/**
 *  菜单弹出视图
 */
@property(nonatomic,strong) NSArray *menueViewControllers;
- (void)loadMainViewController:(UIViewController*)mainViewController menueViewControllers:(NSArray *)menueViewControllers;
- (instancetype)initWithMainViewController:(UIViewController*)mainViewController menueViewControllers:(NSArray *)menueViewControllers;

- (void)hideMenueView;

@end
