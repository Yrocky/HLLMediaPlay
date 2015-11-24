//
//  HLLOnlineCell.h
//  HLLMediaPlay
//
//  Created by Youngrocky on 15/11/24.
//  Copyright © 2015年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>


@class HLLMediaModel;
@interface HLLOnlineCell : UITableViewCell

- (void) configureCellWithMediaModel:(HLLMediaModel *)model;
@end
