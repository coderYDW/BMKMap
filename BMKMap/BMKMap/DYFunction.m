//
//  DYFunction.m
//  BMKMap
//
//  Created by mac on 2017/7/26.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "DYFunction.h"

@implementation DYFunction
- (instancetype)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle className:(Class)className {
    self = [super init];
    if (self) {
        self.title = title;
        self.subtitle = subtitle;
        self.className = className;
    }
    return self;
}
@end
