//
//  HLLSearchMediaModel.h
//  HLLMediaPlay
//
//  Created by admin on 15/11/23.
//  Copyright © 2015年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HLLSearchMediaModel : NSObject

@property (nonatomic ,copy) NSString * ID;

@property (nonatomic ,copy) NSString * title;// 视频标题
@property (nonatomic ,copy) NSString * thumbnail;// 视频截图
@property (nonatomic ,strong) NSString * category;// 视频分类
@property (nonatomic ,strong) NSString * link;// 视频地址
@property (nonatomic ,assign) NSString * duration;// 视频时长
@property (nonatomic ,copy) NSString * user_name;// 上传作者

+ (instancetype) mediaModelWithDictionary:(NSDictionary *)dict;
- (instancetype) initMediaModelWithDictionary:(NSDictionary *)dict;
@end


/*
 {
     category = "\U4f53\U80b2";
     "comment_count" = 0;
     "down_count" = 0;
     duration = "16.00";
     "favorite_count" = 0;
     id = "XMTM5MzgxNjAwMA==";
     link = "http://v.youku.com/v_show/id_XMTM5MzgxNjAwMA==.html";
     "operation_limit" =             (
     );
     paid = 0;
     "public_type" = all;
     published = "2015-11-23 12:56:29";
     state = normal;
     streamtypes = (
         hd2,
         flvhd,
         hd,
         3gphd
     );
     tags = "\U7bee\U7403,\U8db3\U7403,NBA,\U77ed\U8dd1,\U7687\U9a6c,\U66fc\U8054,wwe,\U7530\U5f84,\U767e\U7c73,UFC";
     thumbnail = "http://r3.ykimg.com/0542040856529BFF6A0A472C1D0D68E0";
     "thumbnail_v2" = "http://r1.ykimg.com/0542040856529BFF6A0A472C1D0D68E0";
     title = "2015\U5e74\U4e3e\U91cd\U4e16\U9526\U8d5b\U8bad\U7ec3\U8425\Uff1a77\U516c\U65a4\U7ea7Rasoul Taghian\U540e\U8e72240\U516c\U65a42\U6b21";
     "up_count" = 0;
     user = {
     id = 76126269;
     link = "http://i.youku.com/u/UMzA0NTA1MDc2";
     name = fredhatfield;
     };
     "view_count" = 17;
 },
 */