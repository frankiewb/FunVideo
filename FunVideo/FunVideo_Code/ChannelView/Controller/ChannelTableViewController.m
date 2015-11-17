//
//  ChannelTableViewController.m
//  FunVideo
//
//  Created by frankie on 15/11/3.
//  Copyright © 2015年 FrankieCompany. All rights reserved.
//

#import "ChannelTableViewController.h"
#import "AppDelegate.h"
#import "ChannelInfo.h"
#import "PlayerInfo.h"
#import "UIKIT+AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "EGORefreshTableHeaderView.h"
#import "Commons.h"

@interface ChannelTableViewController()
{
    DoubanServer * doubanServer;
    AppDelegate * appDelegate;
    ChannelGroup * channelGroup;
    PlayerInfo * playerInfo;
    
    //refreshView
    EGORefreshTableHeaderView * _refreshHeaderView;
    BOOL _IsReloading;
}

@end

@implementation ChannelTableViewController


-(void)viewDidLoad
{
    [super viewDidLoad];
    
    //初始化工具
    appDelegate = [[UIApplication sharedApplication]delegate];
    doubanServer = [[DoubanServer alloc]initDoubanServer];
    [doubanServer DoubanGetChannelGroup];
    channelGroup = appDelegate.channelGroup;
    playerInfo = appDelegate.playerInfo;
    doubanServer.delegate = self;
    assert(channelGroup);

    //创建分组样式的UItableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(TABLEVIEW_ORIGIN_X, TABLEVIEW_ORIGIN_Y, FrankieAppWidth, FrankieAppHeigth) style:
                      UITableViewStyleGrouped];
    
    //加载refreshHeaderView
    if(!_refreshHeaderView)
    {
        _refreshHeaderView = [[EGORefreshTableHeaderView alloc]initWithFrame:CGRectMake(0, 0-self.tableView.bounds.size.height, self.tableView.bounds.size.width, self.tableView.bounds.size.height) arrowImageName:@"blackArrow@2x" textColor:[UIColor blackColor]];
        _refreshHeaderView.delegate = self;
        [self.tableView addSubview:_refreshHeaderView];
        _IsReloading = NO;
        
    }


}

#pragma mark Data Source Loading / Reloading Methods

-(void)ReloadTableViewDataSource
{
    //  should be calling your tableviews data source model to reload
    //[appDelegate.channelGroup removeAllChannelGroupObject];
    [doubanServer DoubanGetChannelGroup];
    _IsReloading = YES;
}

-(void)DoneLoadingTableViewData
{
    //  model should call this when its done loading
    _IsReloading = NO;
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
    [self ReloadTableViewDataSource];
    [self performSelector:@selector(DoneLoadingTableViewData) withObject:nil afterDelay:2.0];
}

-(BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
    // should return if data source model is reloading
    return _IsReloading;
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
    // should return date data source was last changed
    return [NSDate date];
}


-(void)initTableViewCellWithChannelInfo:(ChannelInfo *)channelInfo TableViewCell:(UITableViewCell *)cell
{
    cell.textLabel.text = channelInfo.ChannelName;
    cell.detailTextLabel.text = channelInfo.ChannelIntro;
    cell.imageView.layer.cornerRadius = cell.imageView.bounds.size.width/2.0;
    cell.imageView.layer.masksToBounds = YES;
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:channelInfo.ChannelCoverURL] placeholderImage:[UIImage imageNamed:@"defaultcell"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
    {
        NSLog(@"LoadPic successful");
    }];
}

-(void)initUserLabelCellWithChannelInfo:(ChannelInfo *)channelInfo TableViewCell:(UITableViewCell *)cell
{
    cell.textLabel.text = channelInfo.ChannelName;
    cell.detailTextLabel.text = channelInfo.ChannelIntro;
    cell.imageView.layer.cornerRadius = cell.imageView.bounds.size.width/2.0;
    cell.imageView.layer.masksToBounds = YES;
    [cell.imageView setImage:[UIImage imageNamed:@"noneuser.png"]];
    NSLog(@"LoadNonUserPic successful");

}



-(void)ReloadTableView
{
    [self.tableView reloadData];
}

-(void)ReloadTableViewCellWithIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark -数据源方法
#pragma mark 返回分组数

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"计算分组数");
    return [channelGroup.TotalChannelArray count];
}

#pragma mark 返回每组行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"计算每组(组%li)行数",(long)section);
    return [[channelGroup.TotalChannelArray objectAtIndex:section] count];
    
}

#pragma mark 返回每行的单元格
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    //NSIndexPath是一个结构体，记录了组和行的信息
    NSLog(@"生成单元格(组:%li,行%li)",(long)indexPath.section,indexPath.row);
    ChannelInfo * channelInfoCell = [[channelGroup.TotalChannelArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
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
        if([channelInfoCell.ChannelName isEqualToString:@"未登录"])
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
    return [channelGroup.ChannelGroupTitleArray objectAtIndex:section];
}

#pragma 设置分组标题内容高度
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        return TABLEVIEW_TITLE_HEIGHT + 20;
    }
    return TABLEVIEW_TITLE_HEIGHT;
}

#pragma 设置尾部说明高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return TABLEVIEW_FOOTER_HEIGHT;
}

#pragma 设置每行高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return TABLEVIEW_ROW_HEIGHT;
}

#pragma 点击行
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChannelInfo * channelInfo = [[channelGroup.TotalChannelArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if(indexPath.section == 0 && indexPath.row == 0)
    {
        //跳转至登录页面
        [_delegate ShowViewWithIndex:2];
    }
    else
    {
        playerInfo.CurrentChannel = [playerInfo.CurrentChannel initWithChannelInfo:channelInfo];
        [doubanServer DoubanSongOperationWithType:@"n"];
        [_delegate ShowViewWithIndex:0];

    }
    
}
















@end
