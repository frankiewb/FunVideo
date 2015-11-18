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
    if(self             = [super init])
    {
    self.SongArtist     = Dic[@"artist"];
    self.SongTitle      = Dic[@"title"];
    self.SongUrl        = Dic[@"url"];
    self.SongPictureUrl = Dic[@"picture"];
    self.SongTimeLong   = Dic[@"length"];
    self.SongIsLike     = Dic[@"like"];
    self.SongId         = Dic[@"sid"];
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
        _SongArtist     = [aDecoder decodeObjectForKey:@"artist"];
        _SongTitle      = [aDecoder decodeObjectForKey:@"title"];
        _SongUrl        = [aDecoder decodeObjectForKey:@"songurl"];
        _SongPictureUrl = [aDecoder decodeObjectForKey:@"pictureurl"];
        _SongTimeLong   = [aDecoder decodeObjectForKey:@"timelong"];
        _SongIsLike     = [aDecoder decodeObjectForKey:@"islike"];
        _SongId         = [aDecoder decodeObjectForKey:@"songid"];
    }
    return self;
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p, %@",[self class],self,@{@"SongArtist":_SongArtist,
                                                                         @"SongTitle":_SongTitle,
                                                                         @"SongURL":_SongUrl,
                                                                         @"SongPictureURL":_SongPictureUrl,
                                                                         @"SongTimeLong":_SongTimeLong,
                                                                         @"SongIsLike":_SongIsLike,
                                                                         @"SongID":_SongId}];
}

-(NSString *)debugDescription
{
    return [NSString stringWithFormat:@"<%@: %p, %@",[self class],self,@{@"SongArtist":_SongArtist,
                                                                         @"SongTitle":_SongTitle,
                                                                         @"SongURL":_SongUrl,
                                                                         @"SongPictureURL":_SongPictureUrl,
                                                                         @"SongTimeLong":_SongTimeLong,
                                                                         @"SongIsLike":_SongIsLike,
                                                                         @"SongID":_SongId}];

}






@end
