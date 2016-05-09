//
//  MyTabBarController.m
//  HappyRun
//
//  Created by YuZai on 16/2/1.
//  Copyright © 2016年 YuZai. All rights reserved.
//

#import "MyTabBarController.h"
#import "UserViewController.h"
#import "HomePageController.h"

@interface MyTabBarController ()

@property (nonatomic, strong) UserViewController *userController;
@property (nonatomic, strong) HomePageController *homePageController;
@end

@implementation MyTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    _homePageController = [[HomePageController alloc] init];
    _homePageController.view.backgroundColor = [UIColor redColor];
    _homePageController.title = @"首页";
    _homePageController.tabBarItem.image = [UIImage imageNamed:@"tabBarPortal"];
    _homePageController.tabBarItem.selectedImage = [UIImage imageNamed:@"tabBarPortalSelected"];
    
    UIViewController *vc2;
    vc2 = [[UIViewController alloc] init];
    vc2.view.backgroundColor = [UIColor blueColor];
    vc2.title = @"page2";
    _userController = [[UserViewController alloc] init];
    _userController.title = @"个人中心";
    _userController.tabBarItem.image = [UIImage imageNamed:@"tabBarPersonal"];
    _userController.tabBarItem.selectedImage = [UIImage imageNamed:@"tabBarPersonalSelected"];
    self.viewControllers = [NSArray arrayWithObjects:_homePageController, vc2, _userController, nil];
    self.tabBar.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
