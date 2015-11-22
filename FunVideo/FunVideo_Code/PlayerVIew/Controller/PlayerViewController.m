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
#import "NSTimer + FunVideo.h"


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
    NSTimer *timer;
    int currentTimeMinutes;
    int currentTImeSeconds;
    NSMutableString *currentTimeString;
    int totalTImeMinutes;
    int totalTimeSeconds;
    NSMutableString * totalTImeString;
    NSMutableString * timerLabelString;
    
    
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
    
    UIImageView *playerImage;
    
    UIImageView *playerImageBlock;
    
    UIProgressView *timeProgressBar;
    
    UILabel *timeLabel;
    
    UILabel *channelTitle;
    
    UILabel *songTitle;
    
    UILabel *songArtist;
    
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
    [self p_setUpUI];
    [self p_setupPlayerInfo];
    [self p_addNotification];
    [self p_setupGesture];
    
    
    
    
    
    
//解决NSTimer保留环问题
//    timer = [NSTimer scheduledTimerWithTimeInterval:0.02
//                                             target:self
//                                           selector:@selector(p_updateProgress)
//                                           userInfo:nil
//                                            repeats:YES];
    
    
    __weak PlayerViewController * weakSelf = self;
     timer = [NSTimer FunVideo_scheduledTimerWithTimeInterval:0.02
                                                        block:^{[weakSelf p_updateProgress];}
                                                      repeats:YES];
}






-(void)viewDidAppear:(BOOL)animated
{
    playerImage.layer.cornerRadius = playerImage.bounds.size.width/2.0;
    playerImage.layer.masksToBounds = YES;
    [super viewDidAppear:animated];
    [self p_flashSongInfo];
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

-(void)p_updateProgress
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





-(void)p_addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(p_startPlay)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(p_flashSongInfo)
                                                 name:MPMoviePlayerLoadStateDidChangeNotification
                                               object:nil];
}


-(void)p_setupPlayerInfo
{
    doubanServer = [[DoubanServer alloc]initDoubanServer];
    [doubanServer doubanSongOperationWithType:@"n"];

}

-(void)p_setupGesture
{
    playerImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(p_pauseButton)];
    [singleTap setNumberOfTouchesRequired:1];
    [playerImage addGestureRecognizer:singleTap];
}


-(void)p_startPlay
{
    doubanServer = [[DoubanServer alloc]initDoubanServer];
    [doubanServer doubanSongOperationWithType:@"p"];
}



-(void)p_flashSongInfo
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
    NSString * playerImageName = [NSString stringWithFormat:@"%@_imageName",appDelegate.playerInfo.currentSong.songTitle];
    NSURL * imageURL = [NSURL URLWithString:appDelegate.playerInfo.currentSong.songPictureUrl];
    //[_PlayerImage setImageWithURL:imageURL
                 //placeholderImage:[UIImage imageNamed:playerImageName]];
    //采用SDIMageCache技术缓存
    [playerImage sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"playerImageName"]];
    NSLog(@"%@",playerImage.image);
    
    //初始化各UI界面
    channelTitle.text = [NSString stringWithFormat:@"♪%@♪",appDelegate.playerInfo.currentChannel.channelName];
    songArtist.text = appDelegate.playerInfo.currentSong.songArtist;
    songTitle.text = appDelegate.playerInfo.currentSong.songTitle;
    //Chanel没设计呢
    
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
    [timer setFireDate:[NSDate date]];
    [self p_configVideoPlayerInfo];
    
}

-(void)p_configVideoPlayerInfo
{
    if(NSClassFromString(@"MPNowPlayingInfoCenter"))
    {
        if(appDelegate.playerInfo.currentSong.songTitle != nil)
        {
            NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
            [dict setObject:appDelegate.playerInfo.currentSong.songTitle forKey:MPMediaItemPropertyTitle];
            [dict setObject:appDelegate.playerInfo.currentSong.songArtist forKey:MPMediaItemPropertyArtist];
            UIImage * playerViewImage = playerImage.image;
            if(playerViewImage != nil)
            {
                [dict setObject:[[MPMediaItemArtwork alloc]initWithImage:playerViewImage]forKey:MPMediaItemPropertyArtwork];
            }
            [dict setObject:[NSNumber numberWithFloat:[appDelegate.playerInfo.currentSong.songTimeLong floatValue]] forKey:MPMediaItemPropertyPlaybackDuration];
            [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];
        }
    }
}

-(void)p_setUpUI
{
    //初始化背景颜色
    self.view.backgroundColor = UIBACKGROUNDCOLOR;
    
    //初始化PlyaerImage界面
    playerImage = [[UIImageView alloc]init];
    playerImage.frame = CGRectMake(PlayerImage_X_point, kPlayerImage_Y_point, kPlayerImageWidth, kPlayerImageHeight);
    playerImage.layer.masksToBounds = YES;
    playerImage.layer.cornerRadius = 10;
    [self.view addSubview:playerImage];
    
   
    //初始化PlayerImageBlock界面
    playerImageBlock = [[UIImageView alloc]init];
    playerImageBlock.frame = CGRectMake(PlayerImage_X_point, kPlayerImage_Y_point, kPlayerImageWidth, kPlayerImageHeight);
    [playerImageBlock setImage:[UIImage imageNamed:@"albumBlock"]];
    playerImageBlock.layer.masksToBounds = YES;
    playerImageBlock.layer.cornerRadius = 10;
    [self.view addSubview:playerImageBlock];
    
    //初始化TimeLabel
    timeLabel = [[UILabel alloc]init];
    timeLabel.backgroundColor = UIBACKGROUNDCOLOR;
    timeLabel.font = [UIFont systemFontOfSize:15];
    timeLabel.textColor = [UIColor blackColor];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.frame = CGRectMake(PlayerImage_X_point, kPlayerImage_Y_point + kPlayerImageHeight + kLabel_Height_Distance * 1, kLabel_Width, kLabel_Height);
    [self.view addSubview:timeLabel];

    //初始化TimeProgressBar
    timeProgressBar = [[UIProgressView alloc]init];
    timeProgressBar.frame = CGRectMake(PlayerImage_X_point, kPlayerImage_Y_point + kPlayerImageHeight + kLabel_Height_Distance * 3, kLabel_Width, kLabel_Height);
    [self.view addSubview:timeProgressBar];
    
    //初始化ChannelLabel
    channelTitle = [[UILabel alloc]init];
    channelTitle.backgroundColor = UIBACKGROUNDCOLOR;
    channelTitle.font = [UIFont systemFontOfSize:15];
    channelTitle.textColor = [UIColor blackColor];
    channelTitle.textAlignment = NSTextAlignmentCenter;
    channelTitle.frame = CGRectMake(PlayerImage_X_point, kPlayerImage_Y_point + kPlayerImageHeight + kLabel_Height_Distance * 5, kLabel_Width, kLabel_Height);
    [self.view addSubview:channelTitle];
    
    //初始化SongTitle
    songTitle = [[UILabel alloc]init];
    songTitle.backgroundColor = UIBACKGROUNDCOLOR;
    songTitle.font = [UIFont systemFontOfSize:25];
    songTitle.textColor = [UIColor blackColor];
    songTitle.textAlignment = NSTextAlignmentCenter;
    songTitle.frame = CGRectMake(PlayerImage_X_point, kPlayerImage_Y_point + kPlayerImageHeight + kLabel_Height_Distance * 7, kLabel_Width, kLabel_Height);
    [self.view addSubview:songTitle];
    
    //初始化SongArtist
    songArtist = [[UILabel alloc]init];
    songArtist.backgroundColor = UIBACKGROUNDCOLOR;
    songArtist.font = [UIFont systemFontOfSize:15];
    songArtist.textColor = [UIColor blackColor];
    songArtist.textAlignment = NSTextAlignmentCenter;
    songArtist.frame = CGRectMake(PlayerImage_X_point, kPlayerImage_Y_point + kPlayerImageHeight + kLabel_Height_Distance * 9, kLabel_Width, kLabel_Height);
    [self.view addSubview:songArtist];
    
    //初始化PauseButton
    pauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [pauseButton setImage:[UIImage imageNamed:@"stop"] forState:UIControlStateNormal];
    [pauseButton addTarget:self action:@selector(p_pauseButton) forControlEvents:UIControlEventTouchUpInside];
    pauseButton.frame = CGRectMake(kButton_X_point, kPlayerImage_Y_point + kPlayerImageHeight + kLabel_Height_Distance * 10 + kButton_Height_Distance, kButton_Width, kButton_Height);
    [self.view addSubview:pauseButton];
    
    //初始化LikeButton
    likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [likeButton setImage:[UIImage imageNamed:@"heart1"] forState:UIControlStateNormal];
    [likeButton addTarget:self action:@selector(p_likeButton) forControlEvents:UIControlEventTouchUpInside];
    likeButton.frame = CGRectMake(kButton_X_point + kButton_Width_Distance * 1,kPlayerImage_Y_point + kPlayerImageHeight + kLabel_Height_Distance * 10 + kButton_Height_Distance , kButton_Width, kButton_Height);
    [self.view addSubview:likeButton];
    
    //初始化DeleteButton
    deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteButton setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(p_deleteButton) forControlEvents:UIControlEventTouchUpInside];
    deleteButton.frame = CGRectMake(kButton_X_point + kButton_Width_Distance * 2,kPlayerImage_Y_point + kPlayerImageHeight + kLabel_Height_Distance * 10 + kButton_Height_Distance , kButton_Width, kButton_Height);
    [self.view addSubview:deleteButton];
    
    //初始化SkipButton
    skipButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [skipButton setImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
    [skipButton addTarget:self action:@selector(p_skipButton) forControlEvents:UIControlEventTouchUpInside];
    skipButton.frame = CGRectMake(kButton_X_point + kButton_Width_Distance * 3,kPlayerImage_Y_point + kPlayerImageHeight + kLabel_Height_Distance * 10 + kButton_Height_Distance , kButton_Width, kButton_Height);
    [self.view addSubview:skipButton];

}


- (IBAction)p_pauseButton
{
    if(isPlaying)
    {
        isPlaying = NO;
        playerImage.alpha = 0.2f;
        playerImageBlock.image = [UIImage imageNamed:@"albumBlock2"];
        [pauseButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        [appDelegate.VideoPlayer pause];
        //关闭计时器
        [timer setFireDate:[NSDate distantFuture]];
    }
    else
    {
        isPlaying = YES;
        playerImage.alpha = 1.0f;
        playerImageBlock.image = [UIImage imageNamed:@"albumBlock"];
        [pauseButton setImage:[UIImage imageNamed:@"stop"] forState:UIControlStateNormal];
        [appDelegate.VideoPlayer play];
        //开启计时器
        [timer setFireDate:[NSDate date]];
    }
}

- (IBAction)p_likeButton
{
    if(![appDelegate.playerInfo.currentSong.songIsLike intValue])
    {
        appDelegate.playerInfo.currentSong.songIsLike = @"1";
        [likeButton setImage:[UIImage imageNamed:@"heart2"] forState:UIControlStateNormal];
        [doubanServer doubanSongOperationWithType:@"r"];
        
    }
    else
    {
        appDelegate.playerInfo.currentSong.songIsLike = @"0";
        [likeButton setImage:[UIImage imageNamed:@"heart1"] forState:UIControlStateNormal];
    }
}

- (IBAction)p_deleteButton
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

- (IBAction)p_skipButton
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
