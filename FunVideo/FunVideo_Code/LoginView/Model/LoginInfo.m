//
//  LoginInfo.m
//  FunVideo
//
//  Created by frankie on 15/10/28.
//  Copyright © 2015年 FrankieCompany. All rights reserved.
//

#import "LoginInfo.h"

@implementation LoginInfo

-(NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p, %@",[self class],self,@{@"LoginName":_loginName,
                                                                         @"LoginPassWord":_passWord,
                                                                         @"CaptchaInputWord":_capthchaInputWord}];
}

-(NSString *)debugDescription
{
    return [NSString stringWithFormat:@"<%@: %p, %@",[self class],self,@{@"LoginName":_loginName,
                                                                         @"LoginPassWord":_passWord,
                                                                         @"CaptchaInputWord":_capthchaInputWord}];

}



@end
