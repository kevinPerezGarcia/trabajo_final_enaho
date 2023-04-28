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
		;
		#delimit cr
		lab val dpto dpto
		
	*** Global
		global var_adi area dpto
		
*** Análisis estadístico

	*** Estableciendo el diseño muestral
		svyset [pweight = facpob07], psu(conglome) strata(estrato)
	
	*** Cargando archivo Excel
		putexcel set "${tables}\anexo.xlsx", replace
	
		foreach x of varlist $ana_var {
			
		*** Modificando archivo Excel
			putexcel set "${tables}\anexo.xlsx", modify sheet("preg7-`x'", replace)
			
			*** Nombre de columnas
				putexcel A1:F1	, font(calibri, 11, black) bold vcenter hcenter txtwrap
				putexcel A1:F28	, border(all)
			
				putexcel A1 = "Categoría"
				putexcel B1 = "Media o Proporción"
				putexcel C1 = "Error Estándar"
				putexcel D1 = "Intervalo Inferior"
				putexcel E1 = "Intervalo Superior"
				putexcel F1 = "Coeficiente de Variación"

			*** Media o proporción, y desviación estándar
			
				*** Según área
					display in red "`x' según área - Media o proporción, y desviación estándar"
					svy: mean `x', over(area)
					
					matrix b	= r(table)'
					matrix aux	= b[.,"b".."se"], b[.,"ll".."ul"]
					matrix rownames aux = "Urbano" "Rural"
					putexcel A2 = matrix(aux), rownames
				
				*** Según departamento
					display in red "`x' según departamento - Media o proporción, y desviación estándar"
					svy: mean `x', over(dpto)
					
					matrix b	= r(table)'
					matrix aux	= b[., "b".."se"], b[., "ll".."ul"]
					matrix rownames aux =	"Amazonas"		///
											"Ancash"		///
											"Apurimac"		///
											"Arequipa"		///
											"Ayacucho"		///
											"Cajamarca"		///
											"Callao"		///
											"Cusco"			///
											"Huancavelica"	///
											"Huanuco"		///
											"Ica"			///
											"Junin"			///
											"La_Libertad"	///
											"Lambayeque"	///
											"Lima"			///
											"Loreto"		///
											"Madre_de_Dios"	///
											"Moquegua"		///
											"Pasco"			///
											"Piura"			///
											"Puno"			///
											"San_Martin"	///
											"Tacna"			///
											"Tumbes"		///
											"Ucayali"
					putexcel A4 = matrix(aux), rownames
					
			*** Coeficiente de variación
			
				*** Según área
					display in red "`x' según área - Media o proporción, y desviación estándar"
					svy: mean `x', over(area)
					estat cv
					
					matrix b	= r(cv)'
					matrix aux	= b[.,"r1"]
					putexcel F2 = matrix(aux)
				
				*** Según departamento
					display in red "`x' según departamento - Media o proporción, y desviación estándar"
					svy: mean `x', over(dpto)
					estat cv
					
					matrix b	= r(cv)'
					matrix aux	= b[., "r1"]
					putexcel F4 = matrix(aux)
		}