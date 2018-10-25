//
//  ViewController.m
//  WeatherApp
//
//  Created by Guest-BCA-GSIT-iMac 1 on 23/10/18.
//  Copyright © 2018 Guest-BCA-GSIT-iMac 1. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
- (IBAction)changeTemp:(id)sender;
@property int temp;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchingWeather];
    
}
-(void)fetchingWeather{
    NSLog(@"start fetching..");
    NSString *urlString = @"https://api.darksky.net/forecast/ae0689290d9d2c94ad502883d593a295/-6.175110,106.865036?exclude=minutely,hourly,flags";
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSLog(@"Fetching finished..");
        
        if(!error){
            NSDictionary *weather = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            NSDictionary *currently = [weather objectForKey:@"currently"];
            //get location
            NSArray *location = [[weather objectForKey:@"timezone"] componentsSeparatedByString:@"/"];
            NSLog(@"%@", [location objectAtIndex:1]);
            //get temperature
            self->_temp = [[currently objectForKey:@"temperature"] intValue];
            NSLog(@"%i",self->_temp);
        
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self->_locationLbl.text = [location objectAtIndex:1];
                self->_weatherLbl.text = [currently objectForKey:@"summary"];
                self->_degreeLbl.text =[NSString stringWithFormat:@"%i",self->_temp];
                
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
        _degreeLbl.text =[NSString stringWithFormat:@"%i",self->_temp];
    }else{
        int celcius = (_temp-32)/9*5;
        _degreeLbl.text =[NSString stringWithFormat:@"%i",celcius];
    }
}
@end
