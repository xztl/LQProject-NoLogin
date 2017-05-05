//
//  ADView.m
//  STLaunchAD
//
//  Created by 研发部 on 16/9/22.
//  Copyright © 2016年 SKYTang. All rights reserved.
//

#import "ADView.h"

@interface ADView ()

/** 新广告的本地路径 **/
@property (nonatomic, strong) NSString *filePath;
/** 新广告图片的地址 **/
@property (nonatomic, strong) NSString *imageUrl;
/** 新广告的链接 **/
@property (nonatomic, strong) NSString *adUrl;
/** 点击回调 **/
@property (nonatomic, copy) void (^clickBlock)(NSString *clikADUrl);
/** 点击广告的链接 **/
@property (nonatomic, strong) NSString *clikADUrl;
/** 广告图片视图 **/
@property (nonatomic, strong) UIImageView *adView;
/** 倒计时按钮 **/
@property (nonatomic, strong) UIButton *countBtn;

@property (nonatomic, assign) NSInteger count;

@property (nonatomic, strong) NSTimer *countTimer;

@end

@implementation ADView

- (void)setupNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterBG) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterFG) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)enterBG {
    LQLog(@"进入后台");
    [self stopTimer];
}

- (void)enterFG {
    LQLog(@"进入前台");
    [self startTimer];
}

- (void)startTimer {
    if (_countTimer) {
        [_countBtn setTitle:[NSString stringWithFormat:@"跳过%zd", _count] forState:UIControlStateNormal];
        [_countTimer setFireDate:[NSDate distantPast]];
    }
}

- (void)stopTimer {
    if (_countTimer) {
        [_countTimer setFireDate:[NSDate distantFuture]];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    [self cancelCountTimer];
}

/**
 *  初始化
 *
 *  @param frame    坐标
 *  @param imageUrl 图片地址
 *  @param adUrl    广告链接
 *  @param block    点击广告回调
 *
 *  @return self
 */
- (instancetype)initWithFrame:(CGRect)frame withImageUrl:(NSString *)imageUrl withADUrl:(NSString *)adUrl withClickBlock:(void (^)(NSString *clikADUrl))block {
    if (self = [super initWithFrame:frame]) {
        _imageUrl = imageUrl;
        _adUrl = adUrl;
        _clickBlock = block;
        
        _adView = [[UIImageView alloc] initWithFrame:frame];
        _adView.userInteractionEnabled = YES;
        _adView.contentMode = UIViewContentModeScaleToFill;
        _adView.clipsToBounds = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToAD)];
        [_adView addGestureRecognizer:tap];
        
        CGFloat btnW = 60;
        CGFloat btnH = 30;
        _countBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW - btnW - 10, btnH, btnW, btnH)];
        _countBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_countBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_countBtn addTarget:self action:@selector(skipAD) forControlEvents:UIControlEventTouchUpInside];
        _countBtn.backgroundColor = [UIColor colorWithWhite:0.5 alpha:1];
        _countBtn.layer.cornerRadius = 4;
        
        [self addSubview:_adView];
        [self addSubview:_countBtn];
        [self setupNotification];
    }
    return self;
}

- (void)pushToAD {
    LQLog(@"跳转到广告");
    if (_clikADUrl) {
        _clickBlock(_clikADUrl);
        [self dismiss];
    }
}

- (void)skipAD {
    LQLog(@"跳过广告到主页");
    [self dismiss];
}

- (void)show {
    if ([self isImageExist]) {
        [_countBtn setTitle:[NSString stringWithFormat:@"跳过%zd", self.showTime] forState:UIControlStateNormal];
        _adView.image = [UIImage imageWithContentsOfFile:_filePath];
        _clikADUrl = [UserDefaults valueForKey:adUrl];
        [self timerFire];
        UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
        [window addSubview:self];
    }
    [self setNewAdImageUrl:_imageUrl];
}

- (BOOL)isImageExist {
    _filePath = [self getFilePathWithImageName:[UserDefaults valueForKey:adImageName]];
    BOOL isExist = [self isFileExistWithFilePath:_filePath];
    return isExist;
}

- (NSString *)getFilePathWithImageName:(NSString *)imageName {
    if (imageName) {
        NSString *cachesPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
        NSString *filePath = [cachesPath stringByAppendingPathComponent:imageName];
        return filePath;
    }
    return nil;
}

- (BOOL)isFileExistWithFilePath:(NSString *)filePath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir;
    return [fileManager fileExistsAtPath:filePath isDirectory:&isDir];
}

- (NSInteger)showTime {
    if (_showTime == 0) {
        return 5;
    }else {
        return _showTime;
    }
}

- (void)timerFire {
    _count = self.showTime;
    [[NSRunLoop currentRunLoop] addTimer:self.countTimer forMode:NSRunLoopCommonModes];
}

- (NSTimer *)countTimer {
    if (_countTimer == nil) {
        _countTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    }
    return _countTimer;
}

- (void)countDown {
    _count--;
    LQLog(@"正在倒计时: %zd", _count);
    [_countBtn setTitle:[NSString stringWithFormat:@"跳过%zd", _count] forState:UIControlStateNormal];
    if (_count == 0) {
        LQLog(@"倒计时完毕!");
        [self dismiss];
    }
}

- (void)dismiss {
    [self cancelCountTimer];
    [UIView animateWithDuration:0.5f animations:^{
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)cancelCountTimer {
    [_countTimer invalidate];
    _countTimer = nil;
}

- (void)setNewAdImageUrl:(NSString *)imageUrl {
    NSString *imageName = [imageUrl componentsSeparatedByString:@"/"].lastObject;
    NSString *filePath = [self getFilePathWithImageName:imageName];
    if (![self isFileExistWithFilePath:filePath]) {
        [self downloadADImageWithUrl:imageUrl withImageName:imageName];
    }
}

- (void)downloadADImageWithUrl:(NSString *)imageUrl withImageName:(NSString *)imageName {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
        UIImage *image = [UIImage imageWithData:data];
        NSString *filePath = [self getFilePathWithImageName:imageName];
        if ([UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES]) {
            LQLog(@"新图片保存成功");
            [self deleteOldImage];
            [UserDefaults setObject:imageName forKey:adImageName];
            [UserDefaults setObject:_adUrl forKey:adUrl];
            [UserDefaults synchronize];
        }else {
            LQLog(@"新图片保存失败");
        }
    });
}

- (void)deleteOldImage {
    NSString *imageName = [UserDefaults objectForKey:adImageName];
    if (imageName) {
        NSString *filePath = [self getFilePathWithImageName:imageName];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:filePath error:nil];
    }
}

@end
