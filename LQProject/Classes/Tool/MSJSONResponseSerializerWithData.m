//
//  MSJSONResponseSerializerWithData.m
//  PublicLawyerChat
//
//  Created by lawchat on 16/5/12.
//  Copyright © 2016   . All rights reserved.
//

#import "MSJSONResponseSerializerWithData.h"

@implementation MSJSONResponseSerializerWithData
- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error
{
    id JSONObject = [super responseObjectForResponse:response data:data error:error]; // may mutate `error`
    
    switch ([[response valueForKey:JSONResponseSerializerWithBodyKey] integerValue]) {
        case 200:
        {
            LQLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            (*error) = nil;
            return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        }
            break;
        default:
        {
            if (*error != nil) {
                NSMutableDictionary *userInfo = [(*error).userInfo mutableCopy];
                [userInfo setValue:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] forKey:JSONResponseSerializerWithDataKey];
                [userInfo setValue:[response valueForKey:JSONResponseSerializerWithBodyKey] forKey:JSONResponseSerializerWithBodyKey];

                NSError *newError = [NSError errorWithDomain:(*error).domain code:(*error).code userInfo:userInfo];
                (*error) = newError;
            }
            return JSONObject;
        }
            break;
    }
    
    
    
    return JSONObject;
}
@end
