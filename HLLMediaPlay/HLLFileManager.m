//
//  HLLFileManager.m
//  HLLMediaPlay
//
//  Created by admin on 16/2/22.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "HLLFileManager.h"
#import <UIKit/UIKit.h>

@interface HLLFileManager ()


@end
@implementation HLLFileManager


static HLLFileManager *_instance;
+ (id)allocWithZone:(NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}
+ (HLLFileManager *)sharedFileManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (NSString *) getFilePath{
    
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/File"];
}

- (void) clearFolderWithPath:(NSString *)path{

    NSFileManager *fileManager=[NSFileManager defaultManager];
    
    NSError * error;
    if (![fileManager removeItemAtPath:path error:&error]) {
        NSLog(@"Fail to remove .Error infromation:%@",[error localizedDescription]);
    }
}

- (void) removeFileWithFilePath:(NSString *)filePath{

    NSFileManager *fileManager=[NSFileManager defaultManager];
    
    NSError * error;
    
    if(![fileManager removeItemAtPath:filePath error:nil]){
        NSLog(@"Fail to remove .Error infromation:%@",[error localizedDescription]);
    };
}
@end;

@implementation HLLFileManager (Media)

- (NSString *) getMediaPath{

    NSString * mediaPath = [NSString stringWithFormat:@"%@/Media",[self getFilePath]];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:mediaPath]) {
        
        [[NSFileManager defaultManager] createDirectoryAtPath:mediaPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return mediaPath;
}

- (NSURL *) getMediaUrlWithFileName:(NSString *)fileName{
    
    NSURL * mediaUrl = [NSURL fileURLWithPath:[self getMediaPathWithFileName:fileName]];
    
    return mediaUrl;
}

- (NSString *) getMediaPathWithFileName:(NSString *)fileName{
    
    NSString *cachePath = [self getMediaPath];
    NSString * mediaPath = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",fileName]];

    return mediaPath;
}

- (void)clearMediaCacheFolder{

    NSString *mediaPath = [self getMediaPath];
    
    [self clearFolderWithPath:mediaPath];
}

- (void)removeMediaCacheFileWithFileName:(NSString *)fileName{
    
    NSString * mediaPath = [self getMediaPathWithFileName:fileName];
    
    [self removeFileWithFilePath:mediaPath];
}
@end

@implementation HLLFileManager (Image)


- (NSString *) getImagePath{
 
    NSString * imagePath = [NSString stringWithFormat:@"%@/Image",[self getFilePath]];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:imagePath]) {
        
        [[NSFileManager defaultManager] createDirectoryAtPath:imagePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return imagePath;
}

- (NSString *) getImagePathWithFileName:(NSString *)fileName{
 
    NSString * imagePath = [[self getImagePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.PNG",fileName]];
 
    return imagePath;
}

- (NSURL *) getImageUrlWithFileName:(NSString *)fileName{

    NSURL * imageURL = [NSURL URLWithString:[self getImagePathWithFileName:fileName]];
    return imageURL;
}

- (void) downloadImage:(NSURL *)imageURL{

//    HLLImageDownload * imageDownload = [[HLLImageDownload alloc] init];
//    imageDownload.fileURL = imageURL;
//    imageDownload.completionHandle = ^(){
//    
//        
//    };
//    [imageDownload startDownloadImage];
}

- (void) clearImageCacheFolder{
    
    NSString * imagePath = [self getImagePath];
    
    [self clearFolderWithPath:imagePath];
}

- (void) removeImageCacheFileWithFileName:(NSString *)fileName{
    
    NSString * imagePath = [self getImagePathWithFileName:fileName];
    
    [self removeFileWithFilePath:imagePath];
}

@end


@interface HLLImageDownload ()

@property (nonatomic ,strong) NSURLSessionDownloadTask * downloadTask;

@property (nonatomic ,strong) NSData * _Nullable resumeData;

@end
@implementation HLLImageDownload

-(void)startDownloadImage{

    if (self.resumeData != nil) {
        
        _downloadTask = [[NSURLSession sharedSession] downloadTaskWithResumeData:self.resumeData completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            [self downloadImageCompletionHandleWithLocatioin:location reponse:response error:error];
        }];
    }else{
        _downloadTask = [[NSURLSession sharedSession] downloadTaskWithURL:self.imageURL completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            NSLog(@"location:%@",location);
            if (location && (error == nil)) {

                [self downloadImageCompletionHandleWithLocatioin:location reponse:response error:error];
            }
        }];
    }
    
    [_downloadTask resume];
}

- (void) downloadImageCompletionHandleWithLocatioin:(NSURL * _Nullable) location reponse:(NSURLResponse * _Nullable)response error:(NSError * _Nullable )error{
    
    
    if (error) {
        if ([error code] == NSURLErrorAppTransportSecurityRequiresSecureConnection) {
            abort();
        }
    }
    
    NSFileManager * fileManager = [NSFileManager defaultManager];
    
    NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    
    NSString * suggestedFilename = [caches stringByAppendingPathComponent:response.suggestedFilename];
   
    if (self.filePath) {
        suggestedFilename = self.filePath;
    }
    
    if ([fileManager moveItemAtPath:location.path toPath:suggestedFilename error:nil]){
        
        NSLog(@"Move Image from %@ to %@ fail.Error inforation:%@",location.path,suggestedFilename,[error localizedDescription]);
    }
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        if (self.completionHandle) {
            self.completionHandle();
        }
    }];
}
- (void)cancelDownloadImage{

    if (self.downloadTask.state != NSURLSessionTaskStateCanceling) {
        
        typeof(self) weakSelf = self;
        [_downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
            
            weakSelf.resumeData = resumeData;
            _downloadTask = nil;
        }];
    }
}
@end