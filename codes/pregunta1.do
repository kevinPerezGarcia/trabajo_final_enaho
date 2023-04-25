***	Cargando base de datos
	use "${rawdata}\enaho01-2021-100.dta", clear
	
*** Combinando bases de datos
	merge 1:m conglome vivienda hogar using "${rawdata}\enaho01-2021-200.dta", keep(3) nogenerate
	
	merge m:1 conglome vivienda hogar using "${rawdata}\sumaria-2021.dta", keep(3) nogenerate
	
*** Filtrando observaciones

	*** Resultados completos e incompletos
		keep if (result == 1  | result == 2)	// De acuerdo con el módulo 100
		
	*** Residentes habituales
		codebook	p204 /// miembro del hogarp
					p205 /// ausente del hogar mayor o igual a 30 días
					p206 //  presente en el hogar mayor o igual a 30 días
					
		gen		residenteHabitual = ( (p204 == 1 & p205 == 2) | (p204 == 2 & p206 == 1) )
		lab var residenteHabitual "Residente habitual"
		lab def residenteHabitual 1 "Residente habitual" 0 "Residente no habitual"
		lab val residenteHabitual residenteHabitual
		
		keep if (residenteHabitual == 1)