//
//  FileHandle.m
//  HLLMediaPlay
//
//  Created by admin on 15/11/26.
//  Copyright © 2015年 admin. All rights reserved.
//

#import "FileHandle.h"

#define Documents_Media_Cache_Path @"Documents/Private_Documents/Cache"

@implementation FileHandle



static FileHandle *_instance;
+ (id)allocWithZone:(NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}
+ (FileHandle *)sharedPlistHandle
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}
#pragma mark - get
// 获得视频缓存文件夹的地址
- (NSString *) getMediaCachePath{

    return [NSHomeDirectory() stringByAppendingPathComponent:Documents_Media_Cache_Path];
}
// 获得对应视频的url
- (NSURL *) getMediaUrlWithMediaName:(NSString *)fileName{
    
    NSURL * mediaUrl = [NSURL fileURLWithPath:[self getMediaPathWithFileName:fileName]];
    
    return mediaUrl;
}

// 获得对应视频的path
- (NSString *) getMediaPathWithFileName:(NSString *)fileName{
    
    NSString *cachePath = [self getMediaCachePath];
    NSString * mediaPath = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",fileName]];
    return mediaPath;
}

#pragma mark - delete
// 删除缓存视频文件夹
- (void) clearMediaCacheFolder{
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    
    NSString *cachePath = [self getMediaCachePath];
    
    [fileManager removeItemAtPath:cachePath error:nil];
}

// 删除本地缓存的视频
- (void) removeMediaCacheFileWithFileName:(NSString *)fileName{
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    
    NSString * mediaPath = [self getMediaPathWithFileName:fileName];
    
    [fileManager removeItemAtPath:mediaPath error:nil];
}

@end
