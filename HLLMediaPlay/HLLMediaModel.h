//
//  HLLMediaModel.h
//  HLLMediaPlay
//
//  Created by Youngrocky on 15/11/24.
//  Copyright © 2015年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HLLClass.h"

@interface HLLMediaModel : HLLClass

@property (nonatomic ,copy) NSString * ID;
@property (nonatomic ,copy) NSString * img;
@property (nonatomic ,copy) NSString * score;
@property (nonatomic ,assign) NSTimeInterval time;
@property (nonatomic ,copy) NSString * title;
@property (nonatomic ,copy) NSString * mediaDescription;


@end
/*

 description = "\U300a\U6211\U53ef\U80fd\U4e0d\U4f1a\U7231\U4f60\U300b\U756a\U5916";
 id = 33106;
 img = "http://image.jxvdy.com/2015/1122/56519440cee1ff3ccdd27_0.jpg";
 score = "8.0";
 time = 1448187074;
 title = "\U4ece\U5fc3\U53d1\U73b0\U7231";
 */