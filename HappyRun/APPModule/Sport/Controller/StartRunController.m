//
//  StartRunController.m
//  HappyRun
//
//  Created by liyongyu on 16/5/9.
//  Copyright © 2016年 YuZai. All rights reserved.
//

#import "StartRunController.h"
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import "StartRunView.h"
#import "SportModel.h"

@interface StartRunController ()<BMKMapViewDelegate, BMKLocationServiceDelegate>

@property (nonatomic, strong) StartRunView *startRunView;
@property (nonatomic, strong) BMKLocationService *locationService;
@property (nonatomic, strong) BMKUserLocation *userLocation;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) SportModel *sportModel;
/** 轨迹 */
@property (nonatomic, strong) BMKPolyline *polyLine;

@property (nonatomic, strong) CLLocationManager *locationManager;
// 中间变量->location类型(地理位置)
@property (nonatomic, strong) CLLocation *preLocation;
@end

#define kDefaultSpeed           10              //单位：米/秒，超过该速度视为漂移点，丢弃
#define kDefaultAccuracy        25              //单位：米，精度超过该值视为漂移点，丢弃

@implementation StartRunController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"viewDidLoad");
    self.view.backgroundColor = [UIColor blackColor];
    _startRunView = [[StartRunView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:_startRunView];
    [self setupUI];
    [self setupService];
}

- (void)setupUI{
    [_startRunView.locationBtn addTarget:self action:@selector(Location:) forControlEvents:UIControlEventTouchUpInside];
    [_startRunView.startBtn addTarget:self action:@selector(startRun:) forControlEvents:UIControlEventTouchUpInside];
    [_startRunView.stopBtn addTarget:self action:@selector(stopRun:) forControlEvents:UIControlEventTouchUpInside];
    
    [_startRunView setDistance:[NSString stringWithFormat:@"%.2f公里", (float)self.sportModel.distance/1000]];
    [_startRunView setSpeed:[NSString stringWithFormat:@"%.2f公里/小时", (float)self.sportModel.distance/1000]];
    [_startRunView setTime:[NSString stringWithFormat:@"运动时间：00:00:00"]];
}


- (void)setupService{
    _locationService = [[BMKLocationService alloc]init];
    _locationService.distanceFilter = 5;
    _locationService.headingFilter = 15;
    _locationService.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    _locationService.allowsBackgroundLocationUpdates = YES;
    [_locationService startUserLocationService];
    
    _startRunView.mapView.showsUserLocation = YES;//显示定位图层
    _startRunView.mapView.userTrackingMode = BMKUserTrackingModeFollow;//设置定位的状态
//    BMKMapRect rect = self.startRunView.mapView.visibleMapRect;
//    rect.size = BMKMapSizeMake(1000, 1000);
//    [_startRunView.mapView setVisibleMapRect:rect];
    
    self.sportModel = [[SportModel alloc] init];
}

- (void)startRunWithUserLocation:(BMKUserLocation *)userLocation{
    CLLocation *location = [[CLLocation alloc] initWithLatitude:userLocation.location.coordinate.latitude longitude:userLocation.location.coordinate.longitude];
        if (userLocation.location.horizontalAccuracy > kDefaultAccuracy) {
            return;
        }
    if (nil == self.sportModel.paths) {
        self.sportModel.paths = [[NSMutableArray alloc] init];
    }
    //1. 每5米记录一个点
    if (self.sportModel.paths.count > 0) {
        SportPath *prePath = [self.sportModel.paths lastObject];
        CLLocation *preLocation = [[CLLocation alloc] initWithLatitude:[prePath.latitude doubleValue] longitude:[prePath.longitude doubleValue]];
        CLLocationDistance distance = [location distanceFromLocation:preLocation];
        self.sportModel.distance += distance;
    }
    SportPath *path = [[SportPath alloc] init];
    path.latitude = [NSString stringWithFormat:@"%f",userLocation.location.coordinate.latitude];
    path.longitude = [NSString stringWithFormat:@"%f",userLocation.location.coordinate.longitude];
    path.create_time = [NSDate date].timeIntervalSince1970;
    [self.sportModel.paths addObject:path];
    
    // 4、作为前一个坐标位置辅助操作
    _preLocation = userLocation.location;
    
    // 5、开始画线
    [self configureRoutes];
    
    // 6、实时更新用户位子
    [_startRunView.mapView updateLocationData:userLocation];
}

- (void)startRun:(id)sender{
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateSportData) userInfo:nil repeats:YES];
    [_startRunView setTime:[NSString stringWithFormat:@"运动时间：00:00:00"]];
    self.sportModel.begin_time = [[NSDate date] timeIntervalSince1970];
//    [_time fire];
    
    _startRunView.mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _startRunView.mapView.userTrackingMode = BMKUserTrackingModeFollow;//设置定位的状态
    _startRunView.mapView.showsUserLocation = YES;//显示定位图层
    
    // 由于IOS8中定位的授权机制改变 需要进行手动授权(导致程序无法进行定位的主要原因)
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8) {
        _locationManager = [[CLLocationManager alloc] init];
        [_locationManager requestAlwaysAuthorization];
        [_locationManager requestWhenInUseAuthorization];
    }
    // 开启用户定位
    [_locationService startUserLocationService];
    
    // 1、通过比例调试地图的显示
#if 1
    [_startRunView.mapView setZoomEnabled:YES];
    _startRunView.mapView.zoomLevel = 17;// 级别是 3-19
#endif
    
#if 0
    // 2、通过范围调试地图的显示
    BMKCoordinateRegion adjustRegion = [_startRunView.mapView regionThatFits:BMKCoordinateRegionMake(locationService.userLocation.location.coordinate, BMKCoordinateSpanMake(0.03f,0.03f))];
    [_startRunView.mapView setRegion:adjustRegion animated:YES];
#endif
    
}

- (void)stopRun:(id)sender{
    [_timer invalidate];
    _timer = nil;
    self.sportModel.distance = 0;
    //    [_locationService stopUserLocationService];
}

- (void)Location:(id)sender {
    [_startRunView.mapView setCenterCoordinate:self.userLocation.location.coordinate animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [_startRunView.mapView viewWillAppear];
    NSLog(@"viewWillAppear");
    _startRunView.mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locationService.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated{
    [_startRunView.mapView viewWillDisappear];
    NSLog(@"viewWillDisappear");
    _startRunView.mapView.delegate = nil; // 不用时，置nil
    _locationService.delegate = nil;
}

- (void)dealloc {
    if (_startRunView.mapView) {
        _startRunView.mapView = nil;
    }
}



#pragma mark - mapView的协议
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id<BMKOverlay>)overlay{
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView *polylineView = [[BMKPolylineView alloc]initWithPolyline:overlay];
        // 设置划出的轨迹的基本属性-->也是使得定位看起来更加准确的主要原因
        polylineView.strokeColor = [[UIColor blueColor]colorWithAlphaComponent:0.5];
        polylineView.fillColor = [[UIColor blueColor]colorWithAlphaComponent:0.8];
        polylineView.lineWidth = 6.0;
        return polylineView;
    }
    return nil;
}

#pragma mark - 绘制轨迹
-(void)configureRoutes{
    // 1、分配内存空间给存储经过点的数组
    BMKMapPoint* pointArray = (BMKMapPoint *)malloc(sizeof(CLLocationCoordinate2D) * self.sportModel.paths.count);
    
    // 2、创建坐标点并添加到数组中
    for(int idx = 0; idx < self.sportModel.paths.count; idx++)
    {
        SportPath *path = [self.sportModel.paths objectAtIndex:idx];
        CLLocation *location = [[CLLocation alloc] initWithLatitude:[path.latitude doubleValue] longitude:[path.longitude doubleValue]];
        CLLocationDegrees latitude  = location.coordinate.latitude;
        CLLocationDegrees longitude = location.coordinate.longitude;
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        BMKMapPoint point = BMKMapPointForCoordinate(coordinate);
        pointArray[idx] = point;
    }
    // 3、防止重复绘制
    if (_polyLine) {
        //在地图上移除已有的坐标点
        [_startRunView.mapView removeOverlay:_polyLine];
    }
    
    // 4、画线
    _polyLine = [BMKPolyline polylineWithPoints:pointArray count:self.sportModel.paths.count];
    
    // 5、将折线(覆盖)添加到地图
    if (nil != _polyLine) {
        [_startRunView.mapView addOverlay:_polyLine];
    }

    // 6、清楚分配的内存
    free(pointArray);
}

#pragma mark - 更新用户位置时所调用的三种方法
// 更新位置
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    _userLocation = userLocation;
    [self startRunWithUserLocation:userLocation];
}

// 更新方向
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation{
    [_startRunView.mapView updateLocationData:userLocation];
}

// 定位失败了会调用
- (void)didFailToLocateUserWithError:(NSError *)error{
    NSLog(@"did failed locate,error is %@",[error localizedDescription]);
}

//更新
- (void)updateSportData {
    _sportModel.total_time = [[NSDate date] timeIntervalSince1970] - self.sportModel.begin_time;
    [_startRunView setTime:[NSString stringWithFormat:@"运动时间：%02ld:%02ld:%02ld",
                                (long)self.sportModel.total_time / 3600,
                                (long)self.sportModel.total_time % 3600 / 60,
                                (long)self.sportModel.total_time % 60]];
    self.startRunView.distanceLabel.text = [NSString stringWithFormat:@"%d米",self.sportModel.distance];
    
    CGFloat speed = self.sportModel.distance/self.sportModel.total_time;
    _startRunView.speedLabel.text = [NSString stringWithFormat:@"时速%.2f公里/小时", speed*3600/1000];
}

@end
