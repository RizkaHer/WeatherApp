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
@property int temp;
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
    NSLog(@"end editing");
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
    NSString *urlString = [NSString stringWithFormat:@"https://api.opencagedata.com/geocode/v1/json?q=%@&key=481025d551544a41bbf11e717bfb7fce&pretty=1",searchLoc];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSLog(@"Fetching finished location..");
        
        if(!error){
            NSDictionary *searchedLocation = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];

            NSArray *result = [searchedLocation objectForKey:@"results"];
            NSDictionary *mainResult = result [0];
            
            NSDictionary *geometry = [mainResult objectForKey:@"geometry"];
            self.latitude = [geometry objectForKey:@"lat"];
            NSLog(@"latitude : %@",self.latitude);
            self.longitude = [geometry objectForKey:@"lng"];
            NSLog(@"longitude : %@",self.longitude);
            
            self.geography = [NSString stringWithFormat:@"%@,%@",self.latitude,self.longitude];
            
            //city
            NSDictionary *city = [mainResult objectForKey:@"components"];
            dispatch_async(dispatch_get_main_queue(), ^{
                 self.locationLbl.text = [city objectForKey:@"city"];
                [self fetchingWeatherwithGeography:self.geography];
                NSLog(@"weather done: %@", self.geography);
            });
            
        }else{
            NSLog(@"ERROR %@",error);
        }
    }]resume] ;
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
        
            self.temp = [[currently objectForKey:@"temperature"] intValue];
            NSLog(@"temp : %i",self.temp);
        
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.weatherLbl.text = [currently objectForKey:@"summary"];
                self.degreeLbl.text =[NSString stringWithFormat:@"%i",self.temp];
                NSLog(@"degree : %@",self.degreeLbl.text);
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
        int fahrenheit = _temp;
        NSLog(@"%i", fahrenheit);
        _degreeLbl.text =[NSString stringWithFormat:@"%i",fahrenheit];
    }else{
        int celcius = (_temp-32)/9*5;
        _degreeLbl.text =[NSString stringWithFormat:@"%i",celcius];
    }
}
@end
