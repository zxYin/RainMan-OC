//
//  ViewController.m
//  RainMan-OC
//
//  Created by 殷子欣 on 2017/4/12.
//  Copyright © 2017年 yinzixin. All rights reserved.
//

#import "HelloViewController.h"
#define ChangeTemperature(oldTemperature) (int)(((oldTemperature) - 34) / 1.8)
static NSString *serverURLString = @"https://api.darksky.net/forecast/48ab230da9721facd94485094d904aef/37.8267,-122.4233";
static NSInteger const WeatherImageTag = 500;
static NSInteger const WeatherTemperatureTag = 1000;
static NSInteger const WeatherNameTag = 1500;

@interface HelloViewController()
@property (strong, nonatomic) IBOutlet UIView *weatherView;
@property (weak, nonatomic) IBOutlet UILabel *windLabel;
@property (weak, nonatomic) IBOutlet UILabel *moistureLabel;
@property (weak, nonatomic) IBOutlet UILabel *rainLabel;
@property (weak, nonatomic) IBOutlet UILabel *temperatureMinLabel;
@property (weak, nonatomic) IBOutlet UILabel *temperatureMaxLabel;

@property (weak, nonatomic) IBOutlet UIImageView *mainImage;
@property (weak, nonatomic) IBOutlet UILabel *mainWeatherLabel;
@property (weak, nonatomic) IBOutlet UILabel *mainTemperatureLabel;

@property (nonatomic, copy) NSDictionary* taskWeatherDict;
@end
@implementation HelloViewController

#pragma mark -Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadWeatherData];
    // Do any additional setup after loading the view, typically from a mmnib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Public API

- (void)loadWeatherData {
    NSURL *url = [NSURL URLWithString: serverURLString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"GET";
    request.timeoutInterval = 10;
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
    {
        if (error == nil) {
            NSError *jsonError;
            self.taskWeatherDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error: &jsonError];
            [self refreshWeatherView];
            /*
            self.taskWeatherDict =
            @{
              @"currently" : @{
                    @"apparentTemperature" : @"55.94",
                    @"humidity" : @"0.9",
                    @"icon" : @"cloudy",
                    @"precipProbability" : @"0",
                    @"temperature" : @"55.94",
                    @"windSpeed" : @"6.36",
                },
              @"daily" : @{
                  @"data" : @[
                                @{
                                    @"icon" : @"partly-cloudy-day",
                                    @"temperatureMax" : @"64.73999999999999",
                                    @"temperatureMin" : @"55.94",
                                    },
                                @{
                                    @"icon" : @"partly-cloudy-day",
                                    @"temperatureMax" : @"68.31999999999999",
                                    @"temperatureMin" : @"52.86",
                                    },
                                @{
                                    @"icon" : @"partly-cloudy-day",
                                    @"temperatureMax" : @"71.76000000000001",
                                    @"temperatureMin" : @"52.07",
                                },
                                @{
                                    @"icon" : @"clear-day",
                                    @"temperatureMax" : @"72.89",
                                    @"temperatureMin" : @"56.27",
                                },
                                @{
                                    @"icon" : @"clear-day",
                                    @"temperatureMax" : @"74.3",
                                    @"temperatureMin" : @"55.58",
                                },
                                @{
                                    @"icon" : @"partly-cloudy-day",
                                    @"temperatureMax" : @"71.75",
                                    @"temperatureMin" : @"56.68",
                                },
                                @{
                                    @"icon" : @"partly-cloudy-day",
                                    @"temperatureMax" : @"75.87",
                                    @"temperatureMin" : @"57.84",
                                },
                                @{
                                    @"icon" : @"partly-cloudy-day",
                                    @"temperatureMax" : @"77.95",
                                    @"temperatureMin" : @"59.75",
                                }]

                    }

              };
            */
            
          }
        
    }];
    [dataTask resume];
}

#pragma mark - Private API

#pragma mark - Getter && Setter

- (void)showWeekWeathers {
    NSArray *dateName = @[@"未知",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日"];
    WeatherWeekModel *weekWeather = [[WeatherWeekModel alloc] init];
    [weekWeather weekWeatherModel:self.taskWeatherDict];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (NSInteger count=1; count<7; count++) {
            NSInteger dateNumber = weekWeather.dayWeathers[count].name;
            
            NSString *temperatureDayMax = [NSString stringWithFormat:@"%d", ChangeTemperature(weekWeather.dayWeathers[count].temperatureMax)];
            NSString *temperatureDayMin = [NSString stringWithFormat:@"%d", ChangeTemperature(weekWeather.dayWeathers[count].temperatureMin)];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UILabel *weatherName = (UILabel *)[self.weatherView viewWithTag:count+WeatherNameTag];
                if (dateNumber>7 || dateNumber<1) {
                    weatherName.text = dateName[dateNumber];
                }else{
                    weatherName.text = dateName[dateNumber];
                }
                
                UILabel *weatherTemperature = (UILabel *)[self.weatherView viewWithTag:count+WeatherTemperatureTag];
                weatherTemperature.text = [NSString stringWithFormat:@"%@/%@", temperatureDayMin, temperatureDayMax];
                
                UIImageView *weatherImage = (UIImageView *)[self.weatherView viewWithTag:count+WeatherImageTag];
                [weatherImage setImage:weekWeather.dayWeathers[count].iconImage];
            });
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.temperatureMinLabel.text = [NSString stringWithFormat:@"%d", ChangeTemperature(weekWeather.dayWeathers[0].temperatureMin)];
            self.temperatureMaxLabel.text = [NSString stringWithFormat:@"%d", ChangeTemperature(weekWeather.dayWeathers[0].temperatureMax)];
        });
    });
}

- (void)showCurrentWeather {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDictionary *currentWeatherDict = [self fetchCurrentWeather:self.taskWeatherDict];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.rainLabel.text = [NSString stringWithFormat:@"%.2f", [currentWeatherDict[@"precipProbability"] floatValue]];
            self.windLabel.text = [NSString stringWithFormat:@"%.2f", [currentWeatherDict[@"windSpeed"] floatValue]];
            self.moistureLabel.text = [NSString stringWithFormat:@"%.2f", [currentWeatherDict[@"humidity"] floatValue]];
            self.mainTemperatureLabel.text = [NSString stringWithFormat:@"%d", ChangeTemperature([currentWeatherDict[@"temperature"] floatValue])];
            [self.mainImage setImage:[UIImage imageNamed:currentWeatherDict[@"icon"]]];
            self.mainWeatherLabel.text = [currentWeatherDict[@"icon"] weatherName];
        });
    });
}

- (void)refreshWeatherView {
    [self showWeekWeathers];
    [self showCurrentWeather];
}

- (NSDictionary *)fetchCurrentWeather:(NSDictionary *)mainWeatherDict {
    if ([mainWeatherDict[@"currently"] isKindOfClass:[NSDictionary class]]) {
        return mainWeatherDict[@"currently"];
    }
    return NULL;
}

- (IBAction)degreeButtonDidClick:(id)sender {
    [self refreshWeatherView];
}

@end
