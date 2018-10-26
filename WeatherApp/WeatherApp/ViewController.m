//
//  ViewController.m
//  WeatherApp
//
//  Created by Guest-BCA-GSIT-iMac 1 on 23/10/18.
//  Copyright © 2018 Guest-BCA-GSIT-iMac 1. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UISearchBarDelegate>
- (IBAction)changeTemp:(id)sender;
@property float temp;
@property(strong,nonatomic)NSString* longitude;
@property(strong,nonatomic)NSString* latitude;
@property(strong,nonatomic)NSString* searchAddress;
@property(strong, nonatomic)NSString* geography;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _geography = @"-6.175110,106.865036";
    _searchLocation.delegate = self;
    [self searchBarSearchButtonClicked:_searchLocation];
    [self searchBarCancelButtonClicked:_searchLocation];
    
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [_loading setHidden:YES];
    
    if(searchBar.text.length >1){
        _searchAddress = searchBar.text;
        _searchAddress = [_searchAddress stringByReplacingOccurrencesOfString:@" " withString:@"+"];
        _searchAddress = [_searchAddress stringByReplacingOccurrencesOfString:@"," withString:@"%2C"];

        NSLog(@"search loc: %@", _searchAddress);
        [self fetchingLocation:_searchAddress];
        NSLog(@"location done: %@", _searchAddress);
        
        searchBar.text = @"";
    }else{
        [self fetchingWeatherwithGeography:_geography];
    }
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    self.searchLocation.text =@"";
    [self.searchLocation resignFirstResponder];
    [self fetchingWeatherwithGeography:_geography];
}


-(void)fetchingLocation:(NSString*)searchLoc{
    NSLog(@"start fetching location..");
    
    [_loading startAnimating];
    [_degreeLbl setHidden:YES];
    [_loading setHidden:NO];
    [_weatherLbl setHidden:YES];
    [_locationLbl setHidden:YES];
    
    NSString *urlString = [NSString stringWithFormat:@"https://api.opencagedata.com/geocode/v1/json?q=%@&key=481025d551544a41bbf11e717bfb7fce&pretty=1",searchLoc];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSLog(@"Fetching finished location..");
        NSString *checkCity;
        
        if(!error){
            NSDictionary *searchedLocation = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            NSArray *result = [searchedLocation objectForKey:@"results"];
            
            //array kosong
            if(result.firstObject != nil){
                NSDictionary *mainResult = result [0];
            
                //city
                NSDictionary *city = [mainResult objectForKey:@"components"];

                // PUNYA ANDY
                //rizka tambahin logic
                
                if ([city objectForKey:@"city"] != nil) {
                    checkCity = [city objectForKey:@"city"];
                } else if ([city objectForKey:@"county"] != nil) {
                    checkCity = [city objectForKey:@"county"];
                }else if ([city objectForKey:@"state_district"] != nil) {
                    checkCity = [city objectForKey:@"state_district"];
                } else if ([city objectForKey:@"town"] != nil) {
                    checkCity = [city objectForKey:@"town"];
                } else {
                    checkCity = @"Unknown";
                }
                
                if(![checkCity isEqualToString:@"Unknown"]){
                    //geography
                    NSDictionary *geometry = [mainResult objectForKey:@"geometry"];
                    self.latitude = [geometry objectForKey:@"lat"];
                    self.longitude = [geometry objectForKey:@"lng"];
                    self.geography = [NSString stringWithFormat:@"%@,%@",self.latitude,self.longitude];

                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.locationLbl.text = checkCity;
                        [self fetchingWeatherwithGeography:self.geography];
                        NSLog(@"weather done: %@", self.geography);
                    });
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self showingSetError];
                    });
                }
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showingSetError];
            });
            NSLog(@"ERROR %@",error);
        }
        
    }]resume] ;
}

-(void)showingSetError{
    [self.loading stopAnimating];
    [self.loading setHidden:YES];
    [self.locationLbl setHidden:NO];
    self.locationLbl.text = @"Unknown";
    [self.degreeLbl setHidden:YES];
    [self.weatherLbl setHidden:YES];
}
-(void)fetchingWeatherwithGeography:(NSString*)geo{
    NSLog(@"start fetching weather..");
    NSString *urlString = [NSString stringWithFormat:@"https://api.darksky.net/forecast/ae0689290d9d2c94ad502883d593a295/%@?exclude=minutely,hourly,flags",geo];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSLog(@"Fetching weather finished..");
        
        if(!error){
            NSDictionary *weather = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"%@", weather);
            
            NSDictionary *currently = [weather objectForKey:@"currently"];
        
            self.temp = [[currently objectForKey:@"temperature"] floatValue];
            NSLog(@"temp : %f",self.temp);
        
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.weatherLbl.text = [currently objectForKey:@"summary"];
                self.degreeLbl.text =[NSString stringWithFormat:@"%.2f",self.temp];
                NSLog(@"degree : %@",self.degreeLbl.text);
                [self.loading stopAnimating];
                [self.loading setHidden:YES];
                [self.degreeLbl setHidden:NO];
                [self.weatherLbl setHidden:NO];
                [self.locationLbl setHidden:NO];
            });
        }else{
            NSLog(@"ERROR %@",error);
        }
    }]resume] ;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)changeTemp:(id)sender {
    if(_temperatureSet.selectedSegmentIndex == 0 ){
        float fahrenheit = _temp;
        NSLog(@"%f", fahrenheit);
        _degreeLbl.text =[NSString stringWithFormat:@"%.2f",fahrenheit];
    }else{
        float celcius = (((_temp-32)/9)*5);
        _degreeLbl.text =[NSString stringWithFormat:@"%.2f",celcius];
    }
}
@end
