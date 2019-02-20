//
//  GPShareItem.h
//  GPShare
//
//  Created by Gorpeln on 2018/2/17.
//  Copyright © 2018 Gorpeln. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GPShareItem : NSObject

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, copy) void (^selectedHandler)(void); //点击后的事件处理

- (instancetype)initWithImage:(UIImage *)image
                        title:(NSString *)title
                      handler:(void (^)(void))handler;




@end

NS_ASSUME_NONNULL_END
