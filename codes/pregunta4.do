*** Diferencia significativa de la edad entre hombres y mujeres
	
	*** Modificando archivo Excel
		putexcel set "${tables}\anexo.xlsx", modify sheet("preg4-dif_sig")
	
	*** Nombre de columnas
		putexcel A1:G1, font(calibri, 11, black) bold vcenter hcenter
		putexcel A1:G5, border(all)
		
		putexcel A1 = "Preg."											, txtwrap
		putexcel B1 = "Diferencia del indicador"						, txtwrap
		putexcel C1 = "Error Estándar"									, txtwrap
		putexcel D1 = "p-valor"											, txtwrap
		putexcel E1 = "Intervalo Inferior"								, txtwrap
		putexcel F1 = "Intervalo Superior"								, txtwrap
		putexcel G1 = "¿La diferencia es significativa al 5% de error?"	, txtwrap
		
	*** Nombre de filas
		putexcel A2 = "1"
		putexcel A3 = "2"
		putexcel A4 = "3"
		putexcel A5 = "4"
		
	*** Diferencia significativa
	
		*** De la edad entre hombres y mujeres
			svy: mean edad, over(mujer)
			lincom edad@0.mujer - edad@1.mujer
			
			putexcel B2 = "`r(estimate)'"
			putexcel C2 = "`r(se)'"
			putexcel D2 = "`r(p)'"
			putexcel E2 = "`r(lb)'"
			putexcel F2 = "`r(ub)'"
			if (r(p) <= 0.05) putexcel G2 = "Sí"
				else putexcel G2 = "No"
				
		*** De ingresos entre hombres y mujeres
			svy: mean ingreso_pc, over(mujer)
			lincom ingreso_pc@0.mujer - ingreso_pc@1.mujer
			
			putexcel B3 = "`r(estimate)'"
			putexcel C3 = "`r(se)'"
			putexcel D3 = "`r(p)'"
			putexcel E3 = "`r(lb)'"
			putexcel F3 = "`r(ub)'"
			if (r(p) <= 0.05) putexcel G3 = "Sí"
				else putexcel G3 = "No"

		*** De ingresos entre pobres y no pobres
			svy: mean ingreso_pc, over(pobre)
			lincom ingreso_pc@1.pobre - ingreso_pc@0.pobre
			
			putexcel B4 = "`r(estimate)'"
			putexcel C4 = "`r(se)'"
			putexcel D4 = "`r(p)'"
			putexcel E4 = "`r(lb)'"
			putexcel F4 = "`r(ub)'"
			if (r(p) <= 0.05) putexcel G4 = "Sí"
				else putexcel G4 = "No"
				
		*** De ingresos entre personas de Loreto y Ucayali
			svy: mean ingreso_pc, over(dpto)
			lincom ingreso_pc@16.dpto - ingreso_pc@25.dpto
			
			putexcel B5 = "`r(estimate)'"
			putexcel C5 = "`r(se)'"
			putexcel D5 = "`r(p)'"
			putexcel E5 = "`r(lb)'"
			putexcel F5 = "`r(ub)'"
			if (r(p) <= 0.05) putexcel G5 = "Sí"
				else putexcel G5 = "No"