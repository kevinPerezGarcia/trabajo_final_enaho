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

display in red "`x' según área - Media o proporción, y desviación estándar"
svy: mean `x', over(area)

matrix b	= r(table)'
matrix aux	= b[.,"b".."se"], b[.,"ll".."ul"]
matrix rownames aux = "Urbano" "Rural"
putexcel A2 = matrix(aux), rownames

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

display in red "`x' según área - Media o proporción, y desviación estándar"
svy: mean `x', over(area)
estat cv

matrix b	= r(cv)'
matrix aux	= b[.,"r1"]
putexcel F2 = matrix(aux)

display in red "`x' según departamento - Media o proporción, y desviación estándar"
svy: mean `x', over(dpto)
estat cv

matrix b	= r(cv)'
matrix aux	= b[., "r1"]
putexcel F4 = matrix(aux)
}
		
***
*** Pregunta 4
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

display in red "`x' según área - Media o proporción, y desviación estándar"
svy: mean `x', over(area)

matrix b	= r(table)'
matrix aux	= b[.,"b".."se"], b[.,"ll".."ul"]
matrix rownames aux = "Urbano" "Rural"
putexcel A2 = matrix(aux), rownames

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

display in red "`x' según área - Media o proporción, y desviación estándar"
svy: mean `x', over(area)
estat cv

matrix b	= r(cv)'
matrix aux	= b[.,"r1"]
putexcel F2 = matrix(aux)

display in red "`x' según departamento - Media o proporción, y desviación estándar"
svy: mean `x', over(dpto)
estat cv

matrix b	= r(cv)'
matrix aux	= b[., "r1"]
putexcel F4 = matrix(aux)
}

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

display in red "`x' según área - Media o proporción, y desviación estándar"
svy: mean `x', over(area)

matrix b	= r(table)'
matrix aux	= b[.,"b".."se"], b[.,"ll".."ul"]
matrix rownames aux = "Urbano" "Rural"
putexcel A2 = matrix(aux), rownames

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

display in red "`x' según área - Media o proporción, y desviación estándar"
svy: mean `x', over(area)
estat cv

matrix b	= r(cv)'
matrix aux	= b[.,"r1"]
putexcel F2 = matrix(aux)

display in red "`x' según departamento - Media o proporción, y desviación estándar"
svy: mean `x', over(dpto)
estat cv

matrix b	= r(cv)'
matrix aux	= b[., "r1"]
putexcel F4 = matrix(aux)
}