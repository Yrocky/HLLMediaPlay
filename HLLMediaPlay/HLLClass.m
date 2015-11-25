//
//  HLLClass.m
//  HLLUserDemo
//
//  Created by apple on 15/8/25.
//  Copyright (c) 2015年 HLL. All rights reserved.
//

#import "HLLClass.h"
#import <objc/runtime.h>


@implementation HLLClass
/**
 * 这样写有一个限制就是属性必须和字典中的键一样，这样的话还不如使用KVC
 */
- (instancetype) initWithDict:(NSDictionary *)dict{
    
    self = [super init];
    if (self) {

        [self runtimeAssginToPropertyWithDictionary:dict];
    }
    return self;
}
+ (instancetype) itemWithDict:(NSDictionary *)dict{
    
    return [[self alloc] initWithDict:dict];
}

#pragma mark - 返回属性和字典key的映射关系

-(NSDictionary *) propertyMapDic{
    
    return nil;
}

- (void) runtimeAssginToPropertyWithDictionary:(NSDictionary *)dict{
    
    if (dict == nil) {
        return;
    }
    
    // 字典key数组
    NSMutableArray * allKeys = [NSMutableArray arrayWithArray:dict.allKeys];
    
    unsigned int outCount;
    // 属性数组
    objc_property_t * propertys = class_copyPropertyList(self.class, &outCount);
    
    NSMutableDictionary * newDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    
    for (int index = 0; index < outCount; index ++) {
        // 某一个属性
        objc_property_t property = propertys[index];
        // 属性名
        NSString * propertyKey = [NSString stringWithUTF8String:property_getName(property)];
        
        // 如果有属性和key不一样并且子类进行了映射，就进行字典的修改
        [self dictionaryMapPropertyWithAllKeys:allKeys toNewDictionary:newDict];
        
        if ([allKeys containsObject:propertyKey]) {
            // kvc
            id propertyValue = [newDict objectForKey:propertyKey];
            [self setValue:propertyValue forKey:propertyKey];
        }
    }
    free(propertys);
}

/**
 *  如果子类中有属性和key不对应，就进行传进来的字典和修改
 *
 *  @param allKeys 原字典的allKeys
 *  @param newDict 原字典，也是要通过映射之后修改的字典
 */
- (void) dictionaryMapPropertyWithAllKeys:(NSMutableArray *)allKeys toNewDictionary:(NSMutableDictionary *)newDict{
    
    NSDictionary * mapDictionary = [self propertyMapDic];
    
    if (mapDictionary) {

        [mapDictionary enumerateKeysAndObjectsUsingBlock:^(NSString * mapKey, NSString * mapProperty, BOOL *stop) {
            if ([allKeys containsObject:mapKey]) {

                [newDict setValue:[newDict objectForKey:mapKey] forKey:mapProperty];
                [newDict removeObjectForKey:mapKey];
                
                NSUInteger mapIndex = [allKeys indexOfObject:mapKey];
                [allKeys replaceObjectAtIndex:mapIndex withObject:mapProperty];
            }
        }];
    }
    
}
@end
