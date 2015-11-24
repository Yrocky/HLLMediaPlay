//
//  HTTPTool.h
//  MyOne
//
//  Created by HelloWorld on 8/3/15.
//  Copyright (c) 2015 melody. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"


// 获取关键字搜索视频内容结果

//#define URL_Get_Search_Media_Info @"//http://api.tudou.com/v3/gw"


#define URL_Get_Search_Media_Info @"https://openapi.youku.com/v2/searches/video/by_keyword.json"


// youku云app的client_id
#define Youku_Client_id @"920e518867b95b70"

@interface HTTPTool : NSObject

// 请求成功之后回调的 Block
typedef void(^SuccessBlock) (AFHTTPRequestOperation *operation, id responseObject);

// 请求失败之后回调的 Block
typedef void(^FailBlock) (AFHTTPRequestOperation *operation, NSError *error);

+ (void) requestSearchMediaInfoWithKeyWord:(NSString *)keyWord successedBlock:(SuccessBlock)success andFailedBlock:(FailBlock)fail;
@end
