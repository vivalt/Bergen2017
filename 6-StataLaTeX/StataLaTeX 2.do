// Alternative commands:
// estout can be used after a regression
// see e.g. http://repec.org/bocode/e/estout/esttab.html

// regression goes here

eststo r1
esttab r1 using esttaboutput.tex, cells(b(star fmt(3)) se(par fmt(2))) starlevels(* 0.10 ** 0.05 *** 0.01) r2(2) style(tex) replace label varlabels(_cons Constant) booktabs wrap title(Regression/label{table1}) eform

****************************************
* To refer to specific values, you can send the output to a file, 
* and then call that output in LaTeX
* Thanks to Henrique Romero for this.
****************************************
// Edited for different systems - may work better for you if you are missing the "\"s:

*(1)* Write a little Stata program to define a new LaTeX command
cap program drop latexnc
program define latexnc
*Spot is the string with the name
local spot1="`1'"
*Spot2 is the actual value stored in the scalar
local spot2=`1'
local latexnc1 "\\newcommand{\\\`spot1'}{`spot2'}"
! echo `latexnc1' >> `2' 
end 

*(2)* Use the program to send output to a file
* NB: You could also do this in one step since you can write directly to a file.
sysuse auto, clear
*Create empty tex file to store new commands
cap rm StataScalarList.tex
! touch StataScalarList.tex
* We want to mention the mean price in our paper 
sum price 
*Need to use full path to tex file because the stata working directory doesn't pass through the shell command 
scalar meanprice=r(mean)
latexnc meanprice "StataScalarList.tex"

// You can also do custom things with matrices, e.g.:

clear matrix
mat T=J(1,4,.)

ttest testvar, by(treatment)
mat T[1,1]=r(mu_1)
mat T[1,2]=r(mu_2)
mat T[1,3]=r(mu_1)-r(mu_2)
mat T[1,4]=r(p)

mat rownames T = testvar
