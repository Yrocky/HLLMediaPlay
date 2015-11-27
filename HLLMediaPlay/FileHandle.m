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

#pragma mark - fileAttribute
// 返回指定文件名的文件信息
- (NSDictionary *) getFileAttributesWithFileName:(NSString *)fileName{

    NSString * mediaPath = [self getMediaPathWithFileName:fileName];
    NSFileManager * filemanager = [NSFileManager defaultManager];
    
    if ([filemanager fileExistsAtPath:mediaPath]) {
        return [filemanager attributesOfItemAtPath:mediaPath error:nil];
    }
    return nil;
}
// 获取指定文件名的文件大小 - - 多少M
- (float) getFileSizeWithFileName:(NSString *)fileName{

    NSDictionary * fileAttribute = [self getFileAttributesWithFileName:fileName];

    if (fileAttribute) {
        long long fileSize = [fileAttribute fileSize];
        return fileSize /(1024.0 * 1024.0);
    }
    return 0.0;
}

// 获得cache文件夹的大小 - - 返回多少M
- (float) getFolderSizeWithAtCachePath{
    
    NSFileManager* filemanager = [NSFileManager defaultManager];
    
    NSString * folderPath = [self getMediaCachePath];
    if (![filemanager fileExistsAtPath:folderPath]) {
        return 0;
    }
    
    NSEnumerator *childFilesEnumerator = [[filemanager subpathsAtPath:folderPath] objectEnumerator];
    
    NSString* fileName;
    long long folderSize = 0;
    
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        
        folderSize += [self getFileSizeWithFileName:fileName];
    }
    return folderSize/(1024.0*1024.0);
}
// 获取指定文件名的创建时间，格式为yyyy-MM-dd hh:mm
- (NSString *) getFileCreationDateWithFileName:(NSString *)fileName{
    
    NSDictionary * fileAttribute = [self getFileAttributesWithFileName:fileName];
    
    if (fileAttribute) {
        NSDate * creatioinDate = [fileAttribute fileCreationDate];
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        return [dateFormatter stringFromDate:creatioinDate];
    }
    return @"";
}

@end
