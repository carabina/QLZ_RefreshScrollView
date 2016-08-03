//
//  ViewController.m
//  QLZ_RefreshScrollView
//
//  Created by 张庆龙 on 16/2/3.
//  Copyright © 2016年 张庆龙. All rights reserved.
//

#import "ViewController.h"
#import "UIScrollView+QLZ_Refresh.h"
#import "NormalTableViewController.h"
#import "CustomTableViewController.h"
#import "WebRefreshViewController.h"
#import "CollectionRefreshViewController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate> {
    UITableView *mainTableView;
    NSArray *array;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"刷新样式";
//    self.automaticallyAdjustsScrollViewInsets = NO;
    
    array = @[@"自带刷新效果形式1", @"自带刷新效果形式2", @"自带刷新效果形式3", @"自带刷新效果形式4", @"自定义刷新效果形式1", @"自定义刷新效果形式2", @"自定义刷新效果形式3", @"自定义刷新效果形式4", @"CollectionView刷新", @"WebView刷新"];
    
    mainTableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    mainTableView.backgroundColor = [UIColor clearColor];
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    [self.view addSubview:mainTableView];
    mainTableView.tableFooterView = [[UIView alloc] init];
    
//    mainTableView.refreshPullingPercent = 1.0f;
//    mainTableView.loadMorePullingPercent = 0.0f;
    
    __weak __typeof(self) weakSelf = self;
    [mainTableView addRefreshViewWithScrollType:QLZ_ComponentScrollType_ScrollWithView viewBlock:nil refreshingCompletionBlock:^{
        [weakSelf endRefresh];
    }];
    [mainTableView addLoadMoreViewWithScrollType:QLZ_ComponentScrollType_ScrollWithView viewBlock:nil loadingMoreCompletionBlock:^{
        [weakSelf endLoadMore];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    self.navigationController.navigationBarHidden = NO;
}

- (void)endRefresh {
    NSLog(@"refresh");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [mainTableView reloadData];
        [mainTableView allLoadCompletion];
    });
}

- (void)endLoadMore {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [mainTableView reloadData];
        [mainTableView allLoadCompletion];
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *NameCell = @"NameCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NameCell];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NameCell];
    }
    cell.textLabel.text = array[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < 4) {
        NormalTableViewController *normalTableView = [[NormalTableViewController alloc] initWithRefreshType:(int)indexPath.row title:array[indexPath.row]];
        [self.navigationController pushViewController:normalTableView animated:YES];
    }
    else if (indexPath.row < 8) {
        CustomTableViewController *customTableView = [[CustomTableViewController alloc] initWithRefreshType:(int)indexPath.row - 4 title:array[indexPath.row]];
        [self.navigationController pushViewController:customTableView animated:YES];
    }
    else if (indexPath.row == 8) {
        CollectionRefreshViewController *collectionRefreshViewController = [[CollectionRefreshViewController alloc] init];
        [self.navigationController pushViewController:collectionRefreshViewController animated:YES];
    }
    else if (indexPath.row == 9) {
        WebRefreshViewController *webRefreshViewController = [[WebRefreshViewController alloc] init];
        [self.navigationController pushViewController:webRefreshViewController animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
