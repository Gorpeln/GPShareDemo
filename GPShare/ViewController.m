//
//  ViewController.m
//  GPShare
//
//  Created by Gorpeln on 2018/2/17.
//  Copyright © 2018 Gorpeln. All rights reserved.
//

#import "ViewController.h"
#import "GPShareView.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property(nonatomic, strong) NSArray *titleArray;

@property(nonatomic, strong) NSMutableArray *shareArray;
@property(nonatomic, strong) NSMutableArray *functionArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"GPShare";

    _titleArray = @[
                    @"单行样式",
                    @"双行样式",
                    @"多行样式",
                    @"九宫格样式",
                    @"自定义取消按钮、分割线",
                    ];
    
    [self loadTableView];
    
}

- (NSMutableArray *)shareArray{
    if (!_shareArray) {
        _shareArray = [NSMutableArray array];
        
        [_shareArray addObject:[[GPShareItem alloc] initWithImage:[UIImage imageNamed:@"share_weixin"] title:@"微信" handler:^{
            [self customHandlerWithTitle:@"微信"];
        }]];
        [_shareArray addObject:[[GPShareItem alloc] initWithImage:[UIImage imageNamed:@"share_qq"] title:@"QQ" handler:^{
            [self customHandlerWithTitle:@"QQ"];
        }]];
        [_shareArray addObject:[[GPShareItem alloc] initWithImage:[UIImage imageNamed:@"share_sina"] title:@"微博" handler:^{
            [self customHandlerWithTitle:@"新浪微博"];
        }]];
        [_shareArray addObject:[[GPShareItem alloc] initWithImage:[UIImage imageNamed:@"share_alipay"] title:@"支付宝" handler:^{
            [self customHandlerWithTitle:@"支付宝"];
        }]];
        [_shareArray addObject:[[GPShareItem alloc] initWithImage:[UIImage imageNamed:@"share_sms"] title:@"短信" handler:^{
            [self customHandlerWithTitle:@"短信"];
        }]];
        [_shareArray addObject:[[GPShareItem alloc] initWithImage:[UIImage imageNamed:@"share_email"] title:@"email" handler:^{
            [self customHandlerWithTitle:@"email"];
        }]];
        
        
    }
    return _shareArray;
}

- (NSMutableArray *)functionArray{
    if (!_functionArray) {
        _functionArray = [NSMutableArray array];
        [_functionArray addObject:[[GPShareItem alloc] initWithImage:[UIImage imageNamed:@"function_collection"] title:@"收藏" handler:^{
            [self customHandlerWithTitle:@"收藏"];
        }]];
        [_functionArray addObject:[[GPShareItem alloc] initWithImage:[UIImage imageNamed:@"function_copy"] title:@"复制" handler:^{
            [self customHandlerWithTitle:@"复制"];
        }]];
        [_functionArray addObject:[[GPShareItem alloc] initWithImage:[UIImage imageNamed:@"function_expose"] title:@"举报" handler:^{
            [self customHandlerWithTitle:@"举报"];
        }]];
        [_functionArray addObject:[[GPShareItem alloc] initWithImage:[UIImage imageNamed:@"function_font"] title:@"调整字体" handler:^{
            [self customHandlerWithTitle:@"调整字体"];
        }]];
        [_functionArray addObject:[[GPShareItem alloc] initWithImage:[UIImage imageNamed:@"function_link"] title:@"复制链接" handler:^{
            [self customHandlerWithTitle:@"复制链接"];
        }]];
        [_functionArray addObject:[[GPShareItem alloc] initWithImage:[UIImage imageNamed:@"function_refresh"] title:@"刷新" handler:^{
            [self customHandlerWithTitle:@"刷新"];
        }]];
        
    }
    return _functionArray;
}

#pragma mark -
#pragma mark -- TableViewDelegate
-(void)loadTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = YES;
    _tableView.userInteractionEnabled = YES;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    [self.view addSubview:_tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndertifier=@"cellIndertifier";
    UITableViewCell *tableViewCell=[tableView dequeueReusableCellWithIdentifier:cellIndertifier];
    if (!tableViewCell) {
        tableViewCell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndertifier];
    }
    tableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
    tableViewCell.textLabel.text = _titleArray[indexPath.row];
    tableViewCell.textLabel.textAlignment = NSTextAlignmentCenter;
    tableViewCell.textLabel.font = [UIFont fontWithName:@"heiti SC" size:15.0];
    tableViewCell.textLabel.textColor = [UIColor blueColor];
    return tableViewCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    switch (indexPath.row) {
        case 0:
            [self shoeSingleRowStyle];// 单行样式
            break;
        case 1:
            [self showDoubleRowsStyle];// 双行样式
            break;
        case 2:
            [self showMultipleRowsStyle];// 多行样式
            break;
        case 3:
            [self showSquaredStyle];// 九宫格样式
            break;
        case 4:
            [self showUserDefineStyle];// 自定义取消按钮、分割线
            break;
        default:
            break;
    }
    
}

-(void)shoeSingleRowStyle{
    
    GPShareView *shareView = [[GPShareView alloc]initWithShareItems:self.shareArray];
    shareView.itemSize = CGSizeMake(80, 100);
    shareView.isDisplayInline = YES;
    [shareView showFromControlle:self];
    
}

-(void)showDoubleRowsStyle{
    
    GPShareView *shareView = [[GPShareView alloc]initWithShareItems:self.shareArray functionItems:self.functionArray];
    shareView.itemSize = CGSizeMake(80, 100);
    shareView.isDisplayInline = YES;
    shareView.isShowBorderLine = NO;
    shareView.isShowCancleButton = YES;
    [shareView showFromControlle:self];
    
}

-(void)showMultipleRowsStyle{
    
    NSMutableArray *totalArry = [NSMutableArray array];
    [totalArry addObjectsFromArray:self.shareArray];
    [totalArry addObjectsFromArray:self.functionArray];
    
    NSInteger spaceWidth = (self.view.frame.size.width - 60 * 4) /10;
    
    GPShareView *shareView = [[GPShareView alloc]initWithShareItems:totalArry];
    shareView.itemSize = CGSizeMake(60 + spaceWidth * 2,60 + spaceWidth * 2 + 20);
    shareView.isDisplayInline = NO;
    
    shareView.itemImageSize = CGSizeMake(60, 60);
    shareView.sectionInsetSpace = spaceWidth;
    [shareView showFromControlle:self];
    
}

-(void)showSquaredStyle{
    
    GPShareView *shareView = [[GPShareView alloc]initWithShareItems:self.shareArray];
    shareView.itemSize = CGSizeMake(SCREEN_WIDTH/4, SCREEN_WIDTH/4);
    shareView.itemImageSize = CGSizeMake(45, 45);
    shareView.isDisplayInline = NO;
    shareView.isShowBorderLine = YES;
    shareView.isShowCancleButton = NO;
    shareView.isShowHeaderLabel = NO;
    shareView.sectionInsetSpace = 0;
    [shareView showFromControlle:self];
    
}

-(void)showUserDefineStyle{
    
    GPShareView *shareView = [[GPShareView alloc]initWithShareItems:self.shareArray functionItems:self.functionArray];
    shareView.itemSize = CGSizeMake(80, 100);
    shareView.isDisplayInline = YES;
    shareView.isShowBorderLine = NO;
    shareView.isShowCancleButton = YES;
    [shareView.cancleButton setTitle:@"我是可以自定义的按钮" forState:UIControlStateNormal];
    shareView.middleLineColor = [UIColor redColor];
    shareView.middleLineEdgeSpace = 20;
    shareView.middleTopSpace = 10;
    shareView.middleBottomSpace = 10;
    [shareView showFromControlle:self];
    
}



-(void)customHandlerWithTitle:(NSString *)title{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:title preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定"style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
