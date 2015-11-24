//
//  HLLSearchCell.m
//  HLLMediaPlay
//
//  Created by admin on 15/11/23.
//  Copyright © 2015年 admin. All rights reserved.
//

#import "HLLSearchCell.h"
#import "HLLSearchMediaModel.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface HLLSearchCell ()
@property (weak, nonatomic) IBOutlet UIImageView *searchImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;

@property(nonatomic ,strong) UIColor * categoryColor;

@end
@implementation HLLSearchCell

- (void) configureCellWithModel:(HLLSearchMediaModel *)model{

    self.titleLabel.text = model.title;
    self.userNameLabel.text = model.user_name;
    self.timeLabel.text = [NSString stringWithFormat:@"%@",model.duration];
    self.categoryLabel.text = model.category;
    NSURL * url = [NSURL URLWithString:model.thumbnail];
    
    [self.searchImageView sd_setImageWithURL:url
                      placeholderImage:[UIImage imageNamed:@"load"]];
}
- (void)awakeFromNib {
    _categoryColor = self.categoryLabel.backgroundColor;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [super touchesBegan:touches withEvent:event];
    self.categoryLabel.backgroundColor = self.categoryColor;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
