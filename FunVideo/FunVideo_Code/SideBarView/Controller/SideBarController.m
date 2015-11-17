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
    NSMutableArray * ButtonList;
    
    //表明Sidebar是否打开
    BOOL SideBarIsOpen;
    
}

/**
 *存放4个导航按钮的View
 **/
@property(nonatomic,strong) UIView * BackgroundMenuView;

/**
 *展开存放导航按钮View的Button
 **/
@property(nonatomic,strong) UIButton * MainViewButton;

@end


@implementation SideBarController


-(void)viewDidLoad
{
    [super viewDidLoad];
    doubanServer = [[DoubanServer alloc]init];
    doubanServer.delegate = self;
    [self SetUpUI];
    UIStoryboard * MainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    playerVC = [MainStoryBoard instantiateViewControllerWithIdentifier:@"playerVC"];
    loginVC = [MainStoryBoard instantiateViewControllerWithIdentifier:@"loginVC"];
    userVC = [MainStoryBoard instantiateViewControllerWithIdentifier:@"userVC"];
    channelVC = [MainStoryBoard instantiateViewControllerWithIdentifier:@"channelVC"];
    channelVC.delegate = self;
    userVC.delegate = channelVC;
    
    
    self.viewControllers = @[playerVC,channelVC,userVC];
}


-(void)SetUpUI
{
    self.tabBar.hidden = YES;
    //初始化Image队列
    NSArray * ImageList = @[[UIImage imageNamed:@"menuPlayer"],
                            [UIImage imageNamed:@"menuChannel"],
                            [UIImage imageNamed:@"menuLogin"],
                            [UIImage imageNamed:@"menuClose.png"]];
    
    ButtonList = [[NSMutableArray alloc]initWithCapacity:ImageList.count];
    
    //设置BackgroundMenuView
    _BackgroundMenuView = [[UIView alloc]init];
    _BackgroundMenuView.frame = CGRectMake(FrankieAppWidth, 0,SideBarView_BackgroundView_Width,[UIScreen mainScreen].bounds.size.height);
    _BackgroundMenuView.backgroundColor = UISIDEBARCOLOR;
    [self.view addSubview:_BackgroundMenuView];

    
    //设置MainViewButton
    _MainViewButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _MainViewButton.bounds = CGRectMake(0,0,SideBarView_MainButton_Width,SideBarView_MainButton_Height);
    [_MainViewButton setImage:[UIImage imageNamed:@"menuIcon"] forState:UIControlStateNormal];
    [_MainViewButton addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    _MainViewButton.frame = CGRectMake(SideBarView_MainButton_Xpoint, SideBarView_MainButton_Ypoint, SideBarView_MainButton_Width, SideBarView_MainButton_Height);
    [self.view addSubview:_MainViewButton];
    UITapGestureRecognizer * singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                                action:@selector(dismissMenu)];
    singleTap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:singleTap];
    
    
    
    
    //生成4个button
    int buttonIndexTag = 0;
    for(UIImage * image in [ImageList copy])
    {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:image forState:UIControlStateNormal];
        button.frame = CGRectMake(SideBarView_FunctionButton_Xpoint, SideBarView_FunctionButton_Ypoint +
                                  SideBarView_FunctionButton_Heigth_Distance * buttonIndexTag, SideBarView_FunctionButton_Width, SideBarView_MainButton_Height);
        
        button.tag = buttonIndexTag;
        button.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 70, 0);
        
        [button addTarget:self action:@selector(OnMenuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_BackgroundMenuView addSubview:button];
        [ButtonList addObject:button];
        buttonIndexTag++;
    }
    
}

//主屏幕显示哪个页面
//index : 1  PlayerView
//index : 2  ChannelView
//index : 3  LoginView
//index : 4  self
-(void)ShowViewWithIndex:(NSInteger)Index
{
    switch (Index)
    {
        case 0:
        case 1:
        case 2:
            self.selectedIndex = Index;
            break;
        case 3:
            break;
    }

}


-(void)OnMenuButtonClick:(UIButton *)button
{
    NSInteger Index = button.tag;
    [self ShowViewWithIndex:Index];
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
    if(SideBarIsOpen)
    {
        SideBarIsOpen = false;
        [self performSelectorInBackground:@selector(performDismissAnimation) withObject:nil];
    }
}


-(void)performDismissAnimation
{
    [UIView animateWithDuration:0.4 animations:^{
       
        _MainViewButton.alpha = 1.0;
        _MainViewButton.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0);
        _BackgroundMenuView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0);
    }];
    dispatch_async(dispatch_get_main_queue(), ^{
        for (UIButton * button in ButtonList)
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
    if(!SideBarIsOpen)
    {
        SideBarIsOpen = true;
        [self performSelectorInBackground:@selector(performOpenAnimation) withObject:nil];
    }
}


-(void)performOpenAnimation
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.4 animations:^{
           
            _MainViewButton.alpha = 0.0;
            _MainViewButton.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, -70, 0);
            _BackgroundMenuView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, -SideBarView_BackgroundView_Width, 0);
        }];
    });
    
    for(UIButton * button in ButtonList)
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
