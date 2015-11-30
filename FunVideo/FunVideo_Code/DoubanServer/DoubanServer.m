//
//  DoubanServer.m
//  FrankieVideo_New
//
//  Created by frankie on 15/10/19.
//  Copyright © 2015年 frankieCompany. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "DoubanServer.h"
#import "AppDelegate.h"
#import "UserInfo.h"
#import "Commons.h"
#import "PlayerInfo.h"
#import "LoginInfo.h"
#import "CaptchaImageInfo.h"
#import "ChannelGroup.h"
#import "ChannelInfo.h"
#import "SongInfo.h"


#define PLAYERURLFORMATSTRING     @"http://douban.fm/j/mine/playlist?type=%@&sid=%@&pt=%f&channel=%@&from=mainsite"
#define USERIMAGEURL              @"http://img3.douban.com/icon/ul%@-1.jpg"
#define LOGINURLSTRING            @"http://douban.fm/j/login"
#define LOGOUTURLSTRING           @"http://douban.fm/partner/logout"
#define CAPTCHAIDURLSTRING        @"http://douban.fm/j/new_captcha"
#define CAPTCHAIMGURLFORMATSTRING @"http://douban.fm/misc/captcha?size=m&id=%@"
#define LOGINCHANNELURL           @"http://douban.fm/j/explore/get_login_chls?uk="
#define TOTALCHANNELURL           @"http://douban.fm/j/explore/up_trending_channels"

//频道：频道ID
//语言年代兆赫
static const NSInteger HUAYU_MHz               = 1;
static const NSInteger OUMEI_MHz               = 2;
static const NSInteger YUEYU_MHz               = 6;
static const NSInteger BALING_MHz              = 4;
static const NSInteger JIULING_MHz             = 5;
//风格流派兆赫
static const NSInteger YAOGUN_MHz              = 7;
static const NSInteger MINYAO_MHz              = 8;
static const NSInteger QINGYINYUE_MHz          = 9;
static const NSInteger DIANYINGYUANSHENG_MHz   = 10;
static const NSInteger XIAOQINGXIN_MHz         = 76;
static const NSInteger JAZZ_MHz                = 13;
static const NSInteger GUDIAN_MHz              = 27;
//心情场景兆赫
static const NSInteger XINGE_MHz               = 61;
static const NSInteger COFFEE_MHz              = 32;
static const NSInteger WORKSTUDY_MHz           = 153;


@interface DoubanServer()
{
    AppDelegate * appDelegate;
    AFHTTPRequestOperationManager * doubanServerManager;
    ChannelGroup * channelGroup;
    UserInfo * userInfo;
}



@end

@implementation DoubanServer

-(instancetype)initDoubanServer
{
    if(self = [super init])
    {
        appDelegate = [[UIApplication sharedApplication]delegate];
        doubanServerManager = [AFHTTPRequestOperationManager manager];
        channelGroup = appDelegate.channelGroup;
        userInfo = appDelegate.userInfo;
        _captchaImageInfo = [[CaptchaImageInfo alloc]init];
        
    }
    return self;
}

//向服务器获取ChannelCell信息
-(void)doubanGetChannelCellWithURLString:(NSString *)channelURLString
{
    [doubanServerManager GET:channelURLString
                  parameters:nil
                     success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary * tempChannelsDictionary = responseObject;
         NSDictionary * channelsDictionary = tempChannelsDictionary[@"data"];
                  
         if([channelURLString isEqualToString:[NSString stringWithFormat:@"%@%@",LOGINCHANNELURL,appDelegate.userInfo.userID]])
         {
             [appDelegate.channelGroup removeMyChannelObject];
             //先插入用户labelcell
             ChannelInfo * channelCell = [[ChannelInfo alloc]init];
             channelCell.channelName = appDelegate.userInfo.userName;
             channelCell.channelCoverURL = [NSString stringWithFormat:USERIMAGEURL,userInfo.userID];
             [channelGroup.myRedHeartChannelCellArray addObject:channelCell];
             
             //再插入用户喜爱频道
             NSDictionary * fav_chlsChannel = channelsDictionary[@"res"];
             for(NSDictionary * redHeartChannel in fav_chlsChannel[@"fav_chls"])
             {
                 ChannelInfo * channelCell = [[ChannelInfo alloc]initWithDictionary:redHeartChannel];
                 [channelGroup.myRedHeartChannelCellArray addObject:channelCell];
                 NSLog(@"填充redHeart歌曲:%@",channelCell.channelName);
             }
             channelGroup.isEmpty = NO;

         }
         else if([channelURLString isEqualToString:TOTALCHANNELURL])
         {
             [appDelegate.channelGroup removeCommonChannelGroupObject];
             for(NSDictionary * channelCellInfo in channelsDictionary[@"channels"])
             {
                ChannelInfo * channelCell = [[ChannelInfo alloc]initWithDictionary:channelCellInfo];
                [self p_addingIntoChannelArrayWithChannelCell:channelCell];
             }
             if ([channelGroup.myRedHeartChannelCellArray count] == 0)
             {
                 ChannelInfo * channelCell = [[ChannelInfo alloc]init];
                 channelCell.channelName = @"未登录";
                 channelCell.channelCoverURL = nil;
                 [channelGroup.myRedHeartChannelCellArray addObject:channelCell];
             }
             channelGroup.isEmpty = NO;
             
         }
         else
         {
             NSLog(@"GETCHANNELCELL_URL_TYPE_ERROR:%@",channelURLString);
         }
         //刷新ChannelTableView
         [self.delegate doubanDelegate_reloadTableView];
         
     }
                     failure:^(AFHTTPRequestOperation *operation, NSError * error)
     {
         NSLog(@"GETCHANNELCELL_ERROR : %@",error);
     }];
}



//向服务器获取ChannelGroup信息
-(void)doubanGetChannelGroup
{
    
    if(userInfo.cookies)
    {
        NSString * loginChannelUrl = [NSString stringWithFormat:@"%@%@",LOGINCHANNELURL,appDelegate.userInfo.userID];
        [self doubanGetChannelCellWithURLString:loginChannelUrl];
    }
    [self doubanGetChannelCellWithURLString:TOTALCHANNELURL];
    
}




-(void)p_addingIntoChannelArrayWithChannelCell:(ChannelInfo *)channelCell
{
    int channelID = [channelCell.channelID intValue];
    switch (channelID) {

        case HUAYU_MHz:
        case OUMEI_MHz:
        case YUEYU_MHz:
        case BALING_MHz:
        case JIULING_MHz:
            [channelGroup.laguageChannelCellArray addObject:channelCell];
            break;
        case YAOGUN_MHz:
        case MINYAO_MHz:
        case QINGYINYUE_MHz:
        case DIANYINGYUANSHENG_MHz:
        case XIAOQINGXIN_MHz:
        case JAZZ_MHz:
        case GUDIAN_MHz:
            [channelGroup.songStyleChannelCellArray addObject:channelCell];
            break;
        case XINGE_MHz:
        case COFFEE_MHz:
        case WORKSTUDY_MHz:
            [channelGroup.feelingChannelCellArray addObject:channelCell];
            break;
        default:
            [channelGroup.recomandChannelCellArray addObject:channelCell];
            break;
    }
}

//向服务器获取验证码的图片URL
-(void)doubanLoadCaptchaImage
{
    doubanServerManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [doubanServerManager GET:CAPTCHAIDURLSTRING
                  parameters:nil
                     success:^(AFHTTPRequestOperation * operation, id responseObject)
     {
         NSMutableString *tempCaptchaID = [[NSMutableString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
         [tempCaptchaID replaceOccurrencesOfString:@"\"" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [tempCaptchaID length])];
         _captchaImageInfo.captchaID = tempCaptchaID;
         _captchaImageInfo.capthaImgURL = [NSString stringWithFormat:CAPTCHAIMGURLFORMATSTRING,tempCaptchaID];
         [_delegate doubanDelegate_setCaptchaImageWithURL:_captchaImageInfo.capthaImgURL];
     }
                     failure:^(AFHTTPRequestOperation * operation, NSError *error)
     {
         NSLog(@"LOADCAPTCHAIMAGE_ERROR:%@",error);
     }];
}

//登陆数据格式
//POST Params:
//remember:on/off
//source:radio
//captcha_solution:cheese 验证码
//alias:xxxx%40gmail.com
//form_password:password
//captcha_id:jOtEZsPFiDVRR9ldW3ELsy57%3en
-(void)doubanLoginWithLoginInfo:(LoginInfo *)loginInfo
{
    NSDictionary * doubanLoginParam = @{@"remember":@"off",
                                        @"source":@"radio",
                                        @"captcha_solution":loginInfo.capthchaInputWord,
                                        @"alias":loginInfo.loginName,
                                        @"form_password":loginInfo.passWord,
                                        @"captcha_id":_captchaImageInfo.captchaID};
    doubanServerManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [doubanServerManager POST:LOGINURLSTRING
                   parameters:doubanLoginParam
                      success:^(AFHTTPRequestOperation * operation, id responseObject)
     {
         NSDictionary *tempLoginInfoDictionary = responseObject;
         //r = 0 login successful
         if([(NSNumber *)tempLoginInfoDictionary[@"r"]intValue] == 0)
         {
             userInfo = [userInfo initWithDictionary:tempLoginInfoDictionary];
             [_delegate doubanDelegate_loginSuccessful];
             
         }
         else// login fail
         {

             NSString * errorMessage = [NSString stringWithFormat:@"Error : %@",[tempLoginInfoDictionary valueForKey:@"err_msg"]];
             [_delegate doubanDelegate_loginFail:errorMessage];
             [self doubanLoadCaptchaImage];
         }
         
     }
     
                      failure:^(AFHTTPRequestOperation * operation, NSError * error)
     {
         NSLog(@"LOGIN_ERROR:%@",error);
     }];
                                        
}






//source
//value radio
//ck
//the key ck in your cookie
//no_login
//value y #### Response none #### Example none


-(void)doubanLogout
{
    NSDictionary * logoutParameters = @{@"source": @"radio",
                                        @"ck":userInfo.cookies,
                                        @"no_login": @"y"};
    
    
    
    //注意这里！！
    doubanServerManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    
    
    
    
    [doubanServerManager GET:LOGOUTURLSTRING
                  parameters:logoutParameters
                     success:^(AFHTTPRequestOperation * operation, id responseObject)
     {
         
         appDelegate.userInfo.cookies = nil;
         [_delegate doubanDelegate_logoutSuccessful];
     }
                     failure:^(AFHTTPRequestOperation * operation, NSError * error)
     {
         NSLog(@"LOGOUT_ERROR:%@",error);
     }];
}








//获取PlayerView的model数据信息
//type
//n : None. Used for get a song list only.
//e : Ended a song normally.
//u : Unlike a hearted song.
//r : Like a song.
//s : Skip a song.
//b : Delete a song.
//p : Use to get a song list when the song in playlist was all played.
//sid : the song's id

-(void)doubanSongOperationWithType:(NSString *)type
{
    //组织服务器请求URL
    NSString * PlayListUrl = [NSString stringWithFormat:PLAYERURLFORMATSTRING,type,appDelegate.playerInfo.currentSong.songId,appDelegate.VideoPlayer.currentPlaybackTime, appDelegate.playerInfo.currentChannel.channelID];
    
    doubanServerManager.responseSerializer = [AFJSONResponseSerializer serializer];
    [doubanServerManager GET:PlayListUrl
                  parameters:nil
                     success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary * songDictionary = responseObject;
         for(NSDictionary * song in songDictionary[@"song"])
         {
            //subtype = T 为广告标示位，如果为T，则不加入播放列表（去广告）
            if([song[@"subtype"]isEqualToString:@"T"])
            {
                continue;
            }
            if([type isEqualToString: @"r"])
            {
                NSLog(@"喜欢！");
            }
            else
            {
                NSLog(@"当前歌曲：%@",appDelegate.playerInfo.currentSong.songTitle);
                appDelegate.playerInfo.currentSong = [appDelegate.playerInfo.currentSong initSongInfoWithDictionary:song];
                [appDelegate.VideoPlayer setContentURL:[NSURL URLWithString:appDelegate.playerInfo.currentSong.songUrl]];
                [appDelegate.VideoPlayer play];
                NSLog(@"即将播放歌曲：%@",appDelegate.playerInfo.currentSong.songTitle);

            }
        }
         
     }
                     failure:^(AFHTTPRequestOperation * operation, NSError *error)
     {
         [_delegate doubanDelegate_getSongListFail];
         NSLog(@"DOUBANSONGOPERATION_ERROR:%@",error);
     }];
    
}










@end
