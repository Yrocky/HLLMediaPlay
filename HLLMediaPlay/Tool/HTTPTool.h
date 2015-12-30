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

// 金象
#define URL_Get_Search_JXVDY_Media_Info @"http://api2.jxvdy.com/search_list"
#define URL_Get_JXVDY_Media_Info @"http://api2.jxvdy.com/video_info"
// youku
#define URL_Get_Search_Media_Info @"https://openapi.youku.com/v2/searches/video/by_keyword.json"

// 金象微电影的token
#define JXVDYToken @"gDATiGWi8G1HPXi_-r3TORzC7Igp6_OzlXoaB6-oQ-gbmfjYlPSY1HHMu0Wglnexr6cuX8ikaw"

// youku云app的client_id
#define Youku_Client_id @"920e518867b95b70"

@interface HTTPTool : NSObject

// 请求成功之后回调的 Block
typedef void(^SuccessBlock) (AFHTTPRequestOperation *operation, id responseObject);

// 请求失败之后回调的 Block
typedef void(^FailBlock) (AFHTTPRequestOperation *operation, NSError *error);

+ (void) requestSearchMediaInfoWithKeyWord:(NSString *)keyWord successedBlock:(SuccessBlock)success andFailedBlock:(FailBlock)fail;

+ (void) requestJXVDYMediaSourceWithKeyword:(NSString *)keyWord offset:(NSString *)offset successedBlock:(SuccessBlock)success andFialedBlock:(FailBlock)fail;

+ (void) requestJXVDYMediaInfoWithID:(NSString *)ID successedBlock:(SuccessBlock)success andFialedBlock:(FailBlock)fail;

+ (void) requestBankCode:(NSString *)bankCode name:(NSString *)name bankcardno:(NSString *)bankcardno successedBlock:(SuccessBlock)success andFailedBlock:(FailBlock)fail;
@end
