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
@property(nonatomic,strong) ChannelInfo * CurrentChannel;

/**
 * 当前歌曲的所有相关信息
 */
@property(nonatomic,strong) SongInfo * CurrentSong;


/**
 * 初始化PlayerInfo
 */
-(instancetype)InitPlayerInfo;


//序列化，压缩为二进制
-(void)encodeWithCoder:(NSCoder *)aCoder;


//反序列化，从二进制反编译为实际数据结构
-(id)initWithCoder:(NSCoder *)aDecoder;



@end
