//
//  HLLClass.h
//  HLLUserDemo
//
//  Created by apple on 15/8/25.
//  Copyright (c) 2015年 HLL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HLLClass : NSObject

+ (instancetype) itemWithDict:(NSDictionary *)dict;

- (instancetype) initWithDict:(NSDictionary *)dict;

/**
 *  为解决属性和字典的key不一样建立的映射
 *
 *  @return 映射字典
 */
-(NSDictionary *) propertyMapDic;
@end
