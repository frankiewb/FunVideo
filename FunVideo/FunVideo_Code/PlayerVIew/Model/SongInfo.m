//
//  SongInfo.m
//  FrankieVideo_New
//
//  Created by frankie on 15/10/19.
//  Copyright © 2015年 frankieCompany. All rights reserved.
//

#import "SongInfo.h"

@implementation SongInfo

//默认init直接赋值为空
- (instancetype)initSongInfoWithDictionary:(NSDictionary *)dic
{
    if(self             = [super init])
    {
    self.songArtist     = dic[@"artist"];
    self.songTitle      = dic[@"title"];
    self.songUrl        = dic[@"url"];
    self.songPictureUrl = dic[@"picture"];
    self.songTimeLong   = dic[@"length"];
    self.songIsLike     = dic[@"like"];
    self.songId         = dic[@"sid"];
    }
        return self;
}



//编译为二进制
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_songArtist forKey:@"artist"];
    [aCoder encodeObject:_songTitle forKey:@"title"];
    [aCoder encodeObject:_songUrl forKey:@"songurl"];
    [aCoder encodeObject:_songPictureUrl forKey:@"pictureurl"];
    [aCoder encodeObject:_songTimeLong forKey:@"timelong"];
    [aCoder encodeObject:_songIsLike forKey:@"islike"];
    [aCoder encodeObject:_songId forKey:@"songid"];

}


//反编译二进制
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if([self init])
    {
        _songArtist     = [aDecoder decodeObjectForKey:@"artist"];
        _songTitle      = [aDecoder decodeObjectForKey:@"title"];
        _songUrl        = [aDecoder decodeObjectForKey:@"songurl"];
        _songPictureUrl = [aDecoder decodeObjectForKey:@"pictureurl"];
        _songTimeLong   = [aDecoder decodeObjectForKey:@"timelong"];
        _songIsLike     = [aDecoder decodeObjectForKey:@"islike"];
        _songId         = [aDecoder decodeObjectForKey:@"songid"];
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p, %@",[self class],self,@{@"SongArtist":_songArtist,
                                                                         @"SongTitle":_songTitle,
                                                                         @"SongURL":_songUrl,
                                                                         @"SongPictureURL":_songPictureUrl,
                                                                         @"SongTimeLong":_songTimeLong,
                                                                         @"SongIsLike":_songIsLike,
                                                                         @"SongID":_songId}];
}

- (NSString *)debugDescription
{
    return [NSString stringWithFormat:@"<%@: %p, %@",[self class],self,@{@"SongArtist":_songArtist,
                                                                         @"SongTitle":_songTitle,
                                                                         @"SongURL":_songUrl,
                                                                         @"SongPictureURL":_songPictureUrl,
                                                                         @"SongTimeLong":_songTimeLong,
                                                                         @"SongIsLike":_songIsLike,
                                                                         @"SongID":_songId}];

}






@end
