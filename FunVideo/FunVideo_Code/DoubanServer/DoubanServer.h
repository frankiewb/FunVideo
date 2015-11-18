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

-(void)SetCaptchaImageWithURL:(NSString *) captchaImageURL;

-(void)SetUserInfo;

-(void)LoginSuccessful;

-(void)LogoutSuccessful;

-(void)ReloadTableView;

-(void)ReloadTableViewCellWithIndexPath:(NSIndexPath *)indexPath;


//主屏幕显示哪个页面
//index : 1  PlayerView
//index : 2  ChannelView
//index : 3  LoginView
//index : 4  self
-(void)ShowViewWithIndex:(NSInteger)Index;

@end




@interface DoubanServer : NSObject


@property(nonatomic,strong) CaptchaImageInfo * captchaImageInfo;

@property(nonatomic,weak) id<DoubanDelegate>delegate;

-(instancetype)initDoubanServer;

-(void)DoubanSongOperationWithType:(NSString *)Type;

-(void)DoubanLoginWithLoginInfo:(LoginInfo *)loginInfo;

-(void)DoubanLogout;

-(void)DoubanLoadCaptchaImage;

-(void)DoubanGetChannelGroup;

-(void)DoubanGetChannelCellWithURLString:(NSString *)ChannelURLString;

@end
