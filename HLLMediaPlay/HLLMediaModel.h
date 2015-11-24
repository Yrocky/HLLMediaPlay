//
//  HLLMediaModel.h
//  HLLMediaPlay
//
//  Created by Youngrocky on 15/11/24.
//  Copyright © 2015年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HLLMediaModel : NSObject

@property (nonatomic ,copy) NSString * url;
@property (nonatomic ,copy) NSString * name;
@property (nonatomic ,copy) NSString * image;
@property (nonatomic ,copy) NSString * duration;

@end
/*
 "url" : "http:\/\/7xawdc.com2.z0.glb.qiniucdn.com\/o_19p6vdmi9148s16fs1ptehbm1vd59.mp4",
 "name" : "01",
 "image" : "http:\/\/photo.candou.com\/i\/114\/85501cb8b5bef97379498c6f780edb86",
 "duration" : "06:43"
 */