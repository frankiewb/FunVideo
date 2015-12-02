//
//  ChannelTableViewCell.h
//  FunVideo
//
//  Created by frankie on 15/12/2.
//  Copyright © 2015年 FrankieCompany. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MarqueeLabel.h"
@class ChannelInfo;

@interface ChannelTableViewCell : UITableViewCell

@property(nonatomic,strong)UIImageView * channelImageView;

@property(nonatomic,strong)UILabel * channelNameLabel;

@property(nonatomic,strong)MarqueeLabel * channelDescriptionLabel;


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier isUserCell:(BOOL)isUserCell;

-(void)setChannelCellInfo:(ChannelInfo *)channelInfo;

@end
