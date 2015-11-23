//
//  HTTPTool.h
//  MyOne
//
//  Created by HelloWorld on 8/3/15.
//  Copyright (c) 2015 melody. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

// 获取关键字搜索视频内容结果
#define URL_Get_Search_Media_Info @"https://openapi.youku.com/v2/searches/video/by_keyword.json"


// 获取首页内容接口地址
#define URL_GET_HOME_CONTENT @"http://bea.wufazhuce.com/OneForWeb/one/getHp_N"
// 获取文章接口地址
#define URL_GET_READING_CONTENT @"http://bea.wufazhuce.com/OneForWeb/one/getOneContentInfo"
// 获取问题接口地址
#define URL_GET_QUESTION_CONTENT @"http://bea.wufazhuce.com/OneForWeb/one/getOneQuestionInfo"
// 获取问题后援接口地址 (What the f**k! 日了狗了，试了几次不同日期，获取过来都是最新一天的(也就是今天))，没办法，只能显示一个官方的手机版网页了
//#define URL_BACKUP_GET_QUESTION_CONTENT @"http://bea.wufazhuce.com/OneForWeb/one/getQ_N"
// 获取东西接口地址
#define URL_GET_THING_CONTENT @"http://bea.wufazhuce.com/OneForWeb/one/o_f"

@interface HTTPTool : NSObject

// 请求成功之后回调的 Block
typedef void(^SuccessBlock) (AFHTTPRequestOperation *operation, id responseObject);

// 请求失败之后回调的 Block
typedef void(^FailBlock) (AFHTTPRequestOperation *operation, NSError *error);

- (void) requestSearchMediaInfoWithKeyWord:(NSString *)keyWord successedBlock:(SuccessBlock)success andFailedBlock:(FailBlock)fail;
@end
