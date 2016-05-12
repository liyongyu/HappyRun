//
//  StartRunView.h
//  HappyRun
//
//  Created by liyongyu on 16/5/12.
//  Copyright © 2016年 YuZai. All rights reserved.
//

#import "BaseView.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>

@interface StartRunView : BaseView

@property (nonatomic, strong) BMKMapView *mapView;
@property (nonatomic, strong) UIButton *locationBtn;
@property (nonatomic, strong) UIButton *startBtn;
@property (nonatomic, strong) UIButton *stopBtn;
@property (nonatomic, strong) UILabel *distanceLabel;
@property (nonatomic, strong) UILabel *speedLabel;
@property (nonatomic, strong) UILabel *timeLabel;
//@property (nonatomic, strong) UILabel *KaLuLiLabel;

- (void)setTime:(NSString *)time;
- (void)setDistance:(NSString *)distance;
- (void)setSpeed:(NSString *)speed;
@end
