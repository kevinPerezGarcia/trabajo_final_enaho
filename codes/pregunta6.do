*** Eliminando duplicados a nivel de hogar
	duplicates drop conglome vivienda hogar, force
	
*** Guardando base de datos
	save "${datas}\hogares2021.dta", replace
	
*** Construyendo indicadores

	*** Agua
		codebook p110
		
		recode p110 (1/3 = 1 "Hogar con agua")	///
					(4/8 = 0 "Hogar sin agua"), gen(agua)
					
	*** Saneamiento
		codebook p111a
		
		recode p111a	(1/2 = 1 "Hogar con saneamiento")	///
						(3/9 = 0 "Hogar sin saneamiento"), gen(alcan)
		
	*** Electricidad
		codebook p1121
		
		recode p1121	(1 = 1 "Hogar con electricidad")	///
						(0 = 0 "Hogar sin electricidad"), gen(elec)
		
	*** Agua, saneamiento y electricidad simultáneamente
		gen		tiene_3serv = (agua == 1 & alcan == 1 & elec == 1)
		lab var tiene_3serv "Hogar con acceso a los servicios de agua, saneamiento y electricidad"
		lab def tiene_3serv 1 "Hogar con acceso a tres servicios" 0 "Hogar sin acceso a tres servicios"
		lab val tiene_3serv tiene_3serv