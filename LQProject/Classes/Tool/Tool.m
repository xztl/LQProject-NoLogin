//
//  Tool.m
//  LawChatForLawyer
//
//  Created by lawchat on 15/5/20.
//  Copyright (c) 2015   jackli. All rights reserved.
//

#import "Tool.h"
#import<CommonCrypto/CommonDigest.h>
#import <sys/utsname.h>
#import "MSJSONResponseSerializerWithData.h"
#import "LoginVC.h"
#import "RxWebViewController.h"
#import "JSONKit.h"

@implementation Tool

+ (void)requestApiWithParams:(NSDictionary *)params andRequestUrl:(NSString *)url completedBlock:(void(^)(NSDictionary *dic,bool isSuccess))block
{
    
    // 参数的封装
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //必传参数
    parameters[@"version"] = App_Version;
    parameters[@"channel"] = @0;
    
    
    //追加参数
    [parameters addEntriesFromDictionary:params];
    
    // url 地址
    NSString *URL = [NSString stringWithFormat:@"%@%@",UserApiUrl,url];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    manager.requestSerializer.HTTPShouldHandleCookies = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 10;
    
    manager.responseSerializer = [MSJSONResponseSerializerWithData serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",nil];
    
    
    [manager POST:URL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        LQLog(@"%@ %@ -----API:%@",responseObject,manager.requestSerializer.HTTPRequestHeaders,url);
        NSDictionary *dic = [responseObject objectFromJSONString];
        if ([dic[@"code"] integerValue] > 0) {
            block(dic,YES);
        }
        else {
            block(dic,NO);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        LQLog(@"Error: %@ ----- API:%@", task.response,url);
        
        NSDictionary *dic = [[error.userInfo objectForKey:@"body"] objectFromJSONString];
        if ([dic objectForKey:@"code"]) {
            [self checkError:dic];
            block(dic,NO);
        }else{
            block(nil,NO);
        }
    }];
}

+(void)checkError:(NSDictionary*)dict
{
    if ([dict objectForKey:@"code"]) {
        if([dict[@"code"] intValue] == -1006)
        {
            //未登录去登录
            [self requestLoginMethodWithCompletedBlock:nil noConnet:nil];
        }
    }
    
}
/**
 *  自动登录
 *
 *  @param block 是否登录成功
 */
+ (void)requestLoginMethodWithCompletedBlock:(void(^)(bool isSuccess))block noConnet:(void(^)(void))noConnet{
    
    if (User_Center.ID && User_Center.pass) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"name"] = User_Center.ID;
        params[@"pass"] = User_Center.pass;
        params[@"type"] = @0;
        [Tool requestApiWithParams:params andRequestUrl:@"login" completedBlock:^(NSDictionary *dic, bool isSuccess) {
            if(dic)
            {
                switch ([dic[@"code"] intValue]) {
                    case 1:
                    {
                        /**
                         *  登录成功
                         */
                        //用户中心
                        NSMutableDictionary *data = [NSMutableDictionary dictionaryWithDictionary:dic[@"data"]];
                        data[@"pass"] = params[@"pass"];
                        [UserCenter resetUserCenterWithDictionary:data];
                        
                        if (block) {
                            block(YES);
                        }
                        
                    }
                        break;
                    default:
                    {
                        /**
                         *  跳转登录界面
                         */
                        if (block) {
                            block(NO);
                        }
                        [UserCenter clearUserCenter];
                        [self gotoLoginVC];
                        
                    }
                        break;
                }
            }else{
                /**
                 *  请求连接失败
                 */
                if (noConnet) {
                    noConnet();
                }
            }
        }];
    } else if (User_Center.ID.length > 0 && User_Center.openId.length > 0){
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        if (!User_Center.headurl) {
            User_Center.headurl = @"";
        }
        if (!User_Center.nick) {
            User_Center.nick = @"";
        }
        params[@"headurl"] = User_Center.headurl;
        params[@"nickname"] = User_Center.nick;
        params[@"openid"] = User_Center.openId;
        params[@"type"] = User_Center.unionLoginType;
        
        [Tool requestApiWithParams:params andRequestUrl:@"unionlogin" completedBlock:^(NSDictionary *dic, bool isSuccess) {
            if (isSuccess) {
                
                [UserCenter resetUserCenterWithDictionary:dic[@"data"]];
                
                if (block) {
                    block(YES);
                }
                
            } else {
                if (dic[@"code"]) {
                    /**
                     *  跳转登录界面
                     */
                    if (block) {
                        block(NO);
                    }
                } else {
                    /**
                     *  请求连接失败
                     */
                    if (noConnet) {
                        noConnet();
                    }
                }
            }
        }];
        
    }
}

#pragma mark - 跳转登录界面

+ (void)gotoLoginVC {
    if (User_Center.openId.length>0) {
        //绑定手机号页面
//        UIStoryboard *SB = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
//        BindPhoneTVC *vc = [SB instantiateViewControllerWithIdentifier:@"BindPhoneTVC"];
//        AppDelegate *apd = App_Delegate;
//        [apd.customNavVC pushViewController:vc animated:YES];
        
    } else {
        //登录页面
        UIStoryboard *SB = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        LoginVC *vc = [SB instantiateViewControllerWithIdentifier:@"LoginVC"];
        AppDelegate *apd = App_Delegate;
        [apd.customNavVC pushViewController:vc animated:YES];
    }
}

#pragma mark - 点击关于账户的操作检测是否登录（伴随hud）
+ (void)checkLoginAndShowHUDWithSuccessBlock:(void(^)(void))successBlock {
    if ([UserCenter checkIsLogin]) {
        if (successBlock) {
            successBlock();
        }
    }else{
        if (!User_Center.ID || !User_Center.pass) {
            //如果没有用户ID或者密码，表示从未登录过
            [self gotoLoginVC];
        }else{
            //如果曾经登录过，就自动登录
            [SVProgressHUD show];
            [Tool requestLoginMethodWithCompletedBlock:^(bool isSuccess) {
                [SVProgressHUD dismiss];
                if (isSuccess) {
                    if (successBlock) {
                        successBlock();
                    }
                }
            } noConnet:^{
                [SVProgressHUD dismiss];
                [SVProgressHUD show];
            }];
        }
    }
}

//登录成功获取用户信息，不成功跳转登录界面
+ (void)getUserInfoWithBlock:(void(^)(bool isSuccess))block {
    if ([UserCenter checkIsLogin]) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"id"] = User_Center.ID;
        [Tool requestApiWithParams:params andRequestUrl:@"user/info" completedBlock:^(NSDictionary *dic, bool isSuccess) {
            if(dic)
            {
                switch ([dic[@"code"] intValue]) {
                    case 1:
                    {
                        
                        [UserCenter resetUserCenterWithDictionary:dic[@"data"]];
                        
                        if (block) {
                            block(YES);
                        }
//                        [Tool addNotice];
                    }
                        break;
                    default:
                    {
                        /**
                         *  跳转登录界面
                         */
                        if (block) {
                            block(NO);
                        }
                        [UserCenter clearUserCenter];
                        [self gotoLoginVC];
                        
                    }
                        break;
                }
            }else{
                /**
                 *  请求连接失败
                 */
                if (block) {
                    block(NO);
                }
            }
        }];
    }
}


#pragma mark - MD5加密字符串
+ (NSString *) md5:(NSString *) input {
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}

#pragma mark - 添加服务器推送
//+ (void)addNotice{
//    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
//        if (registrationID.length > 0) {
//            [self requestApiWithParams:@{@"jpushid":registrationID} andRequestUrl:@"user/jpushid/set" completedBlock:^(NSDictionary *dic, bool isSuccess) {
//                if (isSuccess) {
//                    LQLog(@"发送jpushid成功");
//                } else {
//                    LQLog(@"发送jpushid失败");
//                }
//            }];
//            
//        }
//    }];
//}
//+ (void)removeNoticeWithBlock:(void(^)(bool isSuccess))block {
//    [self requestApiWithParams:nil andRequestUrl:@"addNotice" completedBlock:^(NSDictionary *dic, bool isSuccess) {
//        block(isSuccess);
//    }];
//}


#pragma mark - push网页
+ (void)gotoWebWithUrl:(NSString*)url inNavigationVC:(UINavigationController*)navigationVC{
    
    RxWebViewController *VC = [[RxWebViewController alloc] initWithUrl:[NSURL URLWithString:url]];

    if (navigationVC) {
        [navigationVC pushViewController:VC animated:YES];
    } else {
        AppDelegate *apd = App_Delegate;
        [apd.customNavVC pushViewController:VC animated:YES];
    }
    
}


@end
