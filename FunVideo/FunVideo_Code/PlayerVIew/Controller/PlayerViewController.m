//
//  PlayerViewController.m
//  FrankieVideo_New
//
//  Created by frankie on 15/10/19.
//  Copyright © 2015年 frankieCompany. All rights reserved.
//

#import "PlayerViewController.h"
#import "PlayerInfo.h"
#import "Commons.h"
#import "AppDelegate.h"
#import <AFNetworking/AFNetworking.h>
#import "UIKIT+AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "SongInfo.h"
#import "ChannelInfo.h"
#import "NSTimer + FunVideo.h"
#import "Masonry.h"
#import "MarqueeLabel.h"



static const CGFloat kPlayerImageTop               = 40;
static const CGFloat kPlayerImageSidesLengthFactor = 0.56f;
static const CGFloat kTimeLabelTopFactor           = 1.083f;
static const CGFloat kTimeProgressBarTopFactor     = 1.069f;
static const CGFloat kChannelLabelTopFactor        = 1.059f;
static const CGFloat kSongTitleTopFactor           = 1.051f;
static const CGFloat kSongArtistTopFactor          = 1.045f;
static const CGFloat kButtonTopFactor              = 1.15f;
static const CGFloat kLabelWidthFactor             = 0.56f;
static const CGFloat kLabelHeigthFactor            = 0.053f;
static const CGFloat kButtonHeightWidthFactor      = 0.083f;

//字体设置,以iphone6为基准，向下5s及4，向上6s及6s plus兼容
static const CGFloat kLabelFont = 18;
static const CGFloat kBigLabelFont = 22;


@interface PlayerViewController ()
{

    AppDelegate * appDelegate;
    bool isPlaying;
    
    NSTimer *timer;
    int currentTimeMinutes;
    int currentTImeSeconds;
    NSMutableString *currentTimeString;
    int totalTImeMinutes;
    int totalTimeSeconds;
    NSMutableString *totalTImeString;
    NSMutableString *timerLabelString;
    ChannelGroup *channelGroup;
    DoubanServer *doubanServer;

    
    UIImageView *playerImage;
    UIImageView *playerImageBlock;
    UIProgressView *timeProgressBar;
    UILabel *timeLabel;
    UILabel *channelTitle;
    MarqueeLabel *songTitle;
    MarqueeLabel *songArtist;
    UIButton *pauseButton;
    UIButton *likeButton;
    UIButton *deleteButton;
    UIButton *skipButton;
    
}



@end

@implementation PlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    appDelegate =[[UIApplication sharedApplication]delegate];
    [self setUpUI];
    [self setAutoLayOut];
    [self setupPlayerInfo];
    [self addNotification];
    [self setupGesture];
    
//解决NSTimer保留环问题
//    timer = [NSTimer scheduledTimerWithTimeInterval:0.02
//                                             target:self
//                                           selector:@selector(p_updateProgress)
//                                           userInfo:nil
//                                            repeats:YES];
    
    
    __weak PlayerViewController * weakSelf = self;
     timer = [NSTimer FunVideo_scheduledTimerWithTimeInterval:0.02
                                                        block:^{[weakSelf updateProgress];}
                                                      repeats:YES];
    [self flashSongInfo];
}






- (void)viewDidAppear:(BOOL)animated
{
    playerImage.layer.cornerRadius = playerImage.bounds.size.width/2.0;
    playerImage.layer.masksToBounds = YES;
    [super viewDidAppear:animated];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)updateProgress
{
    currentTimeMinutes = (unsigned)appDelegate.VideoPlayer.currentPlaybackTime/60;
    currentTImeSeconds = (unsigned)appDelegate.VideoPlayer.currentPlaybackTime%60;
    
    //专辑图片旋转
    playerImage.transform = CGAffineTransformRotate(playerImage.transform, M_PI / 1440);
    if(currentTImeSeconds < 10)
    {
        currentTimeString = [NSMutableString stringWithFormat:@"%d:0%d",currentTimeMinutes,currentTImeSeconds];
    }
    else
    {
        currentTimeString = [NSMutableString stringWithFormat:@"%d:%d",currentTimeMinutes,currentTImeSeconds];
    }
    timerLabelString = [NSMutableString stringWithFormat:@"%@/%@",currentTimeString,totalTImeString];
    timeLabel.text = timerLabelString;
    timeProgressBar.progress = appDelegate.VideoPlayer.currentPlaybackTime/[appDelegate.playerInfo.currentSong.songTimeLong intValue];
}





- (void)addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(startPlay)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(flashSongInfo)
                                                 name:MPMoviePlayerLoadStateDidChangeNotification
                                               object:nil];
}


- (void)setupPlayerInfo
{
    doubanServer = [[DoubanServer alloc]initDoubanServer];
    doubanServer.delegate = self;
    [doubanServer doubanSongOperationWithType:@"n"];

}


- (void)getSongListFail
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"获取音乐失败"
                                                                              message:@"请检查网络或者服务器异常"
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}



- (void)setupGesture
{
    playerImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pauseButton)];
    [singleTap setNumberOfTouchesRequired:1];
    [playerImage addGestureRecognizer:singleTap];
}


- (void)startPlay
{
    doubanServer = [[DoubanServer alloc]initDoubanServer];
    [doubanServer doubanSongOperationWithType:@"p"];
}



- (void)flashSongInfo
{
    isPlaying = YES;
    if(![self isFirstResponder])
    {
        //远程控制
        [[UIApplication sharedApplication]beginReceivingRemoteControlEvents];
        [self becomeFirstResponder];
    }
    
    //重置旋转图片角度
    playerImage.image = nil;
    NSURL *imageURL = [NSURL URLWithString:appDelegate.playerInfo.currentSong.songPictureUrl];
    //[_PlayerImage setImageWithURL:imageURL
                 //placeholderImage:[UIImage imageNamed:playerImageName]];
    //采用SDIMageCache技术缓存
    
    
    
    //内存膨胀的元凶！！decodeImage函数造成了大量的内存使用！
    [playerImage sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"playerImageName"]];
    NSLog(@"%@",playerImage.image);
    
    //初始化各UI界面
    channelTitle.text = [NSString stringWithFormat:@"♪%@♪",appDelegate.playerInfo.currentChannel.channelName];
    songArtist.text = appDelegate.playerInfo.currentSong.songArtist;
    songTitle.text = appDelegate.playerInfo.currentSong.songTitle;
    
    //初始化TimeLable的总时间
    totalTimeSeconds = [appDelegate.playerInfo.currentSong.songTimeLong intValue]%60;
    totalTImeMinutes = [appDelegate.playerInfo.currentSong.songTimeLong intValue]/60;
    if(totalTimeSeconds < 10)
    {
        totalTImeString = [NSMutableString stringWithFormat:@"%d:0%d",totalTImeMinutes,totalTimeSeconds];
    }
    else
    {
        totalTImeString = [NSMutableString stringWithFormat:@"%d:%d",totalTImeMinutes,totalTimeSeconds];
    }
    
    //初始化likeButton的图像
    if(![appDelegate.playerInfo.currentSong.songIsLike intValue])
    {
        [likeButton setBackgroundImage:[UIImage imageNamed:@"heart1"] forState:UIControlStateNormal];
    }
    else
    {
        [likeButton setBackgroundImage:[UIImage imageNamed:@"heart2"] forState:UIControlStateNormal];
    }
    
    //初始化PauseButton的表示
    playerImage.alpha = 1.0f;
    playerImageBlock.image = [UIImage imageNamed:@"albumBlock"];
    [pauseButton setBackgroundImage:[UIImage imageNamed:@"stop"] forState:UIControlStateNormal];
    
    //初始化timeprogressbar
    [timer setFireDate:[NSDate date]];
    [self configVideoPlayerInfo];
    
}

- (void)configVideoPlayerInfo
{
    if(NSClassFromString(@"MPNowPlayingInfoCenter"))
    {
        if(appDelegate.playerInfo.currentSong.songTitle != nil)
        {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
            [dict setObject:appDelegate.playerInfo.currentSong.songTitle forKey:MPMediaItemPropertyTitle];
            [dict setObject:appDelegate.playerInfo.currentSong.songArtist forKey:MPMediaItemPropertyArtist];
            UIImage *playerViewImage = playerImage.image;
            if(playerViewImage != nil)
            {
                [dict setObject:[[MPMediaItemArtwork alloc]initWithImage:playerViewImage]forKey:MPMediaItemPropertyArtwork];
            }
            [dict setObject:[NSNumber numberWithFloat:[appDelegate.playerInfo.currentSong.songTimeLong floatValue]] forKey:MPMediaItemPropertyPlaybackDuration];
            [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];
        }
    }
}

- (void)setAutoLayOut
{
    //初始化PlyaerImage界面
    [playerImage mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.top.equalTo(self.view.mas_top).with.offset(kPlayerImageTop);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.height.and.width.equalTo(self.view.mas_width).with.multipliedBy(kPlayerImageSidesLengthFactor);
    }];
    
 
    //初始化PlayerImageBlock界面
    [playerImageBlock mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.top.equalTo(self.view.mas_top).with.offset(kPlayerImageTop);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.height.and.width.equalTo(self.view.mas_width).with.multipliedBy(kPlayerImageSidesLengthFactor);

    }];
    
    //初始化TimeLabel
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.top.equalTo(playerImageBlock.mas_bottom).with.multipliedBy(kTimeLabelTopFactor);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.equalTo(self.view.mas_width).with.multipliedBy(kLabelWidthFactor);
        make.height.equalTo(self.view.mas_height).with.multipliedBy(kLabelHeigthFactor);
    }];
    
    //初始化TimeProgressBar
    [timeProgressBar mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.top.equalTo(timeLabel.mas_bottom).with.multipliedBy(kTimeProgressBarTopFactor);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.equalTo(self.view.mas_width).with.multipliedBy(kLabelWidthFactor);
        //make.height.equalTo(self.view.mas_height).with.multipliedBy(kLabelHeigthFactor);
        make.height.mas_equalTo(@3);
    }];
    

    //初始化ChannelLabel
    [channelTitle mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.top.equalTo(timeProgressBar.mas_bottom).with.multipliedBy(kChannelLabelTopFactor);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.equalTo(self.view.mas_width).with.multipliedBy(kLabelWidthFactor);
        make.height.equalTo(self.view.mas_height).with.multipliedBy(kLabelHeigthFactor);
    }];
    
  
    //初始化SongTitle
    [songTitle mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.top.equalTo(channelTitle.mas_bottom).with.multipliedBy(kSongTitleTopFactor);
         make.centerX.mas_equalTo(self.view.mas_centerX);
         make.width.equalTo(self.view.mas_width).with.multipliedBy(kLabelWidthFactor);
         make.height.equalTo(self.view.mas_height).with.multipliedBy(kLabelHeigthFactor);
     }];
 
    
    //初始化SongArtist
    [songArtist mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.top.equalTo(songTitle.mas_bottom).with.multipliedBy(kSongArtistTopFactor);
         make.centerX.mas_equalTo(self.view.mas_centerX);
         make.width.equalTo(self.view.mas_width).with.multipliedBy(kLabelWidthFactor);
         make.height.equalTo(self.view.mas_height).with.multipliedBy(kLabelHeigthFactor);
     }];
    
    
    
    //初始化PauseButton
    [pauseButton mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.top.equalTo(songArtist.mas_bottom).with.multipliedBy(kButtonTopFactor);
        make.centerX.equalTo(self.view.mas_centerX).with.multipliedBy(0.4);
        make.width.and.height.equalTo(self.view.mas_width).with.multipliedBy(kButtonHeightWidthFactor);
    }];
    
    //初始化LikeButton
    [likeButton mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.top.equalTo(songArtist.mas_bottom).with.multipliedBy(kButtonTopFactor);
        make.centerX.equalTo(self.view.mas_centerX).with.multipliedBy(0.8);
        make.width.and.height.equalTo(self.view.mas_width).with.multipliedBy(kButtonHeightWidthFactor);
    }];
    
    
    //初始化DeleteButton
    [deleteButton mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.top.equalTo(songArtist.mas_bottom).with.multipliedBy(kButtonTopFactor);
        make.centerX.equalTo(self.view.mas_centerX).with.multipliedBy(1.2);
        make.width.and.height.equalTo(self.view.mas_width).with.multipliedBy(kButtonHeightWidthFactor);
    }];
    
    
    //初始化SkipButton
    [skipButton mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.top.equalTo(songArtist.mas_bottom).with.multipliedBy(kButtonTopFactor);
        make.centerX.equalTo(self.view.mas_centerX).with.multipliedBy(1.6);
        make.width.and.height.equalTo(self.view.mas_width).with.multipliedBy(kButtonHeightWidthFactor);
    }];
    
}



- (void)setUpUI
{
    //初始化背景颜色
    self.view.backgroundColor = UIBACKGROUNDCOLOR;
    
    //初始化PlyaerImage界面
    playerImage = [[UIImageView alloc]init];
    playerImage.layer.masksToBounds = YES;
    playerImage.layer.cornerRadius = 10;
    [self.view addSubview:playerImage];
    
   
    //初始化PlayerImageBlock界面
    playerImageBlock = [[UIImageView alloc]init];
    [playerImageBlock setImage:[UIImage imageNamed:@"albumBlock"]];
    playerImageBlock.layer.masksToBounds = YES;
    playerImageBlock.layer.cornerRadius = 10;
    [self.view addSubview:playerImageBlock];
    
    //初始化TimeLabel
    timeLabel = [[UILabel alloc]init];
    timeLabel.backgroundColor = UIBACKGROUNDCOLOR;
    timeLabel.font = [UIFont systemFontOfSize:kLabelFont];
    timeLabel.textColor = [UIColor blackColor];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:timeLabel];

    //初始化TimeProgressBar
    timeProgressBar = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
    [timeProgressBar setProgressTintColor:UIBUTTONCOLOR];
    [self.view addSubview:timeProgressBar];
    
    //初始化ChannelLabel
    channelTitle = [[UILabel alloc]init];
    channelTitle.backgroundColor = UIBACKGROUNDCOLOR;
    channelTitle.font = [UIFont systemFontOfSize:kLabelFont];
    channelTitle.textColor = [UIColor blackColor];
    channelTitle.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:channelTitle];
    
    //初始化SongTitle
    songTitle = [[MarqueeLabel alloc]init];
    songTitle.scrollDuration = 10.0f;
    songTitle.fadeLength = 10.0f;
    songTitle.animationCurve = UIViewAnimationCurveEaseIn;
    songTitle.marqueeType = MLLeftRight;
    songTitle.backgroundColor = UIBACKGROUNDCOLOR;
    songTitle.font = [UIFont systemFontOfSize:kBigLabelFont];
    songTitle.textColor = [UIColor blackColor];
    songTitle.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:songTitle];
    
    //初始化SongArtist
    songArtist = [[MarqueeLabel alloc]init];
    songArtist.scrollDuration = 10.0;
    songArtist.fadeLength = 10.0f;
    songArtist.animationCurve = UIViewAnimationCurveEaseIn;
    songArtist.marqueeType = MLLeftRight;
    songArtist.backgroundColor = UIBACKGROUNDCOLOR;
    songArtist.font = [UIFont systemFontOfSize:kLabelFont];
    songArtist.textColor = [UIColor blackColor];
    songArtist.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:songArtist];
    
    //初始化PauseButton
    pauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [pauseButton setBackgroundImage:[UIImage imageNamed:@"stop"] forState:UIControlStateNormal];
    [pauseButton addTarget:self action:@selector(pauseButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pauseButton];
    
    //初始化LikeButton
    likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [likeButton setBackgroundImage:[UIImage imageNamed:@"heart1"] forState:UIControlStateNormal];
    [likeButton addTarget:self action:@selector(likeButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:likeButton];
    
    //初始化DeleteButton
    deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteButton setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(deleteButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:deleteButton];
    
    //初始化SkipButton
    skipButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [skipButton setBackgroundImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
    [skipButton addTarget:self action:@selector(skipButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:skipButton];

}


- (IBAction)pauseButton
{
    if(isPlaying)
    {
        isPlaying = NO;
        playerImage.alpha = 0.2f;
        playerImageBlock.image = [UIImage imageNamed:@"albumBlock2"];
        [pauseButton setBackgroundImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        [appDelegate.VideoPlayer pause];
        //关闭计时器
        [timer setFireDate:[NSDate distantFuture]];
    }
    else
    {
        isPlaying = YES;
        playerImage.alpha = 1.0f;
        playerImageBlock.image = [UIImage imageNamed:@"albumBlock"];
        [pauseButton setBackgroundImage:[UIImage imageNamed:@"stop"] forState:UIControlStateNormal];
        [appDelegate.VideoPlayer play];
        //开启计时器
        [timer setFireDate:[NSDate date]];
    }
}

- (IBAction)likeButton
{
    if(![appDelegate.playerInfo.currentSong.songIsLike intValue])
    {
        appDelegate.playerInfo.currentSong.songIsLike = @"1";
        [likeButton setBackgroundImage:[UIImage imageNamed:@"heart2"] forState:UIControlStateNormal];
        [doubanServer doubanSongOperationWithType:@"r"];
        
    }
    else
    {
        appDelegate.playerInfo.currentSong.songIsLike = @"0";
        [likeButton setBackgroundImage:[UIImage imageNamed:@"heart1"] forState:UIControlStateNormal];
    }
}

- (IBAction)deleteButton
{
    if(!isPlaying)
    {
        isPlaying = YES;
        playerImage.alpha = 1.0f;
        playerImageBlock.image = [UIImage imageNamed:@"albumBlock"];
        [appDelegate.VideoPlayer play];
        [pauseButton setBackgroundImage:[UIImage imageNamed:@"stop"] forState:UIControlStateNormal];
    }
    [doubanServer doubanSongOperationWithType:@"b"];

}

- (IBAction)skipButton
{
    [timer setFireDate:[NSDate distantFuture]];
    [appDelegate.VideoPlayer pause];
    if(!isPlaying)
    {
        playerImage.alpha = 1.0f;
        playerImageBlock.image = [UIImage imageNamed:@"albumBlock"];
    }
    [doubanServer doubanSongOperationWithType:@"s"];
}







































@end
