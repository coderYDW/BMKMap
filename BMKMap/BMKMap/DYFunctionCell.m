//
//  DYFunctionCell.m
//  BMKMap
//
//  Created by mac on 2017/7/26.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "DYFunctionCell.h"
#import "DYFunction.h"

@implementation DYFunctionCell

- (void)setFunction:(DYFunction *)function {

    self.textLabel.text = function.title;
    self.detailTextLabel.text = function.subtitle;

}



@end
