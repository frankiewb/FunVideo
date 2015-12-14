//
//  CaptchaImageInfo.m
//  FunVideo
//
//  Created by frankie on 15/10/30.
//  Copyright © 2015年 FrankieCompany. All rights reserved.
//

#import "CaptchaImageInfo.h"

@implementation CaptchaImageInfo

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p, %@",[self class],self,@{@"CaptchaID":_captchaID,
                                                                         @"CaptchaImgURL":_capthaImgURL}];

}


- (NSString *)debugDescription
{
    return [NSString stringWithFormat:@"<%@: %p, %@",[self class],self,@{@"CaptchaID":_captchaID,
                                                                         @"CaptchaImgURL":_capthaImgURL}];

}



@end
