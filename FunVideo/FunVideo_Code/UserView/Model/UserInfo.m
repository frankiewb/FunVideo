//
//  UserInfo.m
//  FunVideo
//
//  Created by frankie on 15/10/30.
//  Copyright © 2015年 FrankieCompany. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo


- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    if(self = [super init])
    {
        _isNotLogin = dic[@"r"];
        
        NSDictionary *tempUserInfoDic = dic[@"user_info"];
        _cookies = tempUserInfoDic[@"ck"];
        _userID = tempUserInfoDic[@"id"];
        _userName = tempUserInfoDic[@"name"];
        
        NSDictionary *tempPlayRecordDic = tempUserInfoDic[@"play_record"];
        _banned = [NSString stringWithFormat:@"%@",tempPlayRecordDic[@"banned"]];
        _liked = [NSString stringWithFormat:@"%@",tempPlayRecordDic[@"liked"]];
        _plyaed = [NSString stringWithFormat:@"%@",tempPlayRecordDic[@"played"]];
        
    }
    return self;
}

//编译为二进制
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_isNotLogin forKey:@"login"];
    [aCoder encodeObject:_cookies forKey:@"cookies"];
    [aCoder encodeObject:_userID forKey:@"userid"];
    [aCoder encodeObject:_userName forKey:@"name"];
    [aCoder encodeObject:_banned forKey:@"banned"];
    [aCoder encodeObject:_liked forKey:@"liked"];
    [aCoder encodeObject:_plyaed forKey:@"played"];
    
    
}

//反编译二进制
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if([self init])
    {
        _isNotLogin = [aDecoder decodeObjectForKey:@"login"];
        _cookies = [aDecoder decodeObjectForKey:@"cookies"];
        _userID = [aDecoder decodeObjectForKey:@"userid"];
        _userName = [aDecoder decodeObjectForKey:@"name"];
        _banned = [aDecoder decodeObjectForKey:@"banned"];
        _liked = [aDecoder decodeObjectForKey:@"liked"];
        _plyaed = [aDecoder decodeObjectForKey:@"played"];
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p, %@",[self class],self,@{@"IsNotLogin":_isNotLogin,
                                                                         @"Cookies":_cookies,
                                                                         @"UserID":_userID,
                                                                         @"UserName":_userName,
                                                                         @"Banned":_banned,
                                                                         @"Liked":_liked,
                                                                         @"Played":_plyaed}];
}

- (NSString *)debugDescription
{
    return [NSString stringWithFormat:@"<%@: %p, %@",[self class],self,@{@"IsNotLogin":_isNotLogin,
                                                                         @"Cookies":_cookies,
                                                                         @"UserID":_userID,
                                                                         @"UserName":_userName,
                                                                         @"Banned":_banned,
                                                                         @"Liked":_liked,
                                                                         @"Played":_plyaed}];
}

@end
