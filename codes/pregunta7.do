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
				
			*** Cálculos
				display in red "`x' según área"
				
					display in red "Media o proporción, desviación estándar, intérvalo de confianza"
					
						svy: mean `x', cformat(%9.3fc) over(area)
						
							matrix b	= r(table)'
							matrix aux1	= b[.,"b".."se"], b[.,"ll".."ul"]
							matrix rownames aux1 = "Urbano" "Rural"
							
					display in red "Coeficiente de variación"
					
						estat cv
						
							matrix b	= r(cv)'
							matrix aux2	= b[.,"r1"]
					
				display in red "`x' según departamento"
				
					display in red "Media o proporción, desviación estándar, intérvalo de confianza"
					
						svy: mean `x', cformat(%9.3fc) over(dpto)
						
							matrix b	= r(table)'
							matrix aux3	= b[., "b".."se"], b[., "ll".."ul"]
							matrix rownames aux3 =	"Amazonas"		///
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
						
					display in red "Coeficiente de variación"
					
						estat cv
						
							matrix b	= r(cv)'
							matrix aux4	= b[., "r1"]
						
				matrix aux = [aux1, aux2] \ [aux3, aux4]
				putexcel A2 = matrix(aux), rownames
		}