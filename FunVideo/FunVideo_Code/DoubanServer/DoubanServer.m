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





@interface DoubanServer()
{
    AppDelegate * appDelegate;
    AFHTTPRequestOperationManager * DoubanServerManager;
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
        DoubanServerManager = [AFHTTPRequestOperationManager manager];
        channelGroup = appDelegate.channelGroup;
        userInfo = appDelegate.userInfo;
        _captchaImageInfo = [[CaptchaImageInfo alloc]init];
        
    }
    return self;
}

//向服务器获取ChannelCell信息
-(void)DoubanGetChannelCellWithURLString:(NSString *)ChannelURLString
{
    [DoubanServerManager GET:ChannelURLString
                  parameters:nil
                     success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary * tempchannelsDictionary = responseObject;
         NSDictionary * channelsDictionary = tempchannelsDictionary[@"data"];
                  
         if([ChannelURLString isEqualToString:[NSString stringWithFormat:@"%@%@",LOGINCHANNELURL,appDelegate.userInfo.UserID]])
         {
             [appDelegate.channelGroup removeMyChannelObject];
             //先插入用户labelcell
             ChannelInfo * channelCell = [[ChannelInfo alloc]init];
             channelCell.ChannelName = appDelegate.userInfo.UserName;
             channelCell.ChannelCoverURL = [NSString stringWithFormat:USERIMAGEURL,userInfo.UserID];
             [channelGroup.MyRedHeartChannelCellArray addObject:channelCell];
             
             //再插入用户喜爱频道
             NSDictionary * fav_chlsChannel = channelsDictionary[@"res"];
             for(NSDictionary * redHeartChannel in fav_chlsChannel[@"fav_chls"])
             {
                 ChannelInfo * channelCell = [[ChannelInfo alloc]initWithDictionary:redHeartChannel];
                 [channelGroup.MyRedHeartChannelCellArray addObject:channelCell];
                 NSLog(@"填充redHeart歌曲:%@",channelCell.ChannelName);
             }
             channelGroup.isEmpty = NO;

         }
         else if([ChannelURLString isEqualToString:TOTALCHANNELURL])
         {
             [appDelegate.channelGroup removeCommonChannelGroupObject];
             for(NSDictionary * channelCellInfo in channelsDictionary[@"channels"])
             {
                ChannelInfo * channelCell = [[ChannelInfo alloc]initWithDictionary:channelCellInfo];
                [self AddingIntoChannelArrayWithChannelCell:channelCell];
             }
             if ([channelGroup.MyRedHeartChannelCellArray count] == 0)
             {
                 ChannelInfo * channelCell = [[ChannelInfo alloc]init];
                 channelCell.ChannelName = @"未登录";
                 channelCell.ChannelCoverURL = nil;
                 [channelGroup.MyRedHeartChannelCellArray addObject:channelCell];
             }
             channelGroup.isEmpty = NO;
             
         }
         else
         {
             NSLog(@"GETCHANNELCELL_URL_TYPE_ERROR:%@",ChannelURLString);
         }
         //刷新ChannelTableView
         [self.delegate ReloadTableView];
         
     }
                     failure:^(AFHTTPRequestOperation *operation, NSError * error)
     {
         NSLog(@"GETCHANNELCELL_ERROR : %@",error);
     }];
}



//向服务器获取ChannelGroup信息
-(void)DoubanGetChannelGroup
{
    
    if(userInfo.Cookies)
    {
        NSString * LoginChannelUrl = [NSString stringWithFormat:@"%@%@",LOGINCHANNELURL,appDelegate.userInfo.UserID];
        [self DoubanGetChannelCellWithURLString:LoginChannelUrl];
    }
    [self DoubanGetChannelCellWithURLString:TOTALCHANNELURL];
    
}




-(void)AddingIntoChannelArrayWithChannelCell:(ChannelInfo *)channelCell
{
    int channelID = [channelCell.ChannelID intValue];
    switch (channelID) {

        case HUAYU_MHz:
        case OUMEI_MHz:
        case YUEYU_MHz:
        case BALING_MHz:
        case JIULING_MHz:
            [channelGroup.LaguageChannelCellArray addObject:channelCell];
            break;
        case YAOGUN_MHz:
        case MINYAO_MHz:
        case QINGYINYUE_MHz:
        case DIANYINGYUANSHENG_MHz:
        case XIAOQINGXIN_MHz:
        case JAZZ_MHz:
        case GUDIAN_MHz:
            [channelGroup.SongStyleChannelCellArray addObject:channelCell];
            break;
        case XINGE_MHz:
        case COFFEE_MHz:
        case WORKSTUDY_MHz:
            [channelGroup.FeelingChannelCellArray addObject:channelCell];
            break;
        default:
            [channelGroup.RecomandChannelCellArray addObject:channelCell];
            break;
    }
}

//向服务器获取验证码的图片URL
-(void)DoubanLoadCaptchaImage
{
    DoubanServerManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [DoubanServerManager GET:CAPTCHAIDURLSTRING
                  parameters:nil
                     success:^(AFHTTPRequestOperation * operation, id responseObject)
     {
         NSMutableString *temCaptchaID = [[NSMutableString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
         [temCaptchaID replaceOccurrencesOfString:@"\"" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [temCaptchaID length])];
         _captchaImageInfo.captchaID = temCaptchaID;
         _captchaImageInfo.capthaImgURL = [NSString stringWithFormat:CAPTCHAIMGURLFORMATSTRING,temCaptchaID];
         [_delegate SetCaptchaImageWithURL:_captchaImageInfo.capthaImgURL];
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
-(void)DoubanLoginWithLoginInfo:(LoginInfo *)loginInfo
{
    NSDictionary * doubanLoginParam = @{@"remember":@"off",
                                        @"source":@"radio",
                                        @"captcha_solution":loginInfo.CapthchaInputWord,
                                        @"alias":loginInfo.LoginName,
                                        @"form_password":loginInfo.PassWord,
                                        @"captcha_id":_captchaImageInfo.captchaID};
    DoubanServerManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [DoubanServerManager POST:LOGINURLSTRING
                   parameters:doubanLoginParam
                      success:^(AFHTTPRequestOperation * operation, id responseObject)
     {
         NSDictionary *tempLoginInfoDictionary = responseObject;
         //r = 0 login successful
         if([(NSNumber *)tempLoginInfoDictionary[@"r"]intValue] == 0)
         {
             [userInfo initWithDictionary:tempLoginInfoDictionary];
             [_delegate LoginSuccessful];
             
         }
         else// login fail
         {
             UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"yoo～～登陆失败了咩" message:[tempLoginInfoDictionary valueForKey:@"err_msg"] delegate:self cancelButtonTitle:@"GET" otherButtonTitles: nil];
             [alertView show];
             [self DoubanLoadCaptchaImage];
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


-(void)DoubanLogout
{
    NSDictionary * logoutParameters = @{@"source": @"radio",
                                        @"ck":userInfo.Cookies,
                                        @"no_login": @"y"};
    
    
    
    //注意这里！！
    DoubanServerManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    
    
    
    
    [DoubanServerManager GET:LOGOUTURLSTRING
                  parameters:logoutParameters
                     success:^(AFHTTPRequestOperation * operation, id responseObject)
     {
         
         appDelegate.userInfo.Cookies = nil;
         [_delegate LogoutSuccessful];
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

-(void)DoubanSongOperationWithType:(NSString *)Type
{
    //组织服务器请求URL
    NSString * PlayListUrl = [NSString stringWithFormat:PLAYERURLFORMATSTRING,Type,appDelegate.playerInfo.CurrentSong.SongId,appDelegate.VideoPlayer.currentPlaybackTime, appDelegate.playerInfo.CurrentChannel.ChannelID];
    
    DoubanServerManager.responseSerializer = [AFJSONResponseSerializer serializer];
    [DoubanServerManager GET:PlayListUrl
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
            if([Type isEqualToString: @"r"])
            {
                NSLog(@"喜欢！");
            }
            else
            {
                 NSLog(@"当前歌曲：%@",appDelegate.playerInfo.CurrentSong.SongTitle);
                appDelegate.playerInfo.CurrentSong = [appDelegate.playerInfo.CurrentSong initSongInfoWithDictionary:song];
                [appDelegate.VideoPlayer setContentURL:[NSURL URLWithString:appDelegate.playerInfo.CurrentSong.SongUrl]];
                [appDelegate.VideoPlayer play];
                NSLog(@"即将播放歌曲：%@",appDelegate.playerInfo.CurrentSong.SongTitle);

            }
        }
         
     }
                     failure:^(AFHTTPRequestOperation * operation, NSError *error)
     {
         UIAlertView *alerView = [[UIAlertView alloc]initWithTitle:@"Yoo~~~~"
                                                          message:@"登录失败啦～～～"
                                                         delegate:self
                                                cancelButtonTitle:@"哦，酱紫～～"
                                                otherButtonTitles:nil];
         [alerView show];
         NSLog(@"DOUBANSONGOPERATION_ERROR:%@",error);
     }];
    
}










@end
