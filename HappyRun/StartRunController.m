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
#import "SportModel.h"

@interface StartRunController ()<BMKMapViewDelegate, BMKLocationServiceDelegate>

@property (nonatomic, strong) BMKMapView *mapView;
@property (nonatomic, strong) BMKLocationService *locService;
@property (nonatomic, strong) BMKUserLocation *userLocation;
@property (nonatomic, strong) BMKLocationViewDisplayParam *abc;

@property (nonatomic, strong) UIButton *locationBtn;
@property (nonatomic, strong) UIButton *startBtn;
@property (nonatomic, strong) UIButton *stopBtn;
@property (nonatomic, strong) UILabel *distanceLabel;
@property (nonatomic, strong) UILabel *speedLabel;
@property (nonatomic, strong) NSTimer *timeLabel;
@property (nonatomic, strong) UILabel *KaLuLiLabel;

@property (nonatomic, strong) SportModel *sportModel;
/** 轨迹 */
@property (nonatomic, strong) BMKPolyline *polyLine;

@end

@implementation StartRunController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"viewDidLoad");
    [self setupUI];
    [self setupService];
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
    
    _locationBtn = [[UIButton alloc] init];
    [_locationBtn setImage:[UIImage imageNamed:@"trail_location"] forState:UIControlStateNormal];
    [_locationBtn addTarget:self action:@selector(Location:) forControlEvents:UIControlEventTouchUpInside];
    _locationBtn.clipsToBounds = YES;
    _locationBtn.layer.cornerRadius = 4;
    _locationBtn.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
    _locationBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.view addSubview:_locationBtn];
    [_locationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@34);
        make.height.equalTo(@34);
        make.right.equalTo(self.mapView).offset(-10);
        make.bottom.equalTo(self.mapView).offset(-10);
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
    
    _distanceLabel = [[UILabel alloc] init];
    _distanceLabel.textAlignment = NSTextAlignmentCenter;
    _distanceLabel.textColor = [UIColor whiteColor];
    _distanceLabel.text = [NSString stringWithFormat:@"%.2f公里", (float)self.sportModel.distance/1000];
    [self.view addSubview:_distanceLabel];
    [_distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.stopBtn.mas_bottom).offset(20);
        make.right.equalTo(self.view).offset(-30);
        make.width.equalTo(@100);
        make.height.equalTo(@50);
    }];
    
    _speedLabel = [[UILabel alloc] init];
    _speedLabel.textAlignment = NSTextAlignmentCenter;
    _speedLabel.textColor = [UIColor whiteColor];
    _speedLabel.text = [NSString stringWithFormat:@"%.2f公里/小时", (float)self.sportModel.distance/1000];
    [self.view addSubview:_speedLabel];
    [_speedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.startBtn.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(30);
        make.width.equalTo(@100);
        make.height.equalTo(@50);
    }];
}

- (void)setupService{
    _locService = [[BMKLocationService alloc]init];
    _locService.distanceFilter = 1;
    _locService.headingFilter = 15;
    _locService.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    _locService.allowsBackgroundLocationUpdates = YES;
    [_locService startUserLocationService];
    
    _mapView.showsUserLocation = YES;//显示定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;//设置定位的状态
    BMKMapRect rect = self.mapView.visibleMapRect;
    rect.size = BMKMapSizeMake(1000, 1000);
    [_mapView setVisibleMapRect:rect];
    
    self.sportModel = [[SportModel alloc] init];
    self.sportModel.paths = [[NSMutableArray alloc] init];
}


- (void)startTrailRouteWithUserLocation:(BMKUserLocation *)userLocation
{
    CLLocationCoordinate2D userLocationCoor = userLocation.location.coordinate;
    CLLocation *location = [[CLLocation alloc] initWithLatitude:userLocationCoor.latitude longitude:userLocationCoor.longitude];
    
//    if (userLocation.location.horizontalAccuracy > kDefaultAccuracy) {
//        return;
//    }
    
    //1. 每5米记录一个点
    if (self.sportModel.paths.count > 0) {
        
        SportPath *prePath = [self.sportModel.paths lastObject];
        CLLocation *preLocation = [[CLLocation alloc] initWithLatitude:[prePath.latitude doubleValue] longitude:[prePath.longitude doubleValue]];
        CLLocationDistance distance = [location distanceFromLocation:preLocation];
        self.sportModel.distance += distance;
        CGFloat speed = distance/([NSDate date].timeIntervalSince1970-prePath.create_time);
//        if (speed > kDefaultSpeed) {
//            return;
//        }
        //暂停点不计算距离
        self.distanceLabel.text = [NSString stringWithFormat:@"%.2f公里",(float)self.sportModel.distance/1000];
        _speedLabel.text = [NSString stringWithFormat:@"时速%.2f/小时", speed*3600/1000];
        NSLog(@"%f", (float)self.sportModel.distance/1000);
        NSLog(@"%f", speed);
    }
    
    SportPath *path = [[SportPath alloc] init];

    path.latitude = [NSString stringWithFormat:@"%f",userLocationCoor.latitude];
    path.longitude = [NSString stringWithFormat:@"%f",userLocationCoor.longitude];
    path.create_time = [NSDate date].timeIntervalSince1970;
//    2. 记录
    [self.sportModel.paths addObject:path];
    
    //3. 绘图
//    [self onGetWalkPolylineWithLastPoint];
}

/**
 *  绘制步行轨迹路线
 */
- (void)onGetWalkPolylineWithLastPoint
{
    //轨迹点
    NSUInteger count = self.sportModel.paths.count;
    if (count >= 2) {
        BMKMapPoint *tempPoints = malloc(sizeof(BMKMapPoint) * 2);
        SportPath *path = self.sportModel.paths[count-2];
        CLLocation *location = [[CLLocation alloc] initWithLatitude:[path.latitude doubleValue] longitude:[path.longitude doubleValue]];
        BMKMapPoint locationPoint = BMKMapPointForCoordinate(location.coordinate);
        tempPoints[0] = locationPoint;
        
        path = self.sportModel.paths[count-1];
        location = [[CLLocation alloc] initWithLatitude:[path.latitude doubleValue] longitude:[path.longitude doubleValue]];
        locationPoint = BMKMapPointForCoordinate(location.coordinate);
        tempPoints[1] = locationPoint;
        
        // 通过points构建BMKPolyline
        self.polyLine = [BMKPolyline polylineWithPoints:tempPoints count:2];
        
        //添加路线,绘图
        if (self.polyLine) {
            [_mapView addOverlay:self.polyLine];
        }
        free(tempPoints);
//        [self mapViewFitAllLocation];
    } else if (count == 1) {
        SportPath *path = self.sportModel.paths[0];
        CLLocation *location = [[CLLocation alloc] initWithLatitude:[path.latitude doubleValue] longitude:[path.longitude doubleValue]];
//        self.startPoint = [self creatPointWithLocaiton:location title:@"开始"];
    }
}

- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
//    NSLog(@"heading is %@",userLocation.heading);
    [_mapView updateLocationData:userLocation];
}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    _userLocation = userLocation;
    [_mapView updateLocationData:userLocation];
    [self startTrailRouteWithUserLocation:userLocation];

}

- (void)startRun:(id)sender{
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
}

- (void)stopRun:(id)sender{
    //    [_locService stopUserLocationService];
}

- (void)Location:(id)sender {
    [_mapView setCenterCoordinate:self.userLocation.location.coordinate animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [_mapView viewWillAppear];
    NSLog(@"viewWillAppear");
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locService.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated{
    [_mapView viewWillDisappear];
    NSLog(@"viewWillDisappear");
    _mapView.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
}

- (void)dealloc {
    if (_mapView) {
        _mapView = nil;
    }
}

@end
