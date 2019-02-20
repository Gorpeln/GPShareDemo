//
//  GPShareView.h
//  GPShare
//
//  Created by Gorpeln on 2018/2/17.
//  Copyright © 2018 Gorpeln. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPShareItemCell.h"

NS_ASSUME_NONNULL_BEGIN

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define GPSHAREITEMSIZE CGSizeMake(80,100)


@interface GPShareView : UIView

@property (nonatomic) CGSize    itemSize;           //item大小
@property (nonatomic) CGFloat   itemSpace;          //item横向间距
@property (nonatomic) CGFloat   sectionInsetSpace;  //边界间距
@property (nonatomic) CGSize    itemImageSize;      //item中image大小
@property (nonatomic) CGFloat   itemImageTopSpace;  //item图片距离顶部大小
@property (nonatomic) CGFloat   iconAndTitleSpace;  //item图片和文字距离
@property (nullable, nonatomic, strong) UIColor *itemTitleColor;    //标题字体颜色
@property (nullable, nonatomic, strong) UIFont  *itemTitleFont;     //标题字体大小
@property (nullable, nonatomic, strong) UIColor *containViewColor;
@property (nullable, nonatomic, strong) UIColor *middleLineColor;   //分割线颜色
@property (nonatomic) CGFloat middleTopSpace;           //分割线距离上部按钮距离
@property (nonatomic) CGFloat middleBottomSpace;        //分割线距离下部按钮距离
@property (nonatomic) CGFloat middleLineEdgeSpace;      //分割线边距
@property (nonatomic) UIEdgeInsets bodyViewEdgeInsets;  //中间bodyView的边距;

@property (nullable, nonatomic, strong) UILabel *headerLabel; //头部分享标题
@property (nonatomic, strong) UIButton *cancleButton;       //取消

@property(nonatomic, assign) BOOL isDisplayInline;          //是否显示在一行
@property(nonatomic, assign) BOOL isShowBorderLine;         //是否显示item边框
@property(nonatomic, assign) BOOL isShowCancleButton;       //是否显示取消按钮
@property(nonatomic, assign) BOOL isShowHeaderLabel;            //是否显示分享标题
@property (nonatomic) BOOL showsHorizontalScrollIndicator;  //是否显示横向滚动条


- (instancetype)initWithShareItems:(NSArray *)shareItems;
- (instancetype)initWithShareItems:(NSArray *)shareItems functionItems:(NSArray * __nullable)functionItems;


- (void)showFromControlle:(UIViewController *)controller;//fix: 自定义导航栏,遮罩不能完全遮住屏幕
- (void)dismiss:(BOOL)animated;



@end

NS_ASSUME_NONNULL_END
