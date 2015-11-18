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
    
/**
* PlayerView上的控件，改为全部代码生成
*/
    
    UIImageView *PlayerImage;
    
    UIImageView *PlayerImageBlock;
    
    UIProgressView *TimeProgressBar;
    
    UILabel *TimeLabel;
    
    UILabel *ChannelTitle;
    
    UILabel *SongTitle;
    
    UILabel *SongArtist;
    
    UIButton *PauseButton;
    
    UIButton *LikeButton;
    
    UIButton *DeleteButton;
    
    UIButton *SkipButton;
    
}



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
    PlayerImage.layer.cornerRadius = PlayerImage.bounds.size.width/2.0;
    PlayerImage.layer.masksToBounds = YES;
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
    PlayerImage.transform = CGAffineTransformRotate(PlayerImage.transform, M_PI / 1440);
    if(CurrentTImeSeconds < 10)
    {
        CurrentTimeString = [NSMutableString stringWithFormat:@"%d:0%d",CurrentTimeMinutes,CurrentTImeSeconds];
    }
    else
    {
        CurrentTimeString = [NSMutableString stringWithFormat:@"%d:%d",CurrentTimeMinutes,CurrentTImeSeconds];
    }
    TimerLabelString = [NSMutableString stringWithFormat:@"%@/%@",CurrentTimeString,TotalTImeString];
    TimeLabel.text = TimerLabelString;
    TimeProgressBar.progress = appDelegate.VideoPlayer.currentPlaybackTime/[appDelegate.playerInfo.CurrentSong.SongTimeLong intValue];
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
    PlayerImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *SingleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(PauseButton)];
    [SingleTap setNumberOfTouchesRequired:1];
    [PlayerImage addGestureRecognizer:SingleTap];
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
    PlayerImage.image = nil;
    NSString * playerImageName = [NSString stringWithFormat:@"%@_imageName",appDelegate.playerInfo.CurrentSong.SongTitle];
    NSURL * imageURL = [NSURL URLWithString:appDelegate.playerInfo.CurrentSong.SongPictureUrl];
    //[_PlayerImage setImageWithURL:imageURL
                 //placeholderImage:[UIImage imageNamed:playerImageName]];
    //采用SDIMageCache技术缓存
    [PlayerImage sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"playerImageName"]];
    NSLog(@"%@",PlayerImage.image);
    
    //初始化各UI界面
    ChannelTitle.text = [NSString stringWithFormat:@"♪%@♪",appDelegate.playerInfo.CurrentChannel.ChannelName];
    SongArtist.text = appDelegate.playerInfo.CurrentSong.SongArtist;
    SongTitle.text = appDelegate.playerInfo.CurrentSong.SongTitle;
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
        [LikeButton setBackgroundImage:[UIImage imageNamed:@"heart1"] forState:UIControlStateNormal];
    }
    else
    {
        [LikeButton setBackgroundImage:[UIImage imageNamed:@"heart2"] forState:UIControlStateNormal];
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
            UIImage * PlayerViewImage = PlayerImage.image;
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
    PlayerImage = [[UIImageView alloc]init];
    PlayerImage.frame = CGRectMake(PlayerImage_X_point, kPlayerImage_Y_point, kPlayerImageWidth, kPlayerImageHeight);
    PlayerImage.layer.masksToBounds = YES;
    PlayerImage.layer.cornerRadius = 10;
    [self.view addSubview:PlayerImage];
    
   
    //初始化PlayerImageBlock界面
    PlayerImageBlock = [[UIImageView alloc]init];
    PlayerImageBlock.frame = CGRectMake(PlayerImage_X_point, kPlayerImage_Y_point, kPlayerImageWidth, kPlayerImageHeight);
    [PlayerImageBlock setImage:[UIImage imageNamed:@"albumBlock"]];
    PlayerImageBlock.layer.masksToBounds = YES;
    PlayerImageBlock.layer.cornerRadius = 10;
    [self.view addSubview:PlayerImageBlock];
    
    //初始化TimeLabel
    TimeLabel = [[UILabel alloc]init];
    TimeLabel.backgroundColor = UIBACKGROUNDCOLOR;
    TimeLabel.font = [UIFont systemFontOfSize:15];
    TimeLabel.textColor = [UIColor blackColor];
    TimeLabel.textAlignment = NSTextAlignmentCenter;
    TimeLabel.frame = CGRectMake(PlayerImage_X_point, kPlayerImage_Y_point + kPlayerImageHeight + kLabel_Height_Distance * 1, kLabel_Width, kLabel_Height);
    [self.view addSubview:TimeLabel];

    //初始化TimeProgressBar
    TimeProgressBar = [[UIProgressView alloc]init];
    TimeProgressBar.frame = CGRectMake(PlayerImage_X_point, kPlayerImage_Y_point + kPlayerImageHeight + kLabel_Height_Distance * 3, kLabel_Width, kLabel_Height);
    [self.view addSubview:TimeProgressBar];
    
    //初始化ChannelLabel
    ChannelTitle = [[UILabel alloc]init];
    ChannelTitle.backgroundColor = UIBACKGROUNDCOLOR;
    ChannelTitle.font = [UIFont systemFontOfSize:15];
    ChannelTitle.textColor = [UIColor blackColor];
    ChannelTitle.textAlignment = NSTextAlignmentCenter;
    ChannelTitle.frame = CGRectMake(PlayerImage_X_point, kPlayerImage_Y_point + kPlayerImageHeight + kLabel_Height_Distance * 5, kLabel_Width, kLabel_Height);
    [self.view addSubview:ChannelTitle];
    
    //初始化SongTitle
    SongTitle = [[UILabel alloc]init];
    SongTitle.backgroundColor = UIBACKGROUNDCOLOR;
    SongTitle.font = [UIFont systemFontOfSize:25];
    SongTitle.textColor = [UIColor blackColor];
    SongTitle.textAlignment = NSTextAlignmentCenter;
    SongTitle.frame = CGRectMake(PlayerImage_X_point, kPlayerImage_Y_point + kPlayerImageHeight + kLabel_Height_Distance * 7, kLabel_Width, kLabel_Height);
    [self.view addSubview:SongTitle];
    
    //初始化SongArtist
    SongArtist = [[UILabel alloc]init];
    SongArtist.backgroundColor = UIBACKGROUNDCOLOR;
    SongArtist.font = [UIFont systemFontOfSize:15];
    SongArtist.textColor = [UIColor blackColor];
    SongArtist.textAlignment = NSTextAlignmentCenter;
    SongArtist.frame = CGRectMake(PlayerImage_X_point, kPlayerImage_Y_point + kPlayerImageHeight + kLabel_Height_Distance * 9, kLabel_Width, kLabel_Height);
    [self.view addSubview:SongArtist];
    
    //初始化PauseButton
    PauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [PauseButton setImage:[UIImage imageNamed:@"stop"] forState:UIControlStateNormal];
    [PauseButton addTarget:self action:@selector(PauseButton) forControlEvents:UIControlEventTouchUpInside];
    PauseButton.frame = CGRectMake(kButton_X_point, kPlayerImage_Y_point + kPlayerImageHeight + kLabel_Height_Distance * 10 + kButton_Height_Distance, kButton_Width, kButton_Height);
    [self.view addSubview:PauseButton];
    
    //初始化LikeButton
    LikeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [LikeButton setImage:[UIImage imageNamed:@"heart1"] forState:UIControlStateNormal];
    [LikeButton addTarget:self action:@selector(LikeButton) forControlEvents:UIControlEventTouchUpInside];
    LikeButton.frame = CGRectMake(kButton_X_point + kButton_Width_Distance * 1,kPlayerImage_Y_point + kPlayerImageHeight + kLabel_Height_Distance * 10 + kButton_Height_Distance , kButton_Width, kButton_Height);
    [self.view addSubview:LikeButton];
    
    //初始化DeleteButton
    DeleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [DeleteButton setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    [DeleteButton addTarget:self action:@selector(DeleteButton) forControlEvents:UIControlEventTouchUpInside];
    DeleteButton.frame = CGRectMake(kButton_X_point + kButton_Width_Distance * 2,kPlayerImage_Y_point + kPlayerImageHeight + kLabel_Height_Distance * 10 + kButton_Height_Distance , kButton_Width, kButton_Height);
    [self.view addSubview:DeleteButton];
    
    //初始化SkipButton
    SkipButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [SkipButton setImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
    [SkipButton addTarget:self action:@selector(SkipButton) forControlEvents:UIControlEventTouchUpInside];
    SkipButton.frame = CGRectMake(kButton_X_point + kButton_Width_Distance * 3,kPlayerImage_Y_point + kPlayerImageHeight + kLabel_Height_Distance * 10 + kButton_Height_Distance , kButton_Width, kButton_Height);
    [self.view addSubview:SkipButton];

}


- (IBAction)PauseButton
{
    if(isPlaying)
    {
        isPlaying = NO;
        PlayerImage.alpha = 0.2f;
        PlayerImageBlock.image = [UIImage imageNamed:@"albumBlock2"];
        [PauseButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        [appDelegate.VideoPlayer pause];
        //关闭计时器
        [Timer setFireDate:[NSDate distantFuture]];
    }
    else
    {
        isPlaying = YES;
        PlayerImage.alpha = 1.0f;
        PlayerImageBlock.image = [UIImage imageNamed:@"albumBlock"];
        [PauseButton setImage:[UIImage imageNamed:@"stop"] forState:UIControlStateNormal];
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
        [LikeButton setImage:[UIImage imageNamed:@"heart2"] forState:UIControlStateNormal];
        [doubanServer DoubanSongOperationWithType:@"r"];
        
    }
    else
    {
        appDelegate.playerInfo.CurrentSong.SongIsLike = @"0";
        [LikeButton setImage:[UIImage imageNamed:@"heart1"] forState:UIControlStateNormal];
    }
}

- (IBAction)DeleteButton
{
    if(!isPlaying)
    {
        isPlaying = YES;
        PlayerImage.alpha = 1.0f;
        PlayerImageBlock.image = [UIImage imageNamed:@"albumBlock"];
        [appDelegate.VideoPlayer play];
        [PauseButton setBackgroundImage:[UIImage imageNamed:@"stop"] forState:UIControlStateNormal];
    }
    [doubanServer DoubanSongOperationWithType:@"b"];

}

- (IBAction)SkipButton
{
    [Timer setFireDate:[NSDate distantFuture]];
    [appDelegate.VideoPlayer pause];
    if(!isPlaying)
    {
        PlayerImage.alpha = 1.0f;
        PlayerImageBlock.image = [UIImage imageNamed:@"albumBlock"];
    }
    [doubanServer DoubanSongOperationWithType:@"s"];
}





































@end
