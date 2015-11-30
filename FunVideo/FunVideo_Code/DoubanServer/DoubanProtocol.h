//
//  DoubanProtocol.h
//  FunVideo
//
//  Created by frankie on 15/11/30.
//  Copyright © 2015年 FrankieCompany. All rights reserved.
//

#import <Foundation/Foundation.h>


//使用代理
@protocol DoubanDelegate <NSObject>

@optional

-(void)setCaptchaImageWithURL:(NSString *) captchaImageURL;

-(void)loginSuccessful;

-(void)loginFail:(NSString *)errorMessege;

-(void)logoutSuccessful;

-(void)getSongListFail;

-(void)reloadTableView;

-(void)reloadTableViewCellWithIndexPath:(NSIndexPath *)indexPath;

-(void)FlashUserInfoInUserView;


//主屏幕显示哪个页面
//index : 1  PlayerView
//index : 2  ChannelView
//index : 3  LoginView
//index : 4  self
-(void)showViewWithIndex:(NSInteger)index;

@end
