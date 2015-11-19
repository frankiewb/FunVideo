//
//  UserViewController.m
//  FunVideo
//
//  Created by frankie on 15/10/30.
//  Copyright © 2015年 FrankieCompany. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "UserViewController.h"
#include "UserInfo.h"
#import "ChannelInfo.h"
#include "ChannelGroup.h"
#include "DoubanServer.h"
#import "UIKIT+AFNetworking.h"
#import "UIImageView+WebCache.h"
#include "Commons.h"



static const NSString * USERIMAGEURL = @"http://img3.douban.com/icon/ul%@-1.jpg";
static const CGFloat kOrigin_Xpoint  = 85;
static const CGFloat kOrigin_Ypoint = 60;
static const CGFloat kUserImage_Width = 150;
static const CGFloat kUserImage_Height = 150;

static const CGFloat kUserName_Xpoint = 60;
static const CGFloat kUserName_Ypoint = 250;
static const CGFloat kUserName_Width = 200;
static const CGFloat kUserName_Height = 50;

static const CGFloat kPlayedLabel_Xpoint = 40;
static const CGFloat kPlayedLabel_Ypoint = 350;
static const CGFloat kPlayedLabel_Width = 100;
static const CGFloat kPlayedLabel_Height = 100;

static const CGFloat kBannedLabel_Xpoint = 180;
static const CGFloat kBannedLabel_Ypoint = 350;
static const CGFloat kBannedLabel_Width = 100;
static const CGFloat kBannedLabel_Height = 100;

static const CGFloat kLogoutButton_Xpoint = 0;
static const CGFloat kLogoutButton_Ypoint = 500;
static const CGFloat kLogoutButton_Width  = 320;
static const CGFloat kLogoutButton_Hegiht = 68;



@interface UserViewController()
{
    DoubanServer * doubanServer;
    
    AppDelegate * appDelegate;
    
    UserInfo * userInfo;
    
    UIImageView * userViewImage;
    
    UILabel * userNameLabel;
    
    UILabel * playedLabel;
    
    UILabel * bannedLabel;
    
    UIButton * logoutButton;
}



@end



@implementation UserViewController

-(void)viewDidLoad
{
    
    [super viewDidLoad];
    appDelegate =[[UIApplication sharedApplication]delegate];
    doubanServer = [[DoubanServer alloc]initDoubanServer];
    userInfo = appDelegate.userInfo;
    doubanServer.delegate = self;
    [self setupUI];
    [self setUserInfo];
}

-(void)setupUI
{
    /*设置主View背景*/
    self.view.backgroundColor = UIBACKGROUNDCOLOR;
    /*设置LoginImage */
    userViewImage = [[UIImageView alloc]init];
    userViewImage.backgroundColor = UIBACKGROUNDCOLOR;
    userViewImage.contentMode = UIViewContentModeScaleAspectFill;
    if(!userViewImage.clipsToBounds)
    {
        userViewImage.clipsToBounds = YES;
    }
    userViewImage.frame = CGRectMake(kOrigin_Xpoint, kOrigin_Ypoint, kUserImage_Width, kUserImage_Height);
    userViewImage.layer.cornerRadius = userViewImage.frame.size.width/2.0;
    
    //给登录图片增加手势
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                               action:@selector(loginImageTapped)];
    [singleTap setNumberOfTapsRequired:1];
    [userViewImage addGestureRecognizer:singleTap];
    [self.view addSubview:userViewImage];
    
    
    /*设置UserNameLabel*/
    userNameLabel = [[UILabel alloc]init];
    userNameLabel.backgroundColor = UIBACKGROUNDCOLOR;
    userNameLabel.textAlignment = NSTextAlignmentCenter;
    [userNameLabel setFont:[UIFont boldSystemFontOfSize:30]];
    userNameLabel.frame = CGRectMake(kUserName_Xpoint, kUserName_Ypoint, kUserName_Width, kUserName_Height);
    [self.view addSubview:userNameLabel];
    
    
    /*设置PlayedLabel*/
    playedLabel = [[UILabel alloc]init];
    playedLabel.numberOfLines = 0;
    playedLabel.backgroundColor = UIBACKGROUNDCOLOR;
    playedLabel.textAlignment = NSTextAlignmentCenter;
    [playedLabel setFont:[UIFont boldSystemFontOfSize:20]];
    playedLabel.frame = CGRectMake(kPlayedLabel_Xpoint, kPlayedLabel_Ypoint, kPlayedLabel_Width, kPlayedLabel_Height);
    [self.view addSubview:playedLabel];
    
    
    /*设置BannedLabel*/
    bannedLabel = [[UILabel alloc]init];
    bannedLabel.numberOfLines = 0;
    bannedLabel.backgroundColor = UIBACKGROUNDCOLOR;
    bannedLabel.textAlignment = NSTextAlignmentCenter;
    [bannedLabel setFont:[UIFont boldSystemFontOfSize:20]];
    bannedLabel.frame = CGRectMake(kBannedLabel_Xpoint, kBannedLabel_Ypoint, kBannedLabel_Width, kBannedLabel_Height);
    [self.view addSubview:bannedLabel];
    
    /*设置LogoutButton*/
    
    logoutButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [logoutButton setTitle:@"登 出" forState:UIControlStateNormal];
    [logoutButton.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    logoutButton.backgroundColor = UIBACKGROUNDCOLOR;
    [logoutButton addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    logoutButton.frame = CGRectMake(kLogoutButton_Xpoint, kLogoutButton_Ypoint, kLogoutButton_Width, kLogoutButton_Hegiht);
    [self.view addSubview:logoutButton];
    
    
}

-(void)logoutSuccessful
{
    [self setUserInfo];
    NSLog(@"LOGOUT_SUCCESSFUL");
}



-(void)loginImageTapped
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController * loginVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"loginVC"];
    
    
    //!!!!重要！
    loginVC.delegate = self;
    
    
    
    
    [self presentViewController:loginVC animated:YES completion:nil];
}

-(void)logout
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"登出"
                                                       message:@"主人，你这就要走了咩。。"
                                                      delegate:self
                                             cancelButtonTitle:@"算了。。不忍心。。"
                                             otherButtonTitles:@"朕去意已决，爱卿勿拦！", nil];
    [alertView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            break;
        case 1:
            [doubanServer doubanLogout];
        default:
            break;
    }
}

-(void)setUserInfo
{
    if(doubanServer == nil)
    {
        doubanServer = [doubanServer initDoubanServer];
    }
    if(userInfo.cookies)
    {
        [userViewImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:USERIMAGEURL,userInfo.userID]]];
        userViewImage.userInteractionEnabled = NO;
        
        userNameLabel.text = userInfo.userName;
        playedLabel.text = [NSString stringWithFormat:@"Played \n \n %@",userInfo.plyaed];
        bannedLabel.text = [NSString stringWithFormat:@"Banned \n \n %@",userInfo.banned];
        logoutButton.hidden = NO;
        
        //此时设置ChannelGroup第一数组第一个cell的值
        if([appDelegate.channelGroup.myRedHeartChannelCellArray count] != 0)
        {
            ChannelInfo * userChannelInfo = [appDelegate.channelGroup.myRedHeartChannelCellArray objectAtIndex:0];
            userChannelInfo.channelName = userInfo.userName;
            userChannelInfo.channelCoverURL = [NSString stringWithFormat:USERIMAGEURL,userInfo.userID];
            NSIndexPath * indexpath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.delegate reloadTableViewCellWithIndexPath:indexpath];
        }
    }
    else
    {
        [userViewImage setImage:[UIImage imageNamed:@"login"]];
        userViewImage.userInteractionEnabled = YES;
        userNameLabel.text = @"";
        playedLabel.text = [NSString stringWithFormat:@"Played \n \n %@",@"0"];;
        bannedLabel.text = [NSString stringWithFormat:@"Banned \n \n %@",@"0"];
        logoutButton.hidden = YES;
        
        //此时设置ChannelGroup第一数组第一个cell的值
        if([appDelegate.channelGroup.myRedHeartChannelCellArray count] != 0)
        {
            ChannelInfo * UserChannelInfo = [appDelegate.channelGroup.myRedHeartChannelCellArray objectAtIndex:0];
            UserChannelInfo.channelName = @"未登录";
            NSIndexPath * indexpath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.delegate reloadTableViewCellWithIndexPath:indexpath];
        }
        
    }
}


@end

