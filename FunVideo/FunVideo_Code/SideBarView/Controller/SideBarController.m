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
#import "Masonry.h"


static const CGFloat kBackGroundViewWidthFactor          = 0.17;
static const CGFloat kMainButtonTop                      = 40;
static const CGFloat kMainButtonRightFactor              = 0.972f;
static const CGFloat kMainButtonWidthAndHeightFactor     = 0.111f;
static const CGFloat kFunctionButtonHeightDistanceFactor = 0.141;
static const CGFloat kFunctionButtonLeft                 = 10;
static const CGFloat kFunctionButtonWidthAndHeightFactor = 0.111f;


@interface SideBarController()
{
    //表示侧边栏是否展开
    BOOL SidebarIsOpen;
    //PlayerView
    PlayerViewController *playerVC;
    //LoginView
    LoginViewController *loginVC;
    //UserView
    UserViewController *userVC;
    //ChannelView
    ChannelTableViewController *channelVC;
    //doubanServer
    DoubanServer *doubanServer;
    //SideBar上四个按钮容器
    NSMutableArray *buttonList;
    //表明Sidebar是否打开
    BOOL isSideBarOpen;
    //存放4个导航按钮的View
    UIView *backgroundMenuView;
    //展开存放导航按钮View的Button
    UIButton *mainViewButton;
    
}


@end


@implementation SideBarController


- (void)viewDidLoad
{
    [super viewDidLoad];
    doubanServer = [[DoubanServer alloc]init];
    doubanServer.delegate = self;
    [self p_setUpUI];
    [self p_setUpAutoLayout];
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    playerVC = [mainStoryBoard instantiateViewControllerWithIdentifier:@"playerVC"];
    userVC = [mainStoryBoard instantiateViewControllerWithIdentifier:@"userVC"];
    channelVC = [mainStoryBoard instantiateViewControllerWithIdentifier:@"channelVC"];
    channelVC.delegate = self;
    userVC.douban_delegate = channelVC;
    
    
    self.viewControllers = @[playerVC,channelVC,userVC];
}



- (void)p_setUpAutoLayout
{
    //设置BackgroundMenuView
    [backgroundMenuView mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_right);
        make.height.mas_equalTo(self.view.mas_height);
        make.width.equalTo(self.view.mas_width).with.multipliedBy(kBackGroundViewWidthFactor);
        
    }];
    
    
    //设置MainViewButton
    [mainViewButton mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.top.equalTo(self.view.mas_top).with.offset(kMainButtonTop);
        make.right.equalTo(self.view.mas_right).with.multipliedBy(kMainButtonRightFactor);
        make.width.and.height.equalTo(self.view.mas_width).with.multipliedBy(kMainButtonWidthAndHeightFactor);
    }];
    
    //设定4个button位置
    int buttonIndexTag = 0;
    for(UIButton * button in buttonList)
    {
        [button mas_makeConstraints:^(MASConstraintMaker *make)
        {

            make.top.equalTo(backgroundMenuView.mas_top).with.offset(kMainButtonTop + buttonIndexTag*kFunctionButtonHeightDistanceFactor * FrankieAppHeigth);
            make.left.equalTo(backgroundMenuView.mas_left).with.offset(kFunctionButtonLeft);
            make.width.and.height.equalTo(self.view.mas_width).with.multipliedBy(kFunctionButtonWidthAndHeightFactor);
            
        }];
        buttonIndexTag++;
    }

}



- (void)p_setUpUI
{
    self.tabBar.hidden = YES;
    //初始化Image队列
    NSArray *imageList = @[[UIImage imageNamed:@"menuPlayer"],
                            [UIImage imageNamed:@"menuChannel"],
                            [UIImage imageNamed:@"menuLogin"],
                            [UIImage imageNamed:@"menuClose.png"]];
    
    buttonList = [[NSMutableArray alloc]initWithCapacity:imageList.count];
    
    //设置BackgroundMenuView
    backgroundMenuView = [[UIView alloc]init];
    backgroundMenuView.backgroundColor = UISIDEBARCOLOR;
    [self.view addSubview:backgroundMenuView];

    
    //设置MainViewButton
    mainViewButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [mainViewButton setBackgroundImage:[UIImage imageNamed:@"menuIcon"] forState:UIControlStateNormal];
    [mainViewButton addTarget:self action:@selector(p_showMenu) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:mainViewButton];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                                action:@selector(p_dismissMenu)];
    singleTap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:singleTap];
    
    
    
    
    //生成4个button
    int buttonIndexTag = 0;
    for(UIImage *image in [imageList copy])
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:image forState:UIControlStateNormal];
        button.tag = buttonIndexTag;
        button.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 70, 0);
        [button addTarget:self action:@selector(p_onMenuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
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
- (void)showViewWithIndex:(NSInteger)index
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


- (void)p_onMenuButtonClick:(UIButton *)button
{
    NSInteger index = button.tag;
    [self showViewWithIndex:index];
    [self p_dismissMenuWithSelection:button];
}



//以下为SideBar的推出动作
- (void)p_dismissMenuWithSelection:(UIButton *)button
{
  [UIView animateWithDuration:0.3
                        delay:0.0
       usingSpringWithDamping:.2f
        initialSpringVelocity:10.f
                      options:0
                   animations:^{
                       button.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);
                   }completion:^(BOOL finished){
                       [self p_dismissMenu];
                   }];
}




- (void)p_dismissMenu
{
    if(isSideBarOpen)
    {
        isSideBarOpen = false;
        //[self performSelectorInBackground:@selector(p_performDismissAnimation) withObject:nil];
        //涉及ui采用主线程异步gcd
        dispatch_async(dispatch_get_main_queue(), ^(void){[self p_performDismissAnimation];});
    }
}


- (void)p_performDismissAnimation
{
    [UIView animateWithDuration:0.4 animations:^{
       
        mainViewButton.alpha = 1.0;
        mainViewButton.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0);
        backgroundMenuView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0);
    }];
    dispatch_async(dispatch_get_main_queue(), ^{
        for (UIButton *button in buttonList)
        {
            [UIView animateWithDuration:0.4 animations:^{
               
                button.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 70, 0);
            }];
        }
    });
}

//以下为SideBar的推入动作
- (void)p_showMenu
{
    if(!isSideBarOpen)
    {
        isSideBarOpen = true;
        [self performSelectorInBackground:@selector(p_performOpenAnimation) withObject:nil];
    }
}


- (void)p_performOpenAnimation
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.4 animations:^{
           
            mainViewButton.alpha = 0.0;
            mainViewButton.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, -70, 0);
            backgroundMenuView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, -FrankieAppWidth * kBackGroundViewWidthFactor, 0);
        }];
    });
    
    for(UIButton *button in buttonList)
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

//Portrait = 正常竖屏
//UpsideDown ＝ 竖着倒转
//Landscape Left ＝ 横屏且按钮在左边
//Landscape Right = 横屏且按钮在右边

//是否支持屏幕旋转
- (BOOL)shouldAutorotate
{
    //不支持自动旋转，则默认正常竖屏Portrait
    return NO;
}



























@end
