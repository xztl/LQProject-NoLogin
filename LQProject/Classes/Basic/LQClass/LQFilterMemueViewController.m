//
//  LQFilterMemueViewController.m
//  LQFilterMenue
//
//  Created by lawchat on 16/5/20.
//  Copyright © 2016年 jacli. All rights reserved.
//

#import "LQFilterMemueViewController.h"

@interface LQFilterMemueViewController ()

@property(nonatomic,strong)  UIView *menueView;


@property(nonatomic,strong) UIButton *selctedMenueBtn;

@property(nonatomic,strong) NSMutableArray *menueBtnArray;

@property(nonatomic,strong)  UIView *backgroudView;

@end

@implementation LQFilterMemueViewController


- (instancetype)initWithMainViewController:(UIViewController*)mainViewController menueViewControllers:(NSArray *)menueViewControllers
{
    self = [super init];
    if (self) {
        [self loadMainViewController:mainViewController menueViewControllers:menueViewControllers];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if (_menueViewControllers) {
        [self initUI];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

- (void)loadMainViewController:(UIViewController*)mainViewController menueViewControllers:(NSArray *)menueViewControllers {
    _mainViewController = mainViewController;
    _menueViewControllers = menueViewControllers;
}

- (void)initUI{

    if (!_menueHeight) {
        _menueHeight = 40;
    }
    
    //筛选菜单工具条
    _menueView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, _menueHeight)];
    _menueView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_menueView];
    
    //上下灰色线条
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 1)];
    topLine.backgroundColor = MyColor_Line_eee;
    [_menueView addSubview:topLine];
    
    
    /**
     *  筛选菜单按钮
     */
    _menueBtnArray = [NSMutableArray array];
    NSInteger menueButtonCout = _menueViewControllers.count;
    CGFloat btnWidth = (CGFloat)(self.view.bounds.size.width - menueButtonCout + 1) / menueButtonCout;
    
    [_menueViewControllers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIViewController *vc = (UIViewController *)obj;
        
        /**
         *  按钮文字为controller标题
         */
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundColor:[UIColor whiteColor]];
        btn.frame = CGRectMake(btnWidth * idx + idx, 0, btnWidth, _menueHeight);
        //监听标题改变刷新按钮文字
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setTitleColor:MyColor_Text_5a forState:UIControlStateNormal];
        UIImage *image = [UIImage imageNamed:@"lq_向下"];
        [btn setImage:image forState:UIControlStateNormal];
        
        [RACObserve(vc, title) subscribeNext:^(NSString *title) {
            [btn setTitle:vc.title forState:UIControlStateNormal];
            /**
             *  设置图片在文字右边
             */
            
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -btn.imageView.bounds.size.width, 0, btn.imageView.bounds.size.width)];
            [btn setImageEdgeInsets:UIEdgeInsetsMake(0, btn.titleLabel.bounds.size.width, 0, -btn.titleLabel.bounds.size.width)];
        }];
        
        
        
        //添加按钮到界面
        [btn addTarget:self action:@selector(menueBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_menueView addSubview:btn];
        [_menueBtnArray addObject:btn];
        
        /**
         *  如果不是最后一个，添加按钮之间的分割线
         */
        
        if (idx != menueButtonCout - 1) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(btn.frame.origin.x + btn.frame.size.width , _menueHeight / 4.0, 1, _menueHeight / 2.0)];
            view.backgroundColor = MyColor_Line_eee;
            [_menueView addSubview:view];
        }
        
    }];
    
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, _menueHeight-1, self.view.bounds.size.width, 1)];
    bottomLine.backgroundColor = MyColor_Line_eee;
    [_menueView addSubview:bottomLine];
    
    /**
     *  添加主界面到视图中
     */
    [self addChildViewController:_mainViewController];
    _mainViewController.view.frame = CGRectMake(0, _menueView.frame.origin.y + _menueHeight, self.view.frame.size.width, self.view.frame.size.height - (_menueView.frame.origin.y + _menueHeight));
    [self.view addSubview:_mainViewController.view];
    
    _backgroudView = [[UIView alloc] initWithFrame:_mainViewController.view.frame];
    UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideMenueView)];
    [_backgroudView addGestureRecognizer:tapGesturRecognizer];
    _backgroudView.hidden = YES;
    _backgroudView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    [self.view addSubview:_backgroudView];
    /**
     *  添加筛选菜单的视图到界面并隐藏
     */
    CGRect rect = _mainViewController.view.frame;
    rect.size.height = rect.size.height;
    
    for (UIViewController *vc in _menueViewControllers) {
        [self addChildViewController:vc];

        if (vc.view.frame.size.height > rect.size.height) {
            vc.view.frame = rect;
        } else {
            CGRect newRec = rect;
            newRec.size.height = vc.view.frame.size.height;
            vc.view.frame = newRec;
        }
        vc.view.hidden = YES;
        [self.view addSubview:vc.view];
    }
}
-(void)viewWillLayoutSubviews {

    for (UIButton *btn in _menueBtnArray) {
        
        /**
         *  设置图片在文字右边
         */
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -btn.imageView.bounds.size.width-5, 0, btn.imageView.bounds.size.width+5)];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, btn.titleLabel.bounds.size.width+5, 0, -btn.titleLabel.bounds.size.width-5)];
    }
}
#pragma mark - 筛选菜单按钮点击切换筛选视图
- (void)menueBtnClicked:(UIButton *)sender {
    
    if (sender != _selctedMenueBtn) {
        [self hideMenueView];
        _selctedMenueBtn = sender;
        [self showMenueView];

    }else{
        [self hideMenueView];
    }

}

#pragma mark - 隐藏筛选菜单视图
- (void)hideMenueView {
    if (_selctedMenueBtn) {
        [_selctedMenueBtn setTitleColor:MyColor_Text_5a forState:UIControlStateNormal];
        [_selctedMenueBtn setImage:[UIImage imageNamed:@"lq_向下"] forState:UIControlStateNormal];
        NSInteger oldIndex = [_menueBtnArray indexOfObject:_selctedMenueBtn];
        UIViewController *vc = _menueViewControllers[oldIndex];
        /**
         *  隐藏
         */
        vc.view.hidden = YES;
        _backgroudView.hidden = YES;
        _selctedMenueBtn = nil;
    }
}

- (void)showMenueView {
    if (_selctedMenueBtn) {
        
        [_selctedMenueBtn setTitleColor:MyColor_Button_Normal forState:UIControlStateNormal];
        [_selctedMenueBtn setImage:[UIImage imageNamed:@"lq_向上"] forState:UIControlStateNormal];
        NSInteger newIndex = [_menueBtnArray indexOfObject:_selctedMenueBtn];
        UIViewController *vc = _menueViewControllers[newIndex];
        _backgroudView.hidden = NO;
        [self.view bringSubviewToFront:vc.view];
        /**
         *  显示
         */
        
        vc.view.hidden = NO;
    }
}

- (void)dealloc {
    [NotificationCenter removeObserver:self];
}
@end
