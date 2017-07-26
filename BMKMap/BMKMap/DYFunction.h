//
//  DYFunction.h
//  BMKMap
//
//  Created by mac on 2017/7/26.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DYFunction : NSObject

@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *subtitle;

@property(nonatomic,strong) Class className;

- (instancetype)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle className:(Class)className;

@end
