//
//  BaseMapViewController.m
//  BMKMap
//
//  Created by mac on 2017/7/26.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "BaseMapViewController.h"

@interface BaseMapViewController () <BMKMapViewDelegate,UIScrollViewDelegate>

@property (nonatomic, weak) BMKMapView *mapView;

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation BaseMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"BaseMap";
    
    [self initMap];
    
    [self initScrollView];
    
}

- (void)initMap {
    
    BMKMapView *mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT / 2)];
    self.mapView = mapView;
    [self.view addSubview:self.mapView];
    //缩放
    [self.mapView setZoomEnabled:YES];
    //旋转
    [self.mapView setRotateEnabled:YES];
    //移动
    [self.mapView setScrollEnabled:YES];
    //交通状况
    [self.mapView setTrafficEnabled:NO];
    //俯视角(不知道什么效果)
    [self.mapView setOverlookEnabled:NO];
    //3D Touch(不知道什么效果)
    [self.mapView setForceTouchEnabled:NO];
    //热力图
    [self.mapView setBaiduHeatMapEnabled:YES];
    //logo的位置,logo不能隐藏或者用其他控件阻挡
    self.mapView.logoPosition = BMKLogoPositionLeftBottom;
    //比例尺
    self.mapView.showMapScaleBar = YES;
    //指南针的位置,大小是固定的,位置可以调整
    [self.mapView setCompassPosition:CGPointMake(SCREEN_WIDTH - self.mapView.compassSize.width, SCREEN_HEIGHT - self.mapView.compassSize.height)];
    //指南针图片,设置没有效果
    [self.mapView setCompassImage:[UIImage imageNamed:@"icon_compass"]];
    
    //显示
    self.mapView.userTrackingMode = BMKUserTrackingModeFollow;
    [self.mapView showsUserLocation];
    //self.mapView.userLocationVisible = YES;

}

- (void)initScrollView {

    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.mapView.frame), SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetHeight(self.mapView.frame) - 64)];
    self.scrollView.delegate = self;
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.view addSubview:self.scrollView];
    
    UISegmentedControl *segmentedControll = [[UISegmentedControl alloc] initWithItems:@[@"空白地图",@"标准地图",@"卫星地图"]];
    segmentedControll.frame = CGRectMake(0, 5, SCREEN_WIDTH, 30);
    [segmentedControll addTarget:self action:@selector(segmentValueChange:) forControlEvents:UIControlEventValueChanged];
    [self.scrollView addSubview:segmentedControll];
    int count = 5;
    CGFloat width = 44;
    CGFloat margin = (SCREEN_WIDTH - width * count) / (count + 1);
    NSArray *name = @[@"移动",@"缩放",@"旋转",@"热力图",@"比例尺"];
    for (int i = 0; i < count; ++i) {
        
        UISwitch *s = [[UISwitch alloc] init];
        s.tag = i;
        s.on = YES;
        [s addTarget:self action:@selector(switchValueChange:) forControlEvents:UIControlEventValueChanged];
        [self.scrollView addSubview:s];
        s.frame = CGRectMake((margin + width) * i + margin, CGRectGetMaxY(segmentedControll.frame) + 5, width, 30);
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((margin + width) * i + margin, CGRectGetMaxY(s.frame), width, 20)];
        [self.scrollView addSubview:label];
        label.text = name[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:11];
        
    }
    

}

- (void)segmentValueChange:(UISegmentedControl *)sender {

    switch (sender.selectedSegmentIndex) {
        case 0:
            self.mapView.mapType = BMKMapTypeNone;
            break;
        case 1:
            self.mapView.mapType = BMKMapTypeStandard;
            break;
        case 2:
            self.mapView.mapType = BMKMapTypeSatellite;
            break;
        default:
            break;
    }

}

- (void)switchValueChange:(UISwitch *)sender {

    switch (sender.tag) {
        case 0:
            self.mapView.scrollEnabled = sender.on;
            break;
        case 1:
            self.mapView.zoomEnabled = sender.on;
            break;
        case 2:
            self.mapView.rotateEnabled = sender.on;
            break;
        case 3:
            self.mapView.baiduHeatMapEnabled = sender.on;
            break;
        case 4:
            self.mapView.showMapScaleBar = sender.on;
            break;
        default:
            break;
    }

}

-(void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}
-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self addAnnotation];

}

- (void)addAnnotation {

    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    CLLocationCoordinate2D coor;
    coor.latitude = 39.915;
    coor.longitude = 116.404;
    annotation.coordinate = coor;
    annotation.title = @"This is BeiJing";
    [_mapView addAnnotation:annotation];
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    
    BMKPinAnnotationView *newAnnotationView = (BMKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"myAnnotation"];
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple; //样式
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        return newAnnotationView;
    }
    return nil;
}

@end
