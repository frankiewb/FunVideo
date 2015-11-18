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
    
    UIImageView * UserViewImage;
    
    UILabel * UserNameLabel;
    
    UILabel * PlayedLabel;
    
    UILabel * BannedLabel;
    
    UIButton * LogoutButton;
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
    [self SetupUI];
    [self SetUserInfo];
}

-(void)SetupUI
{
    /*设置主View背景*/
    self.view.backgroundColor = UIBACKGROUNDCOLOR;
    /*设置LoginImage */
    UserViewImage = [[UIImageView alloc]init];
    UserViewImage.backgroundColor = UIBACKGROUNDCOLOR;
    UserViewImage.contentMode = UIViewContentModeScaleAspectFill;
    if(!UserViewImage.clipsToBounds)
    {
        UserViewImage.clipsToBounds = YES;
    }
    UserViewImage.frame = CGRectMake(kOrigin_Xpoint, kOrigin_Ypoint, kUserImage_Width, kUserImage_Height);
    UserViewImage.layer.cornerRadius = UserViewImage.frame.size.width/2.0;
    
    //给登录图片增加手势
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                               action:@selector(loginImageTapped)];
    [singleTap setNumberOfTapsRequired:1];
    [UserViewImage addGestureRecognizer:singleTap];
    [self.view addSubview:UserViewImage];
    
    
    /*设置UserNameLabel*/
    UserNameLabel = [[UILabel alloc]init];
    UserNameLabel.backgroundColor = UIBACKGROUNDCOLOR;
    UserNameLabel.textAlignment = NSTextAlignmentCenter;
    [UserNameLabel setFont:[UIFont boldSystemFontOfSize:30]];
    UserNameLabel.frame = CGRectMake(kUserName_Xpoint, kUserName_Ypoint, kUserName_Width, kUserName_Height);
    [self.view addSubview:UserNameLabel];
    
    
    /*设置PlayedLabel*/
    PlayedLabel = [[UILabel alloc]init];
    PlayedLabel.numberOfLines = 0;
    PlayedLabel.backgroundColor = UIBACKGROUNDCOLOR;
    PlayedLabel.textAlignment = NSTextAlignmentCenter;
    [PlayedLabel setFont:[UIFont boldSystemFontOfSize:20]];
    PlayedLabel.frame = CGRectMake(kPlayedLabel_Xpoint, kPlayedLabel_Ypoint, kPlayedLabel_Width, kPlayedLabel_Height);
    [self.view addSubview:PlayedLabel];
    
    
    /*设置BannedLabel*/
    BannedLabel = [[UILabel alloc]init];
    BannedLabel.numberOfLines = 0;
    BannedLabel.backgroundColor = UIBACKGROUNDCOLOR;
    BannedLabel.textAlignment = NSTextAlignmentCenter;
    [BannedLabel setFont:[UIFont boldSystemFontOfSize:20]];
    BannedLabel.frame = CGRectMake(kBannedLabel_Xpoint, kBannedLabel_Ypoint, kBannedLabel_Width, kBannedLabel_Height);
    [self.view addSubview:BannedLabel];
    
    /*设置LogoutButton*/
    
    LogoutButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [LogoutButton setTitle:@"登 出" forState:UIControlStateNormal];
    [LogoutButton.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    LogoutButton.backgroundColor = UIBACKGROUNDCOLOR;
    [LogoutButton addTarget:self action:@selector(Logout) forControlEvents:UIControlEventTouchUpInside];
    LogoutButton.frame = CGRectMake(kLogoutButton_Xpoint, kLogoutButton_Ypoint, kLogoutButton_Width, kLogoutButton_Hegiht);
    [self.view addSubview:LogoutButton];
    
    
}

-(void)LogoutSuccessful
{
    [self SetUserInfo];
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

-(void)Logout
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
            [doubanServer DoubanLogout];
        default:
            break;
    }
}

-(void)SetUserInfo
{
    if(doubanServer == nil)
    {
        doubanServer = [doubanServer initDoubanServer];
    }
    if(userInfo.Cookies)
    {
        [UserViewImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:USERIMAGEURL,userInfo.UserID]]];
        UserViewImage.userInteractionEnabled = NO;
        
        UserNameLabel.text = userInfo.UserName;
        PlayedLabel.text = [NSString stringWithFormat:@"Played \n \n %@",userInfo.Plyaed];
        BannedLabel.text = [NSString stringWithFormat:@"Banned \n \n %@",userInfo.Banned];
        LogoutButton.hidden = NO;
        
        //此时设置ChannelGroup第一数组第一个cell的值
        if([appDelegate.channelGroup.MyRedHeartChannelCellArray count] != 0)
        {
            ChannelInfo * UserChannelInfo = [appDelegate.channelGroup.MyRedHeartChannelCellArray objectAtIndex:0];
            UserChannelInfo.ChannelName = userInfo.UserName;
            UserChannelInfo.ChannelCoverURL = [NSString stringWithFormat:USERIMAGEURL,userInfo.UserID];
            NSIndexPath * indexpath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.delegate ReloadTableViewCellWithIndexPath:indexpath];
        }
    }
    else
    {
        [UserViewImage setImage:[UIImage imageNamed:@"login"]];
        UserViewImage.userInteractionEnabled = YES;
        UserNameLabel.text = @"";
        PlayedLabel.text = [NSString stringWithFormat:@"Played \n \n %@",@"0"];;
        BannedLabel.text = [NSString stringWithFormat:@"Banned \n \n %@",@"0"];
        LogoutButton.hidden = YES;
        
        //此时设置ChannelGroup第一数组第一个cell的值
        if([appDelegate.channelGroup.MyRedHeartChannelCellArray count] != 0)
        {
            ChannelInfo * UserChannelInfo = [appDelegate.channelGroup.MyRedHeartChannelCellArray objectAtIndex:0];
            UserChannelInfo.ChannelName = @"未登录";
            NSIndexPath * indexpath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.delegate ReloadTableViewCellWithIndexPath:indexpath];
        }
        
    }
}


@end

