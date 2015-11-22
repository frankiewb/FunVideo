//
//  SongInfo.h
//  FrankieVideo_New
//
//  Created by frankie on 15/10/19.
//  Copyright © 2015年 frankieCompany. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SongInfo : NSObject<NSCoding>

/**
 *  歌曲名称
 */
@property(nonatomic,copy) NSString *songTitle;

/**
 * 歌曲演唱者
 */
@property(nonatomic,copy) NSString *songArtist;

/**
 *  歌曲图片
 */
@property(nonatomic,copy) NSString *songPictureUrl;

/**
 *  歌曲时长
 */
@property(nonatomic,copy) NSString *songTimeLong;

/**
 * 该歌曲是否为喜爱歌曲 True：喜爱 False：不喜爱
 */
@property (nonatomic,copy) NSString *songIsLike;

/**
 * 该歌曲URL链接
 */
@property(nonatomic,copy) NSString *songUrl;

/**
 * 歌曲ID
 */
@property(nonatomic,copy) NSString *songId;


/**
 * 初始化函数带参数
 */
-(instancetype)initSongInfoWithDictionary:(NSDictionary *)dic;


@end
