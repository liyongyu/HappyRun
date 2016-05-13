//
//  StartRunView.m
//  HappyRun
//
//  Created by liyongyu on 16/5/12.
//  Copyright © 2016年 YuZai. All rights reserved.
//

#import "StartRunView.h"

@implementation StartRunView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor blackColor];
    _mapView = [[BMKMapView alloc] init];
    [self addSubview:_mapView];
    [_mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.centerX.equalTo(self);
        make.width.equalTo(self);
        make.bottom.equalTo(self).offset(-200);
    }];
    
    _locationBtn = [[UIButton alloc] init];
    [_locationBtn setImage:[UIImage imageNamed:@"trail_location"] forState:UIControlStateNormal];
    _locationBtn.clipsToBounds = YES;
    _locationBtn.layer.cornerRadius = 4;
    _locationBtn.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
    _locationBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self addSubview:_locationBtn];
    [_locationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@34);
        make.height.equalTo(@34);
        make.right.equalTo(self.mapView).offset(-10);
        make.bottom.equalTo(self.mapView).offset(-10);
    }];
    
    _startBtn = [[UIButton alloc] init];
    [_startBtn setTitle:@"开始跑步" forState:UIControlStateNormal];
    [_startBtn setBackgroundColor:[UIColor redColor]];
    [_startBtn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [self addSubview:_startBtn];
    [_startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mapView.mas_bottom).offset(20);
        make.left.equalTo(self).offset(30);
        make.width.equalTo(@100);
        make.height.equalTo(@30);
    }];
    
    _stopBtn = [[UIButton alloc] init];
    [_stopBtn setTitle:@"停止跑步" forState:UIControlStateNormal];
    [_stopBtn setBackgroundColor:[UIColor redColor]];
    [_stopBtn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [self addSubview:_stopBtn];
    [_stopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mapView.mas_bottom).offset(20);
        make.right.equalTo(self).offset(-30);
        make.width.equalTo(@100);
        make.height.equalTo(@30);
    }];
    
    _distanceLabel = [[UILabel alloc] init];
    _distanceLabel.textAlignment = NSTextAlignmentLeft;
    _distanceLabel.textColor = [UIColor whiteColor];
    [self addSubview:_distanceLabel];
    [_distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.stopBtn.mas_bottom).offset(10);
        make.right.equalTo(self).offset(-30);
        make.left.equalTo(self).offset(30);
        make.height.equalTo(@20);
    }];
    
    _speedLabel = [[UILabel alloc] init];
    _speedLabel.textAlignment = NSTextAlignmentLeft;
    _speedLabel.textColor = [UIColor whiteColor];
    [self addSubview:_speedLabel];
    [_speedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.distanceLabel.mas_bottom).offset(10);
        make.right.equalTo(self).offset(-30);
        make.left.equalTo(self).offset(30);
        make.height.equalTo(@20);
    }];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.textAlignment = NSTextAlignmentLeft;
    _timeLabel.textColor = [UIColor whiteColor];
    [self addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.speedLabel.mas_bottom).offset(10);
        make.right.equalTo(self).offset(-30);
        make.left.equalTo(self).offset(30);
        make.height.equalTo(@20);
    }];
    return self;
}

-(void)setDistance:(NSString *)distance{
    _distanceLabel.text = distance;
}

-(void)setSpeed:(NSString *)speed{
    _speedLabel.text = speed;
}

-(void)setTime:(NSString *)time{
    _timeLabel.text = time;
}
@end
