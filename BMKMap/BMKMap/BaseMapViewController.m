//
//  BaseMapViewController.m
//  BMKMap
//
//  Created by mac on 2017/7/26.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "BaseMapViewController.h"

@interface BaseMapViewController () <BMKMapViewDelegate>

@property (nonatomic, weak) BMKMapView *mapView;

@end

@implementation BaseMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"BaseMap";
    
    BMKMapView *mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.mapView = mapView;
    [self.view addSubview:self.mapView];
    //地图类型
    [self.mapView setMapType:BMKMapTypeStandard];
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
    [self.mapView setBaiduHeatMapEnabled:NO];
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
    annotation.title = @"北京天安门";
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
