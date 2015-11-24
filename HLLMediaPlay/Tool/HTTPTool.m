//
//  HTTPTool.m
//  MyOne
//
//  Created by HelloWorld on 8/3/15.
//  Copyright (c) 2015 melody. All rights reserved.
//

#import "HTTPTool.h"

@implementation HTTPTool

+ (AFHTTPRequestOperationManager *)initAFHttpManager {
	static AFHTTPRequestOperationManager *manager;
	static dispatch_once_t once;
	dispatch_once(&once, ^{
		manager = [[AFHTTPRequestOperationManager alloc] init];
		manager.responseSerializer = [AFJSONResponseSerializer serializer];
		manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
		manager.operationQueue.maxConcurrentOperationCount = 1;
	});
	
	return manager;
}


+ (void) requestSearchMediaInfoWithKeyWord:(NSString *)keyWord successedBlock:(SuccessBlock)success andFailedBlock:(FailBlock)fail{

    AFHTTPRequestOperationManager *manager = [HTTPTool initAFHttpManager];
//#ifdef Youku_Tudou
//    NSDictionary * parameters = @{@"method":@"item.search",
//                            @"kw":keyWord,
//                            @"inDays":@"7",
//                            @"ttlevel":@"m",
//                            @"sort":@"t",
//                            @"media":@"v"};
//#else
    NSDictionary *parameters = @{@"keyword":keyWord,
                                 @"client_id":Youku_Client_id,
                                 @"period":@"month",
                                 @"orderby":@"published",
                                 @"paid":@"0",
                                 @"public_type":@"all",
                                 @"timeless":@"60"};
//#endif
    [manager GET:URL_Get_Search_Media_Info parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        fail(operation,error);
    }];
}
@end
