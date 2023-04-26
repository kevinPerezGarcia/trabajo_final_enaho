*** Diferencia significativa de la edad entre hombres y mujeres
	
	*** Modificando archivo Excel
		putexcel set "${tables}\anexo.xlsx", modify sheet("dif_sig")
	
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
			