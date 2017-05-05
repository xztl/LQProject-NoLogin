#import <Foundation/Foundation.h>

#define User_Center [UserCenter sharedInstance]

@interface UserCenter : NSObject<NSCoding>

//用户允许进入的标志（如：认证成功标志）
@property (nonatomic, strong) NSString *userAuditState;

//用户ID(手机号)
@property (nonatomic, strong) NSString *ID;
//用户通行证(手机号和密码经MD5加密后的字符串)
@property (nonatomic, strong) NSString *pass;
//用户登录凭证
@property (nonatomic, strong) NSString *uuid;

//性别
@property (nonatomic, strong) NSNumber *gender;

//昵称
@property (nonatomic, strong) NSString *nick;

//会员卡号
@property (nonatomic, strong) NSString *card;

//生日
@property (nonatomic, strong) NSString *birthday;

//积分
@property (nonatomic, strong) NSNumber *cents;

//余额(分)
@property (nonatomic, strong) NSNumber *rmb;

//邮箱
@property (nonatomic, strong) NSString *email;

//行业类型
@property (nonatomic, strong) NSString *work_type;

//公司地址
@property (nonatomic, strong) NSString *company_addr;

//家庭住址
@property (nonatomic, strong) NSString *home_addr;

//密保问题
@property (nonatomic, strong) NSString *sec_question;

//联合登录三方id
@property (nonatomic , strong) NSString *openId;

//头像
@property (nonatomic , strong) NSString *headurl;


//联合登录类型（QQ联合登录=1，微信联合登录=2）
@property (nonatomic , strong) NSNumber *unionLoginType;


//获得单列
+ (instancetype)sharedInstance;
//是否登录
+ (BOOL)checkIsLogin;
//清除用户中心数据
+ (void)clearUserCenter;
//设置用户中心数据
+(void)resetUserCenterWithDictionary:(NSDictionary *)dict;
//存档
+ (void)save;
@end
