//
//  CPDateManager.h
//  CPDateManager
//
//  Created by CuppiZhangTF on 15/5/20.
//  Copyright (c) 2015年 cuppi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CPDateManager : NSObject
+ (instancetype)defaultManager;
- (NSString *)hh_mm_ssFromIntegerSeconds:(NSInteger)seconds;
@end
