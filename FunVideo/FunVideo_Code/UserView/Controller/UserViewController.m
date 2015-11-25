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
#import "UserInfo.h"
#import "ChannelInfo.h"
#import "ChannelGroup.h"
#import "DoubanServer.h"
#import "UIKIT+AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "Commons.h"
#import "Masonry.h"



static const NSString * USERIMAGEURL = @"http://img3.douban.com/icon/ul%@-1.jpg";
static const CGFloat kUserViewImageWidthAndHeightFactor = 0.47;
static const CGFloat UserViewImageHeightDistance = 60;

static const CGFloat userNameLabelTopFactor = 1.2;
static const CGFloat kUserNameLabelWidthFactor = 0.55;
static const CGFloat kUserNameLabelHeightFactor = 0.1;

static const CGFloat kplayedLabelCenterXFactor = 0.5625;
static const CGFloat kbannedLabelCenterXFactor = 1.4375;
static const CGFloat kLabelHeightDistanceFactor = 1.17;
static const CGFloat kLabelWidthFactor = 0.277;
static const CGFloat kLabelHeightFactor = 0.177;

static const CGFloat kbuttonHeightDistanceFactor = 1.05;
static const CGFloat kbuttonWidthFactor = 1;
static const CGFloat kbuttonHeightFactor = 0.15;




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
    [self p_setupUI];
    [self p_setUpAutoLayOut];
    [self p_setUserInfo];
}

-(void)p_setupUI
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
    //给登录图片增加手势
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                               action:@selector(p_loginImageTapped)];
    [singleTap setNumberOfTapsRequired:1];
    [userViewImage addGestureRecognizer:singleTap];
    
    
    [self.view addSubview:userViewImage];
    
    
    /*设置UserNameLabel*/
    userNameLabel = [[UILabel alloc]init];
    userNameLabel.backgroundColor = UIBACKGROUNDCOLOR;
    userNameLabel.textAlignment = NSTextAlignmentCenter;
    [userNameLabel setFont:[UIFont boldSystemFontOfSize:30]];    
    [self.view addSubview:userNameLabel];
    
    
    /*设置PlayedLabel*/
    playedLabel = [[UILabel alloc]init];
    playedLabel.numberOfLines = 0;
    playedLabel.backgroundColor = UIBACKGROUNDCOLOR;
    playedLabel.textAlignment = NSTextAlignmentCenter;
    [playedLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [self.view addSubview:playedLabel];
    
    
    /*设置BannedLabel*/
    bannedLabel = [[UILabel alloc]init];
    bannedLabel.numberOfLines = 0;
    bannedLabel.backgroundColor = UIBACKGROUNDCOLOR;
    bannedLabel.textAlignment = NSTextAlignmentCenter;
    [bannedLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [self.view addSubview:bannedLabel];
    
    /*设置LogoutButton*/
    logoutButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [logoutButton setTitle:@"登 出" forState:UIControlStateNormal];
    [logoutButton.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    logoutButton.backgroundColor = UIBACKGROUNDCOLOR;
    [logoutButton addTarget:self action:@selector(p_logout) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logoutButton];
    
    
}






//解决自动布局下圆形生成办法
-(void)viewDidLayoutSubviews
{
    userViewImage.layer.masksToBounds = YES;
    userViewImage.layer.cornerRadius = userViewImage.frame.size.width/2.0;
}




-(void)p_setUpAutoLayOut
{
    /*设置主View背景*/
    [userViewImage mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.top.equalTo(self.view.mas_top).with.offset(UserViewImageHeightDistance);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.and.height.equalTo(self.view.mas_width).with.multipliedBy(kUserViewImageWidthAndHeightFactor);
    }];
    
    /*设置UserNameLabel*/
    [userNameLabel mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.top.equalTo(userViewImage.mas_bottom).with.multipliedBy(userNameLabelTopFactor);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.equalTo(self.view.mas_width).with.multipliedBy(kUserNameLabelWidthFactor);
        make.height.equalTo(self.view.mas_height).with.multipliedBy(kUserNameLabelHeightFactor);
    }];
    
    /*设置PlayedLabel*/
    [playedLabel mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.top.equalTo(userNameLabel.mas_bottom).with.multipliedBy(kLabelHeightDistanceFactor);
        make.centerX.equalTo(self.view.mas_centerX).with.multipliedBy(kplayedLabelCenterXFactor);
        make.width.equalTo(self.view.mas_width).with.multipliedBy(kLabelWidthFactor);
        make.height.equalTo(self.view.mas_height).with.multipliedBy(kLabelHeightFactor);
    }];
    
    /*设置BannedLabel*/
    [bannedLabel mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.top.equalTo(userNameLabel.mas_bottom).with.multipliedBy(kLabelHeightDistanceFactor);
        make.centerX.equalTo(self.view.mas_centerX).with.multipliedBy(kbannedLabelCenterXFactor);
        make.width.equalTo(self.view.mas_width).with.multipliedBy(kLabelWidthFactor);
        make.height.equalTo(self.view.mas_height).with.multipliedBy(kLabelHeightFactor);
        
    }];
    
    /*设置LogoutButton*/
    [logoutButton mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.top.equalTo(playedLabel.mas_bottom).with.multipliedBy(kbuttonHeightDistanceFactor);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.equalTo(self.view.mas_width).with.multipliedBy(kbuttonWidthFactor);
        make.height.equalTo(self.view.mas_height).with.multipliedBy(kbuttonHeightFactor);
    }];
}





-(void)doubanDelegate_logoutSuccessful
{
    [self p_setUserInfo];
    NSLog(@"LOGOUT_SUCCESSFUL");
}



-(void)p_loginImageTapped
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController * loginVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"loginVC"];
    
    
    //!!!!重要！
    loginVC.douban_delegate = self;
    loginVC.loginView_delegate = self;
    
    
    
    
    [self presentViewController:loginVC animated:YES completion:nil];
}

-(void)p_logout
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


-(void)loginViewDelegate_setUserInfo
{
    [self p_setUserInfo];
}

-(void)p_setUserInfo
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
            [self.douban_delegate doubanDelegate_reloadTableViewCellWithIndexPath:indexpath];
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
            [self.douban_delegate doubanDelegate_reloadTableViewCellWithIndexPath:indexpath];
        }
        
    }
}




@end

