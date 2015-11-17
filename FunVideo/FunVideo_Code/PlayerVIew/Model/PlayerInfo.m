//
//  PlayerInfo.m
//  FrankieVideo_New
//
//  Created by frankie on 15/10/19.
//  Copyright © 2015年 frankieCompany. All rights reserved.
//

#import "PlayerInfo.h"

@implementation PlayerInfo

-(instancetype)InitPlayerInfo
{
    _CurrentSong = [[SongInfo alloc]init];
    _CurrentChannel = [[ChannelInfo alloc]init];
    //初始歌曲ID为0
    _CurrentSong.SongId = @"0";    
    //默认初始频道为华语频道
    _CurrentChannel.ChannelID=@"1";
    _CurrentChannel.ChannelName = @"华语";
    return self;
}

//编译为二进制
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_CurrentSong forKey:@"CurrentSong"];
    [aCoder encodeObject:_CurrentChannel forKey:@"CurrentChannel"];
}


//反编译二进制
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if([self init])
    {
        _CurrentSong = [aDecoder decodeObjectForKey:@"CurrentSong"];
        _CurrentChannel = [aDecoder decodeObjectForKey:@"CurrentChannel"];

    }
        return self;
}

@end
