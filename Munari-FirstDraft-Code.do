//FOR ANYTHING THAT DEALS WITH AGE OF FIRST SEX YOU'LL HAVE TO USE THE "TRANSFORMED" DATA FILE INSTEAD OF THE 2019-2021
 
///Summary Stats
//run this for both datasets
summarize


//Graph of average total children born grouped by total years of education Figure 1
collapse (mean) avgChildren = totChildBorn, by(totYearsEdu)
scatter avgChildren totYearsEdu, title("Average Children Born by Education Years")
////Graph of average age of first sex grouped by total years of education Figure 1
collapse (mean) avgYearofFirstSex = ageFirSex, by(totYearsEdu)
scatter avgYearofFirstSex totYearsEdu, title("Average Year of First Sex by Education Years")
 
//Dummy Variable Creation

/// AgeCoh --- Because the dataset covers years 2019-2021 ill have to write three conditionals to account for those above the age of 14 in 2009 **The logic is if a respondent was below the age of 14 in 2021 then they're ageCoh value equals 1

gen ageCoh = 0
replace ageCoh = 1 if age< 24 & v007 == 2019
replace ageCoh = 1 if age< 25 & v007 == 2020
replace ageCoh = 1 if age< 26 & v007 == 2021
browse


/// HI -- I need to generate a variable that encodes to 1 if a individual's state had a educational expenditure as a % of GSDP higher than the national average AKA a High Intensity State and zero otherwise. So I'll create an array of all high intensity states and iterate through the state column tagging 1 for HI for states that are in that array

gen HI = 0 
tab v024
//Using this report :	Government of India, (Department of Higher Education). Analysis of Budgeted Expenditure on Education 2018-2019 to 2020-2021, Ministry of Education, 2022. 


//
replace HI =1 if state==1
replace HI =1 if state==14
replace HI =1 if state==17
replace HI =1 if state==16
replace HI =1 if state==12
replace HI =1 if state==2
replace HI =1 if state==9
replace HI =1 if state==15
replace HI =1 if state==13
replace HI =1 if state==22
replace HI =1 if state==18



//Run the Regression //with renamed variables for cleaner output

//Specification 1
ivregress 2sls totalChildBorn (totalYearsEdu = ageCoh hi) i.ethnicity i.religion i.age 
ivregress 2sls ageFirSex (totalYearsEdu = ageCoh hi) i.ethnicity i.religion i.age 
reg totYearsEdu ageCoh HI age i.ethnicity i.religion