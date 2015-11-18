//
//  UserInfo.m
//  FunVideo
//
//  Created by frankie on 15/10/30.
//  Copyright © 2015年 FrankieCompany. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo


-(instancetype)initWithDictionary:(NSDictionary *)dic
{
    if(self = [super init])
    {
        _IsNotLogin = dic[@"r"];
        
        NSDictionary *tempUserInfoDic = dic[@"user_info"];
        _Cookies = tempUserInfoDic[@"ck"];
        _UserID = tempUserInfoDic[@"id"];
        _UserName = tempUserInfoDic[@"name"];
        
        NSDictionary *tempPlayRecordDic = tempUserInfoDic[@"play_record"];
        _Banned = [NSString stringWithFormat:@"%@",tempPlayRecordDic[@"banned"]];
        _Liked = [NSString stringWithFormat:@"%@",tempPlayRecordDic[@"liked"]];
        _Plyaed = [NSString stringWithFormat:@"%@",tempPlayRecordDic[@"played"]];
        
    }
    return self;
}

//编译为二进制
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_IsNotLogin forKey:@"login"];
    [aCoder encodeObject:_Cookies forKey:@"cookies"];
    [aCoder encodeObject:_UserID forKey:@"userid"];
    [aCoder encodeObject:_UserName forKey:@"name"];
    [aCoder encodeObject:_Banned forKey:@"banned"];
    [aCoder encodeObject:_Liked forKey:@"liked"];
    [aCoder encodeObject:_Plyaed forKey:@"played"];
    
    
}

//反编译二进制
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if([self init])
    {
        _IsNotLogin = [aDecoder decodeObjectForKey:@"login"];
        _Cookies = [aDecoder decodeObjectForKey:@"cookies"];
        _UserID = [aDecoder decodeObjectForKey:@"userid"];
        _UserName = [aDecoder decodeObjectForKey:@"name"];
        _Banned = [aDecoder decodeObjectForKey:@"banned"];
        _Liked = [aDecoder decodeObjectForKey:@"liked"];
        _Plyaed = [aDecoder decodeObjectForKey:@"played"];
    }
    return self;
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p, %@",[self class],self,@{@"IsNotLogin":_IsNotLogin,
                                                                         @"Cookies":_Cookies,
                                                                         @"UserID":_UserID,
                                                                         @"UserName":_UserName,
                                                                         @"Banned":_Banned,
                                                                         @"Liked":_Liked,
                                                                         @"Played":_Plyaed}];
}

-(NSString *)debugDescription
{
    return [NSString stringWithFormat:@"<%@: %p, %@",[self class],self,@{@"IsNotLogin":_IsNotLogin,
                                                                         @"Cookies":_Cookies,
                                                                         @"UserID":_UserID,
                                                                         @"UserName":_UserName,
                                                                         @"Banned":_Banned,
                                                                         @"Liked":_Liked,
                                                                         @"Played":_Plyaed}];
}

@end
