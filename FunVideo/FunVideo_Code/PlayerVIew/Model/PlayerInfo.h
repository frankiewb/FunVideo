//
//  PlayerInfo.h
//  FrankieVideo_New
//
//  Created by frankie on 15/10/19.
//  Copyright © 2015年 frankieCompany. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ChannelInfo;
@class SongInfo;

@interface PlayerInfo : NSObject<NSCoding>

@property(nonatomic,strong) ChannelInfo *currentChannel;
@property(nonatomic,strong) SongInfo *currentSong;

- (instancetype)initPlayerInfo;



@end
