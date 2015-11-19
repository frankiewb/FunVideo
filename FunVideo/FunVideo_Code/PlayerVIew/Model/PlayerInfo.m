//
//  PlayerInfo.m
//  FrankieVideo_New
//
//  Created by frankie on 15/10/19.
//  Copyright © 2015年 frankieCompany. All rights reserved.
//

#import "PlayerInfo.h"
#import "SongInfo.h"
#import "ChannelInfo.h"

@implementation PlayerInfo

-(instancetype)initPlayerInfo
{
    _currentSong = [[SongInfo alloc]init];
    _currentChannel = [[ChannelInfo alloc]init];
    //初始歌曲ID为0
    _currentSong.songId = @"0";
    //默认初始频道为华语频道
    _currentChannel.channelID=@"1";
    _currentChannel.channelName = @"华语";
    return self;
}

//编译为二进制
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_currentSong forKey:@"CurrentSong"];
    [aCoder encodeObject:_currentChannel forKey:@"CurrentChannel"];
}


//反编译二进制
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if([self init])
    {
        _currentSong = [aDecoder decodeObjectForKey:@"CurrentSong"];
        _currentChannel = [aDecoder decodeObjectForKey:@"CurrentChannel"];

    }
        return self;
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p, %@",[self class],self,@{@"CurrentSong":_currentSong,
                                                                         @"CurrentChannel":_currentChannel}];

}

-(NSString *)debugDescription
{
    return [NSString stringWithFormat:@"<%@: %p, %@",[self class],self,@{@"CurrentSong":_currentSong,
                                                                         @"CurrentChannel":_currentChannel}];
}


@end
