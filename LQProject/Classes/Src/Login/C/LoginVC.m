//
//  LoginVC.m
//  PublicLawyerChat
//
//  Created by lawchat on 16/5/12.
//  Copyright © 2016 . All rights reserved.
//

#import "LoginVC.h"

@interface LoginVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UIImageView *userNameIconImageView;
@property (weak, nonatomic) IBOutlet UIImageView *passwordIconImageView;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UIView *userNameSubLine;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextFiled;
@property (weak, nonatomic) IBOutlet UIView *passwordSubLine;

@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;

/**
 *  获得验证码倒计时
 */
@property (assign, nonatomic) BOOL runningGettingCodeTimer;

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = FlatSand;
    [self initViewData];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}
- (void)initViewData {
    /**
     *  关闭按钮
     */
    [_closeBtn setImage:[UIImage imageNamed:@"error"] forState:UIControlStateNormal];
    [[_closeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self dismissViewControllerAnimated:YES completion:nil];//关闭登录界面
    }];
    
    /**
     *  用户名icon
     */
    _userNameIconImageView.image = [UIImage imageNamed:@"shouji"];
    
    /**
     *  密码icon
     */
    _passwordIconImageView.image = [UIImage imageNamed:@"yanzhengma"];
    
    /**
     *  填充已保存用户名密码
     */
    if ([UserDefaults objectForKey:@"userName"]) {
        _userNameTextField.text = [UserDefaults objectForKey:@"userName"];
    }
    if ([UserDefaults objectForKey:@"password"]) {
        _passwordTextFiled.text = [UserDefaults objectForKey:@"password"];
    }
    
    /**
     *  登录按钮
     */
    _loginBtn.layer.cornerRadius = 5;

    
    /**
     *  设置输入用户名密码交互
     */
    
    _userNameTextField.delegate = self;
    _passwordTextFiled.delegate = self;
    
    //用户名输入框信号通道
    RACSignal *validUsernameSignal =
    [self.userNameTextField.rac_textSignal
     map:^id(NSString *text) {
         return @([self isValidUsername:text]);
     }];
    
    RAC(self.userNameTextField, textColor) =
    [validUsernameSignal
     map:^id(NSNumber *userNameValid){
         return [userNameValid boolValue] ? MyColor_Button_Normal:MyColor_Text_333;
     }];
    
    [[[_userNameTextField rac_signalForControlEvents:UIControlEventEditingDidEnd]
    flattenMap:^id(id x){
        return validUsernameSignal;
    }]
     subscribeNext:^(NSNumber *validUsername){

         BOOL success =[validUsername boolValue];
         if(success){
             _userNameTextField.textColor = MyColor_Button_Normal;
         }else{
             _userNameTextField.textColor = MyColor_Red;
         }
     }];
    
    //用户名输入正确手机号，验证码可用
    RAC(self.getCodeBtn, enabled) =
    [validUsernameSignal
     map:^id(NSNumber *userNameValid) {
         
         return @([userNameValid boolValue] && !_runningGettingCodeTimer);
     }];
    
    
    //密码输入框信号通道
    RACSignal *validPasswordSignal =
    [self.passwordTextFiled.rac_textSignal
     map:^id(NSString *text) {
         return @([self isValidPassword:text]);
     }];
    RAC(self.passwordTextFiled, textColor) =
    [validPasswordSignal
     map:^id(NSNumber *passwordValid){
         return [passwordValid boolValue] ? MyColor_Button_Normal:MyColor_Text_333;
     }];
    [[[_passwordTextFiled rac_signalForControlEvents:UIControlEventEditingDidEnd]
      flattenMap:^id(id x){
          return validPasswordSignal;
      }]
     subscribeNext:^(NSNumber *validUsername){
         BOOL success =[validUsername boolValue];
         if(success){
             _passwordTextFiled.textColor = MyColor_Button_Normal;
         }else{
             _passwordTextFiled.textColor = MyColor_Red;
         }
     }];
    
    
    //聚合用户名-密码 输入框信号通道
    RACSignal *signUpActiveSignal =
    [RACSignal combineLatest:@[validUsernameSignal, validPasswordSignal]
                      reduce:^id(NSNumber*usernameValid, NSNumber *passwordValid){
                          return @([usernameValid boolValue]&&[passwordValid boolValue]);
                      }];
    [signUpActiveSignal subscribeNext:^(NSNumber*signupActive){
        self.loginBtn.enabled = [signupActive boolValue];
        if ([signupActive boolValue]) {
            self.loginBtn.backgroundColor = MyColor_Button_Normal;
        }else{
            self.loginBtn.backgroundColor = MyColor_Button_Disable;
        }
    }];
    
    /**
     *  登录交互
     */
    
    [[[[self.loginBtn
        rac_signalForControlEvents:UIControlEventTouchUpInside]
       doNext:^(id x){
           self.loginBtn.enabled =NO;
           self.loginBtn.backgroundColor = MyColor_Button_Disable;
       }]
      flattenMap:^id(id x){
          return [self signInSignal];
      }]
     subscribeNext:^(NSNumber*signedIn){
         self.loginBtn.enabled = YES;
         self.loginBtn.backgroundColor = MyColor_Button_Normal;
         BOOL success =[signedIn boolValue];
         if(success){
             [self.navigationController popViewControllerAnimated:YES];//返回上个页面
         }
     }];
    /**
     *  获取验证码按钮交互
     */
    
    [[[[self.getCodeBtn
        rac_signalForControlEvents:UIControlEventTouchUpInside]
       doNext:^(id x){
           _getCodeBtn.enabled = NO;
       }]
      flattenMap:^id(id x){
          return [self getLoginSMSCode];
      }]
     subscribeNext:^(NSNumber *gotCode){
         _getCodeBtn.enabled = YES;
         BOOL success =[gotCode boolValue];
         if(success){
             _runningGettingCodeTimer = YES;
             [self verificationCode:^{
                 if ([_userNameTextField.text checkPhoneNumber]) {
                     self.getCodeBtn.enabled = YES;
                 }
                 _runningGettingCodeTimer = NO;
                 [self.getCodeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
                 [self.getCodeBtn setTitle:@"重新获取" forState:UIControlStateDisabled];
             } blockNo:^(id time) {
                 self.getCodeBtn.enabled = NO;
                 [self.getCodeBtn setTitle:[NSString stringWithFormat:@"%@s后重新获取",time] forState:UIControlStateDisabled];
             }];
         }
     }];
}

#pragma mark - 用户名是否有效
- (BOOL)isValidUsername:(NSString *)text {
    
    return [text checkPhoneNumber];
}

#pragma mark - 密码是否有效
- (BOOL)isValidPassword:(NSString *)text {
    
    return [text checkPassword];
}

#pragma mark - 登录按钮消息通道
- (RACSignal *)signInSignal {
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber){
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"phone"] = _userNameTextField.text;
        params[@"code"] = _passwordTextFiled.text;
        
        
        [SVProgressHUD show];
        [Tool requestApiWithParams:params andRequestUrl:@"checkLoginSMSCode" completedBlock:^(NSDictionary *dic, bool isSuccess) {
            
//            if(dic)
//            {
//                switch ([dic[@"code"] intValue]) {
//                    case 1:
//                    {
//                        //保存用户名密码
//                        User_Center.ID = params[@"phone"];
//                        User_Center.pass = params[@"code"];
//                        //用户中心
//                        [UserCenter resetUserCenterWithDictionary:dic[@"data"]];
//
//                        [subscriber sendNext:@(YES)];
//                        [subscriber sendCompleted];
//                    }
//                        break;
//                    default:
//                        [SVProgressHUD dismiss];
//                        [SVProgressHUD showErrorWithStatus:@"登录失败"];
//                        [subscriber sendNext:@(NO)];
//                        [subscriber sendCompleted];
//                        break;
//                }
//            }else{
//                [SVProgressHUD dismiss];
//                [SVProgressHUD showErrorWithStatus:@"网络异常"];
//                [subscriber sendNext:@(NO)];
//                [subscriber sendCompleted];
//            }
            
            //调试设置:(需删除这段代码)
            [SVProgressHUD dismiss];
            User_Center.ID = params[@"phone"];
            User_Center.pass = params[@"code"];
            User_Center.userAuditState = @"1";
            [subscriber sendNext:@(YES)];
            [subscriber sendCompleted];
            //调试设置:(需删除这段代码)
            
        }];
        
        return nil;
    }];
}

#pragma mark - 请求获取验证码
- (RACSignal *)getLoginSMSCode {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber){
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"phone"] = _userNameTextField.text;
        
        [SVProgressHUD showWithStatus:@"发送验证码"];
        [Tool requestApiWithParams:params andRequestUrl:@"getLoginSMSCode" completedBlock:^(NSDictionary *dic, bool isSuccess) {
            [SVProgressHUD dismiss];
            if(dic)
            {
                switch ([dic[@"code"] intValue]) {
                    case 1:
                    {
                        [subscriber sendNext:@(YES)];
                        [subscriber sendCompleted];
                    }
                        break;
                    default:
                        [SVProgressHUD showErrorWithStatus:@"发送失败"];
                        [subscriber sendNext:@(NO)];
                        [subscriber sendCompleted];
                        break;
                }
            }else{
                [SVProgressHUD showErrorWithStatus:@"网络异常"];
                [subscriber sendNext:@(NO)];
                [subscriber sendCompleted];
            }
        }];
        
        return nil;
    }];
    
}

#pragma mark - 验证码倒计时
- (void)verificationCode:(void(^)())blockYes blockNo:(void(^)(id time))blockNo {
    __block int timeout=60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                blockYes();
            });
        }else{
            //            int minutes = timeout / 60;
            NSString *strTime = [NSString stringWithFormat:@"%d", timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                
                blockNo(strTime);
                
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == _userNameTextField) {
        if ([NSString stringWithFormat:@"%@%@",_userNameTextField.text,string].length>11) {
            return NO;
        }
    }
    
    if (textField == _passwordTextFiled) {
        if ([NSString stringWithFormat:@"%@%@",_passwordTextFiled.text,string].length>6) {
            return NO;
        }
    }
    
    return YES;
}


@end
