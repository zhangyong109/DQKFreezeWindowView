//
//  ViewController.m
//  DQKFreezeWindowView
//
//  Created by 宋宋 on 15/7/16.
//  Copyright © 2015年 dianqk. All rights reserved.
//

#import "ViewController.h"
#import "DQKFreezeWindowView.h"
#import "DetailViewController.h"

@interface ViewController () <DQKFreezeWindowViewDataSource, DQKFreezeWindowViewDelegate>

@property (strong, nonatomic) DetailViewController *detailViewController;
@property (strong, nonatomic) NSArray *timeArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    DQKFreezeWindowView *freezeWindowView = [[DQKFreezeWindowView alloc] initWithFrame:self.view.frame FreezePoint:CGPointMake(54, 64) cellViewSize:CGSizeMake(103, 44)];
    [self.view addSubview:freezeWindowView];
    freezeWindowView.dataSource = self;
    freezeWindowView.delegate = self;
    [freezeWindowView setSignViewBackgroundColor:[UIColor colorWithRed:245./255. green:245./255. blue:245./255. alpha:1.]];
    freezeWindowView.style = DQKFreezeWindowViewStyleRowOnLine;
    freezeWindowView.bounceStyle = DQKFreezeWindowViewBounceStyleMain;
    NSDateComponents *dateComponents = [self getDateWithDaySinceNow:0];
    NSString *monthStr = [NSString stringWithFormat:@"%@",[self getMonthStrWithMonth:[dateComponents month]]];
    [freezeWindowView setSignViewWithContent:monthStr];
    self.detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    self.detailViewController.title = @"Event Details";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark - freeze data source
- (NSInteger)numberOfSectionsInFreezeWindowView:(DQKFreezeWindowView *)freezeWindowView {
    return 100;
}

- (NSInteger)numberOfRowsInFreezeWindowView:(DQKFreezeWindowView *)freezeWindowView {
    self.timeArray = @[@"00:00",@"01:00",@"02:00",@"03:00",@"04:00",@"05:00",@"06:00",@"07:00",@"08:00",@"09:00",@"10:00",@"11:00",@"12:00",@"13:00",@"14:00",@"15:00",@"16:00",@"17:00",@"18:00",@"19:00",@"20:00",@"21:00",@"22:00",@"23:00",@"00:00"];
    return self.timeArray.count;
}

- (DQKMainViewCell *)freezeWindowView:(DQKFreezeWindowView *)freezeWindowView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *eventCell = @"eventCell";
    DQKMainViewCell *mainCell = [freezeWindowView dequeueReusableMainCellWithIdentifier:eventCell forIndexPath:indexPath];
    if (mainCell == nil) {
        mainCell = [[DQKMainViewCell alloc] initWithStyle:DQKMainViewCellStyleCustom reuseIdentifier:eventCell];
        if (indexPath.row == 3 && indexPath.section == 2) {
            UIView *blueLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 1.5, 1.5, 42)];
            blueLineView.backgroundColor = [UIColor colorWithRed:56./255 green:157./255. blue:241./255. alpha:1];
            [mainCell addSubview:blueLineView];
            UILabel *eventLabel = [[UILabel alloc] initWithFrame:CGRectMake(1.5, 1.5, 100, 42)];
            [eventLabel setTag:200];
            eventLabel.backgroundColor = [UIColor colorWithRed:204./255. green:234./255. blue:252./255. alpha:1];
            [eventLabel setFont:[UIFont systemFontOfSize:11]];
            eventLabel.text = @"DianQK\n\n";
            eventLabel.numberOfLines = 0;
            [mainCell addSubview:eventLabel];
        }
    }
    return mainCell;
}

- (DQKSectionViewCell *)freezeWindowView:(DQKFreezeWindowView *)freezeWindowView cellAtSection:(NSInteger)section {
    static NSString *dayCell = @"dayCell";
    DQKSectionViewCell *sectionCell = [freezeWindowView dequeueReusableSectionCellWithIdentifier:dayCell forSection:section];
    sectionCell.backgroundColor = [UIColor colorWithRed:245./255. green:245./255. blue:245./255. alpha:1.];
    NSDateComponents *dateComponents = [self getDateWithDaySinceNow:section - 2];
    NSString *monthStr = [NSString stringWithFormat:@"%@",[self getMonthStrWithMonth:[dateComponents month]]];
    [freezeWindowView setSignViewWithContent:monthStr];
    if (sectionCell == nil) {
        sectionCell = [[DQKSectionViewCell alloc] initWithStyle:DQKSectionViewCellStyleCustom reuseIdentifier:dayCell];
        UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 103, 24)];
        dateLabel.text = [NSString stringWithFormat:@"%ld",(long)[dateComponents day]];
        dateLabel.textAlignment = NSTextAlignmentCenter;
        [dateLabel setTag:300];
        [sectionCell addSubview:dateLabel];
        UILabel *weekLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, 103, 24)];
        [weekLabel setFont:[UIFont systemFontOfSize:14]];
        weekLabel.text = [self getWeekStrWithWeek:[dateComponents weekday]];
        weekLabel.textAlignment = NSTextAlignmentCenter;
        [sectionCell addSubview:weekLabel];
        if (section == 2) {
            dateLabel.textColor = [UIColor whiteColor];
            [dateLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
            [weekLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
            UIView *nowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 34, 34)];
            nowView.center = dateLabel.center;
            nowView.layer.cornerRadius = 17;
            nowView.backgroundColor = [UIColor redColor];
            [sectionCell insertSubview:nowView belowSubview:dateLabel];
        }
    }
    return sectionCell;
}

- (DQKRowViewCell *)freezeWindowView:(DQKFreezeWindowView *)freezeWindowView cellAtRow:(NSInteger)row {
    static NSString *timeCell = @"timeCell";
    DQKRowViewCell *rowCell = [freezeWindowView dequeueReusableRowCellWithIdentifier:timeCell forRow:row];
    if (rowCell == nil) {
        rowCell = [[DQKRowViewCell alloc] initWithStyle:DQKRowViewCellStyleCustom reuseIdentifier:timeCell];
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, 10, 41, 20)];
        timeLabel.textColor = [UIColor colorWithRed:151./255. green:151./255. blue:151./255. alpha:1];
        [timeLabel setFont:[UIFont systemFontOfSize:11]];
        if (row >= 0 && row < self.timeArray.count) {
            timeLabel.text = self.timeArray[row];
            [rowCell addSubview:timeLabel];
        }
    }
    return rowCell;
}

#pragma mark - freeze delegate
- (void)freezeWindowView:(DQKFreezeWindowView *)freezeWindowView didSelectIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 3 && indexPath.section == 2) {
        DQKMainViewCell *mainViewCell = [freezeWindowView dequeueReusableMainCellWithIdentifier:@"eventCell" forIndexPath:indexPath];
        if (mainViewCell) {
            UILabel *eventLabel = (UILabel *)[mainViewCell viewWithTag:200];
            self.detailViewController.title = eventLabel.text;
        }
        [self.navigationController pushViewController:self.detailViewController animated:YES];
    }
}


- (NSDateComponents *)getDateWithDaySinceNow:(NSInteger)afterDay {
    NSDate *now = [NSDate dateWithTimeIntervalSinceNow:afterDay * 24 * 60 * 60];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitWeekday;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    return dateComponent;
}

- (NSString *)getWeekStrWithWeek:(NSInteger)week {
    switch (week) {
        case 1: return @"Monday"; break;
        case 2: return @"Tuesday"; break;
        case 3: return @"Wednesday"; break;
        case 4: return @"Thursday"; break;
        case 5: return @"Friday"; break;
        case 6: return @"Saturday"; break;
        case 7: return @"Sunday"; break;
        default: return nil; break;
    }
}

- (NSString *)getMonthStrWithMonth:(NSInteger)month {
    switch (month) {
        case 1: return @"JAN"; break;
        case 2: return @"FEB"; break;
        case 3: return @"MAR"; break;
        case 4: return @"APR"; break;
        case 5: return @"MAY"; break;
        case 6: return @"JUN"; break;
        case 7: return @"JUL"; break;
        case 8: return @"AUG"; break;
        case 9: return @"SEP"; break;
        case 10: return @"OCT"; break;
        case 11: return @"NOV"; break;
        case 12: return @"DEC"; break;
        default: return nil; break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
