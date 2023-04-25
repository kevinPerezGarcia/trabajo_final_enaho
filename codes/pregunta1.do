***	Cargando base de datos
	use "${rawdata}\enaho01-2021-100.dta", clear
	
*** Filtrando observaciones
	keep if (result == 1  | result == 2)
	
*** Combinando bases de datos
	merge 1:m conglome vivienda hogar using "${rawdata}\enaho01-2021-200.dta", keep(3) nogenerate
	merge m:1 conglome vivienda hogar using "${rawdata}\sumaria-2021.dta", keep(3) nogenerate