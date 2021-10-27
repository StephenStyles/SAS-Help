/* This file will hold all relevent code to generate bar charts. Most of the code on how to change
the visuals can be found on either: 
lexjansen.com/nesug.nesug07/ff/ff17.pdf (Charting the Basics with PROC GCHART)
lexjansen.com/nesug.nesug07/np/np16.pdf (Building a Better Bar Chart with SAS/Graph)
*/

/* A chart for some colors can be found at 
support.sas.com/content/dam/SAS/support/en/books/pro-template-made-easy-a-guide-for-sas-users/62007_Appendix.pdf */

/* How to graph dataset where you want to create multiple bars for each row */

data bar_example_1;
	length Province $25;
	infile datalines missover;
	input Province $ var1  var2  var3 ;
	datalines;
	BritishColumbia 25 40 5
	Alberta 14 55 10
	Saskatchewan 9 35 7
	;
run;

/* Now to create a chart that will graph all these values we need to create a transposed dataset where
we see three sequential rows for BC with all three variables followed by three Alberta rows then 
three Saskatchewan rows.
*/

data transpose;
	set bar_example_1;
	/* array colValues{*} then we list variables of interest */
	array colValues{*} var1 var2 var3;
	do i=1 to dim(colValues);
		xValue = vname(colValues{i});
		/* groupValue = Row id */
		groupValue = Province;
		value  = colValues{i};
		output;
	end;
	keep xValue groupValue value;
run;


/* Here we can create a color for each bar that repeats for each group ID,
that is if we have n varaibles we can have n colors */
pattern1 color=BIPB;
pattern2 color=VIGB;
pattern3 color=LIBG;
title1  "Bar Chart Example 1";

/* If we wish to force the order of hierarchical variables being charted we can add
the order = () line to the corresponding axis, however with this example that is not
the case and will be chart alphabetically */
axis1 label = ( f='Arial/Bold' 'Scale');
axis2 label = ( f='Arial/Bold' 'Variables');
axis3 label = ( f='Arial/Bold' 'Groups');

proc gchart data= transpose;
	/* Horizontal bar = hbar
	   Vertical bar = vbar */
	hbar xValue / group = groupValue sumvar = value
	/* Creates a color outline/border around the bar with a set width */
	coutline=red
	woutline=1
	/* The pattern which sas uses to rotate colors, can use (by, group, midpoint, subgroup) */
	patternID = midpoint
	/* Shows the value outside or inside the bar */
	outside=sum
	/* Width of bar
	width= */
	/* Space between bars in same group */
	space=0.1
	/* Space between groups
	gspace= */
	raxis = axis1 maxis=axis2 gaxis=axis3;
run;

