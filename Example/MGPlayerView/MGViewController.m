//
//  MGViewController.m
//  MGPlayerView
//
//  Created by mal666666@163.com on 05/19/2020.
//  Copyright (c) 2020 mal666666@163.com. All rights reserved.
//

#import "MGViewController.h"
#import "MGPlayerDetailController.h"
#import "MGTableViewCell.h"

@interface MGViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *arr;

@end

@implementation MGViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor grayColor];
    
    self.arr = @[@"http://stream1.shopch.jp/HLS/out1/prog_index.m3u8",
                 @"http://www.malgg.com/video/1.mp4",
                 @"http://www.malgg.com/video/2.mp4",
                 @"http://www.malgg.com/video/3.mp4",
                 @"http://www.malgg.com/video/4.mp4",
                 @"http://www.malgg.com/video/5.mp4",
                 @"http://www.malgg.com/video/6.mp4"].mutableCopy;
    UITableView *tab = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    tab.frame = CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height);
    [tab registerClass:[MGTableViewCell class] forCellReuseIdentifier:@"cell"];
    tab.delegate = self;
    tab.dataSource = self;
    [self.view addSubview:tab];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MGTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[MGTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    [cell setImg:self.arr[indexPath.row]];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MGPlayerDetailController *vc = [[MGPlayerDetailController alloc]init];
    vc.url = self.arr[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
