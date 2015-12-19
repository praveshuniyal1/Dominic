//
//  QuestionFurtherVC.m
//  Dominik
//
//  Created by amit varma on 06/11/15.
//  Copyright © 2015 trigma. All rights reserved.
//

#import "QuestionFurtherVC.h"
#import "FMDatabase.h"
#import "AppDelegate.h"



@interface QuestionFurtherVC ()
{
    NSMutableArray * arrselect;
    NSMutableArray * arrStress;
    NSMutableArray * arrHowlong;
    NSMutableArray * arrAntrieb;
    NSMutableArray * arrBodyWeight;
    NSString *path;
    FMDatabase *database;
    NSString *userId;
    NSString *selectDate;
    NSDictionary *questionDic;
    
}

@end

@implementation QuestionFurtherVC
@synthesize btnSelect;

- (void)viewDidLoad
{
    [super viewDidLoad];
    questionDic=[NSDictionary new];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    path = [docsPath stringByAppendingPathComponent:@"database.sqlite"];
    database = [FMDatabase databaseWithPath:path];
    [database open];
}
-(void)viewWillAppear:(BOOL)animated
{
    userId=[[NSUserDefaults standardUserDefaults]objectForKey:@"user_id"];
    selectDate=[[NSUserDefaults standardUserDefaults] valueForKey:@"selectDate"];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM questionTbl where user_id='%@' and date='%@'",userId,selectDate];
    FMResultSet *results = [database executeQuery:sql];
    
    while ([results next])
    {
        questionDic =[results resultDictionary];
    }
    [self showQuestionValue:questionDic];
    [database close];
    [results close];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)showQuestionValue:(NSDictionary*)dic
{
    txt_description.text=[dic valueForKey:@"description"];
    lblMood.text=[dic valueForKey:@"mood"];
    lblstress.text=[dic valueForKey:@"stress"];
    lblHowLong.text=[dic valueForKey:@"howLong"];
    lblAntrieb.text=[dic valueForKey:@"antrieb"];
    lblBodyWeight.text=[dic valueForKey:@"bodyWeight"];
}

- (IBAction)selectClicked:(id)sender
{
    arrselect = [[NSMutableArray alloc] init];
    for (int i=0; i<10; i++)
    {
        [arrselect addObject:[NSString stringWithFormat:@"%d",i+1]];
    }
    
    NSArray * arrImage = [[NSArray alloc] init];
    arrImage = [NSArray arrayWithObjects:[UIImage imageNamed:@"location-pin"], [UIImage imageNamed:@"location-pin"], [UIImage imageNamed:@"location-pin"], [UIImage imageNamed:@"location-pin"], [UIImage imageNamed:@"location-pin"],  nil];
    if(dropDown == nil) {
        CGFloat f = 200;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :arrselect :nil :@"down"];
        dropDown.delegate = self;
    }
    else {
        [dropDown hideDropDown:sender];
        [self rel];
    }
}

- (IBAction)stressClicked:(id)sender
{
    arrStress = [[NSMutableArray alloc] init];
    for (int i=0; i<10; i++)
    {
        [arrStress addObject:[NSString stringWithFormat:@"%d",i+1]];
    }
    NSArray * arrImage = [[NSArray alloc] init];
    arrImage = [NSArray arrayWithObjects:[UIImage imageNamed:@"apple.png"], [UIImage imageNamed:@"apple2.png"], [UIImage imageNamed:@"apple.png"], [UIImage imageNamed:@"apple2.png"], [UIImage imageNamed:@"apple.png"], [UIImage imageNamed:@"apple2.png"], [UIImage imageNamed:@"apple.png"], [UIImage imageNamed:@"apple2.png"], [UIImage imageNamed:@"apple.png"], [UIImage imageNamed:@"apple2.png"], nil];
    if(dropDownStress == nil) {
        CGFloat f = 200;
        dropDownStress = [[NIDropDown alloc]showDropDown:sender :&f :arrStress :nil :@"down"];
        dropDownStress.delegate = self;
    }
    else {
        [dropDownStress hideDropDown:sender];
        [self rel];
    }

}

- (IBAction)howLongClicked:(id)sender
{
    arrHowlong = [[NSMutableArray alloc] init];
    for (int i=0; i<=14; i++)
    {
        [arrHowlong addObject:[NSString stringWithFormat:@"%d",i]];
    }
    NSArray * arrImage = [[NSArray alloc] init];
    arrImage = [NSArray arrayWithObjects:[UIImage imageNamed:@"apple.png"], [UIImage imageNamed:@"apple2.png"], [UIImage imageNamed:@"apple.png"], [UIImage imageNamed:@"apple2.png"], [UIImage imageNamed:@"apple.png"], [UIImage imageNamed:@"apple2.png"], [UIImage imageNamed:@"apple.png"], [UIImage imageNamed:@"apple2.png"], [UIImage imageNamed:@"apple.png"], [UIImage imageNamed:@"apple2.png"], nil];
    if(dropDownHowlong == nil) {
        CGFloat f = 200;
        dropDownHowlong = [[NIDropDown alloc]showDropDown:sender :&f :arrHowlong :nil :@"down"];
        dropDownHowlong.delegate = self;
    }
    else {
        [dropDownHowlong hideDropDown:sender];
        [self rel];
    }

}

- (IBAction)antriebClicked:(id)sender
{
    arrAntrieb = [[NSMutableArray alloc] init];
    for (int i=0; i<10; i++)
    {
        [arrAntrieb addObject:[NSString stringWithFormat:@"%d",i+1]];
    }
    NSArray * arrImage = [[NSArray alloc] init];
    arrImage = [NSArray arrayWithObjects:[UIImage imageNamed:@"apple.png"], [UIImage imageNamed:@"apple2.png"], [UIImage imageNamed:@"apple.png"], [UIImage imageNamed:@"apple2.png"], [UIImage imageNamed:@"apple.png"], [UIImage imageNamed:@"apple2.png"], [UIImage imageNamed:@"apple.png"], [UIImage imageNamed:@"apple2.png"], [UIImage imageNamed:@"apple.png"], [UIImage imageNamed:@"apple2.png"], nil];
    if(dropDownAntrieb == nil) {
        CGFloat f = 200;
        dropDownAntrieb = [[NIDropDown alloc]showDropDown:sender :&f :arrAntrieb :nil :@"down"];
        dropDownAntrieb.delegate = self;
    }
    else {
        [dropDownAntrieb hideDropDown:sender];
        [self rel];
    }

}

- (IBAction)bodyWightClicked:(id)sender
{
    arrBodyWeight = [[NSMutableArray alloc] init];
    for (int i=0; i<215; i++)
    {
        [arrBodyWeight addObject:[NSString stringWithFormat:@"%d",i+1]];
    }

    NSArray * arrImage = [[NSArray alloc] init];
    arrImage = [NSArray arrayWithObjects:[UIImage imageNamed:@"apple.png"], [UIImage imageNamed:@"apple2.png"], [UIImage imageNamed:@"apple.png"], [UIImage imageNamed:@"apple2.png"], [UIImage imageNamed:@"apple.png"], [UIImage imageNamed:@"apple2.png"], [UIImage imageNamed:@"apple.png"], [UIImage imageNamed:@"apple2.png"], [UIImage imageNamed:@"apple.png"], [UIImage imageNamed:@"apple2.png"], nil];
    if(dropDownBodyWeight == nil) {
        CGFloat f = 100;
        dropDownBodyWeight = [[NIDropDown alloc]showDropDown:sender :&f :arrBodyWeight :nil :@"down"];
        dropDownBodyWeight.delegate = self;
    }
    else {
        [dropDownBodyWeight hideDropDown:sender];
        [self rel];
    }

}


- (void) niDropDownDelegateMethod: (NIDropDown *) sender
{
    if (sender==dropDown)
    {
        lblMood.text=[arrselect objectAtIndex:[[NSUserDefaults standardUserDefaults]integerForKey:@"indexPath"]];
        NSLog(@"%@",[arrselect objectAtIndex:[[NSUserDefaults standardUserDefaults]integerForKey:@"indexPath"]]);
    }
    else if (sender==dropDownStress)
    {
        lblstress.text=[arrStress objectAtIndex:[[NSUserDefaults standardUserDefaults]integerForKey:@"indexPath"]];
         NSLog(@"%@",[arrStress objectAtIndex:[[NSUserDefaults standardUserDefaults]integerForKey:@"indexPath"]]);
    }
    else if (sender==dropDownHowlong)
    {
        lblHowLong.text=[arrHowlong objectAtIndex:[[NSUserDefaults standardUserDefaults]integerForKey:@"indexPath"]];
         NSLog(@"%@",[arrHowlong objectAtIndex:[[NSUserDefaults standardUserDefaults]integerForKey:@"indexPath"]]);
    }
    else if (sender==dropDownAntrieb)
    {
        lblAntrieb.text=[arrAntrieb objectAtIndex:[[NSUserDefaults standardUserDefaults]integerForKey:@"indexPath"]];
         NSLog(@"%@",[arrAntrieb objectAtIndex:[[NSUserDefaults standardUserDefaults]integerForKey:@"indexPath"]]);
    }
    else if (sender==dropDownBodyWeight)
    {
        lblBodyWeight.text=[arrBodyWeight objectAtIndex:[[NSUserDefaults standardUserDefaults]integerForKey:@"indexPath"]];
         NSLog(@"%@",[arrBodyWeight objectAtIndex:[[NSUserDefaults standardUserDefaults]integerForKey:@"indexPath"]]);
    }
    [self rel];
}

-(void)rel{
    //    [dropDown release];
    dropDown = nil;
}

#pragma Database action
- (IBAction)checkAction:(id)sender
{
    
    if (txt_description.text.length==0)
    {
        [KappDelgate showAlertView:@"Message" with:@"Please fill description field"];
    }
    else if (lblMood.text.length==0)
    {
        [KappDelgate showAlertView:@"Message" with:@"Please select mood lavel"];
    }
    else if (lblstress.text.length==0)
    {
        [KappDelgate showAlertView:@"Message" with:@"Please select stress lavel"];
    }
    else if (lblHowLong.text.length==0)
    {
        [KappDelgate showAlertView:@"Message" with:@"Please select how long did you sleep lavel"];
    }
    else if (lblAntrieb.text.length==0)
    {
        [KappDelgate showAlertView:@"Message" with:@"Please select antrieb lavel"];
    }
    else if (lblBodyWeight.text.length==0)
    {
        [KappDelgate showAlertView:@"Message" with:@"Please select body weight lavel"];
    }
    else{
        
        database = [FMDatabase databaseWithPath:path];
        [database open];
        [database executeUpdate:@"create table questionTbl(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,user_id text,description text,date text,mood text,stress text,howLong text,antrieb text,bodyWeight text)"];
        
        
        
        NSString *sql = [NSString stringWithFormat:@"SELECT date FROM questionTbl WHERE date ='%@'",[[NSUserDefaults standardUserDefaults] valueForKey:@"selectDate"]];
        
        FMResultSet *results = [database executeQuery:sql];
        if ([results next])
        {
            [KappDelgate showAlertView:@"Message" with:@"your question is allready added"];
            [results close];
        }
        else
        {
            NSString *query = [NSString stringWithFormat:@"insert into questionTbl(user_id,description,date,mood,stress,howLong,antrieb,bodyWeight) values ('%@','%@','%@','%@','%@','%@','%@','%@')",
                               userId,txt_description.text,[[NSUserDefaults standardUserDefaults] valueForKey:@"selectDate"],lblMood.text,lblstress.text,lblHowLong.text,lblAntrieb.text,lblBodyWeight.text];
            [database executeUpdate:query];
            
            NSString *sql = [NSString stringWithFormat:@"SELECT * FROM questionTbl where user_id='%@' and date='%@'",userId,selectDate];
            FMResultSet *results = [database executeQuery:sql];
            
            while ([results next])
            {
                
            }
            [database close];
            [results close];
            
        }

    }
    

}

- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
