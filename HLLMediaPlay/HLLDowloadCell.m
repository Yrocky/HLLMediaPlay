//
//  HLLDowloadCell.m
//  HLLMediaPlay
//
//  Created by admin on 15/11/25.
//  Copyright © 2015年 admin. All rights reserved.
//

#import "HLLDowloadCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "FileHandle.h"

@interface HLLDowloadCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *mediaImageView;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;

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
    
    self.timeLabel.text = [[FileHandle sharedPlistHandle] getFileCreationDateWithFileName:model.name];
    float size = [[FileHandle sharedPlistHandle] getFileSizeWithFileName:model.name];
    self.sizeLabel.text = [NSString stringWithFormat:@"%.1f M",size];
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