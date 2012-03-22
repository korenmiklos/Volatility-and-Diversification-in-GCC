clear
set more off

insheet using ../data/un/un2009.csv


drop gdptotl
/* that is not a sector */

reshape long gdp, i(country year) j(sector) string
egen total = sum(gdp), by(country year)
gen share = gdp/total
drop total

sort country year sector

egen group = group(country sector)
tsset group year

gen pqgrowth = log(gdp)-log(L.gdp)

gen byte treatment = (country=="Bahrain"|country=="Qatar"|country=="Kuwait"|country=="United Arab Emirates"|country=="Oman"|country=="Saudi Arabia")
gen byte control = (country=="Algeria"|country=="Colombia"|country=="Nigeria"|country=="Norway"|country=="Canada"|country=="Indonesia"|country=="Netherlands")

label var gdp "Sectoral value added in current USD"
label var share "Sectoral share in GDP"
label var pqgrowth "Nominal value added growth change"

sort country year sector
saveold ../data/treatmentcontrol, replace

* area chart of sectoral shares 
preserve
gen broad = 1 if sector=="ming"
replace broad =0 if sector=="agri"
replace broad =2 if sector=="manu"
replace broad = 3 if missing(broad) 

collapse (sum) share, by(country year broad)
reshape wide share, i(country year) j(broad) 

label var share0 "Agriculture"
label var share1 "Mining"
label var share2 "Manufacturing"
label var share3 "Services"

* cumulate shares for the area graph
replace share1 = share0+share1
replace share2 = share1+share2
replace share3 = share2+share3

foreach cnt of any "Bahrain" "Qatar" "Kuwait" "United Arab Emirates" "Oman" "Saudi Arabia" {
	tw area share3 share2 share1 share0 year if country=="`cnt'", sort yscale(range(0 1)) ytitle("Share in GDP") title("`cnt'")
	graph export "../figures/`cnt'.png", width(800) replace
}

restore

gen decade = int(year/10)*10
*drop if year<1980


/* do the variance decomposition */
capture prog drop voldecomp
voldecomp, shock(pqgrowth) share(share) sector(sector) country(country treatment control decade) time(year)
saveold ../data/decomposition, replace
outsheet using ../data/decomposition.csv, comma replace

gen cnt_cov = cnt+cov
label var cnt_cov "Country risk (incl. covariance)"

* cumulate components for the area charts
replace idio = gsect+idio
replace cnt = cnt+idio

foreach cnt of any "Bahrain" "Qatar" "Kuwait" "United Arab Emirates" "Oman" "Saudi Arabia" {
	tw area cnt idio gsect year if country=="`cnt'", sort ytitle("Variance components") title("`cnt'") yscale(range(0))
	graph export "../figures/Decomp`cnt'.png", width(800) replace
}

local year 2000
foreach X of var gsect idio cnt cnt_cov {
	local Y : variable label `X'
	tw (scatter `X' herf if year==`year' & control, mlabel(country)) ///
	 (scatter `X' herf if year==`year' & treatment, mlabel(country)) ///
	 (lfit `X' herf if year==`year' ) ///
		, ytitle(`Y' in `year') legend(order(1 "Control group" 2 "Gulf countries" 3 "Fitted line"))
	graph export ../figures/`X'_control.png, width(800) replace
}
