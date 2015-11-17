//
//  ChannelTableViewCell.h
//  FunVideo
//
//  Created by frankie on 15/11/6.
//  Copyright © 2015年 FrankieCompany. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChannelTableViewCell : UITableViewCell


#pragma Channel图片
@property (nonatomic,strong)UIImageView * ChannelImageView;

#pragma Channel主标题
@property (nonatomic,strong)UILabel * ChannelMainLabel;

#pragma Channel详细介绍
@property (nonatomic,strong)UILabel * ChannelDetailLabel;

@end
