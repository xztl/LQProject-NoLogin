#import "UserCenter.h"

static UserCenter *_sharedUserCenter;

@implementation UserCenter
+ (instancetype) sharedInstance {
    
    static dispatch_once_t token;
    
    dispatch_once(&token,^{
        
        if ([UserDefaults objectForKey:@"UserCenter"]) {
            /**
             *  获取保存的用户信息
             */
            NSData *myEncodedObject = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserCenter"];
            _sharedUserCenter = [NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
        }
        if (!_sharedUserCenter) {
            _sharedUserCenter = [[UserCenter alloc] init];
        }
    });
    
    return _sharedUserCenter;
}

+ (BOOL)checkIsLogin {
    
    return (User_Center.ID.length > 0 && User_Center.pass.length  > 0) || (User_Center.openId.length > 0 && User_Center.ID.length > 0 ) ;
}

+ (void)clearUserCenter {
    /**
     *  清除保存到数据
     */
    User_Center.ID = nil;
    User_Center.pass = nil;
    User_Center.uuid = nil;
    User_Center.gender = nil;
    User_Center.nick = nil;
    User_Center.card = nil;
    User_Center.birthday = nil;
    User_Center.cents = nil;
    User_Center.rmb = nil;
    User_Center.email = nil;
    User_Center.work_type = nil;
    User_Center.company_addr = nil;
    User_Center.home_addr = nil;
    User_Center.sec_question = nil;
    User_Center.openId = nil;
    User_Center.headurl = nil;
    User_Center.unionLoginType = nil;

    [UserCenter save];
}

+(void)resetUserCenterWithDictionary:(NSDictionary *)dict {
    
    if (dict[@"ID"]) {
        User_Center.ID = dict[@"ID"];
        
    }
    if (dict[@"pass"]) {
        User_Center.pass = dict[@"pass"];
        
    }
    if (dict[@"uuid"]) {
        User_Center.uuid = dict[@"uuid"];
        
    }
    if (dict[@"gender"]) {
        User_Center.gender = dict[@"gender"];
        
    }
    if (dict[@"nick"]) {
        User_Center.nick = dict[@"nick"];
        
    }
    if (dict[@"card"]) {
        User_Center.card = dict[@"card"];
        
    }
    if (dict[@"cents"]) {
        User_Center.cents = dict[@"cents"];
        
    }
    if (dict[@"rmb"]) {
        User_Center.rmb = dict[@"rmb"];
        
    }
    if (dict[@"birthday"]) {
        User_Center.birthday = dict[@"birthday"];
    }
    if (dict[@"email"]) {
        User_Center.email = dict[@"email"];
    }
    if (dict[@"work_type"]) {
        User_Center.work_type = dict[@"work_type"];
    }
    if (dict[@"company_addr"]) {
        User_Center.company_addr = dict[@"company_addr"];
    }
    if (dict[@"home_addr"]) {
        User_Center.home_addr = dict[@"home_addr"];
    }
    if (dict[@"sec_question"]) {
        User_Center.sec_question = dict[@"sec_question"];
    }
    if (dict[@"openid"]) {
        User_Center.openId = dict[@"openid"];
    }
    if (dict[@"headurl"]) {
        User_Center.headurl = dict[@"headurl"];
    }
    
    [UserCenter save];
}

+ (void)save{
    
    /**
     *  保存用户信息
     */
    NSData *archiveData = [NSKeyedArchiver archivedDataWithRootObject:_sharedUserCenter];
    [[NSUserDefaults standardUserDefaults] setObject:archiveData forKey:@"UserCenter"];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.ID forKey:@"ID"];
    [aCoder encodeObject:self.uuid forKey:@"uuid"];
    [aCoder encodeObject:self.pass forKey:@"pass"];
    [aCoder encodeObject:self.gender forKey:@"gender"];
    [aCoder encodeObject:self.nick forKey:@"nick"];
    [aCoder encodeObject:self.card forKey:@"card"];
    [aCoder encodeObject:self.cents forKey:@"cents"];
    [aCoder encodeObject:self.rmb forKey:@"rmb"];
    [aCoder encodeObject:self.birthday forKey:@"birthday"];
    [aCoder encodeObject:self.email forKey:@"email"];
    [aCoder encodeObject:self.work_type forKey:@"work_type"];
    [aCoder encodeObject:self.company_addr forKey:@"company_addr"];
    [aCoder encodeObject:self.home_addr forKey:@"home_addr"];
    [aCoder encodeObject:self.sec_question forKey:@"sec_question"];
    [aCoder encodeObject:self.openId forKey:@"openId"];
    [aCoder encodeObject:self.unionLoginType forKey:@"unionLoginType"];
    [aCoder encodeObject:self.headurl forKey:@"headurl"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        self.ID             = [aDecoder decodeObjectForKey:@"ID"];
        self.pass           = [aDecoder decodeObjectForKey:@"pass"];
        self.uuid           = [aDecoder decodeObjectForKey:@"uuid"];
        self.gender         = [aDecoder decodeObjectForKey:@"gender"];
        self.nick           = [aDecoder decodeObjectForKey:@"nick"];
        self.card           = [aDecoder decodeObjectForKey:@"card"];
        self.cents          = [aDecoder decodeObjectForKey:@"cents"];
        self.rmb            = [aDecoder decodeObjectForKey:@"rmb"];
        self.birthday       = [aDecoder decodeObjectForKey:@"birthday"];
        self.email          = [aDecoder decodeObjectForKey:@"email"];
        self.work_type      = [aDecoder decodeObjectForKey:@"work_type"];
        self.company_addr   = [aDecoder decodeObjectForKey:@"company_addr"];
        self.home_addr      = [aDecoder decodeObjectForKey:@"home_addr"];
        self.sec_question   = [aDecoder decodeObjectForKey:@"sec_question"];
        self.openId         = [aDecoder decodeObjectForKey:@"openId"];
        self.unionLoginType = [aDecoder decodeObjectForKey:@"unionLoginType"];
        self.headurl        = [aDecoder decodeObjectForKey:@"headurl"];
    }
    return self;
}

@end
