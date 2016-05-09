//
//  AppDelegate.m
//  HappyRun
//
//  Created by YuZai on 16/2/1.
//  Copyright © 2016年 YuZai. All rights reserved.
//

#import "AppDelegate.h"
#import "MyTabBarController.h"

@interface AppDelegate ()

@property (nonatomic, strong) MyTabBarController *tabController;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:@"CM2kMG40xNLHOc21oy6qY80V"  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _tabController = [[MyTabBarController alloc] init];
    self.window.rootViewController = _tabController;
    [self.window addSubview:_tabController.view];
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
