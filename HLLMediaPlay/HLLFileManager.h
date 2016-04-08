//
//  HLLFileManager.h
//  HLLMediaPlay
//
//  Created by admin on 16/2/22.
//  Copyright © 2016年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CompletionDownloadHandle)(void);

@interface HLLFileManager : NSObject

+ (HLLFileManager *)sharedFileManager;

// 获得File文件夹的地址
//Documents/File
- (NSString *) getFilePath;

@end;

@interface HLLFileManager (Media)


//Documents/File/Video/'fileName'
- (NSString *) getMediaPathWithFileName:(NSString *)fileName;

- (NSURL *) getMediaUrlWithFileName:(NSString *)fileName;

// 删除缓存视频的文件夹->Documents/File/Video
- (void) clearMediaCacheFolder;
// 删除缓存视频->Documents/File/Video/'fileName'
- (void) removeMediaCacheFileWithFileName:(NSString *)fileName;

@end;

@interface HLLFileManager (Image)


//Documents/File/Image/'fileName'
- (NSString *) getImagePathWithFileName:(NSString *)fileName;

- (NSURL *) getImageUrlWithFileName:(NSString *)fileName;


- (void) downloadImage:(NSURL *)imageURL;

// 删除缓存图片的文件夹->Documents/File/Image
- (void) clearImageCacheFolder;
// 删除缓存图片->Documents/File/Image/'fileName'
- (void) removeImageCacheFileWithFileName:(NSString *)fileName;

@end

@interface HLLImageDownload : NSObject

@property (nonatomic ,strong) NSURL * imageURL;

@property (nonatomic ,strong) NSString * filePath;
@property (nonatomic ,strong) NSURL * fileURL;

@property (nonatomic ,strong) NSString * fileName;

@property (nonatomic ,copy) CompletionDownloadHandle completionHandle;

- (void) startDownloadImage;
- (void) cancelDownloadImage;
@end