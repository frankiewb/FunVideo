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
        _myRedHeartChannelCellArray = [[NSMutableArray alloc]init];
        _recomandChannelCellArray = [[NSMutableArray alloc]init];
        _laguageChannelCellArray = [[NSMutableArray alloc]init];
        _songStyleChannelCellArray = [[NSMutableArray alloc]init];
        _feelingChannelCellArray = [[NSMutableArray alloc]init];
        _totalChannelArray = [[NSMutableArray alloc]init];
        _channelGroupTitleArray = [[NSMutableArray alloc]init];
        
        [_totalChannelArray addObject:_myRedHeartChannelCellArray];
        NSString * redHeartChannelTitle = @"我的红心兆赫";
        [_channelGroupTitleArray addObject:redHeartChannelTitle];
        
        [_totalChannelArray addObject:_recomandChannelCellArray];
        NSString * reconmandChannelTitle = @"推荐兆赫";
        [_channelGroupTitleArray addObject:reconmandChannelTitle];
                
        [_totalChannelArray addObject:_laguageChannelCellArray];
        NSString * languageChannelCellTitle = @"语言年代兆赫";
        [_channelGroupTitleArray addObject:languageChannelCellTitle];
        
        [_totalChannelArray addObject:_songStyleChannelCellArray];
        NSString * songStyleChannelCellTitle = @"风格流派兆赫";
        [_channelGroupTitleArray addObject:songStyleChannelCellTitle];
        
        [_totalChannelArray addObject:_feelingChannelCellArray];
        NSString * feelingChannelCellTitle = @"心情场景兆赫";
        [_channelGroupTitleArray addObject:feelingChannelCellTitle];
        
        _isEmpty = YES;
    
    }
    return self;
}

-(void)removeMyChannelObject
{
    if(_myRedHeartChannelCellArray)
    {
        [_myRedHeartChannelCellArray removeAllObjects];
    }
}



-(void)removeCommonChannelGroupObject
{
    if(_recomandChannelCellArray)
    {
        [_recomandChannelCellArray removeAllObjects];
    }
    if(_laguageChannelCellArray)
    {
        [_laguageChannelCellArray removeAllObjects];
    }
    if(_songStyleChannelCellArray)
    {
        [_songStyleChannelCellArray removeAllObjects];
    }
    if(_feelingChannelCellArray)
    {
        [_feelingChannelCellArray removeAllObjects];
    }
    _isEmpty = YES;
    
}




-(void)encodeWithCoder:(NSCoder *)aCoder
{
    //int不能直接转为id类型
    NSNumber *isEmpty = [NSNumber numberWithInt:_isEmpty];
    [aCoder encodeObject:isEmpty forKey:@"isEmpty"];
    [aCoder encodeObject:_myRedHeartChannelCellArray forKey:@"redHeart"];
    [aCoder encodeObject:_recomandChannelCellArray forKey:@"recomand"];
    [aCoder encodeObject:_laguageChannelCellArray forKey:@"language"];
    [aCoder encodeObject:_songStyleChannelCellArray forKey:@"songstyle"];
    [aCoder encodeObject:_feelingChannelCellArray forKey:@"feeling"];
    [aCoder encodeObject:_totalChannelArray forKey:@"total"];
    [aCoder encodeObject:_channelGroupTitleArray forKey:@"channelname"];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if([self init])
    {
        NSNumber * isEmpty = [aDecoder decodeObjectForKey:@"isEmpty"];
        _isEmpty = [isEmpty intValue];
        
        _myRedHeartChannelCellArray = [aDecoder decodeObjectForKey:@"redHeart"];
        _recomandChannelCellArray = [aDecoder decodeObjectForKey:@"recomand"];
        _laguageChannelCellArray = [aDecoder decodeObjectForKey:@"language"];
        _songStyleChannelCellArray = [aDecoder decodeObjectForKey:@"songstyle"];
        _feelingChannelCellArray = [aDecoder decodeObjectForKey:@"feeling"];
        _totalChannelArray = [aDecoder decodeObjectForKey:@"total"];
        _channelGroupTitleArray = [aDecoder decodeObjectForKey:@"channelname"];
    }
    return self;
    
}




@end
