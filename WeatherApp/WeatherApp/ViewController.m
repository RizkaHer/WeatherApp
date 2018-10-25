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
@property(strong,nonatomic)NSString* searchLoc;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _searchLocation.delegate = self;
    [self searchBarSearchButtonClicked:_searchLocation];
    [self searchBarCancelButtonClicked:_searchLocation];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"end editing");
    if(searchBar.text.length >1){
        
        _searchLoc = searchBar.text;
        NSLog(@"search loc: %@", _searchLoc);
        [self fetchingLocation:_searchLoc];
        NSLog(@"%@", _longitude);
        NSLog(@"%@", _latitude);
        [self fetchingWeatherwithLongitude:_longitude andLatitude:_latitude];
        
    }else{
        [self fetchingWeatherwithLongitude:@"106.865036" andLatitude:@"-6.175110"];
    }
        
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    self.searchLocation.text =@"";
    [self.searchLocation resignFirstResponder];
    [self fetchingWeatherwithLongitude:@"106.865036" andLatitude:@"-6.175110"];
}


-(void)fetchingLocation:(NSString*)searchLoc{
    NSLog(@"start fetching location..");
    NSString *urlString = [NSString stringWithFormat:@"https://api.opencagedata.com/geocode/v1/json?q=%@&pretty=1&key=481025d551544a41bbf11e717bfb7fce",searchLoc];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSLog(@"Fetching finished location..");
        
        if(!error){
            NSDictionary *searchedLocation = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"%@",searchedLocation);
            
            NSDictionary *result = [searchedLocation objectForKey:@"result"];
            NSDictionary *geometry = [result objectForKey:@"geometry"];
            self.latitude = [geometry objectForKey:@"lat"];
            NSLog(@"degree : %@",self.latitude);
            self.longitude = [geometry objectForKey:@"lng"];
            NSLog(@"degree : %@",self.longitude);
        }else{
            NSLog(@"ERROR %@",error);
        }
    }]resume] ;
}


-(void)fetchingWeatherwithLongitude:(NSString*)longitude andLatitude:(NSString *)latitude{
    NSLog(@"start fetching weather..");
    NSString *urlString = [NSString stringWithFormat:@"https://api.darksky.net/forecast/ae0689290d9d2c94ad502883d593a295/%@,%@?exclude=minutely,hourly,flags",latitude,longitude];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSLog(@"Fetching weather finished..");
        
        if(!error){
            NSDictionary *weather = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            NSDictionary *currently = [weather objectForKey:@"currently"];
            //get location
            NSArray *location = [[weather objectForKey:@"timezone"] componentsSeparatedByString:@"/"];
            NSLog(@"location : %@", [location objectAtIndex:1]);
            //get temperature
            self.temp = [[currently objectForKey:@"temperature"] intValue];
            NSLog(@"temp : %i",self.temp);
        
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.locationLbl.text = [location objectAtIndex:1];
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
