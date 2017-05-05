//
//  GuideViewController.m
//  LawChatForLawyer
//
//  Created by  jackli on 15/5/15.
//  Copyright (c) 2015   jackli. All rights reserved.
//

#import "GuideViewController.h"
#import "GuidePageModel.h"
#import "ZFModalTransitionAnimator.h"

@interface GuideViewController ()<UIScrollViewDelegate>
{
    GuidePageModel *guideModel;
    
}
@property (nonatomic, strong) ZFModalTransitionAnimator *animator;
@property(nonatomic,strong) UIScrollView *aSscroll;

@property (nonatomic, strong) NSArray *imageArr;


@end

@implementation GuideViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *plistPath = [[NSBundle mainBundle]pathForResource:@"guidePage" ofType:@"plist"];
    NSArray *arr = [[NSArray alloc] initWithContentsOfFile:plistPath];
    _imageArr = [NSArray modelArrayWithClass:NSClassFromString(@"GuidePageModel") json:arr];

    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    _aSscroll = [[UIScrollView alloc] initWithFrame:self.view.frame];
    _aSscroll.delegate = self;
    _aSscroll.bounces = NO;
    _aSscroll.pagingEnabled = YES;
    _aSscroll.contentSize = CGSizeMake(SCREEN_WIDTH * _imageArr.count, SCREEN_HEIGHT);
    [self.view addSubview:_aSscroll];
    _aSscroll.showsVerticalScrollIndicator = NO;
    _aSscroll.showsHorizontalScrollIndicator = NO;
    
    
    for (int i = 0; i< _imageArr.count ; i++)
    {
        UIImageView *imageView = [[UIImageView alloc] init];
        
        // 1.设置frame
        imageView.frame = CGRectMake(i * SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        
        // 2.设置图片
        guideModel = _imageArr[i];
        
        NSString *imgName = [NSString stringWithFormat:@"%@", guideModel.pageIcon];
        imageView.image = [UIImage imageNamed:imgName];
        
        [_aSscroll addSubview:imageView];
        
        if (i == _imageArr.count-1) {
            //按钮
            UIButton *tasteButton = [UIButton buttonWithType:UIButtonTypeCustom];
            UIImage *img = [UIImage imageNamed:@"立即体验"];
            
            [tasteButton addTarget:self action:@selector(delayMethod:) forControlEvents:UIControlEventTouchUpInside];
            [tasteButton setBackgroundImage:img forState:UIControlStateNormal];
            
            tasteButton.frame = CGRectMake(0,0,img.size.width, img.size.height);
            //            tasteButton.center = CGPointMake(SCREEN_WIDTH * i + SCREEN_WIDTH/2, pageControl.frame.origin.y + 50);
            tasteButton.center = CGPointMake(SCREEN_WIDTH * i + SCREEN_WIDTH/2, SCREEN_HEIGHT*0.9);
            [self.aSscroll addSubview:tasteButton];
        }
    }
    
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGFloat t = scrollView.contentOffset.x;
    if (t < 0)
    {
        scrollView.contentOffset = CGPointZero;
    }
    if (t >= (_imageArr.count -1) *SCREEN_WIDTH)
    {
        scrollView.contentOffset = CGPointMake((_imageArr.count -1) * SCREEN_WIDTH, 0);
        
    }

}

- (void)click:(UIPageControl *)page
{
    NSInteger t = page.currentPage;
    _aSscroll.contentOffset = CGPointMake(t*SCREEN_WIDTH, 0);
}


- (void)delayMethod:(UIButton *)button
{
    
    self.view.userInteractionEnabled = NO;
    
    button.enabled = NO;
    _aSscroll.scrollEnabled = NO;

    AppDelegate *d = App_Delegate;
    
   d.window.rootViewController = d.rootViewController;
}


- (BOOL)prefersStatusBarHidden {
    return YES;
}
@end
