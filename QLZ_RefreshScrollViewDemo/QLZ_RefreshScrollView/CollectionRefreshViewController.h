//
//  CollectionRefreshViewController.h
//  QLZ_RefreshScrollView
//
//  Created by 张庆龙 on 16/2/4.
//  Copyright © 2016年 张庆龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionRefreshViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout> {
    UICollectionView *mainCollectionView;
    NSMutableArray *array;
}

@end
