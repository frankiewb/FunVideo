//
//  DoubanServer.h
//  FrankieVideo_New
//
//  Created by frankie on 15/10/19.
//  Copyright © 2015年 frankieCompany. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DoubanProtocol.h"


@class CaptchaImageInfo;
@class LoginInfo;

@interface DoubanServer : NSObject<DoubanDelegate>

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
