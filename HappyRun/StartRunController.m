//
//  StartRunController.m
//  HappyRun
//
//  Created by liyongyu on 16/5/9.
//  Copyright © 2016年 YuZai. All rights reserved.
//

#import "StartRunController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>

@interface StartRunController ()<BMKMapViewDelegate, BMKLocationServiceDelegate>

@property (nonatomic, strong) BMKMapView *mapView;
@property (nonatomic, strong) BMKLocationService *locService;
@property (nonatomic, strong) BMKUserLocation *userLocation;
@property (nonatomic, strong) BMKLocationViewDisplayParam *abc;

@property (nonatomic, strong) UIButton *startBtn;
@property (nonatomic, strong) UIButton *stopBtn;

@end

@implementation StartRunController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"viewDidLoad");
    _locService = [[BMKLocationService alloc]init];
    [_locService startUserLocationService];
    
    [self setupUI];

//    _abc = [[BMKLocationViewDisplayParam alloc]init];
//    _abc.locationViewImgName = @"bnavi_icon_location_fixed";

}

- (void)setupUI{
    _mapView = [[BMKMapView alloc] init];
    [self.view addSubview:_mapView];
    [_mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.centerX.equalTo(self.view);
        make.width.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-200);
    }];
    
    _startBtn = [[UIButton alloc] init];
    [_startBtn setTitle:@"开始跑步" forState:UIControlStateNormal];
    [_startBtn setBackgroundColor:[UIColor redColor]];
    [_startBtn addTarget:self action:@selector(startRun:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_startBtn];
    [_startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mapView.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(30);
        make.width.equalTo(@100);
        make.height.equalTo(@50);
    }];
    
    _stopBtn = [[UIButton alloc] init];
    [_stopBtn setTitle:@"停止跑步" forState:UIControlStateNormal];
    [_stopBtn setBackgroundColor:[UIColor redColor]];
    [_stopBtn addTarget:self action:@selector(stopRun:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_stopBtn];
    [_stopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mapView.mas_bottom).offset(20);
        make.right.equalTo(self.view).offset(-30);
        make.width.equalTo(@100);
        make.height.equalTo(@50);
    }];
}

//实现相关delegate 处理位置信息更新
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
//    NSLog(@"heading is %@",userLocation.heading);
}

//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
//    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    _userLocation = userLocation;
    [_mapView updateLocationData:_userLocation];

//    BMKMapPoint point =  BMKMapPointForCoordinate(userLocation.location.coordinate);
//    [_mapView setVisibleMapRect:point animated:YES];
}

- (void)startRun:(id)sender{
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locService.delegate = self;
    
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeFollowWithHeading;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
    
    BMKMapRect rect = self.mapView.visibleMapRect;
    rect.size = BMKMapSizeMake(1000, 1000);
    [_mapView setVisibleMapRect:rect];
}

- (void)stopRun:(id)sender{
    _mapView.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
    //    [_locService stopUserLocationService];
}

- (void)viewWillAppear:(BOOL)animated{
    [_mapView viewWillAppear];
    NSLog(@"viewWillAppear");
}

- (void)viewWillDisappear:(BOOL)animated{
    [_mapView viewWillDisappear];
    NSLog(@"viewWillDisappear");
}

- (void)dealloc {
    if (_mapView) {
        _mapView = nil;
    }
}

@end
