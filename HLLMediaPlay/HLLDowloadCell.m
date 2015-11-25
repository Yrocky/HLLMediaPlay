//
//  HLLDowloadCell.m
//  HLLMediaPlay
//
//  Created by admin on 15/11/25.
//  Copyright © 2015年 admin. All rights reserved.
//

#import "HLLDowloadCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface HLLDowloadCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *mediaImageView;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end

@implementation HLLDowloadCell

+ (UINib *)nib{

    return [UINib nibWithNibName:@"HLLDowloadCell" bundle:nil];
}

+ (NSString *)identifier{

    return @"dowload";
}

- (void) configureCellWithModel:(HLLDowloadModel *)model{

    
    self.nameLabel.text = model.name;
    self.descriptionLabel.text = model.mediaDescription;
    NSURL * url = [NSURL URLWithString:model.image];
    [self.mediaImageView sd_setImageWithURL:url
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

@implementation HLLDowloadModel

- (NSDictionary *)propertyMapDic{

    return @{@"description":@"mediaDescription"};
}
@end