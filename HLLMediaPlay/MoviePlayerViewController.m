//
//  MoviePlayerViewController.m
//  Player
//
//  Created by dllo on 15/11/7.
//  Copyright © 2015年 zhaoqingwen. All rights reserved.
//

#import "MoviePlayerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "Masonry.h"
#import "HTTPTool.h"
#import "HLLMediaInfoModel.h"


@interface MoviePlayerViewController ()

@property(nonatomic,strong)AVPlayer *player; // 播放属性
@property(nonatomic,strong)AVPlayerItem *playerItem; // 播放属性
@property(nonatomic,assign)CGFloat width; // 坐标
@property(nonatomic,assign)CGFloat height; // 坐标
@property(nonatomic,strong)UISlider *slider; // 进度条
@property(nonatomic,strong)UILabel *currentTimeLabel; // 当前播放时间
@property(nonatomic,strong)UILabel *systemTimeLabel; // 系统时间
@property(nonatomic,strong)UIView *backView; // 上面一层Viewd
@property(nonatomic,assign)CGPoint startPoint;
@property(nonatomic,assign)CGFloat systemVolume;
@property(nonatomic,strong)UISlider *volumeViewSlider;
@property(nonatomic,strong)UIActivityIndicatorView *activity; // 系统菊花
@property(nonatomic,strong)UIProgressView *progress; // 缓冲条
@property(nonatomic,strong)UIButton *backButton;
@property(nonatomic,strong)UIButton *fullScreenButton;
@property(nonatomic,strong)UIView *topView;
@property(nonatomic,strong)UIView *bottomView;
@property (nonatomic ,strong) UILabel * titleLabel;
@end

@implementation MoviePlayerViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:_player.currentItem];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"播放";
    
    
    _width = [[UIScreen mainScreen]bounds].size.height;
    _height = [[UIScreen mainScreen]bounds].size.width;
    
    self.backView = [[UIView alloc]init];
    [self.view addSubview:_backView];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(@0);
        make.right.equalTo(@0);
        make.height.equalTo(@200);
    }];
    _backView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor blackColor];
    [self creatTopView];
    
    [self creatBottomView];
    
    [self createGesture];
    
    [self customVideoSlider];
    
    [self creatActivityIndicatorView];
    
//    //延迟线程
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [UIView animateWithDuration:0.5 animations:^{
            
            _backView.alpha = 0;
        }];
        
    });
    
    //计时器
    [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(Stack) userInfo:nil repeats:YES];
//    self.modalPresentationCapturesStatusBarAppearance = YES;
    
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    // 创建AVPlayer
    NSString * playurl;
    NSString * highP = self.mediaInfo.playurl[@"720P"];
    NSString * middleP = self.mediaInfo.playurl[@"480P"];
    NSString * lowP = self.mediaInfo.playurl[@"360P"];
    playurl = highP ? highP:(middleP?middleP:lowP);
    self.playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:playurl]];
    self.player = [AVPlayer playerWithPlayerItem:_playerItem];
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    playerLayer.frame = CGRectMake(0, 0, _height, 200);
    playerLayer.videoGravity = AVLayerVideoGravityResize;
    [self.view.layer insertSublayer:playerLayer atIndex:0];
    
    [_player play];
    //AVPlayer播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:_player.currentItem];
    
    self.titleLabel.text = self.mediaInfo.title;
}


#pragma mark - 顶部视图
- (void)creatTopView
{
    _topView = [[UIView alloc]init];
    _topView.backgroundColor = [UIColor blackColor];
    _topView.alpha = 0.5;
    [_backView addSubview:_topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(@0);
        make.height.equalTo(@40);
        make.right.equalTo(@0);
    }];
    [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];// 监听loadedTimeRanges属性
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"gobackBtn.png"] forState:UIControlStateNormal];
    [_topView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.centerY.equalTo(@0);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    [button addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    button.hidden = YES;
    self.backButton = button;
    
    UILabel *label = [[UILabel alloc]init];
    [self.topView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.height.mas_equalTo(25);
    }];
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor whiteColor];
    label.text = @"default";
    label.textAlignment = NSTextAlignmentCenter;
    _titleLabel = label;
    
}

#pragma mark - 底部视图
- (void)creatBottomView
{
    
    _bottomView = [[UIView alloc] init];
    _bottomView.backgroundColor = [UIColor blackColor];
    _bottomView.alpha = 0.5;
    [_backView addSubview:_bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(35);
    }];
    
#pragma mark - start
    
    UIButton *startButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.bottomView addSubview:startButton];
    
    [startButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    if (_player) {
        
        if (_player.rate == 1.0) {
            [startButton setBackgroundImage:[UIImage imageNamed:@"pauseBtn.png"] forState:UIControlStateNormal];
        } else {
            [startButton setBackgroundImage:[UIImage imageNamed:@"playBtn.png"] forState:UIControlStateNormal];
        }
    }else{
        [startButton setBackgroundImage:[UIImage imageNamed:@"pauseBtn.png"] forState:UIControlStateNormal];
    }
    [startButton addTarget:self action:@selector(startAction:) forControlEvents:UIControlEventTouchUpInside];
    
#pragma mark - time
    
    _currentTimeLabel = [[UILabel alloc]init];
    _currentTimeLabel.textAlignment = NSTextAlignmentRight;
    [self.bottomView addSubview:_currentTimeLabel];
    
    [self.currentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(20);
        make.right.mas_equalTo(-5);
        make.width.mas_greaterThanOrEqualTo(2);
        make.centerY.mas_equalTo(startButton);
    }];
    _currentTimeLabel.textColor = [UIColor whiteColor];
    _currentTimeLabel.font = [UIFont systemFontOfSize:12];
    _currentTimeLabel.text = @"00:00/00:00";
    
#pragma mark - fullButton
    
    _fullScreenButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_fullScreenButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [self.topView addSubview:_fullScreenButton];
    _fullScreenButton.backgroundColor = [UIColor orangeColor];
    [_fullScreenButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.size.mas_equalTo(_backButton);
        make.centerY.mas_equalTo(_backButton);
    }];
    [_fullScreenButton addTarget:self action:@selector(fullScreenButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
#pragma mark - progress
    
    self.progress = [[UIProgressView alloc]init];
    [_bottomView addSubview:_progress];
    
    [self.progress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(startButton.mas_right).offset(10);
        make.centerY.mas_equalTo(startButton);
        make.right.equalTo(_currentTimeLabel.mas_left).offset(-10);
    }];
    
#pragma mark - slider
    
    self.slider = [[UISlider alloc]init];
    [self.bottomView addSubview:_slider];
    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.left.mas_equalTo(startButton.mas_right).offset(10);
        //        make.centerY.mas_equalTo(startButton);
        //        make.right.equalTo(_currentTimeLabel.mas_left).offset(-10);
    }];
    [_slider setThumbImage:[UIImage imageNamed:@"iconfont-yuan.png"] forState:UIControlStateNormal];
    [_slider addTarget:self action:@selector(progressSlider:) forControlEvents:UIControlEventValueChanged];
    _slider.minimumTrackTintColor = [UIColor colorWithRed:30 / 255.0 green:80 / 255.0 blue:100 / 255.0 alpha:1];
}

#pragma mark - 横屏代码
- (BOOL)shouldAutorotate{
    return NO;
} //NS_AVAILABLE_IOS(6_0);当前viewcontroller是否支持转屏

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskLandscape;
} //当前viewcontroller支持哪些转屏方向

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationLandscapeRight;
}

- (BOOL)prefersStatusBarHidden
{
    return YES; // 返回NO表示要显示，返回YES将hiden
}

#pragma mark - slider滑动事件
- (void)progressSlider:(UISlider *)slider
{
    //拖动改变视频播放进度
    if (_player.status == AVPlayerStatusReadyToPlay) {
        
//    //计算出拖动的当前秒数
    CGFloat total = (CGFloat)_playerItem.duration.value / _playerItem.duration.timescale;
    
//    NSLog(@"%f", total);
    
    NSInteger dragedSeconds = floorf(total * slider.value);
    
//    NSLog(@"dragedSeconds:%ld",dragedSeconds);
    
    //转换成CMTime才能给player来控制播放进度
    
    CMTime dragedCMTime = CMTimeMake(dragedSeconds, 1);
    
    [_player pause];
    
    [_player seekToTime:dragedCMTime completionHandler:^(BOOL finish){
        
        [_player play];
        
    }];
    
    }
}
#pragma mark -
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        NSTimeInterval timeInterval = [self availableDuration];// 计算缓冲进度
//        NSLog(@"Time Interval:%f",timeInterval);
        CMTime duration = self.playerItem.duration;
        CGFloat totalDuration = CMTimeGetSeconds(duration);
        [self.progress setProgress:timeInterval / totalDuration animated:NO];
    }
}

- (NSTimeInterval)availableDuration {
    NSArray *loadedTimeRanges = [[_player currentItem] loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}
- (void)customVideoSlider {
    UIGraphicsBeginImageContextWithOptions((CGSize){ 1, 1 }, NO, 0.0f);
    UIImage *transparentImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
//    [self.slider setMinimumTrackImage:transparentImage forState:UIControlStateNormal];
    [self.slider setMaximumTrackImage:transparentImage forState:UIControlStateNormal];
}

#pragma mark - 计时器事件
- (void)Stack
{
    if (_playerItem.duration.timescale != 0) {

    _slider.maximumValue = 1;//音乐总共时长
    _slider.value = CMTimeGetSeconds([_playerItem currentTime]) / (_playerItem.duration.value / _playerItem.duration.timescale);//当前进度
    
    //当前时长进度progress
    NSInteger proMin = (NSInteger)CMTimeGetSeconds([_player currentTime]) / 60;//当前秒
    NSInteger proSec = (NSInteger)CMTimeGetSeconds([_player currentTime]) % 60;//当前分钟
//    NSLog(@"%d",_playerItem.duration.timescale);
//    NSLog(@"%lld",_playerItem.duration.value/1000 / 60);
    
    //duration 总时长
    
        NSInteger durMin = (NSInteger)_playerItem.duration.value / _playerItem.duration.timescale / 60;//总秒
        NSInteger durSec = (NSInteger)_playerItem.duration.value / _playerItem.duration.timescale % 60;//总分钟
        self.currentTimeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld / %02ld:%02ld", proMin, proSec, durMin, durSec];
    }
    if (_player.status == AVPlayerStatusReadyToPlay) {
        [_activity stopAnimating];
    } else {
        [_activity startAnimating];
    }
    
}

#pragma mark - 菊花
- (void) creatActivityIndicatorView{

    _activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [self.view addSubview:_activity];
    [_activity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(_backView);
    }];
    [_activity startAnimating];
}

#pragma mark - 播放暂停按钮方法
- (void)startAction:(UIButton *)button
{
    if (button.selected) {
        [_player play];
        [button setBackgroundImage:[UIImage imageNamed:@"pauseBtn.png"] forState:UIControlStateNormal];

    } else {
        [_player pause];
        [button setBackgroundImage:[UIImage imageNamed:@"playBtn.png"] forState:UIControlStateNormal];

    }
    button.selected =!button.selected;
    
}

#pragma mark - 创建手势
- (void)createGesture
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.view addGestureRecognizer:tap];
    
    
    
    //获取系统音量
    MPVolumeView *volumeView = [[MPVolumeView alloc] init];
    _volumeViewSlider = nil;
    for (UIView *view in [volumeView subviews]){
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            _volumeViewSlider = (UISlider *)view;
            break;
        }
    }
    _systemVolume = _volumeViewSlider.value;
}
#pragma mark - 轻拍方法
- (void)tapAction:(UITapGestureRecognizer *)tap
{
    if (_backView.alpha == 1) {
        [UIView animateWithDuration:0.5 animations:^{
            
            _backView.alpha = 0;
        }];
    } else if (_backView.alpha == 0){
        [UIView animateWithDuration:0.5 animations:^{
            
            _backView.alpha = 1;
        }];
    }
    if (_backView.alpha == 1) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [UIView animateWithDuration:0.5 animations:^{
                
                _backView.alpha = 0;
            }];
            
        });

    }
}
#pragma mark - 滑动调整音量大小
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if(event.allTouches.count == 1){
        //保存当前触摸的位置
        CGPoint point = [[touches anyObject] locationInView:self.view];
        _startPoint = point;
    }
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    if(event.allTouches.count == 1){
        //计算位移
        CGPoint point = [[touches anyObject] locationInView:self.view];
        //        float dx = point.x - startPoint.x;
        float dy = point.y - _startPoint.y;
        int index = (int)dy;
        if(index>0){
            if(index%5==0){//每10个像素声音减一格
                NSLog(@"%.2f",_systemVolume);
                if(_systemVolume>0.1){
                    _systemVolume = _systemVolume-0.05;
                    [_volumeViewSlider setValue:_systemVolume animated:YES];
                    [_volumeViewSlider sendActionsForControlEvents:UIControlEventTouchUpInside];
                }
            }
        }else{
            if(index%5==0){//每10个像素声音增加一格
                NSLog(@"+x ==%d",index);
                NSLog(@"%.2f",_systemVolume);
                if(_systemVolume>=0 && _systemVolume<1){
                    _systemVolume = _systemVolume+0.05;
                    [_volumeViewSlider setValue:_systemVolume animated:YES];
                    [_volumeViewSlider sendActionsForControlEvents:UIControlEventTouchUpInside];
                }
            }
        }
        //亮度调节
        //        [UIScreen mainScreen].brightness = (float) dx/self.view.bounds.size.width;
    }
}


- (void)moviePlayDidEnd:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}
- (void)backButtonAction
{
    [_player pause];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void) fullScreenButtonAction{

}

#pragma mark - server
- (void) mediaInfoWithMediaID:(NSString *)ID{

    [HTTPTool requestJXVDYMediaInfoWithID:ID successedBlock:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"result:%@",responseObject);
        
        [_activity stopAnimating];
    } andFialedBlock:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_activity stopAnimating];
        NSLog(@"fail:%@",error.localizedDescription);
    }];
}
@end
