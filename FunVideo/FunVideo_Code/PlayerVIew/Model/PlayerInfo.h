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

/**
 * 当前歌曲所在的频道
 */
@property(nonatomic,strong) ChannelInfo * currentChannel;

/**
 * 当前歌曲的所有相关信息
 */
@property(nonatomic,strong) SongInfo * currentSong;


/**
 * 初始化PlayerInfo
 */
-(instancetype)initPlayerInfo;



@end
