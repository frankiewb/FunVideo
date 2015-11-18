//
//  ChannelInfo.m
//  FunVideo
//
//  Created by frankie on 15/11/3.
//  Copyright © 2015年 FrankieCompany. All rights reserved.
//

#import "ChannelInfo.h"

@implementation ChannelInfo

-(instancetype)initWithDictionary:(NSDictionary *)dic
{
    if(self = [super init])
    {
        _ChannelCoverURL = dic[@"cover"];
        _ChannelID = dic[@"id"];
        _ChannelName = dic[@"name"];
        _ChannelIntro = dic[@"intro"];
        _ChannelBannerURL = dic[@"banner"];
    }
    return self;
}

-(instancetype)initWithChannelInfo:(ChannelInfo *)channelInfo
{
    if(self = [super init])
    {
        _ChannelCoverURL = channelInfo.ChannelCoverURL;
        _ChannelID = channelInfo.ChannelID;
        _ChannelName = channelInfo.ChannelName;
        _ChannelIntro = channelInfo.ChannelIntro;
        _ChannelBannerURL = channelInfo.ChannelBannerURL;
    }
    return self;
}

//编译为二进制
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_ChannelCoverURL forKey:@"channelcover"];
    [aCoder encodeObject:_ChannelID forKey:@"channelid"];
    [aCoder encodeObject:_ChannelName forKey:@"channelname"];
    [aCoder encodeObject:_ChannelIntro forKey:@"channelintro"];
    [aCoder encodeObject:_ChannelBannerURL forKey:@"channelbanner"];
    
}


//反编译二进制
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if([self init])
    {
        _ChannelCoverURL = [aDecoder decodeObjectForKey:@"channelcover"];
        _ChannelID = [aDecoder decodeObjectForKey:@"channelid"];
        _ChannelName = [aDecoder decodeObjectForKey:@"channelname"];
        _ChannelIntro = [aDecoder decodeObjectForKey:@"channelintro"];
        _ChannelBannerURL = [aDecoder decodeObjectForKey:@"channelbanner"];
    }
    return self;
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p, %@",[self class],self,@{@"ChannelCoverURL":_ChannelCoverURL,
                                                                         @"ChannelID":_ChannelID,
                                                                         @"ChannelName":_ChannelName,
                                                                         @"ChannelIntro":_ChannelIntro,
                                                                         @"ChannelBannerURL":_ChannelBannerURL}];
}

-(NSString *)debugDescription
{
    return [NSString stringWithFormat:@"<%@: %p, %@",[self class],self,@{@"ChannelCoverURL":_ChannelCoverURL,
                                                                         @"ChannelID":_ChannelID,
                                                                         @"ChannelName":_ChannelName,
                                                                         @"ChannelIntro":_ChannelIntro,
                                                                         @"ChannelBannerURL":_ChannelBannerURL}];

}



@end
