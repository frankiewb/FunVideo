//
//  ChannelGroup.h
//  FunVideo
//
//  Created by frankie on 15/11/4.
//  Copyright © 2015年 FrankieCompany. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ChannelGroup : NSObject<NSCoding>


//表明是否为空
@property(nonatomic)bool isEmpty;

//我的红心兆赫
@property(nonatomic,copy)NSMutableArray * myRedHeartChannelCellArray;

//推荐兆赫
@property(nonatomic,copy)NSMutableArray * recomandChannelCellArray;;

//语言年代兆赫
@property(nonatomic,copy)NSMutableArray * laguageChannelCellArray;

//风格流派兆赫
@property(nonatomic,copy)NSMutableArray * songStyleChannelCellArray;

//心情场景兆赫
@property(nonatomic,copy)NSMutableArray * feelingChannelCellArray;

//存放所有Channel分组
@property(nonatomic,copy)NSMutableArray * totalChannelArray;

//存放所有CHannel分组Title
@property(nonatomic,copy)NSMutableArray * channelGroupTitleArray;





-(instancetype)init;

-(void)removeCommonChannelGroupObject;
-(void)removeMyChannelObject;

@end
