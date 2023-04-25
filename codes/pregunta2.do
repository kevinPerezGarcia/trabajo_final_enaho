*** Ingreso per cápita
	codebook inghog1d
	codebook mieperho
	
	gen ingreso_pc = (inghog1d / mieperho) / 12
	lab var ingreso_pc "Ingreso per cápita mensual"

*** Pobre
	codebook pobreza
	
	recode pobreza (1/2 = 1 "Pobre") (3 = 0 "No pobre"), gen(pobre)
	lab var pobre "Pobreza monetaria (dos categorías)"
	
*** Mujer
	codebook p207
	
	recode p207 (2 = 1 "Mujer") (1 = 0 "Hombre"), gen(mujer)
	lab var mujer "Mujer 1, Hombre 0"
	
*** Edad
	codebook p208a
	
	rename p208a edad
	lab var edad "Edad de la persona en años"
	
*** Global
	global var_ana ingreso_pc pobre mujer edad