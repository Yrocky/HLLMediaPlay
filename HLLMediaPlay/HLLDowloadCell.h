//
//  HLLDowloadCell.h
//  HLLMediaPlay
//
//  Created by admin on 15/11/25.
//  Copyright © 2015年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLLClass.h"

@class HLLDowloadModel;

@interface HLLDowloadCell : UITableViewCell

+ (UINib *) nib;
+ (NSString *)identifier;

- (void) configureCellWithModel:(HLLDowloadModel *)model;

@end

@interface HLLDowloadModel : HLLClass

@property (nonatomic ,copy) NSString * ID;
@property (nonatomic ,copy) NSString * name;
@property (nonatomic ,copy) NSString * image;
@property (nonatomic ,copy) NSString * path;
@property (nonatomic ,copy) NSString * mediaDescription;

@end