//
//  MineTVC.m
//  LQProject
//
//  Created by JW on 2016/12/1.
//  Copyright © 2016年 jacli. All rights reserved.
//

#import "MineTVC.h"

@interface MineTVC ()

@end

@implementation MineTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"mine";
    
    
//    [self add];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    AppDelegate *apd = App_Delegate;
    apd.customNavVC = self.navigationController;
}




@end
