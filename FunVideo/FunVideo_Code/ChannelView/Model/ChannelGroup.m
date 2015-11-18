//
//  ChannelGroup.m
//  FunVideo
//
//  Created by frankie on 15/11/4.
//  Copyright © 2015年 FrankieCompany. All rights reserved.
//

#import "ChannelGroup.h"
#import "Commons.h"
#import "ChannelInfo.h"


@implementation ChannelGroup


-(instancetype)init
{
    if(self = [super init])
    {
        _MyRedHeartChannelCellArray = [[NSMutableArray alloc]init];
        _RecomandChannelCellArray = [[NSMutableArray alloc]init];
        _LaguageChannelCellArray = [[NSMutableArray alloc]init];
        _SongStyleChannelCellArray = [[NSMutableArray alloc]init];
        _FeelingChannelCellArray = [[NSMutableArray alloc]init];
        _TotalChannelArray = [[NSMutableArray alloc]init];
        _ChannelGroupTitleArray = [[NSMutableArray alloc]init];
        
        [_TotalChannelArray addObject:_MyRedHeartChannelCellArray];
        NSString * RedHeartChannelTitle = @"我的红心兆赫";
        [_ChannelGroupTitleArray addObject:RedHeartChannelTitle];
        
        [_TotalChannelArray addObject:_RecomandChannelCellArray];
        NSString * ReconmandChannelTitle = @"推荐兆赫";
        [_ChannelGroupTitleArray addObject:ReconmandChannelTitle];
                
        [_TotalChannelArray addObject:_LaguageChannelCellArray];
        NSString * LanguageChannelCellTitle = @"语言年代兆赫";
        [_ChannelGroupTitleArray addObject:LanguageChannelCellTitle];
        
        [_TotalChannelArray addObject:_SongStyleChannelCellArray];
        NSString * SongStyleChannelCellTitle = @"风格流派兆赫";
        [_ChannelGroupTitleArray addObject:SongStyleChannelCellTitle];
        
        [_TotalChannelArray addObject:_FeelingChannelCellArray];
        NSString * FeelingChannelCellTitle = @"心情场景兆赫";
        [_ChannelGroupTitleArray addObject:FeelingChannelCellTitle];
        
        _isEmpty = YES;
    
    }
    return self;
}

-(void)removeMyChannelObject
{
    if(_MyRedHeartChannelCellArray)
    {
        [_MyRedHeartChannelCellArray removeAllObjects];
    }
}



-(void)removeCommonChannelGroupObject
{
    if(_RecomandChannelCellArray)
    {
        [_RecomandChannelCellArray removeAllObjects];
    }
    if(_LaguageChannelCellArray)
    {
        [_LaguageChannelCellArray removeAllObjects];
    }
    if(_SongStyleChannelCellArray)
    {
        [_SongStyleChannelCellArray removeAllObjects];
    }
    if(_FeelingChannelCellArray)
    {
        [_FeelingChannelCellArray removeAllObjects];
    }
    _isEmpty = YES;
    
}




-(void)encodeWithCoder:(NSCoder *)aCoder
{
    //int不能直接转为id类型
    NSNumber *isEmpty = [NSNumber numberWithInt:_isEmpty];
    [aCoder encodeObject:isEmpty forKey:@"isEmpty"];
    [aCoder encodeObject:_MyRedHeartChannelCellArray forKey:@"redHeart"];
    [aCoder encodeObject:_RecomandChannelCellArray forKey:@"recomand"];
    [aCoder encodeObject:_LaguageChannelCellArray forKey:@"language"];
    [aCoder encodeObject:_SongStyleChannelCellArray forKey:@"songstyle"];
    [aCoder encodeObject:_FeelingChannelCellArray forKey:@"feeling"];
    [aCoder encodeObject:_TotalChannelArray forKey:@"total"];
    [aCoder encodeObject:_ChannelGroupTitleArray forKey:@"channelname"];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if([self init])
    {
        NSNumber * isEmpty = [aDecoder decodeObjectForKey:@"isEmpty"];
        _isEmpty = [isEmpty intValue];
        
        _MyRedHeartChannelCellArray = [aDecoder decodeObjectForKey:@"redHeart"];
        _RecomandChannelCellArray = [aDecoder decodeObjectForKey:@"recomand"];
        _LaguageChannelCellArray = [aDecoder decodeObjectForKey:@"language"];
        _SongStyleChannelCellArray = [aDecoder decodeObjectForKey:@"songstyle"];
        _FeelingChannelCellArray = [aDecoder decodeObjectForKey:@"feeling"];
        _TotalChannelArray = [aDecoder decodeObjectForKey:@"total"];
        _ChannelGroupTitleArray = [aDecoder decodeObjectForKey:@"channelname"];
    }
    return self;
    
}


@end
