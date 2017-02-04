//
//  MazeFlowLayout.m
//  FlickrMaze
//
//  Created by Minhung Ling on 2017-02-03.
//  Copyright © 2017 Minhung Ling. All rights reserved.
//

#import "MazeFlowLayout.h"

@implementation MazeFlowLayout

- (void)prepareLayout {
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.itemSize = CGSizeMake(self.collectionView.frame.size.width/3, self.collectionView.frame.size.height/3);
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray <UICollectionViewLayoutAttributes *> *superAttrs = [super layoutAttributesForElementsInRect:rect];
    NSMutableArray<UICollectionViewLayoutAttributes *> *newAttrs = [[NSMutableArray alloc] init];
    for (UICollectionViewLayoutAttributes *superAttr in superAttrs) {
        UICollectionViewLayoutAttributes *attr = [superAttr copy];
        CGFloat newX = attr.size.width * attr.indexPath.row;
  //      CGFloat newY = attr.
        //        CGFloat newX = sin(attr.indexPath.item)*100+self.collectionView.frame.size.width/2;
//        CGFloat newY = sin(attr.indexPath.item*30)*300+self.collectionView.frame.size.height/2;
        //        float test = [self.collectionView numberOfItemsInSection:attr.indexPath.section];
        //        float alpha = 1.0 - (attr.indexPath.item)/test;
        //        attr.alpha = alpha;
        //        CGFloat newX = 10*attr.indexPath.item*(cos(3.6*attr.indexPath.item))+self.collectionView.frame.size.width/2;
        //        CGFloat newY = 10*attr.indexPath.item*(sin(3.6*attr.indexPath.item))+self.collectionView.frame.size.height/2;
        //sin(attr.indexPath.item*0.25+1)*200+(self.collectionView.frame.size.height+30)/2;
 //       attr.center = CGPointMake(attr.center.x, newY);
        //        attr.size = CGSizeMake(attr.size.width, (1/attr.center.y)*100000);
        [newAttrs addObject:attr];
    }
    return newAttrs;
}

@end
