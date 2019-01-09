//
//  GDTableViewDataSource.h
//  Network
//
//  Created by jelly on 2018/8/29.
//  Copyright © 2018年 jelly. All rights reserved.
//

#import <Foundation/Foundation.h>


#import <UIKit/UIKit.h>

typedef void(^ConfigCellBlock)(id cell,UITableView *tableView, NSIndexPath *indexPath,NSArray *dataSoucre);

/**
    cellIdentifier 通过回调， 可以配合多种Cell情况  默认的 "cellIdentifier";
 
 */
typedef NSString *(^CellIdentifierBlock)(NSIndexPath *indexPath);

@interface GDTableViewDataSource : NSObject<UITableViewDataSource>

@property (nonatomic, copy, readonly) NSArray *dataSource;


/**
 初始化状态

 @param dataSource 数据源
 @param identifierBlock tableviewcell 的 identity 重复用。
 @param configCellBlock tableviewcell 的 cell的个性化UI设置
 @return GDTableViewDataSource 对象
 */
- (instancetype)initDataSource:(NSArray *)dataSource cellIdentifier:(CellIdentifierBlock )identifierBlock configCellBlock:(ConfigCellBlock )configCellBlock;

- (void)updateDataSources:(NSArray *)dataSource;

@end



