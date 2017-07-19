//
//  ViewController.h
//  Getting Started Storyboard Objc
//
//  Created by Guy Daher on 23/06/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

#import <UIKit/UIKit.h>
@import InstantSearch;
@import InstantSearchCore;

@interface ViewController : UIViewController <HitsTableViewDataSource>

@property (weak, nonatomic) IBOutlet HitsTableWidget *tableView;
@property HitsController* hitsController;

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAt:(NSIndexPath *)indexPath containing:(NSDictionary<NSString *,id> *)hit;


@end

