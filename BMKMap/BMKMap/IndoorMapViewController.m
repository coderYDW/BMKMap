//
//  IndoorMapViewController.m
//  BMKMap
//
//  Created by Yangdongwu on 2017/9/8.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "IndoorMapViewController.h"

@interface IndoorMapViewController () <BMKMapViewDelegate,BMKLocationServiceDelegate>

@property (nonatomic, strong) BMKMapView *mapView;

@property (nonatomic, strong) BMKLocationService *locService;

@property (nonatomic, strong) MBProgressHUD *hud;

@property (nonatomic, strong) BMKUserLocation *userLocation;

@end

@implementation IndoorMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"IndoorMap";
    
    [self initLocation];
    
    [self initMap];
    
    [self createUI];
}

- (void)initLocation {

    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //启动LocationService
    [_locService startUserLocationService];
}

- (void)initMap {
    
    BMKMapView *mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVBAR_HEIGHT)];
    self.mapView = mapView;
    mapView.delegate = self;
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
    [self.mapView setBaiduHeatMapEnabled:NO];
    //logo的位置,logo不能隐藏或者用其他控件阻挡
    self.mapView.logoPosition = BMKLogoPositionLeftBottom;
    //比例尺
    self.mapView.showMapScaleBar = YES;
    //指南针的位置,大小是固定的,位置可以调整
    [self.mapView setCompassPosition:CGPointMake(SCREEN_WIDTH - self.mapView.compassSize.width, SCREEN_HEIGHT - self.mapView.compassSize.height)];
    //指南针图片,设置没有效果
    [self.mapView setCompassImage:[UIImage imageNamed:@"icon_compass"]];
    
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = BMKUserTrackingModeFollow;
    
    //室内地图使能
    self.mapView.baseIndoorMapEnabled = YES;
    
    
}

- (void)createUI {

    UIButton *locationBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 64, 44, 44)];
    locationBtn.backgroundColor = [UIColor blueColor];
    [locationBtn addTarget:self action:@selector(showLocation) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:locationBtn];

}

- (void)showLocation {

    [self setRegionWithCoordinate:self.userLocation.location.coordinate mapView:self.mapView];
    
}


#pragma mark - BMKMapViewDelegate

-(void)mapview:(BMKMapView *)mapView baseIndoorMapWithIn:(BOOL)flag baseIndoorMapInfo:(BMKBaseIndoorMapInfo *)info
{
    if (flag) {//进入室内图
        //coding...
        NSLog(@"室内");
        
        [self hudShowText:@"室内"];
    } else {//移出室内图
        //coding...
        NSLog(@"室外");
        
        [self hudShowText:@"室外"];
    }
    
    NSString *indoorID = info.strID;
    BMKSwitchIndoorFloorError error = [_mapView switchBaseIndoorMapFloor:@"F1" withID:indoorID];
    if (error == BMKSwitchIndoorFloorSuccess) {
        NSLog(@"切换楼层成功");
    }
}

#pragma mark - BMKLocationServiceDelegate

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    
    self.userLocation = userLocation;
    
    [self.mapView updateLocationData:userLocation];
    //BMKCoordinateSpan span = BMKCoordinateSpanMake(0.1, 0.1);
    //[self.mapView setRegion:BMKCoordinateRegionMake(userLocation.location.coordinate, span)];
    
}

/**
 *定位失败后，会调用此函数
 *@param error 错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error {
    NSLog(@"%s", __FUNCTION__);
}

#pragma mark - 工具方法

- (void)setRegionWithCoordinate:(CLLocationCoordinate2D)coordinate
                        mapView:(BMKMapView *)mapView{
    
    BMKCoordinateSpan span = BMKCoordinateSpanMake(0.1, 0.1);
    [mapView setRegion:BMKCoordinateRegionMake(coordinate, span)];

}

- (MBProgressHUD *)hud {
    if (_hud == nil) {
        _hud = [[MBProgressHUD alloc] init];
        _hud.mode = MBProgressHUDModeIndeterminate;
        _hud.label.textColor = [UIColor blackColor];
        _hud.minShowTime = 3;
    }
    return _hud;
}

- (void)hudShowText:(NSString *)text {

    // 快速显示一个提示信息
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.detailsLabel.text = text; //多行显示
    
    hud.detailsLabel.font = [UIFont systemFontOfSize:16]; //多行显示时设置文字大小
    
    //hud.labelText = text; 只能一行显示
    
    //hud.labelFont = [UIFont systemFontOfSize:14];单行显示时设置文字大小
    
    //  只显示文本
    
    hud.mode = MBProgressHUDModeText;
    
    //hud.mode = MBProgressHUDModeCustomView; 再设置模式
    
    // 隐藏时候从父控件中移除
    
    hud.removeFromSuperViewOnHide = YES;
    
    // 2秒之后再消失
    
    [hud hideAnimated:YES afterDelay:2.0];
    
}

- (void)mapview:(BMKMapView *)mapView onDoubleClick:(CLLocationCoordinate2D)coordinate {

    [self hudShowText:@"双击地图"];
}

@end
