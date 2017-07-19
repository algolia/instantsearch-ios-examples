//
//  ViewController.m
//  Getting Started Storyboard Objc
//
//  Created by Guy Daher on 23/06/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [InstantSearch.shared registerAllWidgetsIn:self.view];
    
    self.hitsController = [[HitsController alloc] initWithTable: self.tableView];
    self.tableView.dataSource = self.hitsController;
    self.tableView.delegate  = self.hitsController;
    self.hitsController.tableDataSource = self;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAt:(NSIndexPath *)indexPath containing:(NSDictionary<NSString *,id> *)hit {
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"hitCell" forIndexPath:indexPath];
    
    cell.textLabel.highlightedTextColor = [UIColor blueColor];
    cell.textLabel.highlightedBackgroundColor = [UIColor yellowColor];
    
    
    cell.textLabel.highlightedText = [[SearchResults highlightResultWithHit:hit path:@"name"] value];
    
    return cell;
}


@end
