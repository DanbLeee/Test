//
//  CustomCell.m
//  UISearchBar
//
//  Created by 李蛋伯 on 2016/8/17.
//  Copyright © 2016年 李蛋伯. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell

//初始化自定义单元格
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    //调用父类构造函数
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        //设定标签栏和图片视图尺寸参数
        CGFloat cellWidth = self.frame.size.width;
        CGFloat cellHeight = self.frame.size.height;
        
        CGFloat imageViewRightView = 38;
        CGFloat imageViewWidth = 49;
        CGFloat imageViewHeight = 35;
        
        CGFloat labelLeftView = 38;
        CGFloat labelHeight = 21;
        CGFloat labelWidth = 101;
        
        //添加imageView。表达式 (cellHeight - imageViewHeight)/2 作为ImageView的X坐标，可以使ImageView在单元格中垂直居中
        _myImageView = [[UIImageView alloc]initWithFrame:CGRectMake(cellWidth - (imageViewRightView + imageViewWidth), (cellHeight - imageViewHeight)/2, imageViewWidth, imageViewHeight)];
        
        [self addSubview:_myImageView];
        
        //添加标签
        _myLabel = [[UILabel alloc]initWithFrame:CGRectMake(labelLeftView, (cellHeight - labelHeight)/2, labelWidth, labelHeight)];
        
        [self addSubview:_myLabel];
        
    }
    
    return self;
    
}

@end
