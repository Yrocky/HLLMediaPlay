//
//  HLLSearchCell.h
//  HLLMediaPlay
//
//  Created by admin on 15/11/23.
//  Copyright © 2015年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HLLSearchMediaModel;
@interface HLLSearchCell : UITableViewCell

- (void) configureCellWithModel:(HLLSearchMediaModel *)model;
@end
