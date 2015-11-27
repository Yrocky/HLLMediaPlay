//
//  FileHandle.h
//  HLLMediaPlay
//
//  Created by admin on 15/11/26.
//  Copyright © 2015年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileHandle : NSObject

#warning 本文件操作仅仅针对于Documents/Private_Documents/Cache下的文件
#warning 切记！！！
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


// 获取指定文件名的文件大小 - - 多少M
- (float) getFileSizeWithFileName:(NSString *)fileName;
// 获得cache文件夹的大小 - - 返回多少M
- (float) getFolderSizeWithAtCachePath;
// 获取指定文件名的创建时间，格式为yyyy-MM-dd hh:mm
- (NSString *) getFileCreationDateWithFileName:(NSString *)fileName;
@end
