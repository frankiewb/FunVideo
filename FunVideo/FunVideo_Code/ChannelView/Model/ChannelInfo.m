//
//  ChannelInfo.m
//  FunVideo
//
//  Created by frankie on 15/11/3.
//  Copyright © 2015年 FrankieCompany. All rights reserved.
//

#import "ChannelInfo.h"

@implementation ChannelInfo

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    if(self = [super init])
    {
        _channelCoverURL = dic[@"cover"];
        _channelID = dic[@"id"];
        _channelName = dic[@"name"];
        _channelIntro = dic[@"intro"];
        _channelBannerURL = dic[@"banner"];
    }
    return self;
}

- (instancetype)initWithChannelInfo:(ChannelInfo *)channelInfo
{
    if(self = [super init])
    {
        _channelCoverURL = channelInfo.channelCoverURL;
        _channelID = channelInfo.channelID;
        _channelName = channelInfo.channelName;
        _channelIntro = channelInfo.channelIntro;
        _channelBannerURL = channelInfo.channelBannerURL;
    }
    return self;
}

//编译为二进制
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_channelCoverURL forKey:@"channelcover"];
    [aCoder encodeObject:_channelID forKey:@"channelid"];
    [aCoder encodeObject:_channelName forKey:@"channelname"];
    [aCoder encodeObject:_channelIntro forKey:@"channelintro"];
    [aCoder encodeObject:_channelBannerURL forKey:@"channelbanner"];
    
}


//反编译二进制
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if([self init])
    {
        _channelCoverURL = [aDecoder decodeObjectForKey:@"channelcover"];
        _channelID = [aDecoder decodeObjectForKey:@"channelid"];
        _channelName = [aDecoder decodeObjectForKey:@"channelname"];
        _channelIntro = [aDecoder decodeObjectForKey:@"channelintro"];
        _channelBannerURL = [aDecoder decodeObjectForKey:@"channelbanner"];
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p, %@",[self class],self,@{@"ChannelCoverURL":_channelCoverURL,
                                                                         @"ChannelID":_channelID,
                                                                         @"ChannelName":_channelName,
                                                                         @"ChannelIntro":_channelIntro,
                                                                         @"ChannelBannerURL":_channelBannerURL}];
}

- (NSString *)debugDescription
{
    return [NSString stringWithFormat:@"<%@: %p, %@",[self class],self,@{@"ChannelCoverURL":_channelCoverURL,
                                                                         @"ChannelID":_channelID,
                                                                         @"ChannelName":_channelName,
                                                                         @"ChannelIntro":_channelIntro,
                                                                         @"ChannelBannerURL":_channelBannerURL}];

}



@end
