//
//  Tool.h
//  LawChatForLawyer
//
//  Created by lawchat on 15/5/20.
//  Copyright (c) 2015   jackli. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Tool : NSObject

//网络请求
+ (void)requestApiWithParams:(NSDictionary *)params andRequestUrl:(NSString *)url completedBlock:(void(^)(NSDictionary *dic,bool isSuccess))block;
//检测code
+ (void)checkError:(NSDictionary*)dict;

//自动登录
+ (void)requestLoginMethodWithCompletedBlock:(void(^)(bool isSuccess))block noConnet:(void(^)(void))noConnet;

#pragma mark - 跳转登录界面
+ (void)gotoLoginVC;

+ (void)checkLoginAndShowHUDWithSuccessBlock:(void(^)(void))successBlock;



#pragma mark - push网页
+ (void)gotoWebWithUrl:(NSString*)url inNavigationVC:(UINavigationController*)navigationVC;



@end
