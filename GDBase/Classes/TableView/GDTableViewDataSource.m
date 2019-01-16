//
//  GDTableViewDataSource.m
//  Network
//
//  Created by jelly on 2018/8/29.
//  Copyright © 2018年 jelly. All rights reserved.
//

#import "GDTableViewDataSource.h"

@interface GDTableViewDataSource (){
    
}
@property (nonatomic, copy) NSArray *dataSource;

@property (nonatomic, copy) ConfigCellBlock configCellBlock;

@property (nonatomic, copy) CellIdentifierBlock cellIdentitierBlock;

@end

@implementation GDTableViewDataSource



- (instancetype)initDataSource:(NSArray *)dataSource cellIdentifier:(CellIdentifierBlock)identifierBlock configCellBlock:(ConfigCellBlock)configCellBlock{
    if (self = [super init]) {
        self.dataSource = dataSource;
        self.configCellBlock = configCellBlock;
        self.cellIdentitierBlock = identifierBlock;
    }
    return self;
}

- (void)updateDataSources:(NSArray *)dataSource{
    self.dataSource = dataSource;
}


- (id)itemAtIndexPath:(NSIndexPath*)indexPath {
    return self.dataSource[(NSUInteger)indexPath.row];
}

- (NSInteger)tableView:(UITableView*)tableView
 numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView
        cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    NSString *identifier = @"cellIdentifier";
    if (self.cellIdentitierBlock) {
        identifier = self.cellIdentitierBlock(indexPath);
    }
    id cell = [tableView dequeueReusableCellWithIdentifier:identifier
                                              forIndexPath:indexPath];
    if(self.configCellBlock){
        self.configCellBlock(cell,tableView, indexPath,self.dataSource);
    }
    return cell;
}
@end
