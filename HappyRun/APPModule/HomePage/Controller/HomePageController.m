//
//  HomePageController.m
//  HappyRun
//
//  Created by liyongyu on 16/5/6.
//  Copyright © 2016年 YuZai. All rights reserved.
//

#import "HomePageController.h"

@interface HomePageController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation HomePageController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView = [[UITableView alloc] init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"kEmy"];
    [self.view addSubview: _tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView cellForRowAtIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kEmy"];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (!decelerate){
        NSLog(@"is decelerating");
    } else {
        NSLog(@"isn't decelerating");
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSLog(@"end decelerating");
}
@end