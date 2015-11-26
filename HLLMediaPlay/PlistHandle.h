//
//  PlistHandle.h
//  zhaozhao
//
//  Created by apple on 15/1/21.
//
// 这里的plist操作仅仅是对一个数组包含字典的结构进行的

#import <Foundation/Foundation.h>

@interface PlistHandle : NSObject

+ (PlistHandle *)sharedPlistHandle;

#pragma mark - plist handle
// write
-(void)writerDataWithPlistName:(NSString *)plistName ID:(NSString *)ID withDict:(NSDictionary *)dict;
// get
- (id)getDataWithPlistName:(NSString *)name;
- (id) getDataFromPlistWithName:(NSString *)plistName andID:(NSString *)ID;
// remove
- (BOOL) removeDataWithPlistName:(NSString *)plistName withDataID:(NSString *)ID;
// clear
- (BOOL) clearDataWithPlistName:(NSString *)plistName;
// check
- (BOOL) existMediaFromPlist:(NSString *)plistName WithID:(NSString *)ID;
@end
