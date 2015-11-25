//
//  HLLMediaModel.m
//  HLLMediaPlay
//
//  Created by Youngrocky on 15/11/24.
//  Copyright © 2015年 admin. All rights reserved.
//

#import "HLLMediaModel.h"

@implementation HLLMediaModel

-(NSDictionary *) propertyMapDic{
 
    NSDictionary * dict = @{@"id":@"ID",
                            @"description":@"mediaDescription"};
    return dict;
}
@end
