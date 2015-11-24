//
//  HLLSearchMediaModel.m
//  HLLMediaPlay
//
//  Created by admin on 15/11/23.
//  Copyright © 2015年 admin. All rights reserved.
//

#import "HLLSearchMediaModel.h"
#define Youku_Tudou

@implementation HLLSearchMediaModel

+ (instancetype) mediaModelWithDictionary:(NSDictionary *)dict{

    return [[HLLSearchMediaModel alloc] initMediaModelWithDictionary:dict];
}
- (instancetype) initMediaModelWithDictionary:(NSDictionary *)dict{

    self = [super init];
    if (self) {
        
//#ifdef Youku_Tudou
//        _ID = dict[@"code"];
//        _title = dict[@"title"];
//        _thumbnail = dict[@"picUrl"];
//        _duration = dict[@"totalTime"];
//        _category = dict[@"mediaType"];
//        _user_name = dict[@"ownerNickname"]?dict[@"ownerNickname"]:dict[@"ownerName"];
//        _link = dict[@"outerPlayerUrl"];
//        
//#else
        _ID = dict[@"id"];
        _title = dict[@"title"]? dict[@"title"]:@"default";
        _duration = [self _changeFloatDurationToStringDuration:[dict[@"duration"] floatValue]];
        _thumbnail = dict[@"thumbnail"]?dict[@"thumbnail"]:@"http://r4.ykimg.com/054204085652ACE76A0A3F045E6E8412";
        NSDictionary * user = dict[@"user"]?dict[@"user"]:@"default";
        _user_name = [user[@"name"] copy];
        _category = dict[@"category"]?dict[@"category"]:@"nil";
        _tags = [self _tageWithTagString:dict[@"tags"]];
        _link = [dict[@"link"]copy];
        _published = [dict[@"published"] copy];
        _comment_count = [dict[@"comment_count"] integerValue];
        _view_couint = [dict[@"view_count"] integerValue];
        _favorite_count = [dict[@"favorite_count"] integerValue];
//#endif
        
    }
    return self;
}

- (NSArray *) _tageWithTagString:(NSString *)string{

    NSArray * tags = [string componentsSeparatedByString:@","];
    return tags;
}

- (NSString *) _changeFloatDurationToStringDuration:(float)duration{

    NSInteger time = (NSInteger)duration;
    
    NSInteger minute = time / 60;
    NSInteger second = time % 60;
    NSString * minuteString = minute ? [NSString stringWithFormat:@"%ld分钟",(long)minute]:@"";
    NSString * secondString = second ? [NSString stringWithFormat:@"%ld秒",(long)second]:@"";
    NSString * mediaTime = [NSString stringWithFormat:@"%@%@",minuteString,secondString];
    return mediaTime;
}
@end
