//
//  DoubanServer.h
//  FrankieVideo_New
//
//  Created by frankie on 15/10/19.
//  Copyright © 2015年 frankieCompany. All rights reserved.
//

#import <Foundation/Foundation.h>


@class CaptchaImageInfo;
@class LoginInfo;


//使用代理
@protocol DoubanDelegate <NSObject>

@optional

-(void)setCaptchaImageWithURL:(NSString *) captchaImageURL;

-(void)setUserInfo;

-(void)loginSuccessful;

-(void)logoutSuccessful;

-(void)reloadTableView;

-(void)reloadTableViewCellWithIndexPath:(NSIndexPath *)indexPath;


//主屏幕显示哪个页面
//index : 1  PlayerView
//index : 2  ChannelView
//index : 3  LoginView
//index : 4  self
-(void)showViewWithIndex:(NSInteger)index;

@end




@interface DoubanServer : NSObject


@property(nonatomic,strong) CaptchaImageInfo * captchaImageInfo;

@property(nonatomic,weak) id<DoubanDelegate>delegate;

-(instancetype)initDoubanServer;

-(void)doubanSongOperationWithType:(NSString *)type;

-(void)doubanLoginWithLoginInfo:(LoginInfo *)loginInfo;

-(void)doubanLogout;

-(void)doubanLoadCaptchaImage;

-(void)doubanGetChannelGroup;

-(void)doubanGetChannelCellWithURLString:(NSString *)channelURLString;

@end
