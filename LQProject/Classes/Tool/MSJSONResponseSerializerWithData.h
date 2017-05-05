//
//  MSJSONResponseSerializerWithData.h
//  PublicLawyerChat
//
//  Created by lawchat on 16/5/12.
//  Copyright © 2016   . All rights reserved.
//

#import "AFURLResponseSerialization.h"

static NSString * const JSONResponseSerializerWithDataKey = @"body";
static NSString * const JSONResponseSerializerWithBodyKey = @"statusCode";

@interface MSJSONResponseSerializerWithData : AFJSONResponseSerializer

@end