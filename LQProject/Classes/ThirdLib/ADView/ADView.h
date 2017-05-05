//
//  ADView.h
//  STLaunchAD
//
//  Created by 研发部 on 16/9/22.
//  Copyright © 2016年 SKYTang. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height
#define UserDefaults [NSUserDefaults standardUserDefaults]

static NSString *const adImageName = @"adImageName";
static NSString *const adUrl = @"adUrl";

@interface ADView : UIView

@property (nonatomic, assign) NSInteger showTime;

- (instancetype)initWithFrame:(CGRect)frame withImageUrl:(NSString *)imageUrl withADUrl:(NSString *)adUrl withClickBlock:(void (^)(NSString *clikADUrl))block;

- (void)show;

@end
