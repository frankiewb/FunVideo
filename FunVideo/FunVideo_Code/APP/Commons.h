//
//  Commons.h
//  FrankieVideo_New
//
//  Created by frankie on 15/10/20.
//  Copyright © 2015年 frankieCompany. All rights reserved.
//

#ifndef Commons_h
#define Commons_h



/**
 * 公用宏
 */

#define FrankieAppWidth [UIScreen mainScreen].bounds.size.width
#define FrankieAppHeigth [UIScreen mainScreen].bounds.size.height

#define PLAYERURLFORMATSTRING @"http://douban.fm/j/mine/playlist?type=%@&sid=%@&pt=%f&channel=%@&from=mainsite"
#define LOGINURLSTRING @"http://douban.fm/j/login"
#define LOGOUTURLSTRING @"http://douban.fm/partner/logout"
#define CAPTCHAIDURLSTRING @"http://douban.fm/j/new_captcha"
#define CAPTCHAIMGURLFORMATSTRING @"http://douban.fm/misc/captcha?size=m&id=%@"
#define USERIMAGEURL @"http://img3.douban.com/icon/ul%@-1.jpg"

#define UIBACKGROUNDCOLOR [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1.0]
#define UISIDEBARCOLOR [UIColor colorWithRed:1/255.0 green:1/255.0 blue:1/255.0 alpha:0.5]
#define UILOGINVIEWLABELCOLOR [UIColor whiteColor]


/**
 *PlayerView控件相关宏
 */


#define PlayerView_Label_Height_Distance 20
#define PlayerView_label_Height 30
#define PlayerView_label_Width 200

#define PlayerView_Button_X_point 35
#define PlayerView_Button_Height_Distance 30
#define PlayerView_Button_Width_Distance 70
#define PlayerView_Button_Height 40
#define PlayerView_Button_Width 40

#define PlayerImageWidth  200
#define PlayerImageHeight 200
#define PlayerImage_X_point (FrankieAppWidth-PlayerImageWidth)/2
#define PlayerImage_Y_point 40

/**
 *SideBarView控件相关宏
 */

#define SideBarView_MainButton_Xpoint FrankieAppWidth - 50
#define SideBarView_MainButton_Ypoint 40
#define SideBarView_MainButton_Height 40
#define SideBarView_MainButton_Width 40

#define SideBarView_FunctionButton_Xpoint 10
#define SideBarView_FunctionButton_Ypoint 50
#define SideBarView_FunctionButton_Heigth_Distance 80
#define SideBarView_FunctionButton_Width 40
#define SideBarView_FunctionButton_Height 40

#define SideBarView_BackgroundView_Width 60
#define SideBarView_BackgroundView_Height [UIScreen mainScreen].bounds.size.height


/**
 *LoginView控件相关宏
 */

#define LoginView_Origin_Xpoint 10
#define LoginView_Origin_Ypoint 35
#define LoginView_LabelHeight_Distance 30
#define LoginView_TextFieldHeight_Distance 20
#define LoginView_CaptchaImageWidth_Distance 10

#define LoginView_Label_Field_Width 300
#define LoginView_Label_Field_Height 50

#define LoginView_Captcha_Width 140
#define LoginView_Captcha_Height 50

#define LoginView_CaptchaImageView_Width 150
#define LoginView_CaptchaImageView_Height 50

#define LoginView_ButtonHeight_Distance 50
#define LoginView_Button_Width 300
#define LoginView_Button_Heigth 50


/**
 * UserView控件相关宏
 */

#define UserView_Origin_Xpoint 85
#define UserView_Origin_Ypoint 60
#define UserView_UserImage_Width 150
#define UserView_UserImage_Height 150


#define UserView_UserName_Xpoint 60
#define UserView_UserName_Ypoint 250
#define UserView_UserName_Width 200
#define UserView_UserName_Height 50


#define UserView_PlayedLabel_Xpoint 40
#define UserView_PlayedLabel_Ypoint 350
#define UserView_PlayedLabel_Width 100
#define UserView_PlayedLabel_Height 100


#define UserView_BannedLabel_Xpoint 180
#define UserView_BannedLabel_Ypoint 350
#define UserView_BannedLabel_Width 100
#define UserView_BannedLabel_Height 100


#define UserView_LogoutButton_Xpoint 0
#define UserView_LogoutButton_Ypoint 500
#define UserView_LogoutButton_Width  320
#define UserView_LogoutButton_Hegiht 68


/**
 * ChannelView相关宏
 */

#define LOGINCHANNELURL @"http://douban.fm/j/explore/get_login_chls?uk="
#define TOTALCHANNELURL @"http://douban.fm/j/explore/up_trending_channels"
//#define CHANNELGROUPCOUNT 6


//频道：频道ID

//语言年代兆赫
#define HUAYU_MHz 1
#define OUMEI_MHz 2
#define YUEYU_MHz 6
#define BALING_MHz 4
#define JIULING_MHz 5

//风格流派兆赫
#define YAOGUN_MHz 7
#define MINYAO_MHz 8
#define QINGYINYUE_MHz 9
#define DIANYINGYUANSHENG_MHz 10
#define XIAOQINGXIN_MHz 76
#define JAZZ_MHz 13
#define GUDIAN_MHz 27

//心情场景兆赫
#define XINGE_MHz 61
#define COFFEE_MHz 32
#define WORKSTUDY_MHz 153



#define TABLEVIEW_TITLE_HEIGHT 40
#define TABLEVIEW_FOOTER_HEIGHT 1
#define TABLEVIEW_ROW_HEIGHT 60


#define TABLEVIEW_ORIGIN_X 0
#define TABLEVIEW_ORIGIN_Y 0
















#endif /* Commons_h */


