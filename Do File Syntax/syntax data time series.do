/*******************************************************************************
							Data Visualization with Stata
							by Pangudi Jatirahardi
								Sekolah STATA
*******************************************************************************/
global input "D:\Kelas Visualisasi Data dengan Stata\data-mentah-time-series"
global hasil "D:\Kelas Visualisasi Data dengan Stata\"
*Import - Eksport Data

//1. Membuat dataset BTC-USD
import delimited "$input\BTC-USD.csv", varnames(1) clear 

replace close = "" if close == "null"
destring close, replace
ren close bitcoin

keep date bitcoin
replace bitcoin = 7096.18 if date == "2020-04-17"
replace bitcoin = 11064.46 if date == "2020-10-09"
replace bitcoin = 11555.36 if date == "2020-10-12"
replace bitcoin = 11425.90 if date == "2020-10-13"

split date, p(-)
destring date1 date2 date3, replace
gen edate = mdy(date2, date3, date1)
format edate %dM_d,_CY

tsset edate

keep bitcoin edate

tempfile bitcoin
save `bitcoin'

//2. Membuat dataset USDT-USD
import delimited "$input\USDT-USD.csv", varnames(1) clear 

replace close = "" if close == "null"
destring close, replace
ren close usdt

keep date usdt
br if usdt ==.
replace usdt = 1 if date == "2020-04-17"
replace usdt = 1 if date == "2020-10-09"
replace usdt = 1 if date == "2020-10-12"
replace usdt = 1 if date == "2020-10-13"

split date, p(-)
destring date1 date2 date3, replace
gen edate = mdy(date2, date3, date1)
format edate %dM_d,_CY

tsset edate

keep usdt edate

tempfile usdt
save `usdt'

//3. Membuat dataset BNB-USD
import delimited "$input\BNB-USD.csv", varnames(1) clear 

replace close = "" if close == "null"
destring close, replace
ren close bnb

keep date bnb
br if bnb ==.
replace bnb = 15.74 if date == "2020-04-17"
replace bnb = 28.45 if date == "2020-10-09"
replace bnb = 30.71 if date == "2020-10-12"
replace bnb = 30.71 if date == "2020-10-13"

split date, p(-)
destring date1 date2 date3, replace
gen edate = mdy(date2, date3, date1)
format edate %dM_d,_CY

tsset edate

keep bnb edate

tempfile bnb
save `bnb'

//4. Membuat dataset ETH-USD
import delimited "$input\ETH-USD.csv", varnames(1) clear 

replace close = "" if close == "null"
destring close, replace
ren close eth

keep date eth
br if eth ==.
replace eth = 171.64 if date == "2020-04-17"
replace eth = 365.59 if date == "2020-10-09"
replace eth = 387.73 if date == "2020-10-12"
replace eth = 381.19 if date == "2020-10-13"

split date, p(-)
destring date1 date2 date3, replace
gen edate = mdy(date2, date3, date1)
format edate %dM_d,_CY

tsset edate

keep eth edate

tempfile eth
save `eth'


//5. Membuat dataset GBP-USD
import delimited "$input\GBPUSD=X", varnames(1) clear 

replace close = "" if close == "null"
destring close, replace
ren close gbp

keep date gbp
br if gbp ==.
egen med_gbp = median(gbp)
replace gbp = med_gbp if gbp == .

split date, p(-)
destring date1 date2 date3, replace
gen edate = mdy(date2, date3, date1)
format edate %dM_d,_CY

tsset edate

keep gbp edate

tempfile gbp
save `gbp'


//5. Menggabungkan dataset
use `bitcoin', clear
merge 1:1 edate using `usdt'
keep if _merge == 3
drop _merge

merge 1:1 edate using `bnb'
keep if _merge == 3
drop _merge

merge 1:1 edate using `eth'
keep if _merge == 3
drop _merge

merge 1:1 edate using `gbp'
drop if _merge == 2
egen med_gbp = median(gbp)
replace gbp = med_gbp if gbp == .

drop _merge med_gbp
order edate

*Membuat variabel Return
sort edate
foreach i in bitcoin usdt bnb eth gbp {
gen r_`i' = (`i'- l.`i')/l.`i'
}


save "$hasil\data-time-series", replace

/*******************************************************************************
Visualisasi Data
*******************************************************************************/
use "$hasil\data-time-series", clear
label variable bitcoin "Bitcoin"
label variable usdt "Usdt"
label variable bnb "Bnb"
label variable eth "Eth"

tsset edate

//1. Summary Statistics
sum r_*, detail
sum r_*
asdoc sum r_*, detail  save($hasil\summary_stats.doc) replace

//2. Pearson Correlation
pwcorr  r_*, star(.05)
asdoc pwcorr  r_*, star(.05) save($hasil\pearson_correlation.doc) replace

//4. Heatmap-colored-correlation
*ssc install corrtable
corrtable r_*, half flag1(r(rho) > 0) howflag1(plotregion(color(blue * 0.1))) flag2(r(rho) < 0) howflag2(plotregion(color(red*0.1))) 

//5. Graph One Side
line r_* edate, legend(size(medsmall))

//6. Graph two side
twoway (tsline r_eth) (tsline r_bnb)
scatter bitcoin edate
twoway (tsline r_bitcoin) (tsline r_bnb)
twoway (tsline eth, recast(area)) (tsline bnb, yaxis(2))
