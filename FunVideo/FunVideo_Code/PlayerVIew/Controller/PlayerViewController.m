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
#import "DoubanServer.h"
#import "AppDelegate.h"
#import <AFNetworking/AFNetworking.h>
#import "UIKIT+AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "SongInfo.h"
#import "ChannelInfo.h"


#define PlayerImage_X_point (FrankieAppWidth-kPlayerImageWidth)/2
static const CGFloat kLabel_Height_Distance  = 20;
static const CGFloat kLabel_Height           = 30;
static const CGFloat kLabel_Width            = 200;
static const CGFloat kButton_X_point         = 35;
static const CGFloat kButton_Height_Distance = 30;
static const CGFloat kButton_Width_Distance  = 70;
static const CGFloat kButton_Height          = 40;
static const CGFloat kButton_Width           = 40;
static const CGFloat kPlayerImageWidth       = 200;
static const CGFloat kPlayerImageHeight      = 200;
static const CGFloat kPlayerImage_Y_point    = 40;





@interface PlayerViewController ()
{

    AppDelegate * appDelegate;

/**
 *表示当前播放器是否在播放 Yes播放 No不播放
 */
    bool isPlaying;
    
/**
 *用于TimeProgressBar计时用
 */
    NSTimer *Timer;
    int CurrentTimeMinutes;
    int CurrentTImeSeconds;
    NSMutableString *CurrentTimeString;
    int TotalTImeMinutes;
    int TotalTimeSeconds;
    NSMutableString * TotalTImeString;
    NSMutableString * TimerLabelString;
    
    
/**
 * ChannelGroup
 */
    ChannelGroup * channelGroup;
    
/**
 *  DoubanServer
 */
    DoubanServer * doubanServer;
    
}

/**
 * PlayerView上的控件，改为全部代码生成
 */

@property(nonatomic,strong) UIImageView *PlayerImage;

@property(nonatomic,strong) UIImageView *PlayerImageBlock;

@property(nonatomic,strong) UIProgressView *TimeProgressBar;

@property(nonatomic,strong) UILabel *TimeLabel;

@property(nonatomic,strong) UILabel *ChannelTitle;

@property(nonatomic,strong) UILabel *SongTitle;

@property(nonatomic,strong) UILabel *SongArtist;

@property(nonatomic,strong) UIButton *PauseButton;

@property(nonatomic,strong) UIButton *LikeButton;

@property(nonatomic,strong) UIButton *DeleteButton;

@property(nonatomic,strong) UIButton *SkipButton;

@end

@implementation PlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    appDelegate =[[UIApplication sharedApplication]delegate];
    [self SetUpUI];
    [self SetupPlayerInfo];
    [self AddNotification];
    [self SetupGesture];
    
    Timer = [NSTimer scheduledTimerWithTimeInterval:0.02
                                             target:self
                                           selector:@selector(UpdateProgress)
                                           userInfo:nil
                                            repeats:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    _PlayerImage.layer.cornerRadius = _PlayerImage.bounds.size.width/2.0;
    _PlayerImage.layer.masksToBounds = YES;
    [super viewDidAppear:animated];
    [self FlashSongInfo];
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

-(void)UpdateProgress
{
    CurrentTimeMinutes = (unsigned)appDelegate.VideoPlayer.currentPlaybackTime/60;
    CurrentTImeSeconds = (unsigned)appDelegate.VideoPlayer.currentPlaybackTime%60;
    
    //专辑图片旋转
    _PlayerImage.transform = CGAffineTransformRotate(_PlayerImage.transform, M_PI / 1440);
    if(CurrentTImeSeconds < 10)
    {
        CurrentTimeString = [NSMutableString stringWithFormat:@"%d:0%d",CurrentTimeMinutes,CurrentTImeSeconds];
    }
    else
    {
        CurrentTimeString = [NSMutableString stringWithFormat:@"%d:%d",CurrentTimeMinutes,CurrentTImeSeconds];
    }
    TimerLabelString = [NSMutableString stringWithFormat:@"%@/%@",CurrentTimeString,TotalTImeString];
    _TimeLabel.text = TimerLabelString;
    _TimeProgressBar.progress = appDelegate.VideoPlayer.currentPlaybackTime/[appDelegate.playerInfo.CurrentSong.SongTimeLong intValue];
}





-(void)AddNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(StartPlay)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(FlashSongInfo)
                                                 name:MPMoviePlayerLoadStateDidChangeNotification
                                               object:nil];
}


-(void)SetupPlayerInfo
{
    doubanServer = [[DoubanServer alloc]initDoubanServer];
    [doubanServer DoubanSongOperationWithType:@"n"];

}

-(void)SetupGesture
{
    _PlayerImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *SingleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(PauseButton)];
    [SingleTap setNumberOfTouchesRequired:1];
    [_PlayerImage addGestureRecognizer:SingleTap];
}


-(void)StartPlay
{
    doubanServer = [[DoubanServer alloc]initDoubanServer];
    [doubanServer DoubanSongOperationWithType:@"p"];
}



-(void)FlashSongInfo
{
    isPlaying = YES;
    if(![self isFirstResponder])
    {
        //远程控制
        [[UIApplication sharedApplication]beginReceivingRemoteControlEvents];
        [self becomeFirstResponder];
    }
    
    //重置旋转图片角度
    _PlayerImage.image = nil;
    NSString * playerImageName = [NSString stringWithFormat:@"%@_imageName",appDelegate.playerInfo.CurrentSong.SongTitle];
    NSURL * imageURL = [NSURL URLWithString:appDelegate.playerInfo.CurrentSong.SongPictureUrl];
    //[_PlayerImage setImageWithURL:imageURL
                 //placeholderImage:[UIImage imageNamed:playerImageName]];
    //采用SDIMageCache技术缓存
    [_PlayerImage sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"playerImageName"]];
    NSLog(@"%@",_PlayerImage.image);
    
    //初始化各UI界面
    _ChannelTitle.text = [NSString stringWithFormat:@"♪%@♪",appDelegate.playerInfo.CurrentChannel.ChannelName];
    _SongArtist.text = appDelegate.playerInfo.CurrentSong.SongArtist;
    _SongTitle.text = appDelegate.playerInfo.CurrentSong.SongTitle;
    //Chanel没设计呢
    
    //初始化TimeLable的总时间
    TotalTimeSeconds = [appDelegate.playerInfo.CurrentSong.SongTimeLong intValue]%60;
    TotalTImeMinutes = [appDelegate.playerInfo.CurrentSong.SongTimeLong intValue]/60;
    if(TotalTimeSeconds < 10)
    {
        TotalTImeString = [NSMutableString stringWithFormat:@"%d:0%d",TotalTImeMinutes,TotalTimeSeconds];
    }
    else
    {
        TotalTImeString = [NSMutableString stringWithFormat:@"%d:%d",TotalTImeMinutes,TotalTimeSeconds];
    }
    
    //初始化likeButton的图像
    if(![appDelegate.playerInfo.CurrentSong.SongIsLike intValue])
    {
        [_LikeButton setBackgroundImage:[UIImage imageNamed:@"heart1"] forState:UIControlStateNormal];
    }
    else
    {
        [_LikeButton setBackgroundImage:[UIImage imageNamed:@"heart2"] forState:UIControlStateNormal];
    }
    [Timer setFireDate:[NSDate date]];
    [self ConfigVideoPlayerInfo];
    
}

-(void)ConfigVideoPlayerInfo
{
    if(NSClassFromString(@"MPNowPlayingInfoCenter"))
    {
        if(appDelegate.playerInfo.CurrentSong.SongTitle != nil)
        {
            NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
            [dict setObject:appDelegate.playerInfo.CurrentSong.SongTitle forKey:MPMediaItemPropertyTitle];
            [dict setObject:appDelegate.playerInfo.CurrentSong.SongArtist forKey:MPMediaItemPropertyArtist];
            UIImage * PlayerViewImage = _PlayerImage.image;
            if(PlayerViewImage != nil)
            {
                [dict setObject:[[MPMediaItemArtwork alloc]initWithImage:PlayerViewImage]forKey:MPMediaItemPropertyArtwork];
            }
            [dict setObject:[NSNumber numberWithFloat:[appDelegate.playerInfo.CurrentSong.SongTimeLong floatValue]] forKey:MPMediaItemPropertyPlaybackDuration];
            [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];
        }
    }
}

-(void)SetUpUI
{
    //初始化背景颜色
    self.view.backgroundColor = UIBACKGROUNDCOLOR;
    
    //初始化PlyaerImage界面
    _PlayerImage = [[UIImageView alloc]init];
    _PlayerImage.frame = CGRectMake(PlayerImage_X_point, kPlayerImage_Y_point, kPlayerImageWidth, kPlayerImageHeight);
    _PlayerImage.layer.masksToBounds = YES;
    _PlayerImage.layer.cornerRadius = 10;
    [self.view addSubview:_PlayerImage];
    
   
    //初始化PlayerImageBlock界面
    _PlayerImageBlock = [[UIImageView alloc]init];
    _PlayerImageBlock.frame = CGRectMake(PlayerImage_X_point, kPlayerImage_Y_point, kPlayerImageWidth, kPlayerImageHeight);
    [_PlayerImageBlock setImage:[UIImage imageNamed:@"albumBlock"]];
    _PlayerImageBlock.layer.masksToBounds = YES;
    _PlayerImageBlock.layer.cornerRadius = 10;
    [self.view addSubview:_PlayerImageBlock];
    
    //初始化TimeLabel
    _TimeLabel = [[UILabel alloc]init];
    _TimeLabel.backgroundColor = UIBACKGROUNDCOLOR;
    _TimeLabel.font = [UIFont systemFontOfSize:15];
    _TimeLabel.textColor = [UIColor blackColor];
    _TimeLabel.textAlignment = NSTextAlignmentCenter;
    _TimeLabel.frame = CGRectMake(PlayerImage_X_point, kPlayerImage_Y_point + kPlayerImageHeight + kLabel_Height_Distance * 1, kLabel_Width, kLabel_Height);
    [self.view addSubview:_TimeLabel];

    //初始化TimeProgressBar
    _TimeProgressBar = [[UIProgressView alloc]init];
     _TimeProgressBar.frame = CGRectMake(PlayerImage_X_point, kPlayerImage_Y_point + kPlayerImageHeight + kLabel_Height_Distance * 3, kLabel_Width, kLabel_Height);
    [self.view addSubview:_TimeProgressBar];
    
    //初始化ChannelLabel
    _ChannelTitle = [[UILabel alloc]init];
    _ChannelTitle.backgroundColor = UIBACKGROUNDCOLOR;
    _ChannelTitle.font = [UIFont systemFontOfSize:15];
    _ChannelTitle.textColor = [UIColor blackColor];
    _ChannelTitle.textAlignment = NSTextAlignmentCenter;
    _ChannelTitle.frame = CGRectMake(PlayerImage_X_point, kPlayerImage_Y_point + kPlayerImageHeight + kLabel_Height_Distance * 5, kLabel_Width, kLabel_Height);
    [self.view addSubview:_ChannelTitle];
    
    //初始化SongTitle
    _SongTitle = [[UILabel alloc]init];
    _SongTitle.backgroundColor = UIBACKGROUNDCOLOR;
    _SongTitle.font = [UIFont systemFontOfSize:25];
    _SongTitle.textColor = [UIColor blackColor];
    _SongTitle.textAlignment = NSTextAlignmentCenter;
    _SongTitle.frame = CGRectMake(PlayerImage_X_point, kPlayerImage_Y_point + kPlayerImageHeight + kLabel_Height_Distance * 7, kLabel_Width, kLabel_Height);
    [self.view addSubview:_SongTitle];
    
    //初始化SongArtist
    _SongArtist = [[UILabel alloc]init];
    _SongArtist.backgroundColor = UIBACKGROUNDCOLOR;
    _SongArtist.font = [UIFont systemFontOfSize:15];
    _SongArtist.textColor = [UIColor blackColor];
    _SongArtist.textAlignment = NSTextAlignmentCenter;
    _SongArtist.frame = CGRectMake(PlayerImage_X_point, kPlayerImage_Y_point + kPlayerImageHeight + kLabel_Height_Distance * 9, kLabel_Width, kLabel_Height);
    [self.view addSubview:_SongArtist];
    
    //初始化PauseButton
    _PauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_PauseButton setImage:[UIImage imageNamed:@"stop"] forState:UIControlStateNormal];
    [_PauseButton addTarget:self action:@selector(PauseButton) forControlEvents:UIControlEventTouchUpInside];
    _PauseButton.frame = CGRectMake(kButton_X_point, kPlayerImage_Y_point + kPlayerImageHeight + kLabel_Height_Distance * 10 + kButton_Height_Distance, kButton_Width, kButton_Height);
    [self.view addSubview:_PauseButton];
    
    //初始化LikeButton
    _LikeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_LikeButton setImage:[UIImage imageNamed:@"heart1"] forState:UIControlStateNormal];
    [_LikeButton addTarget:self action:@selector(LikeButton) forControlEvents:UIControlEventTouchUpInside];
    _LikeButton.frame = CGRectMake(kButton_X_point + kButton_Width_Distance * 1,kPlayerImage_Y_point + kPlayerImageHeight + kLabel_Height_Distance * 10 + kButton_Height_Distance , kButton_Width, kButton_Height);
    [self.view addSubview:_LikeButton];
    
    //初始化DeleteButton
    _DeleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_DeleteButton setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    [_DeleteButton addTarget:self action:@selector(DeleteButton) forControlEvents:UIControlEventTouchUpInside];
    _DeleteButton.frame = CGRectMake(kButton_X_point + kButton_Width_Distance * 2,kPlayerImage_Y_point + kPlayerImageHeight + kLabel_Height_Distance * 10 + kButton_Height_Distance , kButton_Width, kButton_Height);
    [self.view addSubview:_DeleteButton];
    
    //初始化SkipButton
    _SkipButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_SkipButton setImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
    [_SkipButton addTarget:self action:@selector(SkipButton) forControlEvents:UIControlEventTouchUpInside];
    _SkipButton.frame = CGRectMake(kButton_X_point + kButton_Width_Distance * 3,kPlayerImage_Y_point + kPlayerImageHeight + kLabel_Height_Distance * 10 + kButton_Height_Distance , kButton_Width, kButton_Height);
    [self.view addSubview:_SkipButton];

}


- (IBAction)PauseButton
{
    if(isPlaying)
    {
        isPlaying = NO;
        _PlayerImage.alpha = 0.2f;
        _PlayerImageBlock.image = [UIImage imageNamed:@"albumBlock2"];
        [_PauseButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        [appDelegate.VideoPlayer pause];
        //关闭计时器
        [Timer setFireDate:[NSDate distantFuture]];
    }
    else
    {
        isPlaying = YES;
        _PlayerImage.alpha = 1.0f;
        _PlayerImageBlock.image = [UIImage imageNamed:@"albumBlock"];
        [_PauseButton setImage:[UIImage imageNamed:@"stop"] forState:UIControlStateNormal];
        [appDelegate.VideoPlayer play];
        //开启计时器
        [Timer setFireDate:[NSDate date]];
    }
}

- (IBAction)LikeButton
{
    if(![appDelegate.playerInfo.CurrentSong.SongIsLike intValue])
    {
        appDelegate.playerInfo.CurrentSong.SongIsLike = @"1";
        [_LikeButton setImage:[UIImage imageNamed:@"heart2"] forState:UIControlStateNormal];
        [doubanServer DoubanSongOperationWithType:@"r"];
        
    }
    else
    {
        appDelegate.playerInfo.CurrentSong.SongIsLike = @"0";
        [_LikeButton setImage:[UIImage imageNamed:@"heart1"] forState:UIControlStateNormal];
    }
}

- (IBAction)DeleteButton
{
    if(!isPlaying)
    {
        isPlaying = YES;
        _PlayerImage.alpha = 1.0f;
        _PlayerImageBlock.image = [UIImage imageNamed:@"albumBlock"];
        [appDelegate.VideoPlayer play];
        [_PauseButton setBackgroundImage:[UIImage imageNamed:@"stop"] forState:UIControlStateNormal];
    }
    [doubanServer DoubanSongOperationWithType:@"b"];

}

- (IBAction)SkipButton
{
    [Timer setFireDate:[NSDate distantFuture]];
    [appDelegate.VideoPlayer pause];
    if(!isPlaying)
    {
        _PlayerImage.alpha = 1.0f;
        _PlayerImageBlock.image = [UIImage imageNamed:@"albumBlock"];
    }
    [doubanServer DoubanSongOperationWithType:@"s"];
}





































@end
