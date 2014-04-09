//
//  SJAppDelegate.m
//  SJScrollCollectionView
//
//  Created by SeokJong Gwak on 2014. 4. 3..
//  Copyright (c) 2014년 SeokJong Gwak. All rights reserved.
//

#import "SJScrollCollectionView.h"
#import "SJCollectionViewCell.h"
#import "SJAppDelegate.h"

@interface SJAppDelegate() <SJScrollCollectionViewDataSource>
{
    SJScrollCollectionView *view;
    NSInteger rowCount;
    NSInteger colCount;
}

@end

@implementation SJAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    UIViewController *controller = [[UIViewController alloc] init];
    
    view = [[SJScrollCollectionView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    view.numberOfColsInPage = 3;
    rowCount = 50;
    colCount = 1000000;
    view.collectionViewDataSource = self;
    [view registerClass:[SJCollectionViewCell class] forCellWithReuseIdentifier:@"SJCollectionViewCell"];
    [controller.view addSubview:view];
    
    [self.window setRootViewController:controller];
    self.window.backgroundColor = [UIColor blackColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (NSInteger)numberOfRowsCollectionView:(UICollectionView *)collectionView
{
    return rowCount;
}

- (NSInteger)numberOfColsCollectionView:(UICollectionView *)collectionView
{
    return colCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForColAtIndexPath:(NSIndexPath *)indexPath
{
    SJCollectionViewCell *cell = [view dequeueReusableCellWithReuseIdentifier:@"SJCollectionViewCell" forIndexPath:indexPath];
    
    NSString *imageName = [NSString stringWithFormat:@"%i", (indexPath.tableCol + indexPath.tableRow) % 5];
    cell.imageView.image = [UIImage imageNamed:imageName];
    [cell.label setText:[NSString stringWithFormat:@"%d, %d", indexPath.tableRow, indexPath.tableCol]];
    
    return cell;
}

@end
