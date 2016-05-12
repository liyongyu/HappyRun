//
//  SportController.m
//  HappyRun
//
//  Created by liyongyu on 16/5/10.
//  Copyright © 2016年 YuZai. All rights reserved.
//

#import "SportController.h"
#import "StartRunController.h"

@interface SportController ()

@property (nonatomic, strong) UIButton *start;
@property (nonatomic, strong) StartRunController *startController;

@end

@implementation SportController

- (void)viewDidLoad {
    [super viewDidLoad];
    _start = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 300, 300)];
    [_start setTitle:@"开始跑步" forState:UIControlStateNormal];
    [_start addTarget:self action:@selector(Start:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_start];
    self.startController = [[StartRunController alloc] init];
}

- (void) Start:(id)sender{
    [self.navigationController pushViewController:_startController animated:YES];
}
@end
