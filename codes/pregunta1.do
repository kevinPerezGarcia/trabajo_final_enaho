***	Cargando base de datos
	use "${rawdata}\enaho01-2021-100.dta", clear
	
*** Combinando bases de datos
	merge 1:m conglome vivienda hogar using "${rawdata}\enaho01-2021-200.dta", keep(3) nogenerate
	
	merge m:1 conglome vivienda hogar using "${rawdata}\sumaria-2021.dta", keep(3) nogenerate
	
*** Filtrando observaciones

	*** Resultados completos e incompletos
		keep if (result == 1  | result == 2)	// De acuerdo con el módulo 100
		
	*** Miembros del hogar
		codebook	p204 // miembro del hogar
		
		keep if (p204 == 1)
		
*** Guardando base de datos
	save "${datas}\Peru2021.dta", replace