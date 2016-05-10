//
//  SportModel.h
//  HappyRun
//
//  Created by liyongyu on 16/5/10.
//  Copyright © 2016年 YuZai. All rights reserved.
//

#import "BaseModel.h"
#import "SportPath.h"

@interface SportModel : BaseModel

@property (nonatomic, copy, readonly) NSString *path_id;
@property (nonatomic, strong) NSMutableArray *paths;
@property (nonatomic, assign) NSInteger charity_id;
@property (nonatomic, assign) NSInteger begin_time;
@property (nonatomic, assign) NSInteger end_time;
@property (nonatomic, assign) NSInteger total_time;
@property (nonatomic, assign) NSInteger distance;
@property (nonatomic, assign) NSInteger calory;
@property (nonatomic, assign) NSInteger step;
@property (nonatomic, assign) NSInteger donated_money;
@property (nonatomic, copy) NSString *charity_title;
@property (nonatomic, copy) NSString *love_title;

@end
