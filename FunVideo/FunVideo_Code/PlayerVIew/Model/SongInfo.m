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
-(instancetype)initSongInfoWithDictionary:(NSDictionary *)Dic
{
    if(self = [super init])
    {
        self.SongArtist = [Dic objectForKey:@"artist"];
        self.SongTitle = [Dic objectForKey:@"title"];
        self.SongUrl = [Dic objectForKey:@"url"];
        self.SongPictureUrl = [Dic objectForKey:@"picture"];
        self.SongTimeLong = [Dic objectForKey:@"length"];
        self.SongIsLike = [Dic objectForKey:@"like"];
        self.SongId = [Dic objectForKey:@"sid"];
    }
        return self;
}



//编译为二进制
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_SongArtist forKey:@"artist"];
    [aCoder encodeObject:_SongTitle forKey:@"title"];
    [aCoder encodeObject:_SongUrl forKey:@"songurl"];
    [aCoder encodeObject:_SongPictureUrl forKey:@"pictureurl"];
    [aCoder encodeObject:_SongTimeLong forKey:@"timelong"];
    [aCoder encodeObject:_SongIsLike forKey:@"islike"];
    [aCoder encodeObject:_SongId forKey:@"songid"];

}


//反编译二进制
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if([self init])
    {
        _SongArtist = [aDecoder decodeObjectForKey:@"artist"];
        _SongTitle = [aDecoder decodeObjectForKey:@"title"];
        _SongUrl = [aDecoder decodeObjectForKey:@"songurl"];
        _SongPictureUrl = [aDecoder decodeObjectForKey:@"pictureurl"];
        _SongTimeLong = [aDecoder decodeObjectForKey:@"timelong"];
        _SongIsLike = [aDecoder decodeObjectForKey:@"islike"];
        _SongId = [aDecoder decodeObjectForKey:@"songid"];
    }
    return self;
}




@end
