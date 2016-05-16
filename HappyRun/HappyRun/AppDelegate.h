//
//  AppDelegate.h
//  HappyRun
//
//  Created by YuZai on 16/2/1.
//  Copyright © 2016年 YuZai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) BMKMapManager* mapManager;

@end

