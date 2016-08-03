//
//  CollectionRefreshViewController.m
//  QLZ_RefreshScrollView
//
//  Created by 张庆龙 on 16/2/4.
//  Copyright © 2016年 张庆龙. All rights reserved.
//

#import "CollectionRefreshViewController.h"
#import "UIScrollView+QLZ_Refresh.h"

@implementation CollectionRefreshViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"CollectionView刷新";
    self.view.backgroundColor = [UIColor whiteColor];
    
    array = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0; i < 10; i++) {
        [array addObject:@(i)];
    }
    
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    mainCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flow];
    mainCollectionView.delegate = self;
    mainCollectionView.dataSource = self;
    [self.view addSubview:mainCollectionView];
    [mainCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"CollectionViewCell"];
    mainCollectionView.backgroundColor = [UIColor whiteColor];
    
    __weak __typeof(self) weakSelf = self;
    [mainCollectionView addRefreshViewWithRefreshingCompletionBlock:^{
        [weakSelf endRefresh];
    }];
    [mainCollectionView addLoadMoreViewWithLoadingMoreCompletionBlock:^{
        [weakSelf endLoadMore];
    }];
}

- (void)endRefresh {
    NSLog(@"refresh");
    [array removeAllObjects];
    for (int i = 0; i < 5; i++) {
        [array addObject:@(i)];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [mainCollectionView reloadData];
        [mainCollectionView allLoadCompletion];
    });
}

- (void)endLoadMore {
    for (int i = 0; i < 5; i++) {
        [array addObject:@(i)];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [mainCollectionView reloadData];
        [mainCollectionView allLoadCompletion];
        if (array.count >= 20) {
            [mainCollectionView noMoreToLoad];
        }
    });
}

#pragma mark UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return array.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor redColor];
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(100, 100);
}

@end
