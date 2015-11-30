//
//  ChannelTableViewController.m
//  FunVideo
//
//  Created by frankie on 15/11/3.
//  Copyright © 2015年 FrankieCompany. All rights reserved.
//

#import "ChannelTableViewController.h"
#import "AppDelegate.h"
#import "ChannelGroup.h"
#import "ChannelInfo.h"
#import "PlayerInfo.h"
#import "UIKIT+AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "Commons.h"



static const CGFloat kTITLE_HEIGHT  = 30;
static const CGFloat kFOOTER_HEIGHT = 1;
static const CGFloat kROW_HEIGHT    = 60;
static const CGFloat kORIGIN_X      = 0;
static const CGFloat kORIGIN_Y      = 0;



@interface ChannelTableViewController()
{
    DoubanServer * doubanServer;
    AppDelegate * appDelegate;
    ChannelGroup * channelGroup;
    PlayerInfo * playerInfo;
    
    //refreshView
    EGORefreshTableHeaderView * _refreshHeaderView;
    BOOL _isReloading;
}

@end

@implementation ChannelTableViewController


-(void)viewDidLoad
{
    [super viewDidLoad];
    
    //初始化工具
    appDelegate = [[UIApplication sharedApplication]delegate];
    doubanServer = [[DoubanServer alloc]initDoubanServer];
    [doubanServer doubanGetChannelGroup];
    channelGroup = appDelegate.channelGroup;
    playerInfo = appDelegate.playerInfo;
    doubanServer.delegate = self;
    assert(channelGroup);

    //创建分组样式的UItableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(kORIGIN_X, kORIGIN_Y, FrankieAppWidth, FrankieAppHeigth) style:
                      UITableViewStyleGrouped];
    self.tableView.separatorColor = UIBUTTONCOLOR;
    
    //加载refreshHeaderView
    if(!_refreshHeaderView)
    {
        _refreshHeaderView = [[EGORefreshTableHeaderView alloc]initWithFrame:CGRectMake(0, 0-self.tableView.bounds.size.height, self.tableView.bounds.size.width, self.tableView.bounds.size.height) arrowImageName:@"blackArrow@2x" textColor:[UIColor blackColor]];
        _refreshHeaderView.delegate = self;
        [self.tableView addSubview:_refreshHeaderView];
        _isReloading = NO;
        
    }


}

#pragma mark Data Source Loading / Reloading Methods

-(void)p_reloadTableViewDataSource
{
    //  should be calling your tableviews data source model to reload
    //[appDelegate.channelGroup removeAllChannelGroupObject];
    [doubanServer doubanGetChannelGroup];
    _isReloading = YES;
}

-(void)p_doneLoadingTableViewData
{
    //  model should call this when its done loading
    _isReloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
}





#pragma mark UIScrollViewDelegate Methods

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}


-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}



#pragma mark EGORefreshTableHeaderDelegate Methods

-(void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    [self p_reloadTableViewDataSource];
    //[self performSelector:@selector(p_doneLoadingTableViewData) withObject:nil afterDelay:2.0];
    //优化采用gcd模式
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC));
    dispatch_after(time, dispatch_get_main_queue(), ^(void){[self p_doneLoadingTableViewData];});
    
    
}

-(BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
    // should return if data source model is reloading
    return _isReloading;
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
    // should return date data source was last changed
    return [NSDate date];
}


-(void)initTableViewCellWithChannelInfo:(ChannelInfo *)channelInfo TableViewCell:(UITableViewCell *)cell
{
    cell.textLabel.text = channelInfo.channelName;
    cell.detailTextLabel.text = channelInfo.channelIntro;
    cell.imageView.layer.cornerRadius = cell.imageView.bounds.size.width/2.0;
    cell.imageView.layer.masksToBounds = YES;
    cell.contentView.backgroundColor = UIBACKGROUNDCOLOR;
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:channelInfo.channelCoverURL] placeholderImage:[UIImage imageNamed:@"defaultcell"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
    {
        NSLog(@"LoadPic successful");
    }];
}

-(void)initUserLabelCellWithChannelInfo:(ChannelInfo *)channelInfo TableViewCell:(UITableViewCell *)cell
{
    cell.textLabel.text = channelInfo.channelName;
    cell.detailTextLabel.text = channelInfo.channelIntro;
    cell.imageView.layer.cornerRadius = cell.imageView.bounds.size.width/2.0;
    cell.imageView.layer.masksToBounds = YES;
    cell.contentView.backgroundColor = UIBACKGROUNDCOLOR;
    [cell.imageView setImage:[UIImage imageNamed:@"noneuser.png"]];
    NSLog(@"LoadNonUserPic successful");

}



-(void)doubanDelegate_reloadTableView
{
    [self.tableView reloadData];
}

-(void)doubanDelegate_reloadTableViewCellWithIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark -数据源方法
#pragma mark 返回分组数

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"计算分组数");
    return [channelGroup.totalChannelArray count];
}

#pragma mark 返回每组行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"计算每组(组%li)行数",(long)section);
    return [[channelGroup.totalChannelArray objectAtIndex:section] count];
    
}

#pragma mark 返回每行的单元格
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    //NSIndexPath是一个结构体，记录了组和行的信息
    NSLog(@"生成单元格(组:%li,行%li)",(long)indexPath.section,indexPath.row);
    ChannelInfo * channelInfoCell = [[channelGroup.totalChannelArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    //此方法调用频繁，cell标示声明为静态变量有利于性能优化，此ID表明的是UItableViewCell的类型，有几个类型声明几个ID
    static NSString * reuseCellID = @"CellIDKey";
    //首先根据标识去缓存池取
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseCellID];
    //如果缓存池没有则重新创建并放到缓存池中去
    if(!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseCellID];
    }
    //cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    //初始化cell
    if(indexPath.section == 0 && indexPath.row == 0)
    {
        if([channelInfoCell.channelName isEqualToString:@"未登录"])
        {
            [self initUserLabelCellWithChannelInfo:channelInfoCell TableViewCell:cell];
            return cell;
        }
        
    }
    [self initTableViewCellWithChannelInfo:channelInfoCell TableViewCell:cell];
    return cell;
}


#pragma mark 返回每组头标题名称
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSLog(@"生成组(组%li)名称",(long)section);
    return channelGroup.channelGroupTitleArray[section];
}

#pragma 设置分组标题内容高度
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section
{
    return kTITLE_HEIGHT;
}
#pragma 设置分组标题高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kTITLE_HEIGHT;
}

#pragma 设置尾部说明高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return kFOOTER_HEIGHT;
}

#pragma 设置每行高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kROW_HEIGHT;
}

#pragma 点击行
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChannelInfo * channelInfo = [[channelGroup.totalChannelArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if(indexPath.section == 0 && indexPath.row == 0)
    {
        //跳转至登录页面
        [_delegate showViewWithIndex:2];
    }
    else
    {
        playerInfo.currentChannel = [playerInfo.currentChannel initWithChannelInfo:channelInfo];
        [doubanServer doubanSongOperationWithType:@"n"];
        [_delegate showViewWithIndex:0];

    }
    
}

-(void)doubanDelegate_getSongListFail
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"登录失败"
                                                                              message:@"请检查网络或者服务器异常"
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];

}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView * HeaderView = (UITableViewHeaderFooterView *)view;
    [HeaderView.textLabel setTextColor:[UIColor whiteColor]];
    HeaderView.textLabel.font = [UIFont boldSystemFontOfSize:14];
    [HeaderView.contentView setBackgroundColor:UIBUTTONCOLOR];
    
}















@end
