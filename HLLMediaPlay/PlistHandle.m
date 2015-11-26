//
//  PlistHandle.m
//  zhaozhao
//
//  Created by apple on 15/1/21.
//
//

#import "PlistHandle.h"

@implementation PlistHandle

static PlistHandle *_instance;
+ (id)allocWithZone:(NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}
+ (PlistHandle *)sharedPlistHandle
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (NSString *) _plistPathWithPlistName:(NSString *)name{
    
    NSArray * path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * filePath = [path objectAtIndex:0];
    NSString * pName = [NSString stringWithFormat:@"%@.plist",name];
    NSString * plistPath = [filePath stringByAppendingPathComponent:pName];
    
    return plistPath;
    
}
#pragma makr - write
// 持久化保存

-(void)writerDataWithPlistName:(NSString *)plistName ID:(NSString *)ID withDict:(NSDictionary *)dict{
    
    NSFileManager * fm = [NSFileManager defaultManager];
    NSString * plistPath = [self _plistPathWithPlistName:plistName];
    
    NSMutableArray * dicdata;
    if ([[NSFileManager defaultManager] fileExistsAtPath:plistPath])
    {
        dicdata = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
    }
    else
    {
        [fm createFileAtPath:plistPath contents:nil attributes:nil];
        dicdata = [[NSMutableArray alloc] init];
    }
    
    [dicdata addObject:dict];
    [dicdata writeToFile:plistPath atomically:YES];
}

#pragma mark - get
- (id)getDataWithPlistName:(NSString *)name{
    
    NSArray * plistData = [NSArray arrayWithContentsOfFile:[self _plistPathWithPlistName:name]];
    
    return plistData;
}
- (BOOL) existMediaFromPlist:(NSString *)plistName WithID:(NSString *)ID{

    NSArray * plistData = [self getDataWithPlistName:plistName];
    for (NSDictionary * media in plistData) {
        if ([[NSString stringWithFormat:@"%@",ID] isEqualToString:[NSString stringWithFormat:@"%@",[media objectForKey:@"ID"]]]) {
            return YES;
        }
    }
    return NO;
}
- (id) getDataFromPlistWithName:(NSString *)plistName andID:(NSString *)ID{
    
    NSArray * plistData = [self getDataWithPlistName:plistName];
//    NSDictionary * data = [plistData valueForKey:ID];
    
    return nil;
    
}
#pragma mark - remove
- (BOOL) removeDataWithPlistName:(NSString *)plistName withDataID:(NSString *)ID{

    BOOL status = NO;
    
    NSMutableArray * plistData = [NSMutableArray arrayWithContentsOfFile:[self _plistPathWithPlistName:plistName]];
    for (NSDictionary * dict in plistData) {
        if ([[NSString stringWithFormat:@"%@",dict[@"ID"]] isEqualToString:ID]) {
            [plistData removeObject:dict];
            status = YES;
            break;
        }
    }
    [plistData writeToFile:[self _plistPathWithPlistName:plistName] atomically:YES];
    if ([[NSFileManager defaultManager] isExecutableFileAtPath:[self _plistPathWithPlistName:plistName]]) {
        
    }
    return status;
}
#pragma mark - clear
- (BOOL) clearDataWithPlistName:(NSString *)plistName{

    NSFileManager * fileManager = [NSFileManager defaultManager];
    return [fileManager removeItemAtPath:[self _plistPathWithPlistName:plistName] error:nil];
}

@end
