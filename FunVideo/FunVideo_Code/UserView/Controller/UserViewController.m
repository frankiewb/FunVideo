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
}

@property (nonatomic,strong) UIImageView * UserViewImage;

@property (nonatomic,strong) UILabel * UserNameLabel;

@property (nonatomic,strong) UILabel * PlayedLabel;

@property (nonatomic,strong) UILabel * BannedLabel;

@property (nonatomic,strong) UIButton * LogoutButton;

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
    _UserViewImage = [[UIImageView alloc]init];
    _UserViewImage.backgroundColor = UIBACKGROUNDCOLOR;
    _UserViewImage.contentMode = UIViewContentModeScaleAspectFill;
    if(!_UserViewImage.clipsToBounds)
    {
        _UserViewImage.clipsToBounds = YES;
    }
    _UserViewImage.frame = CGRectMake(kOrigin_Xpoint, kOrigin_Ypoint, kUserImage_Width, kUserImage_Height);
    _UserViewImage.layer.cornerRadius = _UserViewImage.frame.size.width/2.0;
    
    //给登录图片增加手势
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                               action:@selector(loginImageTapped)];
    [singleTap setNumberOfTapsRequired:1];
    [_UserViewImage addGestureRecognizer:singleTap];
    [self.view addSubview:_UserViewImage];
    
    
    /*设置UserNameLabel*/
    _UserNameLabel = [[UILabel alloc]init];
    _UserNameLabel.backgroundColor = UIBACKGROUNDCOLOR;
    _UserNameLabel.textAlignment = NSTextAlignmentCenter;
    [_UserNameLabel setFont:[UIFont boldSystemFontOfSize:30]];
    _UserNameLabel.frame = CGRectMake(kUserName_Xpoint, kUserName_Ypoint, kUserName_Width, kUserName_Height);
    [self.view addSubview:_UserNameLabel];
    
    
    /*设置PlayedLabel*/
    _PlayedLabel = [[UILabel alloc]init];
    _PlayedLabel.numberOfLines = 0;
    _PlayedLabel.backgroundColor = UIBACKGROUNDCOLOR;
    _PlayedLabel.textAlignment = NSTextAlignmentCenter;
    [_PlayedLabel setFont:[UIFont boldSystemFontOfSize:20]];
    _PlayedLabel.frame = CGRectMake(kPlayedLabel_Xpoint, kPlayedLabel_Ypoint, kPlayedLabel_Width, kPlayedLabel_Height);
    [self.view addSubview:_PlayedLabel];
    
    
    /*设置BannedLabel*/
    _BannedLabel = [[UILabel alloc]init];
    _BannedLabel.numberOfLines = 0;
    _BannedLabel.backgroundColor = UIBACKGROUNDCOLOR;
    _BannedLabel.textAlignment = NSTextAlignmentCenter;
    [_BannedLabel setFont:[UIFont boldSystemFontOfSize:20]];
    _BannedLabel.frame = CGRectMake(kBannedLabel_Xpoint, kBannedLabel_Ypoint, kBannedLabel_Width, kBannedLabel_Height);
    [self.view addSubview:_BannedLabel];
    
    /*设置LogoutButton*/
    
    _LogoutButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_LogoutButton setTitle:@"登 出" forState:UIControlStateNormal];
    [_LogoutButton.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    _LogoutButton.backgroundColor = UIBACKGROUNDCOLOR;
    [_LogoutButton addTarget:self action:@selector(Logout) forControlEvents:UIControlEventTouchUpInside];
    _LogoutButton.frame = CGRectMake(kLogoutButton_Xpoint, kLogoutButton_Ypoint, kLogoutButton_Width, kLogoutButton_Hegiht);
    [self.view addSubview:_LogoutButton];
    
    
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
        [_UserViewImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:USERIMAGEURL,userInfo.UserID]]];
        _UserViewImage.userInteractionEnabled = NO;
        
        _UserNameLabel.text = userInfo.UserName;
        _PlayedLabel.text = [NSString stringWithFormat:@"Played \n \n %@",userInfo.Plyaed];
        _BannedLabel.text = [NSString stringWithFormat:@"Banned \n \n %@",userInfo.Banned];
        _LogoutButton.hidden = NO;
        
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
        [_UserViewImage setImage:[UIImage imageNamed:@"login"]];
        _UserViewImage.userInteractionEnabled = YES;
        _UserNameLabel.text = @"";
        _PlayedLabel.text = [NSString stringWithFormat:@"Played \n \n %@",@"0"];;
        _BannedLabel.text = [NSString stringWithFormat:@"Banned \n \n %@",@"0"];
        _LogoutButton.hidden = YES;
        
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

