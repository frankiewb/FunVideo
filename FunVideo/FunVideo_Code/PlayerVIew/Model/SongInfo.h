//
//  SongInfo.h
//  FrankieVideo_New
//
//  Created by frankie on 15/10/19.
//  Copyright © 2015年 frankieCompany. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SongInfo : NSObject<NSCoding>


@property(nonatomic,copy) NSString *songTitle;
@property(nonatomic,copy) NSString *songArtist;
@property(nonatomic,copy) NSString *songPictureUrl;
@property(nonatomic,copy) NSString *songTimeLong;
@property (nonatomic,copy) NSString *songIsLike;
@property(nonatomic,copy) NSString *songUrl;
@property(nonatomic,copy) NSString *songId;


-(instancetype)initSongInfoWithDictionary:(NSDictionary *)dic;


@end
