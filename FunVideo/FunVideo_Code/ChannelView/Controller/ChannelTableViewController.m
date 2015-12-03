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
#import "ChannelTableViewCell.h"
#import "Commons.h"



static const CGFloat kTitleHeight               = 30;
static const CGFloat kFootHeight                = 0.1;
static const CGFloat kRowHeight                 = 60;
static const CGFloat kOrignTableView_X          = 0;
static const CGFloat kOrignTableView_Y          = 50;
static const CGFloat kOrignTitleLabel_X         = 0;
static const CGFloat kOrignTitleLabel_Y         = 20;
static const CGFloat kTitleViewHeight           = 30;


//字体设置,以iphone6为基准，向下5s及4，向上6s及6s plus兼容
static const CGFloat kHeaderFont = 15;


@interface ChannelTableViewController()
{
    DoubanServer * doubanServer;
    AppDelegate * appDelegate;
    ChannelGroup * channelGroup;
    PlayerInfo * playerInfo;
    
    //tableview
    UITableView * channeltableView;
    
    //ChannelTitleLabel
    UILabel * channelTitleLabel;
    
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
    self.view.backgroundColor = UISIDEBARCOLOR;
    
    //创建频道表头
    channelTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kOrignTitleLabel_X, kOrignTitleLabel_Y, FrankieAppWidth, kTitleViewHeight)];
    channelTitleLabel.backgroundColor = UISIDEBARCOLOR;
    channelTitleLabel.text = @"频道列表";
    channelTitleLabel.font = [UIFont boldSystemFontOfSize :kHeaderFont];
    channelTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:channelTitleLabel];
    

    //创建分组样式的UItableView
    channeltableView =[[UITableView alloc] initWithFrame:CGRectMake(kOrignTableView_X, kOrignTableView_Y, FrankieAppWidth, FrankieAppHeigth) style: UITableViewStyleGrouped];
    channeltableView.separatorColor = UIBUTTONCOLOR;
    channeltableView.delegate = self;
    channeltableView.dataSource = self;
    
    //加载refreshHeaderView
    if(!_refreshHeaderView)
    {
        _refreshHeaderView = [[EGORefreshTableHeaderView alloc]initWithFrame:CGRectMake(0, 0-channeltableView.bounds.size.height, channeltableView.bounds.size.width, channeltableView.bounds.size.height) arrowImageName:@"blackArrow@2x" textColor:[UIColor blackColor]];
        _refreshHeaderView.delegate = self;
        [channeltableView addSubview:_refreshHeaderView];
        _isReloading = NO;
        
    }
    [self.view addSubview:channeltableView];
    


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
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:channeltableView];
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

-(void)reloadTableView
{
    [channeltableView reloadData];
}

-(void)reloadTableViewCellWithIndexPath:(NSIndexPath *)indexPath
{
    [channeltableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationAutomatic];
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
    static NSString * reuseCellID = @"ChannelCellIDKey";
    static NSString * reuseUserCellID = @"UserCellIDKey";
    ChannelTableViewCell * cell = nil;
    if(0 == indexPath.section)
    {
        //首先根据标识去缓存池取
        cell = [tableView dequeueReusableCellWithIdentifier:reuseUserCellID];
        //如果缓存池没有则重新创建并放到缓存池中去
        if(!cell)
        {
             cell = [[ChannelTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseUserCellID isUserCell:YES];
        }
    }
    else
    {
        //首先根据标识去缓存池取
        cell = [tableView dequeueReusableCellWithIdentifier:reuseCellID];
        //如果缓存池没有则重新创建并放到缓存池中去
        if(!cell)
        {
            cell = [[ChannelTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseCellID isUserCell:NO];
        }

    }
    //初始化cell
    [cell setChannelCellInfo:channelInfoCell];
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
    return kTitleHeight;
}
#pragma 设置分组标题高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kTitleHeight;
}

#pragma 设置尾部说明高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return kFootHeight;
}

#pragma 设置每行高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kRowHeight;
}

#pragma 点击行
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChannelInfo * channelInfo = [[channelGroup.totalChannelArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if(0 == indexPath.section && 0 == indexPath.row)
    {
        //跳转至登录页面
       ;
        [_delegate showViewWithIndex:2];
    }
    else
    {
        playerInfo.currentChannel = [playerInfo.currentChannel initWithChannelInfo:channelInfo];
        [doubanServer doubanSongOperationWithType:@"n"];
        [_delegate showViewWithIndex:0];

    }
    
}

-(void)getSongListFail
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
    HeaderView.textLabel.font = [UIFont boldSystemFontOfSize:kHeaderFont];
    [HeaderView.contentView setBackgroundColor:UIBUTTONCOLOR];

}


















@end
