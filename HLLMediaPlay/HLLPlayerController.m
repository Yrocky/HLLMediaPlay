//
//  HLLPlayerController.m
//  HLLMediaPlay
//
//  Created by admin on 15/11/26.
//  Copyright © 2015年 admin. All rights reserved.
//

#import "HLLPlayerController.h"

#import "UINavigationController+FDFullscreenPopGesture.h"
#import "FullViewController.h"
#import "FMGVideoPlayView.h"
#import <Masonry/Masonry.h>
#import "HTTPTool.h"
#import "HLLMediaInfoModel.h"

#define screen_width [UIScreen mainScreen].bounds.size.width
#define screen_height [UIScreen mainScreen].bounds.size.height

@interface HLLPlayerController ()<FMGVideoPlayViewDelegate>

@property (nonatomic ,strong) HLLMediaInfoModel * mediaInfoModel;

@property (nonatomic ,strong) FMGVideoPlayView * playView;
@property (nonatomic ,strong) UIActivityIndicatorView * activity;

@property (nonatomic ,strong) UILabel * titleLabel;
@property (nonatomic ,strong) UILabel * yearLabel;
@property (nonatomic ,strong) UILabel * scoreLabel;
@property (nonatomic ,strong) UILabel * descriptionLabel;

@end

@implementation HLLPlayerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatActivityIndicatorView];
    
    [self playerMediaUseCustomViewWithMediaID:[NSString stringWithFormat:@"%@",self.mediaID]];
}
- (void) creatActivityIndicatorView{
    
    _activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:_activity];
    [_activity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
    }];
    [_activity startAnimating];
}
- (void) playerMediaUseCustomViewWithMediaID:(NSString *)ID{
    
    [HTTPTool requestJXVDYMediaInfoWithID:ID successedBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"media info result:%@",responseObject);
        _mediaInfoModel = [[HLLMediaInfoModel alloc] initWithDict:responseObject];
        
        NSString * mediaUrl;
        
        NSString * highP = responseObject[@"playurl"][@"720P"];
        NSString * middleP = responseObject[@"playurl"][@"480P"];
        NSString * lowP = responseObject[@"playurl"][@"360P"];
        mediaUrl = highP ? highP:(middleP?middleP:lowP);
        
        [self setupVideoPlayViewWithMediaUrl:mediaUrl];
        [self creatMediaInfo];

        [self setupMediaInfoWithMeidaInfoModel:_mediaInfoModel];
        
        [_activity stopAnimating];
    } andFialedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_activity stopAnimating];        
        NSLog(@"fail:%@",error.localizedDescription);
    }];
}

- (void) setupMediaInfoWithMeidaInfoModel:(HLLMediaInfoModel *)mediaIndoModel{

    self.titleLabel.text = mediaIndoModel.title;
    self.yearLabel.text = mediaIndoModel.year;
    self.scoreLabel.text = mediaIndoModel.score;
    self.descriptionLabel.text = mediaIndoModel.mediaDescription;
}
- (void)setupVideoPlayViewWithMediaUrl:(NSString *)mediaUrl{
    
    _playView=[FMGVideoPlayView videoPlayView];
    self.playView.delegate=self;
    // 视频资源路径
    [self.playView setUrlString:mediaUrl];
    // 播放器显示位置（竖屏时）
    // 添加到当前控制器的view上
    [self.view addSubview:self.playView];
    [self.playView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(200);
        make.right.mas_equalTo(0);
    }];
    // 指定一个作为播放的控制器
    self.playView.contrainerViewController = self;
    
    
}

- (void) creatMediaInfo{
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.font = [UIFont systemFontOfSize:17];
    _titleLabel.numberOfLines = 0;
    [self.view addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(_playView.mas_bottom).offset(20);
        make.width.mas_greaterThanOrEqualTo(2);
        make.width.mas_lessThanOrEqualTo(100);
        make.height.mas_greaterThanOrEqualTo(2);
    }];
    
    _scoreLabel = [[UILabel alloc] init];
    _scoreLabel.font = [UIFont systemFontOfSize:40];
    _scoreLabel.textAlignment = NSTextAlignmentCenter;
    _scoreLabel.backgroundColor = [UIColor clearColor];
    _scoreLabel.textColor = [UIColor colorWithRed:54.0/255.0 green:150.0/255.0 blue:160.0/255.0 alpha:1];
    [self.view addSubview:_scoreLabel];
    [_scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).offset(-20);
        make.top.mas_equalTo(_playView.mas_bottom).offset(20);
        make.width.mas_greaterThanOrEqualTo(4);
//        make.height.mas_greaterThanOrEqualTo(4);
    }];
    
    _yearLabel = [[UILabel alloc] init];
    _yearLabel.backgroundColor = [UIColor clearColor];
    _yearLabel.textAlignment = NSTextAlignmentLeft;
    _yearLabel.font = [UIFont systemFontOfSize:12];
    _yearLabel.textColor = [UIColor lightGrayColor];
    [self.view addSubview:_yearLabel];
    [_yearLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_titleLabel.mas_right).offset(10);
        make.height.mas_equalTo(20);
        make.right.mas_greaterThanOrEqualTo(_scoreLabel.mas_left).offset(-10);
        make.bottom.mas_equalTo(_titleLabel.mas_bottom);
    }];
    
    NSArray * types = self.mediaInfoModel.type;
    if (types.count) {
        
        for (NSInteger index = 0; index < types.count; index ++) {
            NSString * type = types[index];
            [self addLabelWithType:type atIndex:index];
        }
    }
    
    _descriptionLabel = [[UILabel alloc] init];
    _descriptionLabel.backgroundColor = [UIColor clearColor];
    _descriptionLabel.textColor = _scoreLabel.textColor;
    _descriptionLabel.font = [UIFont systemFontOfSize:14];
    _descriptionLabel.numberOfLines = 0;
    [self.view addSubview:_descriptionLabel];
    [_descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(20);
        make.right.mas_equalTo(self.view.mas_right).offset(-20);
        make.top.mas_equalTo(_scoreLabel.mas_bottom).offset(30);
        make.height.mas_greaterThanOrEqualTo(2);
        make.bottom.mas_greaterThanOrEqualTo(-20);
        
    }];
}


- (void) addLabelWithType:(NSString *)type atIndex:(NSInteger)index{
    
    UILabel * label = [[UILabel alloc] init];
    label.text = type;
    label.tag = index + 100;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14];
    label.backgroundColor = self.scoreLabel.textColor;
    label.textColor = [UIColor whiteColor];
    label.layer.cornerRadius = 3.0f;
    label.clipsToBounds = YES;
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_greaterThanOrEqualTo(2);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(10);
        make.height.mas_greaterThanOrEqualTo(2);
        if (label.tag == 100) {
            make.left.mas_equalTo(30);
        }else{
            UILabel * forentLabel = [self.view viewWithTag:index + 99];
            make.left.mas_equalTo(forentLabel.mas_right).offset(10);
        }
        
    }];
}

-(void)backAction
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
-(void)shareAction
{
    
}


-(NSString *)GetNowTimes
{
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[date timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.0f",a];
    return timeString;
}




@end
