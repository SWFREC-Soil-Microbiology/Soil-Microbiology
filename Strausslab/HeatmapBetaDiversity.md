# Heat map walkthrough
Files needed:<br>
•	taxonomy.tsv<br>
•	feature-table.tsv

1.	The first step is to get taxonomy information into the feature table
2.	Open both taxonomy and feature table tsv files
3.	Files might not have the same number of rows and these extra rows will need to be removed in order to match up the correct Feature IDs and taxonomy columns<br>
a.	Sort each file by FeatureID<br>
b.	Copy FeatureID column from taxonomy.tsv into a new column in feature-table.tsv<br>
c.	Select both FeatureID columns and select Conditional Formatting > Highlight Cell Rules > Duplicate Values<br>
d.	Remove any cells that are not selected as duplicates from a copy of the taxonomy file, so rows are not removed from original taxonomy file<br>
4.	Verify both taxonomy and feature table files are in the same order
5.	Copy the Taxon column from the taxonomy file into a column in the feature table file
6.	Insert enough columns to the right of the Taxon column so there are enough empty columns for each taxon
7.	Select the Taxon column > Data > Text to Columns > Delimited > check ‘Semicolon” > Finish
8.	Copy all columns excluding the feature id column into a new excel file<br>
a.	This new sheet is the number of sequences per OTUs – name sheet as # sequences per OTU
9.	Scroll to the bottom of the sheet and make a new calculated row<br>
a.	For each sample, calculate the sum of all OTUs
10.	Add a new sheet in the excel file and name it “Relativ. Abund”<br>
a.	Copy the taxonomy information and the sample names into the new sheet<br>
b.	This new sheet will calculate the relative abundance of each OTU
11.	In the first cell for the first sample/taxon use this calculation and modify as necessary<br>
a.	=('# sequences per OTU'!H2/'# sequences per OTU'!$H$23055)*100 <br>
b.	Where H2 is the corresponding cell in the sequences per OTU sheet and $H$23055 is the cell with the total OTUs for that sample
12.	Extend that calculated column for the rest of the cells in that column
13.	Use the same formula for each sample, changing cell location in the formula as necessary 
14.	Create a new sheet called “OTUs by [variable]” to calculate average OTUs by whatever variable you want to compare<br>
a.	Copy the same taxonomy columns into the new sheet<br>
b.	Rather than listing each individual sample, create new column names based on variable groups<br>
c.	Ex: treatment1-timepoint1, treatment1-timepoint2
15.	In the first cell for the first treatment, calculate the average relative abundance for each OUT using the corresponding samples from the “Relativ. Abund” sheet<br>
a.	=AVERAGE(‘Relativ. Abund'!AY2,'Relativ. Abund !AP2,'Relativ. Abund’!BE2,'Relativ. Abund'!BJ2)<br>
b.	Where AY2, AP2, BE2, and BJ2 are replicates of the same treatment/timepoint/etc.<br>
c.	Color coordinating samples by treatment and time point is helpful for this step
16.	Extend that calculated column for the rest of the cells in that column
17.	Use the same formula for each group of samples, changing cell location in the formula as necessary 
18.	Highlight all cells with data > Conditional Formatting > Highlight Cell Rules > Less Than 1
19.	Delete any Rows with zero cells above 1 so all taxa left have at least one column above 1 to show only dominant taxa
20.	Make a new sheet named “>[X]% relative abundance” for the relative abundance you are interested in looking at
21.	Copy everything from the “Relativ. Abund” sheet and paste values into “>[X]% relative abundance”
22.	Select all cells with relative abundance values, Conditional Formatting > Highlight Cell Rules > Less Than > enter relative abundance value 
23.	Delete rows where no columns have a cell over the entered relative abundance 
24.	To remove the highlighting, select all cells with numbers, Conditional Formatting > Manage Rules > Delete rule
25.	Select all cells with numbers again, Conditional Formatting > Color Scales > More Rules > Format Style > 3-Color Scale. Select “Number” for Minimum, Midpoint, and Maximum type. Choose colors to create a gradient. Hit “OK”
26.	Create a key for the colors and the relative abundance they represent 
27.	To hide numbers from cells, select cell, right click > Format Cells > Number > Custom > ;;
28.	Format heat map as desired (adding borders, merge duplicate taxon cells, etc.)


## Morisita and Symmetric Diversity 
1.	Morisita-Horn index for Dominant taxa; Symmetric index for Rare taxa
2.	In a new excel file, copy and paste the information in the combined feature table and taxonomy file created from steps 1-5 in the heat map walkthrough
3.	Name that sheet “Raw_data”
4.	Create a new sheet called “Average”
5.	Calculate the average number of each OTU using the same method as steps 12-15<br>
a.	=AVERAGE(Raw_data!AY2,Raw_data!AP2,Raw_data!BE2,Raw_data!BJ2)<br>
b.	Where AY2, AP2, BE2, and BJ2 are replicates of the same treatment/timepoint/etc.
6.	In a column before the first variable, number each cell starting with 1 at the first OUT through the rest of the rows
7.	Copy the columns including the numbers, variable names, and average OTUs and past values on the same sheet
8.	Each column will eventually be transposed into a row, and Excel can only have 16,384 columns, so in the newly pasted data, remove any data that would exceed that limit<br>
a.	Ex: if there are 20,000 rows, delete data in rows 16,385-20,000
9.	Make a new sheet and name it “[FirstVariable]_[SecondVariable]”<br>
a.	Ex: if you want to compare treatments to the control, it would be “Control_Treatment1
10.	In the new sheet, copy the data in the column with the OUT number and transpose it in the first row of the sheet (you can’t select the entire column or it won’t transpose because the copy area and paste area are not the same size)
11.	Copy the column with the average number for each OTUs for the first variable you want to look at and transpose it in the new sheet underneath the OTU number <br>
a.	Do not copy the variable name, this is why it is important to name the sheet with the variables
12.	Repeat step 10 but for the second variable and transpose it in the row beneath the first variable
13.	The final layout should be: <br>
a.	Row 1: #OTU<br>
b.	Row 2: Sample 1<br>
c.	Row 3: Sample 2<br>
14.	Copy this new sheet into a new Excel file and name the new file as “mydata”
15.	Open R (not RStudio) version 3.6.2<br>
a.	Install and load packages apple, vegan, vegetarian, and Rcmdr
16.	Once R Commander opens in a new window, paste this code in the R Script box:<br>
`morisita<-M.homog(mydata, q=2, std=FALSE)`<br>
`mean(morisita)`<br>
`simmetric<-betadiver(mydata, method=22)`<br>
`mean(simmetric)`
17.	Data > Import Data > from Excel file<br>
a.	Name of dataset: mydata<br>
b.	OK > select the mydata file created in step 12 > OPEN
18.	Select the code entered in step 14 > Submit
19.	Results are in the output box<br>
a.	Results range from 0 to 1
20.	How to interpret the results (species turnover):<br>
a.	Values close to 1: Changes in dominant or rare taxa<br>
b.	Values close to 0: no changes in dominant or rare taxa
21.	Copy and paste results into a new sheet of the Raw_data excel file and organize by index and variables compared
22.	Repeat steps 9-21 for each pair of variables you would like to compare
23.	To make a heat map of results, follow step 21 in the heat map walkthrough
24.	Further reading: Barwell LJ, Isaac NJB, Kunin WE (2015) Measuring ß-diversity with species abundance data. J Animal Ecol 84:1112–1122. doi:10.1111/1365-2656.12362
