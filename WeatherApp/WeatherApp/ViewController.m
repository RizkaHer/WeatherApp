//
//  ViewController.m
//  WeatherApp
//
//  Created by Guest-BCA-GSIT-iMac 1 on 23/10/18.
//  Copyright © 2018 Guest-BCA-GSIT-iMac 1. All rights reserved.
//

#import "ViewController.h"
#import "WeatherApp-Bridging-Header.h"

@interface ViewController () <UISearchBarDelegate>
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _geography = @"-6.175110,106.865036";
    _searchLocation.delegate = self;
    [self searchBarSearchButtonClicked:_searchLocation];
    [self searchBarCancelButtonClicked:_searchLocation];
}

-(NSString*)changeIntoUrlFormat:(NSString*)searchLocation{
    NSString* urlLocation = searchLocation;
    urlLocation = [urlLocation stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    urlLocation = [urlLocation stringByReplacingOccurrencesOfString:@"," withString:@"%2C"];
    return urlLocation;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [_loading setHidden:YES];
    
    if(searchBar.text.length >1 && ![searchBar.text isEqualToString:@"Jakarta"]){
        _searchAddress = [self changeIntoUrlFormat:searchBar.text];
       [self fetchingLocation:_searchAddress];
        //[self fetchingWeatherwithGeography:self.geography];
        searchBar.text = @"";
    }else if([searchBar.text isEqualToString:@"Jakarta"]){
        [self startIconAnimating];
        _geography = @"-6.175110,106.865036";
        _checkCity = @"Jakarta";
        [self fetchingWeatherwithGeography:_geography];
         searchBar.text = @"";
    }else{
        [self startIconAnimating];
        [self fetchingWeatherwithGeography:_geography];
    }
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    self.searchLocation.text =@"";
    [self.searchLocation resignFirstResponder];
    [self fetchingWeatherwithGeography:_geography];
}

-(void)startIconAnimating{
    [_loading startAnimating];
    [_degreeLbl setHidden:YES];
    [_loading setHidden:NO];
    [_weatherLbl setHidden:YES];
    [_locationLbl setHidden:YES];
}

-(NSString*)getCity:(NSDictionary*)city{
    if ([city objectForKey:@"city"] != nil) {
        return [city objectForKey:@"city"];
    } else if ([city objectForKey:@"county"] != nil) {
        return [city objectForKey:@"county"];
    }else if ([city objectForKey:@"state_district"] != nil) {
        return [city objectForKey:@"state_district"];
    } else if ([city objectForKey:@"town"] != nil) {
        return [city objectForKey:@"town"];
    } else{
        return @"Unknown";
    }
}

-(void)fetchingLocation:(NSString*)searchLoc{
    NSLog(@"start fetching location..");
    [self startIconAnimating];
    
    NSString *urlString = [NSString stringWithFormat:@"https://api.opencagedata.com/geocode/v1/json?q=%@&key=481025d551544a41bbf11e717bfb7fce&pretty=1",searchLoc];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(!error){
             [self processJsonLocation:data];
             [self fetchingWeatherwithGeography:self.geography];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showingSetError];
            });
            NSLog(@"ERROR %@",error.localizedDescription);
        }
    }]resume] ;
       [self.loading stopAnimating];
}

-(void)processJsonLocation:(NSData*) data{
    NSLog(@"Fetching finished location..");
    NSString* longitude;
    NSString* latitude;
   
    NSDictionary *searchedLocation = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSArray *result = [searchedLocation objectForKey:@"results"];
    
    //array kosong
    if(result.firstObject != nil){
        NSDictionary *mainResult = result [0];
        
        //city
        NSDictionary *city = [mainResult objectForKey:@"components"];
        
        //call getCity
        self.checkCity = [self getCity:city];
        
        if(![self.checkCity isEqualToString:@"Unknown"]){
            //geography
            NSDictionary *geometry = [mainResult objectForKey:@"geometry"];
            latitude = [geometry objectForKey:@"lat"];
            longitude = [geometry objectForKey:@"lng"];
            self.geography = [NSString stringWithFormat:@"%@,%@",latitude,longitude];
            NSLog(@"geo: %@",_geography);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.locationLbl.text = self.checkCity;
                
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showingSetError];
            });
        }
    }
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
            [self processJsonWeather:data];
        }else{
            NSLog(@"ERROR %@",error);
        }
    }]resume] ;
}

-(void)processJsonWeather:(NSData*)data{
    NSDictionary *weather = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    NSDictionary *currently = [weather objectForKey:@"currently"];
    self.temp = [[currently objectForKey:@"temperature"] floatValue];
    self.condition =[currently objectForKey:@"summary"];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if(self.temperatureSet.selectedSegmentIndex == 1 ){
            self.temp = (((self.temp-32)/9)*5);
        }
        self.weatherLbl.text = self.condition;
        self.degreeLbl.text =[NSString stringWithFormat:@"%.2f",self.temp];
        NSLog(@"Weather: %@", self.weatherLbl.text);
        NSLog(@"Degree: %@", self.degreeLbl.text);
        [self.loading stopAnimating];
        [self.loading setHidden:YES];
        [self.degreeLbl setHidden:NO];
        [self.weatherLbl setHidden:NO];
        [self.locationLbl setHidden:NO];
    });
}

- (IBAction)changeTemp:(id)sender {
    switch (_temperatureSet.selectedSegmentIndex) {
        case 0:
        {
            _temp= ((_temp*9/5)+32);
            _degreeLbl.text =[NSString stringWithFormat:@"%.2f",_temp];
            break;
        }
        case 1:
        {  _temp = (((_temp-32)/9)*5);
            _degreeLbl.text =[NSString stringWithFormat:@"%.2f",_temp];
            break;
        }
    }
}


@end
