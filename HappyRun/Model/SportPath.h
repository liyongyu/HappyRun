//
//  SportPath.h
//  HappyRun
//
//  Created by liyongyu on 16/5/10.
//  Copyright © 2016年 YuZai. All rights reserved.
//

#import "BaseModel.h"

@interface SportPath : BaseModel

@property (nonatomic, copy) NSString *longitude;
@property (nonatomic, copy) NSString *latitude;
@property (nonatomic, assign) NSInteger create_time;
/**
 *  1：进行中，0：暂停
 */
@property (nonatomic, assign) NSInteger status;

@end
