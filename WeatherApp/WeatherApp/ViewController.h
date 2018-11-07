//
//  ViewController.h
//  WeatherApp
//
//  Created by Guest-BCA-GSIT-iMac 1 on 23/10/18.
//  Copyright © 2018 Guest-BCA-GSIT-iMac 1. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ViewController : UIViewController<UISearchBarDelegate>

@property (strong, nonatomic) IBOutlet UISearchBar *searchLocation;
@property (strong, nonatomic) IBOutlet UILabel *locationLbl;
@property (strong, nonatomic) IBOutlet UILabel *degreeLbl;
@property (strong, nonatomic) IBOutlet UILabel *weatherLbl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *temperatureSet;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loading;

@property float temp;
@property(strong,nonatomic)NSString* searchAddress;
@property(strong, nonatomic)NSString* geography;
@property(strong, nonatomic)NSString* condition;
@property (strong, nonatomic)NSString* checkCity;

-(NSString*)changeIntoUrlFormat:(NSString*)searchLocation;
-(void)fetchingLocation:(NSString*)searchLoc;
-(void)fetchingWeatherwithGeography:(NSString*)geo;
-(void)processJsonLocation:(NSData*) data;
-(void)processJsonWeather:(NSData*)data;
@end

