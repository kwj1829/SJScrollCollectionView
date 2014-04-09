//
//  SJCollectionViewCell.m
//  ScrollCollectionView
//
//  Created by SeokJong Gwak on 2014. 4. 2..
//  Copyright (c) 2014년 SeokJong Gwak. All rights reserved.
//

#import "SJCollectionViewCell.h"

@implementation SJCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self.imageView setClipsToBounds:YES];
        [_imageView setContentMode:UIViewContentModeScaleAspectFill];
        [self.contentView addSubview:self.imageView];
        
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, self.bounds.size.height / 5 * 4, self.bounds.size.width, self.bounds.size.height / 5)];
        self.label.backgroundColor = [[UIColor alloc] initWithWhite:1.0 alpha:0.8];
        
        self.contentView.backgroundColor = [UIColor clearColor];
        [self.label setTextAlignment:NSTextAlignmentCenter];
        
        [self.contentView addSubview:self.label];
    }
    return self;
}

@end
