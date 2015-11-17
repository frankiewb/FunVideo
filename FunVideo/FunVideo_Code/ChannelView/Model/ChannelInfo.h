//
//  ChannelInfo.h
//  FunVideo
//
//  Created by frankie on 15/11/3.
//  Copyright © 2015年 FrankieCompany. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChannelInfo : NSObject<NSCoding>


@property (nonatomic,copy) NSString * ChannelCoverURL;
@property (nonatomic,copy) NSString * ChannelID;
@property (nonatomic,copy) NSString * ChannelName;
@property (nonatomic,copy) NSString * ChannelIntro;
@property (nonatomic,copy) NSString * ChannelBannerURL;

-(instancetype)initWithDictionary:(NSDictionary *)dic;
-(instancetype)initWithChannelInfo:(ChannelInfo *)channelInfo;

@end
