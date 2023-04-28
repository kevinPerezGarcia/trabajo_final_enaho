*** Cargando base de datos
	use "${datas}\Peru2021.dta", clear

*** Construyendo indicador de dependencia económica
	codebook p208a
	rename p208a edad
	
	gen dependiente		= (edad <  14 | edad >  65)
	gen independiente	= (edad >= 14 & edad <= 65)
	
	bys conglome vivienda hogar: egen n_dependientes	= sum(dependiente)
	bys conglome vivienda hogar: egen n_independientes	= sum(independiente)
	
	gen		Depen_ratio = n_dependientes / n_independientes
	lab var Depen_ratio "Tasa de dependencia (en tanto por uno)"