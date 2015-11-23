//
//  HLLSearchMediaModel.m
//  HLLMediaPlay
//
//  Created by admin on 15/11/23.
//  Copyright © 2015年 admin. All rights reserved.
//

#import "HLLSearchMediaModel.h"

@implementation HLLSearchMediaModel

+ (instancetype) mediaModelWithDictionary:(NSDictionary *)dict{

    return [[HLLSearchMediaModel alloc] initMediaModelWithDictionary:dict];
}
- (instancetype) initMediaModelWithDictionary:(NSDictionary *)dict{

    self = [super init];
    if (self) {
        _ID = dict[@"id"];
        _title = dict[@"title"]? dict[@"title"]:@"default";
        _duration = [self changeFloatDurationToStringDuration:[dict[@"duration"] floatValue]];
        _thumbnail = dict[@"thumbnail"]?dict[@"thumbnail"]:@"http://r4.ykimg.com/054204085652ACE76A0A3F045E6E8412";
        NSDictionary * user = dict[@"user"]?dict[@"user"]:@"default";
        _user_name = user[@"name"];
        _category = dict[@"category"]?dict[@"category"]:@"nil";
        
    }
    return self;
}

- (NSString *) changeFloatDurationToStringDuration:(float)duration{

    return nil;
}
@end
