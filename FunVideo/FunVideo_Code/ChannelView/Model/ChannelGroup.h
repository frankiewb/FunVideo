//
//  ChannelGroup.h
//  FunVideo
//
//  Created by frankie on 15/11/4.
//  Copyright © 2015年 FrankieCompany. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ChannelGroup : NSObject<NSCoding>



@property(nonatomic)bool isEmpty;
@property(nonatomic,copy)NSMutableArray *myRedHeartChannelCellArray;
@property(nonatomic,copy)NSMutableArray *recomandChannelCellArray;;
@property(nonatomic,copy)NSMutableArray *laguageChannelCellArray;
@property(nonatomic,copy)NSMutableArray *songStyleChannelCellArray;
@property(nonatomic,copy)NSMutableArray *feelingChannelCellArray;
@property(nonatomic,copy)NSMutableArray *totalChannelArray;
//存放所有CHannel分组Title
@property(nonatomic,copy)NSMutableArray *channelGroupTitleArray;


- (instancetype)init;
- (void)removeCommonChannelGroupObject;
- (void)removeMyChannelObject;

@end
