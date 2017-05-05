//
//  GYZChooseCityController.m
//  GYZChooseCityDemo
//  选择城市列表
//  Created by wito on 15/12/29.
//  Copyright © 2015  gouyz. All rights reserved.
//

#import "GYZChooseCityController.h"
#import "GYZCityGroupCell.h"
#import "GYZCityHeaderView.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface GYZChooseCityController ()<GYZCityGroupCellDelegate,UISearchBarDelegate,CLLocationManagerDelegate>
/**
 *  记录所有城市信息，用于搜索
 */
@property (nonatomic, strong) NSMutableArray *recordCityData;
/**
 *  定位城市
 */
@property (nonatomic, strong) NSMutableArray *localCityData;
/**
 *  热门城市
 */
@property (nonatomic, strong) NSMutableArray *hotCityData;
/**
 *  最近访问城市
 */
@property (nonatomic, strong) NSMutableArray *commonCityData;
@property (nonatomic, strong) NSMutableArray *arraySection;
/**
 *  是否是search状态
 */
@property(nonatomic, assign) BOOL isSearch;
/**
 *  搜索框
 */
@property (nonatomic, strong) UISearchBar *searchBar;

/**
 *  搜索城市列表
 */
@property (nonatomic, strong) NSMutableArray *searchCities;
@property(nonatomic,retain)CLLocationManager *locationManager;
@end

NSString *const cityHeaderView = @"CityHeaderView";
NSString *const cityGroupCell = @"CityGroupCell";
NSString *const cityCell = @"CityCell";

@implementation GYZChooseCityController

- (instancetype)init
{
    self = [super init];
    if (self) {
        /**
         *  热门城市
         */
        self.hotCitys = @[@"110000", @"310000", @"440100", @"510100", @"440300",@"330100",@"420100",@"320100"];
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self.navigationItem setTitle:@"城市"];

    self.isSearch = NO;
    [self _initlocationMgr];
    
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44.0f)];
    self.searchBar.translucent  = YES;
    self.searchBar.delegate     = self;
    self.searchBar.placeholder  = @"城市名称或首字母或拼音";
    self.searchBar.searchBarStyle =UISearchBarStyleMinimal;
    [self.searchBar setBarTintColor:[UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1.0]];
    
    [self.tableView setTableHeaderView:self.searchBar];
    [self.tableView setSectionIndexBackgroundColor:[UIColor whiteColor]];
    [self.tableView setSectionIndexColor:[UIColor colorWithRed:91.0/255.0 green:91.0/255.0 blue:91.0/255.0 alpha:1.0]];
    [self.tableView setSeparatorColor:[UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1.0]];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cityCell];
    [self.tableView registerClass:[GYZCityGroupCell class] forCellReuseIdentifier:cityGroupCell];
    [self.tableView registerClass:[GYZCityHeaderView class] forHeaderFooterViewReuseIdentifier:cityHeaderView];
}

-(NSMutableArray *) cityDatas{
    if (_cityDatas == nil) {
        NSArray *array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CityData" ofType:@"plist"]];
        _cityDatas = [[NSMutableArray alloc] init];
        for (NSDictionary *groupDic in array) {
            GYZCityGroup *group = [[GYZCityGroup alloc] init];
            group.groupName = [groupDic objectForKey:@"initial"];
            for (NSDictionary *dic in [groupDic objectForKey:@"citys"]) {
                GYZCity *city = [[GYZCity alloc] init];
                city.cityID = [dic objectForKey:@"city_key"];
                city.cityName = [dic objectForKey:@"city_name"];
                city.shortName = [dic objectForKey:@"short_name"];
                city.pinyin = [dic objectForKey:@"pinyin"];
                city.initials = [dic objectForKey:@"initials"];
                [group.arrayCitys addObject:city];
                [self.recordCityData addObject:city];
            }
            [self.arraySection addObject:group.groupName];
            [_cityDatas addObject:group];
        }
    }
    return _cityDatas;
}

- (NSMutableArray *) recordCityData
{
    if (_recordCityData == nil) {
        _recordCityData = [[NSMutableArray alloc] init];
    }
    return _recordCityData;
}

- (NSMutableArray *) localCityData
{
    if (_localCityData == nil) {
        _localCityData = [[NSMutableArray alloc] init];
        if (self.locationCityID != nil) {
            GYZCity *city = nil;
            for (GYZCity *item in self.recordCityData) {
                if ([item.cityID isEqualToString:self.locationCityID]) {
                    city = item;
                    break;
                }
            }
            if (city == nil) {
                LQLog(@"Not Found City: %@", self.locationCityID);
            }
            else {
                [_localCityData addObject:city];
            }
        }
    }
    return _localCityData;
}

- (NSMutableArray *) hotCityData
{
    if (_hotCityData == nil) {
        _hotCityData = [[NSMutableArray alloc] init];
        for (NSString *str in self.hotCitys) {
            GYZCity *city = nil;
            for (GYZCity *item in self.recordCityData) {
                if ([item.cityID isEqualToString:str]) {
                    city = item;
                    break;
                }
            }
            if (city == nil) {
                LQLog(@"Not Found City: %@", str);
            }
            else {
                [_hotCityData addObject:city];
            }
        }
    }
    return _hotCityData;
}

- (NSMutableArray *) commonCityData
{
    if (_commonCityData == nil) {
        _commonCityData = [[NSMutableArray alloc] init];
        for (NSString *str in self.commonCitys) {
            GYZCity *city = nil;
            for (GYZCity *item in self.recordCityData) {
                if ([item.cityName isEqualToString:str]) {
                    city = item;
                    break;
                }
            }
            if (city == nil) {
                LQLog(@"Not Found City: %@", str);
            }
            else {
                [_commonCityData addObject:city];
            }
        }
    }
    return _commonCityData;
}

- (NSMutableArray *) arraySection
{
    if (_arraySection == nil) {
        _arraySection = [[NSMutableArray alloc] initWithObjects:UITableViewIndexSearch, @"!", @"#", @"$", nil];
    }
    return _arraySection;
}

- (NSMutableArray *) commonCitys
{
    if (_commonCitys == nil) {
        NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:COMMON_CITY_DATA_KEY];
        _commonCitys = (array == nil ? [[NSMutableArray alloc] init] : [[NSMutableArray alloc] initWithArray:array copyItems:YES]);
    }
    return _commonCitys;
}

#pragma mark - Getter
- (NSMutableArray *) searchCities
{
    if (_searchCities == nil) {
        _searchCities = [[NSMutableArray alloc] init];
    }
    return _searchCities;
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //搜索出来只显示一块
    if (self.isSearch) {
        return 1;
    }
    return self.cityDatas.count + 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.isSearch) {
        return self.searchCities.count;
    }
    if (section < 3) {
        return 1;
    }
    GYZCityGroup *group = [self.cityDatas objectAtIndex:section - 3];
    return group.arrayCitys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.isSearch) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cityCell];
        GYZCity *city =  [self.searchCities objectAtIndex:indexPath.row];
        [cell.textLabel setText:city.cityName];
        cell.textLabel.textColor = [UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1.0];
        return cell;
    }
    
    if (indexPath.section < 3) {
        GYZCityGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:cityGroupCell];
        if (indexPath.section == 0) {
            cell.titleLabel.text = @"定位城市";
            cell.noDataLabel.text = @"无法定位当前城市，请稍后再试";
            [cell setCityArray:self.localCityData];
        }
        else if (indexPath.section == 1) {
            cell.titleLabel.text = @"最近访问城市";
            [cell setCityArray:self.commonCityData];
        }
        else {
            cell.titleLabel.text = @"热门城市";
            [cell setCityArray:self.hotCityData];
        }
        [cell setDelegate:self];
        return cell;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cityCell];
    GYZCityGroup *group = [self.cityDatas objectAtIndex:indexPath.section - 3];
    GYZCity *city =  [group.arrayCitys objectAtIndex:indexPath.row];
    [cell.textLabel setText:city.cityName];
    cell.textLabel.textColor = [UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1.0];
    return cell;
}

#pragma mark UITableViewDelegate
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section < 3 || self.isSearch) {
        return nil;
    }
    GYZCityHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:cityHeaderView];
    NSString *title = [_arraySection objectAtIndex:section + 1];
    headerView.titleLabel.text = title;
    return headerView;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isSearch) {
        return 44.0f;
    }
    if (indexPath.section == 0) {
        return [GYZCityGroupCell getCellHeightOfCityArray:self.localCityData];
    }
    else if (indexPath.section == 1) {
        return [GYZCityGroupCell getCellHeightOfCityArray:self.commonCityData];
    }
    else if (indexPath.section == 2){
        return [GYZCityGroupCell getCellHeightOfCityArray:self.hotCityData];
    }
    return 44.0f;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section < 3 || self.isSearch) {
        return 0.0f;
    }
    return 23.5f;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GYZCity *city = nil;
    if (self.isSearch) {
        city =  [self.searchCities objectAtIndex:indexPath.row];
    }else{
        if (indexPath.section < 3) {
            if (indexPath.section == 0 && self.localCityData.count <= 0) {
                [self locationStart];
            }
            return;
        }
        GYZCityGroup *group = [self.cityDatas objectAtIndex:indexPath.section - 3];
        city =  [group.arrayCitys objectAtIndex:indexPath.row];
    }
   
    [self didSelctedCity:city];
}

- (NSArray *) sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (self.isSearch) {
        return nil;
    }
    return self.arraySection;
}

- (NSInteger) tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (index == 0) {
        return -1;
    }
    return index - 1;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_searchBar resignFirstResponder];
    [_searchBar resignFirstResponder]; //searchBar失去焦点
    UIButton *cancelBtn = [_searchBar valueForKey:@"cancelButton"]; //首先取出cancelBtn
    cancelBtn.enabled = YES; //把enabled设置为yes
}

#pragma mark searchBarDelegete

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:YES animated:YES];
    UIButton *btn=[searchBar valueForKey:@"_cancelButton"];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
    self.isSearch = YES;
    [self.tableView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self.searchCities removeAllObjects];
    
    if (searchText.length > 0) {
        for (GYZCity *city in self.recordCityData){
            NSRange chinese = [city.cityName rangeOfString:searchText options:NSCaseInsensitiveSearch];
            NSRange  letters = [city.pinyin rangeOfString:searchText options:NSCaseInsensitiveSearch];
            NSRange  initials = [city.initials rangeOfString:searchText options:NSCaseInsensitiveSearch];
            
            if (chinese.location != NSNotFound || letters.location != NSNotFound || initials.location != NSNotFound) {
                [self.searchCities addObject:city];
            }
            
            //            if ([city.cityName containsString:searchText] || [city.pinyin containsString:searchText] || [city.initials containsString:searchText]) {
            //                [self.searchCities addObject:city];
            //            }
            
        }
    }
    [self.tableView reloadData];
}

//添加搜索事件：
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}


-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{

    
    [searchBar setShowsCancelButton:NO animated:YES];
    searchBar.text=@"";
    self.isSearch = NO;
    [searchBar resignFirstResponder];
    [self.tableView reloadData];
}



#pragma mark GYZCityGroupCellDelegate
- (void) cityGroupCellDidSelectCity:(GYZCity *)city
{
    [self didSelctedCity:city];
}

#pragma mark - Private Methods
- (void) didSelctedCity:(GYZCity *)city
{
    if (_delegate && [_delegate respondsToSelector:@selector(cityPickerController:didSelectCity:)]) {
        [_delegate cityPickerController:self didSelectCity:city];
    }
    
    if (self.commonCitys.count >= MAX_COMMON_CITY_NUMBER) {
        [self.commonCitys removeLastObject];
    }
    for (NSString *str in self.commonCitys) {
        if ([city.cityName isEqualToString:str]) {
            [self.commonCitys removeObject:str];
            break;
        }
    }
    [self.commonCitys insertObject:city.cityName atIndex:0];
    [[NSUserDefaults standardUserDefaults] setValue:self.commonCitys forKey:COMMON_CITY_DATA_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
/**
 *  初始化定位
 */
- (void)_initlocationMgr {
    //定位经纬度
    self.locationManager = [[CLLocationManager alloc] init];
    
    //设置代理
    self.locationManager.delegate = self;
    
    // 设置定位精度
    // kCLLocationAccuracyNearestTenMeters:精度10米
    // kCLLocationAccuracyHundredMeters:精度100 米
    // kCLLocationAccuracyKilometer:精度1000 米
    // kCLLocationAccuracyThreeKilometers:精度3000米
    // kCLLocationAccuracyBest:设备使用电池供电时候最高的精度
    // kCLLocationAccuracyBestForNavigation:导航情况下最高精度，一般要有外接电源时才能使用
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    // distanceFilter是距离过滤器，为了减少对定位装置的轮询次数，位置的改变不会每次都去通知委托，而是在移动了足够的距离时才通知委托程序
    // 它的单位是米，这里设置为至少移动1000再通知委托处理更新;
    self.locationManager.distanceFilter = 1000.0f;
    
    //    [self AutomaticLogin];
    
    [self locationStart];
}
//开始定位
-(void)locationStart{
    //开始定位
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied ||
        [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted )
    {
        //弹出 请打开定位的提示
        
        
        UIAlertController*alertController = [UIAlertController alertControllerWithTitle:@"您未允许“ ”在您使用应用程序时访问您的位置" message:@" 需要定位您当前位置。" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction*cancelAction = [UIAlertAction actionWithTitle:@"忽略" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction*otherAction = [UIAlertAction actionWithTitle:@"去开启" style:UIAlertActionStyleDefault handler:^(UIAlertAction*action){
            NSURL*url=[NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"];  ;
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:otherAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
        return ;
    }
    float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
    if(sysVer > 8)
    {
        [self.locationManager requestAlwaysAuthorization];
    }
    
    [self.locationManager startMonitoringSignificantLocationChanges];
    [self.locationManager startUpdatingLocation];
    
}
#pragma mark - CoreLocation Delegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations

{
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    [self.locationManager stopUpdatingLocation];
    //此处locations存储了持续更新的位置坐标值，取最后一个值为最新位置，如果不想让其持续更新位置，则在此方法中获取到一个值之后让locationManager stopUpdatingLocation
    CLLocation *currentLocation = [locations lastObject];
    
    //获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *array, NSError *error)
     {
         if (array.count >0)
         {
             CLPlacemark *placemark = [array objectAtIndex:0];
             //获取城市
             NSString *currCity = placemark.locality;
             if (!currCity) {
                 //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                 currCity = placemark.administrativeArea;
             }
             currCity = [currCity componentsSeparatedByString:@"市"][0];
             if (self.localCityData.count <= 0) {
                 GYZCity *city = [[GYZCity alloc] init];
                 city.cityName = currCity;
                 city.shortName = currCity;
                 
                 if (currCity.length > 0) {
                     for (GYZCity *city in self.recordCityData){
                         NSRange chinese = [city.cityName rangeOfString:currCity options:NSCaseInsensitiveSearch];
                         NSRange  letters = [city.pinyin rangeOfString:currCity options:NSCaseInsensitiveSearch];
                         NSRange  initials = [city.initials rangeOfString:currCity options:NSCaseInsensitiveSearch];
                         
                         if (chinese.location != NSNotFound || letters.location != NSNotFound || initials.location != NSNotFound) {
                             [self.localCityData addObject:city];
                             break;
                         }
                     }
                 }
                 
                 [self.tableView reloadData];
             }
             
         } else if (error ==nil && [array count] == 0)
         {
             LQLog(@"No results were returned.");
         }else if (error !=nil)
         {
             LQLog(@"An error occurred = %@", error);
         }
         
     }];
    
}
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    if (error.code ==kCLErrorDenied) {
        // 提示用户出错原因，可按住Option键点击 KCLErrorDenied的查看更多出错信息，可打印error.code值查找原因所在
    }
    
}

@end
