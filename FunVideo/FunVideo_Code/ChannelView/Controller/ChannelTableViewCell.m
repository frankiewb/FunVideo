//
//  ChannelTableViewCell.m
//  FunVideo
//
//  Created by frankie on 15/12/2.
//  Copyright © 2015年 FrankieCompany. All rights reserved.
//

#import "ChannelTableViewCell.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
#import "ChannelInfo.h"
#import "Commons.h"

static const CGFloat kChannelImageViewLeft = 10;
static const CGFloat kChannelNameLabelbottomFactor = 0.5f;
static const CGFloat kChannelDescriptionLabelBottomFactor = 0.9f;
static const CGFloat kChannelLabelleftFactor = 1.3f;

@implementation ChannelTableViewCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier isUserCell:(BOOL)isUserCell
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        if(!isUserCell)
        {
            self = [self initChannelTableViewCell];
            [self setUpFrame];
        }
        else
        {
            self = [self initChannelTableViewCellForUserCellCase];
            [self setUpFrameForUserCellCase];
        }
        
    }
    return self;
    
}

- (instancetype)initChannelTableViewCell
{
    self.contentView.backgroundColor = UIBACKGROUNDCOLOR;
    //ChannelImageView
    _channelImageView = [[UIImageView alloc]init];
    [self.contentView addSubview:_channelImageView];

    
    //ChannelNameLabel
    _channelNameLabel = [[UILabel alloc]init];
    _channelNameLabel.font = [UIFont systemFontOfSize:18];
    [self.contentView addSubview:_channelNameLabel];
    
    
    //ChannelDiscriptionLabel
    _channelDescriptionLabel = [[MarqueeLabel alloc]init];
    _channelDescriptionLabel.rate = 10.0f;
    _channelDescriptionLabel.fadeLength = 10.0f;
    _channelDescriptionLabel.animationCurve = UIViewAnimationCurveEaseIn;
    _channelDescriptionLabel.marqueeType = MLLeftRight;
    [_channelDescriptionLabel setFont:[UIFont systemFontOfSize:12]];
    [self.contentView addSubview:_channelDescriptionLabel];
    
    return self;
}


- (void)setUpFrame
{
    [_channelImageView mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.left.equalTo(self.contentView.mas_left).offset(kChannelImageViewLeft);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.width.and.height.mas_equalTo(@45);
    }];
    
    [_channelNameLabel mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.top.mas_equalTo(self.contentView.mas_top);
        make.bottom.equalTo(self.contentView.mas_bottom).multipliedBy(kChannelNameLabelbottomFactor);
        make.left.equalTo(self.channelImageView.mas_right).multipliedBy(kChannelLabelleftFactor);
        make.right.mas_equalTo(self.contentView.mas_right);
    }];
    
    [_channelDescriptionLabel mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.top.mas_equalTo(self.channelNameLabel.mas_bottom);
        make.bottom.equalTo(self.contentView.mas_bottom).multipliedBy(kChannelDescriptionLabelBottomFactor);
        make.left.equalTo(self.channelImageView.mas_right).multipliedBy(kChannelLabelleftFactor);
        make.right.mas_equalTo(self.contentView.mas_right);
    }];
}

- (instancetype)initChannelTableViewCellForUserCellCase
{
    self.contentView.backgroundColor = UIBACKGROUNDCOLOR;
    //ChannelImageView
    _channelImageView = [[UIImageView alloc]init];
    [self.contentView addSubview:_channelImageView];
    
    
    //ChannelNameLabel
    _channelNameLabel = [[UILabel alloc]init];
    _channelNameLabel.font = [UIFont systemFontOfSize:18];
    [self.contentView addSubview:_channelNameLabel];
    
    return self;

}



- (void)setUpFrameForUserCellCase
{
    
    [_channelImageView mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.left.equalTo(self.contentView.mas_left).offset(kChannelImageViewLeft);
         make.centerY.mas_equalTo(self.contentView.mas_centerY);
         make.width.and.height.mas_equalTo(@45);
     }];
    
    [_channelNameLabel mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.top.mas_equalTo(self.contentView.mas_top);
         make.bottom.mas_equalTo(self.contentView.mas_bottom);
         make.left.equalTo(self.channelImageView.mas_right).multipliedBy(kChannelLabelleftFactor);
         make.right.mas_equalTo(self.contentView.mas_right);
     }];
}

- (void)setChannelCellInfo:(ChannelInfo *)channelInfo
{
    //set channelImageView
    if(channelInfo.channelCoverURL)
    {
        [_channelImageView sd_setImageWithURL:[NSURL URLWithString:channelInfo.channelCoverURL]
                             placeholderImage:[UIImage imageNamed:@"defaultcell"]
                                    completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
        {
            
            _channelImageView.layer.cornerRadius = _channelImageView.bounds.size.width/2.0;
            _channelImageView.layer.masksToBounds = YES;
            _channelImageView.contentMode = UIViewContentModeScaleAspectFill;
            //_channelImageView.clipsToBounds = YES;
            if(!error)
            {
                NSLog(@"LoadPic successful");
            }
            else
            {
                NSLog(@"LoadPic Error : %@",error);
            }
        }];
    }
    else
    {

        [_channelImageView setImage:[UIImage imageNamed:@"noneuser.png"]];

    }
    
    
    //set channelName
    _channelNameLabel.text = channelInfo.channelName;
    
    //set channelDescription
    if(_channelDescriptionLabel)
    {
        _channelDescriptionLabel.text = channelInfo.channelIntro;
    }
    
}









@end
