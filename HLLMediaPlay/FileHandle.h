//
//  FileHandle.h
//  HLLMediaPlay
//
//  Created by admin on 15/11/26.
//  Copyright © 2015年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileHandle : NSObject

+ (FileHandle *)sharedPlistHandle;

// 获得视频缓存文件夹的地址
- (NSString *) getMediaCachePath;
// 获得对应视频的path
- (NSString *) getMediaPathWithFileName:(NSString *)fileName;
// 获得对应视频的url
- (NSURL *) getMediaUrlWithMediaName:(NSString *)fileName;

// 删除缓存视频的文件夹
- (void) clearMediaCacheFolder;
// 删除缓存视频
- (void) removeMediaCacheFileWithFileName:(NSString *)fileName;
@end
