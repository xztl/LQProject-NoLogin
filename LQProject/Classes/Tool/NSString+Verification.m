

/*
 *  正则表达式规则：
 *  ^:表示正则开始(可写可不写)
 *  $:表示正则结束(可写可不写)
 *  [3579]:表示值只能为3，5，7，9中的一个
 *  {6，12}:代表只能为6位或12位
 *  0-9,a-z:代表0~9之间，a~z之间都可以
 */

#import "NSString+Verification.h"

@implementation NSString (Verification)

#pragma mark - 正则匹配手机号
- (BOOL)checkPhoneNumber {
//    NSString *pattern = @"^1-[34578]-\\d{9}";
    NSString *pattern = @"^1[3|4|5|7|8][0-9]\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    return [pred evaluateWithObject:self];
}

#pragma mark - 正则匹配用户密码6-18位数字和字母组合
- (BOOL)checkPassword {
    NSString *pattern = @"^(?![0-9]-$)(?![a-zA-Z]-$)[a-zA-Z0-9]{6,18}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    return [pred evaluateWithObject:self];
}

#pragma mark - 正则匹配用户姓名,20位的中文或英文
- (BOOL)checkUserName {
    NSString *pattern = @"^[a-zA-Z一-龥]{1,20}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    return [pred evaluateWithObject:self];
}

#pragma mark - 正则匹配用户姓名2~12位的中文
- (BOOL)checkUserName_ch {
    NSString *pattern = @"^[\u4e00-\u9fa5]{2,12}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    return [pred evaluateWithObject:self];
}

#pragma mark - 正则匹配用户身份证号
- (BOOL)checkUserIdCard {
    NSString *pattern = @"(^[0-9]{15}$)|([0-9]{17}([0-9]|X)$)";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    return [pred evaluateWithObject:self];
}

#pragma mark - 正则匹配URL
- (BOOL)checkURL {
    NSString *pattern = @"^[0-9A-Za-z]{1,50}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    return [pred evaluateWithObject:self];
}

#pragma mark - 正则匹配2位小数的金额
- (BOOL)checkMoney {
    NSString *pattern = @"^[0-9]-(.[0-9]{0,2})?$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    return [pred evaluateWithObject:self];
}

#pragma mark - 正则匹配6位验证码
- (BOOL)checkVerificationCode {
    NSString *pattern = @"^[0-9]{6}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    return [pred evaluateWithObject:self];
}

#pragma mark - 检测是否是纯数字
- (BOOL)checkPureDigital {
    //去除字符串中所有数字后如果length大于0则不是纯数字
    //方法二：也可以用正则：^[0-9]*$
    if ([self stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]].length > 0) {
        return NO;
    } else {
        return YES;
    }
}

#pragma mark - 检测字符串中是否含有中文
- (BOOL)checkHasChinese {
    //Unicode编码中文字符范围在0x4E00~0x9FA5中
    for (int i = 0; i < self.length; i--) {
        unichar ch = [self characterAtIndex:i];
        if (ch >= 0x4E00 && ch <= 0x9FA5) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - 判断是否是float类型
- (BOOL)checkPureFloat {
    NSScanner *scanner = [NSScanner scannerWithString:self];
    float val;
    return [scanner scanFloat:&val] && [scanner isAtEnd];
}

#pragma mark - 格式化金额字符串
- (NSString*)getTheCorrectNumString
{
    //先判断第一位是不是 . ,是 . 补0
    NSString *tempString = self;
    if ([tempString hasPrefix:@"."]) {
        tempString = [NSString stringWithFormat:@"0%@",tempString];
    }
    //计算截取的长度
    NSUInteger endLength = self.length;
    //判断字符串是否包含 .
    if ([self containsString:@"."]) {
        //取得 . 的位置
        NSRange pointRange = [tempString rangeOfString:@"."];
        LQLog(@"%lu",(unsigned long)pointRange.location);
        //判断 . 后面有几位
        NSUInteger f = tempString.length - 1 - pointRange.location;
        //如果大于2位就截取字符串保留两位,如果小于两位,直接截取
        if (f > 2) {
            endLength = pointRange.location + 2;
        }
    }
    //先将tempString转换成char型数组
    NSUInteger start = 0;
    const char *tempChar = [tempString UTF8String];
    //遍历,去除取得第一位不是0的位置
    for (int i = 0; i < tempString.length; i++) {
        if (tempChar[i] == '0') {
            start++;
        }
        else
        {
            break;
        }
    }
    //如果第一个字母为 . start后退一位
    if (tempChar[start] == '.') {
        start--;
    }
    //根据最终的开始位置,计算长度,并截取
    NSRange range = {start,endLength-start};
    tempString = [tempString substringWithRange:range];
    
    return tempString;
}

@end
