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
#import "WetherVC.h"
#import "Constants.h"
#import "CollectionViewCelliPad.h"

#define degreesToRadian(x) (M_PI * (x) / 180.0)

@interface CollectionView ()
{
    NSString *path;
    FMDatabase *database;
    NSMutableArray *symptomArr;
    NSInteger *indexpath;
}

@end

@implementation CollectionView
@synthesize symptomName;

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
    if (IS_IPAD)
    {
         tableCollection.frame=CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height-85);
    }else{
        
         tableCollection.frame=CGRectMake(0, 85, self.view.frame.size.height, self.view.frame.size.width-85);
        [[UIApplication sharedApplication] setStatusBarHidden:YES animated:NO];
        if (self.interfaceOrientation == UIInterfaceOrientationPortrait) {
            self.view.transform = CGAffineTransformIdentity;
            self.view.transform = CGAffineTransformMakeRotation(degreesToRadian(90));
            self.view.bounds = CGRectMake(0.0, 0.0, 568, 320);
        }

    }
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM SymptomTable WHERE isActive ='%@' AND symptomName='%@' ORDER BY date ASC",@"1",symptomName];
    
    FMResultSet *results = [database executeQuery:sql];
    while ([results next])
    {
        [symptomArr addObject:[results resultDictionary]];
       // [arr_symptomId addObject:[[results resultDictionary]valueForKey:@"id"]];
    }
    [results close];
    [database close];
    [tableCollection reloadData];
    
    tableCollection.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];


    
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
    if (IS_IPAD)
    {
        static NSString *cellIdentifier = @"CollectionViewCelliPad";
        CollectionViewCelliPad *cell = (CollectionViewCelliPad *)[tableCollection dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil)
        {
            cell = [[CollectionViewCelliPad alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
            cell = (CollectionViewCelliPad *)[nib objectAtIndex:0];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.selectionStyle=UITableViewCellAccessoryNone;
            
        }
        
        cell.lblDate.text=[[symptomArr valueForKey:@"date"]objectAtIndex:indexPath.row];
        cell.lblPainLavel.text=[[symptomArr valueForKey:@"painLavel"]objectAtIndex:indexPath.row];
        
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
    else
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
        cell.lblPainLavel.text=[[symptomArr valueForKey:@"painLavel"]objectAtIndex:indexPath.row];
        
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
    return nil;
    
}




-(void)selectAction:(UIButton*)sender
{
        FurtherQuestionVC *questionView = [self.storyboard instantiateViewControllerWithIdentifier:@"FurtherQuestionVC"];
       questionView.date=[[symptomArr valueForKey:@"date"]objectAtIndex:sender.tag];
        [self.navigationController pushViewController:questionView animated:YES];
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
    locationView.date=[[symptomArr valueForKey:@"date"]objectAtIndex:sender.tag];
    [self.navigationController pushViewController:locationView animated:YES];
}
-(void)selectPerson:(UIButton*)sender
{
    PersonDetailVC *peopleView = [self.storyboard instantiateViewControllerWithIdentifier:@"PersonDetailVC"];
    peopleView.date=[[symptomArr valueForKey:@"date"]objectAtIndex:sender.tag];
    [self.navigationController pushViewController:peopleView animated:YES];
}
-(void)selectPicture:(UIButton*)sender
{
    PictureVC *peopleView = [self.storyboard instantiateViewControllerWithIdentifier:@"PictureVC"];
    peopleView.date=[[symptomArr valueForKey:@"date"]objectAtIndex:sender.tag];
    [self.navigationController pushViewController:peopleView animated:YES];

}
-(void)selectRecord:(UIButton*)sender
{
    RecordingListVC *peopleView = [self.storyboard instantiateViewControllerWithIdentifier:@"RecordingListVC"];
    peopleView.date=[[symptomArr valueForKey:@"date"]objectAtIndex:sender.tag];
    [self.navigationController pushViewController:peopleView animated:YES];
}
-(void)selectWeather:(UIButton*)sender
{
    WetherVC *peopleView = [self.storyboard instantiateViewControllerWithIdentifier:@"WetherVC"];
    peopleView.date=[[symptomArr valueForKey:@"date"]objectAtIndex:sender.tag];
    [self.navigationController pushViewController:peopleView animated:YES];
    

}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
