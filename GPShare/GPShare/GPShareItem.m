//
//  GPShareItem.m
//  GPShare
//
//  Created by Gorpeln on 2018/2/17.
//  Copyright © 2018 Gorpeln. All rights reserved.
//

#import "GPShareItem.h"

@implementation GPShareItem

#pragma mark - 初始化方法

- (instancetype)initWithImage:(UIImage *)image
                        title:(NSString *)title
                      handler:(void (^)(void))handler
{
    NSParameterAssert(title.length || image);
    
    self = [super init];
    if (self) {
        _title = title;
        _image = image;
        _selectedHandler = handler;
    }
    return self;
}


@end
