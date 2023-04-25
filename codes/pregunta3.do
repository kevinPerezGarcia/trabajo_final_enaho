*** Variables adicionales
	
	*** Área
		codebook estrato
		
		recode estrato (1/5 = 1 "Urbano") (6/8 = 2 "Rural"), gen(area)
		lab var area "Área de residencia: urbano 1, rural 2"
		
	*** Departamento
		codebook ubigeo
		
		gen dpto = real(substr(ubigeo,1,2))
		lab var dpto "Departamento"
		
		#delimit ;
		label define dpto
			1 "Amazonas"
			2 "Ancash"
			3 "Apurimac"
			4 "Arequipa"
			5 "Ayacucho"
			6 "Cajamarca"
			7 "Callao"
			8 "Cusco"
			9 "Huancavelica"
			10 "Huanuco"
			11 "Ica"
			12 "Junin"
			13 "La_Libertad"
			14 "Lambayeque"
			15 "Lima"
			16 "Loreto"
			17 "Madre_de_Dios"
			18 "Moquegua"
			19 "Pasco"
			20 "Piura"
			21 "Puno"
			22 "San_Martin"
			23 "Tacna"
			24 "Tumbes"
			25 "Ucayali"
			26 "Lima Provincias"
		;
		#delimit cr
		lab val dpto dpto
		
	*** Global
		global var_adi area dpto
		
*** Análisis estadístico

	svyset [pweight = facpob07], psu(conglome) strata(estrato)
	
	foreach x of varlist $var_ana {
		
		foreach y of varlist $var_adi {
			
			display in red "`x' según `y' - Media o proporción, desviación estándar, intérvalo de confianza"
			svy: mean `x', over(`y')
			
			display in red "`x' según `y' - Coeficiente de variación"
			estat cv
		}
	}