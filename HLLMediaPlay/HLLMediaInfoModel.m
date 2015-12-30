//
//  HLLMediaInfoModel.m
//  HLLMediaPlay
//
//  Created by admin on 15/11/25.
//  Copyright © 2015年 admin. All rights reserved.
//

#import "HLLMediaInfoModel.h"

@implementation HLLMediaInfoModel

- (NSDictionary *)propertyMapDic{

    return @{@"description":@"mediaDescription"};
}
- (NSString *)videoURL{

    return self.url;
}
@end
