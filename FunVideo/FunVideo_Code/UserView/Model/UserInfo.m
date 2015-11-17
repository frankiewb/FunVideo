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
        _IsNotLogin = [dic valueForKey:@"r"];
        
        NSDictionary *tempUserInfoDic = [dic valueForKey:@"user_info"];
        _Cookies = [tempUserInfoDic valueForKey:@"ck"];
        _UserID = [tempUserInfoDic valueForKey:@"id"];
        _UserName = [tempUserInfoDic valueForKey:@"name"];
        
        NSDictionary *tempPlayRecordDic = [tempUserInfoDic valueForKey:@"play_record"];
        _Banned = [NSString stringWithFormat:@"%@",[tempPlayRecordDic valueForKey:@"banned"]];
        _Liked = [NSString stringWithFormat:@"%@",[tempPlayRecordDic valueForKey:@"liked"]];
        _Plyaed = [NSString stringWithFormat:@"%@",[tempPlayRecordDic valueForKey:@"played"]];
        
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

@end
