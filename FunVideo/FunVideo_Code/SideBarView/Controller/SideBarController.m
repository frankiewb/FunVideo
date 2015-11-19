//
//  SideBarController.m
//  FrankieVideo_New
//
//  Created by frankie on 15/10/26.
//  Copyright © 2015年 frankieCompany. All rights reserved.
//

#import "SideBarController.h"
#import "PlayerViewController.h"
#import "LoginViewController.h"
#import "UserViewController.h"
#import "ChannelTableViewController.h"
#import "Commons.h"


#define UISIDEBARCOLOR [UIColor colorWithRed:1/255.0 green:1/255.0 blue:1/255.0 alpha:0.5]
#define kMainButton_Xpoint FrankieAppWidth - 50
static const CGFloat kMainButton_Ypoint              = 40;
static const CGFloat kMainButton_Height              = 40;
static const CGFloat kMainButton_Width               = 40;
static const CGFloat kFunctionButton_Xpoint          = 10;
static const CGFloat kFunctionButton_Ypoint          = 50;
static const CGFloat kFunctionButton_Heigth_Distance = 80;
static const CGFloat kFunctionButton_Width           = 40;
static const CGFloat kFunctionButton_Height          = 40;
static const CGFloat kBackgroundView_Width           = 60;






@interface SideBarController()
{
    //表示侧边栏是否展开
    BOOL SidebarIsOpen;
    
    //PlayerView
    PlayerViewController * playerVC;
    
    //LoginView
    LoginViewController * loginVC;
    
    //UserView
    UserViewController * userVC;
    
    //ChannelView
    ChannelTableViewController * channelVC;
    
    //doubanServer
    DoubanServer * doubanServer;
    
    
    
    //SideBar上四个按钮容器
    NSMutableArray * buttonList;
    
    //表明Sidebar是否打开
    BOOL isSideBarOpen;
    
    
    //存放4个导航按钮的View
    UIView * backgroundMenuView;
    
    //展开存放导航按钮View的Button
    UIButton * mainViewButton;
    
}


@end


@implementation SideBarController


-(void)viewDidLoad
{
    [super viewDidLoad];
    doubanServer = [[DoubanServer alloc]init];
    doubanServer.delegate = self;
    [self setUpUI];
    UIStoryboard * mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    playerVC = [mainStoryBoard instantiateViewControllerWithIdentifier:@"playerVC"];
    loginVC = [mainStoryBoard instantiateViewControllerWithIdentifier:@"loginVC"];
    userVC = [mainStoryBoard instantiateViewControllerWithIdentifier:@"userVC"];
    channelVC = [mainStoryBoard instantiateViewControllerWithIdentifier:@"channelVC"];
    channelVC.delegate = self;
    userVC.delegate = channelVC;
    
    
    self.viewControllers = @[playerVC,channelVC,userVC];
}


-(void)setUpUI
{
    self.tabBar.hidden = YES;
    //初始化Image队列
    NSArray * imageList = @[[UIImage imageNamed:@"menuPlayer"],
                            [UIImage imageNamed:@"menuChannel"],
                            [UIImage imageNamed:@"menuLogin"],
                            [UIImage imageNamed:@"menuClose.png"]];
    
    buttonList = [[NSMutableArray alloc]initWithCapacity:imageList.count];
    
    //设置BackgroundMenuView
    backgroundMenuView = [[UIView alloc]init];
    backgroundMenuView.frame = CGRectMake(FrankieAppWidth, 0,kBackgroundView_Width,FrankieAppHeigth);
    backgroundMenuView.backgroundColor = UISIDEBARCOLOR;
    [self.view addSubview:backgroundMenuView];

    
    //设置MainViewButton
    mainViewButton = [UIButton buttonWithType:UIButtonTypeCustom];
    mainViewButton.bounds = CGRectMake(0,0,kMainButton_Width,kMainButton_Height);
    [mainViewButton setImage:[UIImage imageNamed:@"menuIcon"] forState:UIControlStateNormal];
    [mainViewButton addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    mainViewButton.frame = CGRectMake(kMainButton_Xpoint, kMainButton_Ypoint, kMainButton_Width, kMainButton_Height);
    [self.view addSubview:mainViewButton];
    UITapGestureRecognizer * singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                                action:@selector(dismissMenu)];
    singleTap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:singleTap];
    
    
    
    
    //生成4个button
    int buttonIndexTag = 0;
    for(UIImage * image in [imageList copy])
    {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:image forState:UIControlStateNormal];
        button.frame = CGRectMake(kFunctionButton_Xpoint, kFunctionButton_Ypoint +
                                  kFunctionButton_Heigth_Distance * buttonIndexTag, kFunctionButton_Width, kMainButton_Height);
        
        button.tag = buttonIndexTag;
        button.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 70, 0);
        
        [button addTarget:self action:@selector(onMenuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [backgroundMenuView addSubview:button];
        [buttonList addObject:button];
        buttonIndexTag++;
    }
    
}

//主屏幕显示哪个页面
//index : 1  PlayerView
//index : 2  ChannelView
//index : 3  LoginView
//index : 4  self
-(void)showViewWithIndex:(NSInteger)index
{
    switch (index)
    {
        case 0:
        case 1:
        case 2:
            self.selectedIndex = index;
            break;
        case 3:
            break;
    }

}


-(void)onMenuButtonClick:(UIButton *)button
{
    NSInteger index = button.tag;
    [self showViewWithIndex:index];
    [self dismissMenuWithSelection:button];
}



//以下为SideBar的推出动作
-(void)dismissMenuWithSelection:(UIButton *)button
{
  [UIView animateWithDuration:0.3
                        delay:0.0
       usingSpringWithDamping:.2f
        initialSpringVelocity:10.f
                      options:0
                   animations:^{
                       button.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);
                   }completion:^(BOOL finished){
                       [self dismissMenu];
                   }];
}




-(void)dismissMenu
{
    if(isSideBarOpen)
    {
        isSideBarOpen = false;
        [self performSelectorInBackground:@selector(performDismissAnimation) withObject:nil];
    }
}


-(void)performDismissAnimation
{
    [UIView animateWithDuration:0.4 animations:^{
       
        mainViewButton.alpha = 1.0;
        mainViewButton.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0);
        backgroundMenuView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0);
    }];
    dispatch_async(dispatch_get_main_queue(), ^{
        for (UIButton * button in buttonList)
        {
            [UIView animateWithDuration:0.4 animations:^{
               
                button.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 70, 0);
            }];
        }
    });
}

//以下为SideBar的推入动作
-(void)showMenu
{
    if(!isSideBarOpen)
    {
        isSideBarOpen = true;
        [self performSelectorInBackground:@selector(performOpenAnimation) withObject:nil];
    }
}


-(void)performOpenAnimation
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.4 animations:^{
           
            mainViewButton.alpha = 0.0;
            mainViewButton.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, -70, 0);
            backgroundMenuView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, -kBackgroundView_Width, 0);
        }];
    });
    
    for(UIButton * button in buttonList)
    {
        [NSThread sleepForTimeInterval:0.02f];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [UIView animateWithDuration:0.3
                                  delay:0.3
                 usingSpringWithDamping:.7
                  initialSpringVelocity:10.f
                                options:0
                             animations:^{
                                 button.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0);
                             }completion:^(BOOL finished){}];
        });
    }
}




























@end
