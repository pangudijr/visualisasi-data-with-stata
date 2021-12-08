use "D:\Kelas Visualisasi Data dengan Stata\data_ifls-2014", clear
*Graph Bar
la val married_under18 married_under18
la def married_under18 1 "1: Married Under 18" 0 "0: Married Above 18"
graph bar educyr if obs_age13_23 == 1 & married == 1, over(married_under18) label

tab fe_residence married_under18, col

graph bar (count)
graph bar (mean)
graph bar (median)
graph dot (mean) age_at_marriage, over(fe_province)

*Average YOS dan first marriage (Mengagregasikan ke level kab kota)
collapse (mean) educyr age_at_marriage if obs_age13_23 == 1 & married == 1, by(fe_province)
	la val fe_province fe_province
	lab def fe_province 11 "ACEH" 12 "SUMATERA UTARA" 13 "SUMATERA BARAT" 14 "RIAU" 15 "JAMBI" 16 "SUMATERA SELATAN" 17 "BENGKULU" 18 "LAMPUNG" 19 "KEPULAUAN BANGKA BELITUNG" 21 "KEPULAUAN RIAU" 31 "DKI JAKARTA" 32 "JAWA BARAT" 33 "JAWA TENGAH" 34 "DI YOGYAKARTA" 35 "JAWA TIMUR"  36 "BANTEN" 51 "BALI" 52 "NUSA TENGGARA BARAT" 53 "NUSA TENGGARA TIMUR" 61 "KALIMANTAN BARAT" 62 "KALIMANTAN TENGAH" 63 "KALIMANTAN SELATAN"  64 "KALIMANTAN TIMUR" 71 "SULAWESI UTARA" 73 "SULAWESI SELATAN" 74 "SULAWESI TENGGARA" 75 "GORONTALO" 76 "SULAWESI BARAT" 81 "MALUKU" 82 "MALUKU UTARA" 94 "PAPUA" 91 "PAPUA BARAT" 72 "SULAWESI TENGAH" 65 "KALIMANTAN UTARA"

scatter educyr age_at_marriage || lfit educyr age_at_marriage , mlabel(fe_province)
scatter educyr age_at_marriage, mlabel(fe_province)
graph twoway (lfit educyr age_at_marriage) (scatter educyr age_at_marriage, mlabel(fe_province))

