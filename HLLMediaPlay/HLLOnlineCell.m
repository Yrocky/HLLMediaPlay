//
//  HLLOnlineCell.m
//  HLLMediaPlay
//
//  Created by Youngrocky on 15/11/24.
//  Copyright © 2015年 admin. All rights reserved.
//

#import "HLLOnlineCell.h"
#import "HLLMediaModel.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface HLLOnlineCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *snipImageView;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end

@implementation HLLOnlineCell


- (void) configureCellWithMediaModel:(HLLMediaModel *)model{

    self.nameLabel.text = model.title;
    self.descriptionLabel.text = model.mediaDescription;
    
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:model.time];
    self.timeLabel.text = date.description;
    NSURL * url = [NSURL URLWithString:model.img];
    [self.snipImageView sd_setImageWithURL:url
                            placeholderImage:[UIImage imageNamed:@"load"]];
    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
