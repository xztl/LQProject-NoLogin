

#ifndef AppDefine_h
#define AppDefine_h


#ifdef DEBUG

//内测
#define BaseUrl @"https://www.baidu.com"
#define WebBaseUrl @"https://www.baidu.com"

#define UserApiUrl [NSString stringWithFormat:@"%@/api?m=",BaseUrl]//用户端api路径


#else
//正式
#define BaseUrl @"https://www.baidu.com"
#define WebBaseUrl @"https://www.baidu.com"

#define UserApiUrl [NSString stringWithFormat:@"%@/api?m=",BaseUrl]//用户端api路径

#endif



#endif /* ServerDefine_h */
