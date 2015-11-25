//
//  MoviePlayerViewController.h
//  Player
//
//  Created by dllo on 15/11/7.
//  Copyright © 2015年 zhaoqingwen. All rights reserved.
//

#import <UIKit/UIKit.h>

//#define mediaUrlString @"http://ignhdvod-f.akamaihd.net/i/assets.ign.com/videos/zencoder/,416/d4ff0368b5e4a24aee0dab7703d4123a-110000,640/d4ff0368b5e4a24aee0dab7703d4123a-500000,640/d4ff0368b5e4a24aee0dab7703d4123a-1000000,960/d4ff0368b5e4a24aee0dab7703d4123a-2500000,1280/d4ff0368b5e4a24aee0dab7703d4123a-3000000,-1354660143-w.mp4.csmil/master.m3u8"
#define mediaUrlString @"http://v.jxvdy.com/sendfile/V7fo3U9VdEiwtqCIAIFQ01lbzqaOW6pJkb3J7jq4XI9Zhs7DO4TtmiM3quYWi-Zv7gAv7Fb1lq_ehq1KZ9trRTkjtFiLig"

//#define mediaUrlString @"http://221.229.165.31:80/play/274CF5C996AFCE2C751D315B5D1BF131B8C08208/298088%5Fstandard.mp4"

@class HLLMediaInfoModel;
@interface MoviePlayerViewController : UIViewController


@property (nonatomic ,strong) HLLMediaInfoModel * mediaInfo;

@end
