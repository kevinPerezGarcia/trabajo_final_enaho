clear all
set more off
	
global codes	"Coloque la dirección de su carpeta\codes"
global datas	"Coloque la dirección de su carpeta\datas"
global tables	"Coloque la dirección de su carpeta\tables"

cd "$datas"
									
***
*** Pregunta 1
***	

use "${datas}\enaho01-2021-100.dta", clear

merge 1:m conglome vivienda hogar using "${datas}\enaho01-2021-200.dta", keep(3) nogenerate

merge m:1 conglome vivienda hogar using "${datas}\sumaria-2021.dta", keep(3) nogenerate

keep if (result == 1  | result == 2)
	
keep if (p204 == 1)
	
save "${datas}\Peru2021.dta", replace
	
***
*** Pregunta 2
***

gen ingreso_pc = (inghog1d / mieperho) / 12
lab var ingreso_pc "Ingreso per cápita mensual"

recode pobreza (1/2 = 1 "Pobre") (3 = 0 "No pobre"), gen(pobre)
lab var pobre "Pobreza monetaria (dos categorías)"

recode p207 (2 = 1 "Mujer") (1 = 0 "Hombre"), gen(mujer)
lab var mujer "Mujer 1, Hombre 0"

rename p208a edad
lab var edad "Edad de la persona en años"

global ana_var ingreso_pc pobre mujer edad
	
***
*** Pregunta 3
***
	
recode estrato (1/5 = 1 "Urbano") (6/8 = 2 "Rural"), gen(area)
lab var area "Área de residencia: urbano 1, rural 2"

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

global var_adi area dpto

svyset [pweight = facpob07], psu(conglome) strata(estrato)

putexcel set "${tables}\anexo.xlsx", replace

foreach x of varlist $ana_var {
	
	putexcel set "${tables}\anexo.xlsx", modify sheet("preg3-`x'", replace)
	
		putexcel A1:F1	, font(calibri, 11, black) bold vcenter hcenter txtwrap
		putexcel A1:F28	, border(all)
	
		putexcel A1 = "Categoría"
		putexcel B1 = "Media o Proporción"
		putexcel C1 = "Error Estándar"
		putexcel D1 = "Intervalo Inferior"
		putexcel E1 = "Intervalo Superior"
		putexcel F1 = "Coeficiente de Variación"

			display in red "`x' según área - Media o proporción, desviación estándar, intérvalo de confianza"
			svy: mean `x', cformat(%9.3fc) over(area)
			
				matrix b	= r(table)'
				matrix aux1	= b[.,"b".."se"], b[.,"ll".."ul"]
				matrix rownames aux1 = "Urbano" "Rural"
			
			display in red "`x' según área - Coeficiente de variación"
			estat cv
			
				matrix b	= r(cv)'
				matrix aux2	= b[.,"r1"]
				
			display in red "`x' según departamento - Media o proporción, desviación estándar, intérvalo de confianza"
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
		
			display in red "`x' según departamento - Coeficiente de variación"
			estat cv
			
				matrix b	= r(cv)'
				matrix aux4	= b[., "r1"]
				
		matrix aux = [aux1, aux2] \ [aux3, aux4]
		putexcel A2 = matrix(aux), rownames
}
		
***
*** Pregunta 4
***

putexcel set "${tables}\anexo.xlsx", modify sheet("preg4-dif_sig")

putexcel A1:G1, font(calibri, 11, black) bold vcenter hcenter
putexcel A1:G5, border(all)

putexcel A1 = "Preg."											, txtwrap
putexcel B1 = "Diferencia del indicador"						, txtwrap
putexcel C1 = "Error Estándar"									, txtwrap
putexcel D1 = "p-valor"											, txtwrap
putexcel E1 = "Intervalo Inferior"								, txtwrap
putexcel F1 = "Intervalo Superior"								, txtwrap
putexcel G1 = "¿La diferencia es significativa al 5% de error?"	, txtwrap

putexcel A2 = "1"
putexcel A3 = "2"
putexcel A4 = "3"
putexcel A5 = "4"


svy: mean edad, over(mujer)
lincom edad@0.mujer - edad@1.mujer

putexcel B2 = "`r(estimate)'"
putexcel C2 = "`r(se)'"
putexcel D2 = "`r(p)'"
putexcel E2 = "`r(lb)'"
putexcel F2 = "`r(ub)'"
if (r(p) <= 0.05) putexcel G2 = "Sí"
	else putexcel G2 = "No"
	
svy: mean ingreso_pc, over(mujer)
lincom ingreso_pc@0.mujer - ingreso_pc@1.mujer

putexcel B3 = "`r(estimate)'"
putexcel C3 = "`r(se)'"
putexcel D3 = "`r(p)'"
putexcel E3 = "`r(lb)'"
putexcel F3 = "`r(ub)'"
if (r(p) <= 0.05) putexcel G3 = "Sí"
	else putexcel G3 = "No"

svy: mean ingreso_pc, over(pobre)
lincom ingreso_pc@1.pobre - ingreso_pc@0.pobre

putexcel B4 = "`r(estimate)'"
putexcel C4 = "`r(se)'"
putexcel D4 = "`r(p)'"
putexcel E4 = "`r(lb)'"
putexcel F4 = "`r(ub)'"
if (r(p) <= 0.05) putexcel G4 = "Sí"
	else putexcel G4 = "No"
	
svy: mean ingreso_pc, over(dpto)
lincom ingreso_pc@16.dpto - ingreso_pc@25.dpto

putexcel B5 = "`r(estimate)'"
putexcel C5 = "`r(se)'"
putexcel D5 = "`r(p)'"
putexcel E5 = "`r(lb)'"
putexcel F5 = "`r(ub)'"
if (r(p) <= 0.05) putexcel G5 = "Sí"
	else putexcel G5 = "No"

***	
*** Pregunta 5
***

use "${datas}\Peru2021.dta", clear

rename p208a edad

gen dependiente		= (edad <  14 | edad >  65)
gen independiente	= (edad >= 14 & edad <= 65)

bys conglome vivienda hogar: egen n_dependientes	= sum(dependiente)
bys conglome vivienda hogar: egen n_independientes	= sum(independiente)

gen		Depen_ratio = n_dependientes / n_independientes
lab var Depen_ratio "Tasa de dependencia (en tanto por uno)"
	
***
*** Pregunta 6
***

duplicates drop conglome vivienda hogar, force

save "${datas}\hogares2021.dta", replace

recode p110 (1/3 = 1 "Hogar con agua")	///
			(4/8 = 0 "Hogar sin agua"), gen(agua)
			
recode p111a	(1/2 = 1 "Hogar con saneamiento")	///
				(3/9 = 0 "Hogar sin saneamiento"), gen(alcan)

recode p1121	(1 = 1 "Hogar con electricidad")	///
				(0 = 0 "Hogar sin electricidad"), gen(elec)

gen		tiene_3serv = (agua == 1 & alcan == 1 & elec == 1)
lab var tiene_3serv "Hogar con acceso a los servicios de agua, saneamiento y electricidad"
lab def tiene_3serv 1 "Hogar con acceso a tres servicios" 0 "Hogar sin acceso a tres servicios"
lab val tiene_3serv tiene_3serv

global ana_var Depen_ratio agua alcan elec tiene_3serv
		
***
*** Pregunta 7
***

recode estrato (1/5 = 1 "Urbano") (6/8 = 2 "Rural"), gen(area)
lab var area "Área de residencia: urbano 1, rural 2"

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

global var_adi area dpto

svyset [pweight = facpob07], psu(conglome) strata(estrato)

putexcel set "${tables}\anexo.xlsx", replace

foreach x of varlist $ana_var {
	
	putexcel set "${tables}\anexo.xlsx", modify sheet("preg7-`x'", replace)
	
		putexcel A1:F1	, font(calibri, 11, black) bold vcenter hcenter txtwrap
		putexcel A1:F28	, border(all)
	
		putexcel A1 = "Categoría"
		putexcel B1 = "Media o Proporción"
		putexcel C1 = "Error Estándar"
		putexcel D1 = "Intervalo Inferior"
		putexcel E1 = "Intervalo Superior"
		putexcel F1 = "Coeficiente de Variación"
		
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