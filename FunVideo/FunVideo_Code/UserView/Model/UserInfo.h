//
//  UserInfo.h
//  FunVideo
//
//  Created by frankie on 15/10/30.
//  Copyright © 2015年 FrankieCompany. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject<NSCoding>

@property (nonatomic,copy) NSString *IsNotLogin;
@property (nonatomic,copy) NSString *Cookies;
@property (nonatomic,copy) NSString *UserID;
@property (nonatomic,copy) NSString *UserName;
@property (nonatomic,copy) NSString *Banned;
@property (nonatomic,copy) NSString *Liked;
@property (nonatomic,copy) NSString *Plyaed;

-(instancetype)initWithDictionary:(NSDictionary *)dic;

@end
