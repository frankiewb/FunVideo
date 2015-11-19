//
//  ChannelInfo.h
//  FunVideo
//
//  Created by frankie on 15/11/3.
//  Copyright © 2015年 FrankieCompany. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChannelInfo : NSObject<NSCoding>


@property (nonatomic,copy) NSString * channelCoverURL;
@property (nonatomic,copy) NSString * channelID;
@property (nonatomic,copy) NSString * channelName;
@property (nonatomic,copy) NSString * channelIntro;
@property (nonatomic,copy) NSString * channelBannerURL;

-(instancetype)initWithDictionary:(NSDictionary *)dic;
-(instancetype)initWithChannelInfo:(ChannelInfo *)channelInfo;

@end
