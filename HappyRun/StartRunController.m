//
//  StartRunController.m
//  HappyRun
//
//  Created by liyongyu on 16/5/9.
//  Copyright © 2016年 YuZai. All rights reserved.
//

#import "StartRunController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>

@interface StartRunController ()

@property (nonatomic, strong) BMKMapView *mapView;

@end

@implementation StartRunController

- (void)viewDidLoad {
    [super viewDidLoad];
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.view = _mapView;
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
