//
//  CollectionView.m
//  Dominik
//
//  Created by amit varma on 17/12/15.
//  Copyright © 2015 trigma. All rights reserved.
//

#import "CollectionView.h"
#import "CollectionViewCell.h"
#import "FMDatabase.h"
#import "FoodDetailVC.h"
#import "PersonDetailVC.h"
#import "LocationDetailVC.h"
#import "PictureVC.h"
#import "FurtherQuestionVC.h"
#import "RecordingListVC.h"

#define degreesToRadian(x) (M_PI * (x) / 180.0)

@interface CollectionView ()
{
    NSString *path;
    FMDatabase *database;
    NSMutableArray *symptomArr;
}

@end

@implementation CollectionView

- (void)viewDidLoad
{
    [super viewDidLoad];

    symptomArr=[[NSMutableArray alloc]init];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    path = [docsPath stringByAppendingPathComponent:@"database.sqlite"];
    database = [FMDatabase databaseWithPath:path];
    [database open];
               
}
-(void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES animated:NO];
    if (self.interfaceOrientation == UIInterfaceOrientationPortrait) {
        self.view.transform = CGAffineTransformIdentity;
        self.view.transform = CGAffineTransformMakeRotation(degreesToRadian(90));
        self.view.bounds = CGRectMake(0.0, 0.0, 480, 320);
    }
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM SymptomTable WHERE isActive ='%@'",@"1"];
    
    FMResultSet *results = [database executeQuery:sql];
    while ([results next])
    {
        [symptomArr addObject:[results resultDictionary]];
       // [arr_symptomId addObject:[[results resultDictionary]valueForKey:@"id"]];
    }
    [results close];
    [database close];
    [tableCollection reloadData];

    
}

- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --TableView Delegate--

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return symptomArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 44;
}

- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CollectionViewCell";
    CollectionViewCell *cell = (CollectionViewCell *)[tableCollection dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[CollectionViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        cell = (CollectionViewCell *)[nib objectAtIndex:0];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.selectionStyle=UITableViewCellAccessoryNone;
        
    }
    cell.lblDate.text=[[symptomArr valueForKey:@"date"]objectAtIndex:indexPath.row];
    
    [cell.btnAction addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.btnAction.tag=indexPath.row;
    
    [cell.btnFood addTarget:self action:@selector(selectFood:) forControlEvents:UIControlEventTouchUpInside];
    cell.btnFood.tag=indexPath.row;
    
    [cell.btnLocation addTarget:self action:@selector(selectLocation:) forControlEvents:UIControlEventTouchUpInside];
    cell.btnLocation.tag=indexPath.row;
    
    [cell.btnPerson addTarget:self action:@selector(selectPerson:) forControlEvents:UIControlEventTouchUpInside];
    cell.btnPerson.tag=indexPath.row;
    
    [cell.btnPicture addTarget:self action:@selector(selectPicture:) forControlEvents:UIControlEventTouchUpInside];
    cell.btnPicture.tag=indexPath.row;
    
    [cell.btnRecord addTarget:self action:@selector(selectRecord:) forControlEvents:UIControlEventTouchUpInside];
    cell.btnRecord.tag=indexPath.row;
    
    [cell.btnWeather addTarget:self action:@selector(selectWeather:) forControlEvents:UIControlEventTouchUpInside];
    cell.btnWeather.tag=indexPath.row;
    
    // Just want to test, so I hardcode the data
    return cell;
}
-(void)selectAction:(UIButton*)sender
{
    
}
-(void)selectFood:(UIButton*)sender
{
    FoodDetailVC *foodView = [self.storyboard instantiateViewControllerWithIdentifier:@"FoodDetailVC"];
    foodView.date=[[symptomArr valueForKey:@"date"]objectAtIndex:sender.tag];
    [self.navigationController pushViewController:foodView animated:YES];
}
-(void)selectLocation:(UIButton*)sender
{
    LocationDetailVC *locationView = [self.storyboard instantiateViewControllerWithIdentifier:@"LocationDetailVC"];
    [self.navigationController pushViewController:locationView animated:YES];
}
-(void)selectPerson:(UIButton*)sender
{
    PersonDetailVC *peopleView = [self.storyboard instantiateViewControllerWithIdentifier:@"PersonDetailVC"];
    [self.navigationController pushViewController:peopleView animated:YES];
}
-(void)selectPicture:(UIButton*)sender
{
    PictureVC *peopleView = [self.storyboard instantiateViewControllerWithIdentifier:@"PictureVC"];
    [self.navigationController pushViewController:peopleView animated:YES];

}
-(void)selectRecord:(UIButton*)sender
{
    RecordingListVC *peopleView = [self.storyboard instantiateViewControllerWithIdentifier:@"RecordingListVC"];
    [self.navigationController pushViewController:peopleView animated:YES];
}
-(void)selectWeather:(UIButton*)sender
{
    FurtherQuestionVC *peopleView = [self.storyboard instantiateViewControllerWithIdentifier:@"FurtherQuestionVC"];
    [self.navigationController pushViewController:peopleView animated:YES];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
