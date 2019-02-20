//
//  GPShareView.m
//  GPShare
//
//  Created by Gorpeln on 2018/2/17.
//  Copyright © 2018 Gorpeln. All rights reserved.
//

#import "GPShareView.h"

@interface GPShareView()<UICollectionViewDelegate,UICollectionViewDataSource>


@property (nonatomic, strong) NSArray *shareItems;
@property (nonatomic, strong) NSArray *functionItems;

@property (nonatomic, strong) UIView *containView;  //背景View(包裹各种元素的view)
@property (nonatomic, strong) UIView *bodyView;     //中间View,主要放分享(去除head、foot放分享按钮的view)
@property (nonatomic, strong) UIView *middleLine;   //中间线

@property(nonatomic, weak)UICollectionView *shareCollectionView;
@property(nonatomic, weak)UICollectionView *functionCollectionView;

@property (nonatomic, weak)UIViewController *presentVC;


@end

@implementation GPShareView

- (instancetype)initWithFrame:(CGRect)frame {
    frame = [UIScreen mainScreen].bounds;
    self = [super initWithFrame:frame];
    if (self) {
        _itemSize = GPSHAREITEMSIZE;
        _itemSpace = 0;
        _sectionInsetSpace = 10;
        _itemImageSize = CGSizeMake(60, 60);
        _itemImageTopSpace = 10;
        _iconAndTitleSpace = 5;
        _itemTitleColor = [UIColor blackColor];
        _itemTitleFont = [UIFont systemFontOfSize:10];
        _containViewColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.9];
        _middleLineColor = [UIColor colorWithWhite:0.5 alpha:0.3];
        _middleTopSpace = 0;
        _middleBottomSpace = 0;
        _middleLineEdgeSpace = 0;
        
        _isShowCancleButton = YES;
        _isShowBorderLine = NO;
        _showsHorizontalScrollIndicator = NO;
        _isShowHeaderLabel = YES;
        
        UIControl *maskView = [[UIControl alloc] initWithFrame:frame];
        maskView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.7];
        maskView.tag = 100;
        [maskView addTarget:self action:@selector(maskViewClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:maskView];
        
        _containView = [[UIView alloc] init];
        _containView.userInteractionEnabled = YES;
        
        [self addSubview:_containView];
        [_containView addSubview:self.headerLabel];
        [_containView addSubview:self.bodyView];
        [_containView addSubview:self.cancleButton];
    }
    return self;
}

#pragma mark -

- (instancetype)initWithShareItems:(NSArray *)shareItems functionItems:(NSArray * __nullable)functionItems{
    
    self = [self init];
    if (self) {
        self.shareItems = shareItems;
        self.functionItems = functionItems;
    }
    
    return self;
}

- (instancetype)initWithShareItems:(NSArray *)shareItems{
    
    return  [self initWithShareItems:shareItems functionItems:nil];
    
}

#pragma mark -

- (void)showFromControlle:(UIViewController *)controller{
    _presentVC = controller;
    [self showInView:controller.view.window];
}

- (void)dismiss:(BOOL)animated{
    if (animated) {
        [self tappedCancel];
    }else{
        [self removeFromSuperview];
    }
}

-(UILabel *)headerLabel{
    
    if (!_headerLabel) {
        _headerLabel = [[UILabel alloc] init];
        _headerLabel.textColor = [UIColor darkGrayColor];
        _headerLabel.text = @"分享";
        _headerLabel.textAlignment = NSTextAlignmentCenter;
        _headerLabel.font = [UIFont systemFontOfSize:14];
    }
    return _headerLabel;
}

-(UIView *)bodyView{
    if (!_bodyView) {
        _bodyView = [[UIView alloc] init];
        _bodyView.userInteractionEnabled = YES;
    }
    return _bodyView;
}

-(UIButton *)cancleButton{
    if (!_cancleButton) {
        _cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancleButton.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 49);
        _cancleButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_cancleButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancleButton setTitleColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_cancleButton setBackgroundImage:[self imageWithColor:[UIColor whiteColor] size:CGSizeMake(1.0, 1.0)] forState:UIControlStateNormal];
        [_cancleButton setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1.0] size:CGSizeMake(1.0, 1.0)] forState:UIControlStateHighlighted];
        [_cancleButton addTarget:self action:@selector(cancleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancleButton;
}

- (UIView *)middleLine {
    if (!_middleLine) {
        _middleLine = [[UIView alloc] init];
        _middleLine.backgroundColor = _middleLineColor;
        [_bodyView addSubview:_middleLine];
    }
    return _middleLine;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    //计算总高度
    float height = _bodyViewEdgeInsets.top + _bodyViewEdgeInsets.bottom;
    
    if (_cancleButton) {
        height += _cancleButton.frame.size.height;
    }
    if (_isShowHeaderLabel) {
        _headerLabel.frame = CGRectMake(0, 0, SCREEN_WIDTH, 30);
        height += _headerLabel.frame.size.height;
    }
    
    if (_middleLine) {
        height += _middleLine.frame.size.height;
    }
    float bodyHeight = 0;
    if (_bodyView) {
        if (_shareCollectionView) {
            bodyHeight += _shareCollectionView.frame.size.height;
        }
        if (_functionCollectionView) {
            bodyHeight += (_shareCollectionView.frame.size.height + 0.5 + + _middleTopSpace + _middleBottomSpace);
        }
        height += bodyHeight;
    }
    
    //动画前置控件位置
    if (_containView) {
        _containView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, height);
        //        _containView.backgroundColor = [UIColor purpleColor];
    }
    if (_headerLabel) {
        _headerLabel.frame = CGRectMake(0, 0, SCREEN_WIDTH, _headerLabel.frame.size.height);
    }
    if (_bodyView) {
        float bodyY = _headerLabel ? CGRectGetMaxY(_headerLabel.frame) : 0;
        _bodyView.frame = CGRectMake(_bodyViewEdgeInsets.left,bodyY+_bodyViewEdgeInsets.top,SCREEN_WIDTH-_bodyViewEdgeInsets.left-_bodyViewEdgeInsets.right, bodyHeight);
        
        CGRect shareViewSize = _shareCollectionView.frame;
        shareViewSize.size.width = _bodyView.frame.size.width;
        _shareCollectionView.frame = shareViewSize;
        
        CGRect functionViewSize = _functionCollectionView.frame;
        functionViewSize.size.width = _bodyView.frame.size.width;
        _functionCollectionView.frame = functionViewSize;
    }
    
    if (_cancleButton) {
        _cancleButton.frame = CGRectMake(0, height-_cancleButton.frame.size.height, SCREEN_WIDTH,_cancleButton.frame.size.height);
    }
    UIView *zhezhaoView = (UIView *)[self viewWithTag:100];
    zhezhaoView.alpha = 0;
    //执行动画
    [UIView animateWithDuration:0.25 animations:^{
        if (_containView) {
            _containView.frame = CGRectMake(0, SCREEN_HEIGHT - height, SCREEN_WIDTH, height);
        }
        
        zhezhaoView.alpha = 0.6;
        
    } completion:nil];
    
}


#pragma mark - Action

- (void)cancleButtonAction:(UIButton *)sender {
    [self tappedCancel];
}

- (void)maskViewClick:(UIControl *)sender {
    [self tappedCancel];
}

- (void)tappedCancel {
    [UIView animateWithDuration:0.25 animations:^{
        UIView *coverView = (UIView *)[self viewWithTag:100];
        coverView.alpha = 0;
        
        if (_containView) {
            _containView.frame = CGRectMake(0, SCREEN_HEIGHT,SCREEN_WIDTH, _containView.frame.size.height);
        }
        
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

#pragma mark - 私有方法

- (void)showInView:(UIView *)view{
    _containView.backgroundColor = _containViewColor;
    if (!_isShowCancleButton) {
        [_cancleButton setTitle:@"" forState:UIControlStateNormal];
        _cancleButton.frame = CGRectZero;
    }
    
    if (!_isShowHeaderLabel) {
        _headerLabel.text = @"";
        _headerLabel.frame = CGRectZero;
    }
    
    
    //计算屏幕容纳几个 cell
    NSInteger count = self.shareItems.count;
    NSInteger numberOfPerRow = SCREEN_WIDTH / _itemSize.width;
    NSInteger number = count / numberOfPerRow;
    NSInteger remainder = count % numberOfPerRow;
    
    CGFloat height = number * _itemSize.height + (remainder > 0 ? _itemSize.height : 0);
    if (_isDisplayInline) {//如果在一行内展示
        height = _itemSize.height;
    }
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    if (_isDisplayInline) {
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    flowLayout.itemSize = _itemSize;
    
    flowLayout.minimumLineSpacing = _itemSpace;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, _sectionInsetSpace, 0, _sectionInsetSpace);
    
    
    UICollectionView *shareCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height) collectionViewLayout:flowLayout];
    self.shareCollectionView = shareCollectionView;
    shareCollectionView.delegate = self;
    shareCollectionView.dataSource = self;
    shareCollectionView.showsVerticalScrollIndicator = NO;
    shareCollectionView.showsHorizontalScrollIndicator = _showsHorizontalScrollIndicator;
    shareCollectionView.bounces = _isDisplayInline;
    shareCollectionView.backgroundColor = [UIColor clearColor];
    [shareCollectionView registerClass:[GPShareItemCell class] forCellWithReuseIdentifier:kCellIdentifier_GPShareItemCell];
    [self.bodyView addSubview:shareCollectionView];
    
    if (self.functionItems) {
        //分割线
        self.middleLine.frame = CGRectMake(_middleLineEdgeSpace, shareCollectionView.frame.origin.y+shareCollectionView.frame.size.height + _middleTopSpace, self.frame.size.width - 2*_middleLineEdgeSpace, 0.5);
        
        UICollectionViewFlowLayout *functionflowLayout = [[UICollectionViewFlowLayout alloc] init];
        functionflowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        functionflowLayout.itemSize = _itemSize;
        functionflowLayout.minimumLineSpacing = _itemSpace;
        functionflowLayout.minimumInteritemSpacing = 0;
        functionflowLayout.sectionInset = UIEdgeInsetsMake(0, _sectionInsetSpace, 0, _sectionInsetSpace);
        
        UICollectionView *functionCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.middleLine.frame.origin.y+self.middleLine.frame.size.height + _middleBottomSpace, self.frame.size.width, _itemSize.height) collectionViewLayout:functionflowLayout];
        self.functionCollectionView = functionCollectionView;
        functionCollectionView.delegate = self;
        functionCollectionView.dataSource = self;
        functionCollectionView.showsVerticalScrollIndicator = NO;
        functionCollectionView.showsHorizontalScrollIndicator = _showsHorizontalScrollIndicator;
        functionCollectionView.bounces = YES;
        functionCollectionView.backgroundColor = [UIColor clearColor];
        [functionCollectionView registerClass:[GPShareItemCell class] forCellWithReuseIdentifier:kCellIdentifier_GPShareItemCell];
        [self.bodyView addSubview:functionCollectionView];
    }
    
    [view addSubview:self];
}

//颜色生成图片方法
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

#pragma mark - UICollectionViewDelegate、UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == self.shareCollectionView) {
        return self.shareItems.count;
    }
    if (collectionView == self.functionCollectionView) {
        return self.functionItems.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    GPShareItemCell *shareItemCell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier_GPShareItemCell forIndexPath:indexPath];
    
    shareItemCell.titleLable.textColor = _itemTitleColor;
    shareItemCell.titleLable.font= _itemTitleFont;
    shareItemCell.itemImageTopSpace = _itemImageTopSpace;
    shareItemCell.iconAndTitleSpace = _iconAndTitleSpace;
    shareItemCell.itemImageSize = _itemImageSize;
    shareItemCell.showBorderLine = _isShowBorderLine;
    
    if (collectionView == self.shareCollectionView) {
        shareItemCell.shareItem = self.shareItems[indexPath.row];
    }else{
        shareItemCell.shareItem = self.functionItems[indexPath.row];
    }
    
    return shareItemCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    GPShareItemCell *cell = (GPShareItemCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell.shareItem.selectedHandler) {
        cell.shareItem.selectedHandler();
    }
    [self dismiss:YES];
}




@end
