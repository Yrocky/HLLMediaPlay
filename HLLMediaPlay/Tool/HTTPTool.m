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

+ (void)requestJXVDYMediaInfoWithID:(NSString *)ID successedBlock:(SuccessBlock)success andFialedBlock:(FailBlock)fail{

    AFHTTPRequestOperationManager *manager = [HTTPTool initAFHttpManager];
    
    NSDictionary *parameters = @{@"id":ID,
                                 @"token":JXVDYToken};
    
    [manager GET:URL_Get_JXVDY_Media_Info parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        fail(operation,error);
    }];

}
+ (void) requestJXVDYMediaSourceWithKeyword:(NSString *)keyWord offset:(NSString *)offset successedBlock:(SuccessBlock)success andFialedBlock:(FailBlock)fail{

    AFHTTPRequestOperationManager *manager = [HTTPTool initAFHttpManager];
    
    NSDictionary *parameters = @{@"keyword":keyWord,
                                 @"count":@"10",
                                 @"offset":offset,
                                 @"model":@"video",
                                 @"token":JXVDYToken};

    [manager GET:URL_Get_Search_JXVDY_Media_Info parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        fail(operation,error);
    }];
}

+ (void) requestSearchMediaInfoWithKeyWord:(NSString *)keyWord successedBlock:(SuccessBlock)success andFailedBlock:(FailBlock)fail{

    AFHTTPRequestOperationManager *manager = [HTTPTool initAFHttpManager];

    NSDictionary *parameters = @{@"keyword":keyWord,
                                 @"client_id":Youku_Client_id,
                                 @"period":@"month",
                                 @"orderby":@"published",
                                 @"paid":@"0",
                                 @"public_type":@"all",
                                 @"timeless":@"60"};
    
    [manager GET:URL_Get_Search_Media_Info parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        fail(operation,error);
    }];
}

// ttp://v.apix.cn/apixcredit/bankcardauth/bankcardauth
+ (void) requestBankCode:(NSString *)bankCode name:(NSString *)name bankcardno:(NSString *)bankcardno successedBlock:(SuccessBlock)success andFailedBlock:(FailBlock)fail{
    
    AFHTTPRequestOperationManager *manager = [HTTPTool initAFHttpManager];
    
    NSDictionary *parameters = @{@"apikey":@"8a0f0d6d9236a7135477e1fc2e744ef3",
                                 @"cardnum":bankcardno};
    
    [manager GET:@"http://apis.baidu.com/datatiny/cardinfo/cardinfo" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        fail(operation,error);
    }];
}
@end
