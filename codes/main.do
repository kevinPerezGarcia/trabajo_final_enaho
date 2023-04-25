*** Contenido
	*** Configuración de limpieza
	*** Configuración de rutas
	*** Control de do-files

***
***
***

*** Configuración de limpieza
	clear all
	set more off
	
*** Configuración de rutas
								global rawdata "J:\Mi unidad\enaho\rawdata\"
	if (c(username) == "Kena")	global project "D:\stata\proyectos\trabajo_final_enaho\"
									global codes	"${project}\codes"
									global datas	"${project}\datas"
									global tables	"${project}\tables"
									
*** Control de do-files
	local pregunta1 0
	local pregunta2 0
	local pregunta3 0
	local pregunta4 0
	local pregunta5 0
	local pregunta6 0
	local pregunta7 0
	
	if (`pregunta1' == 1) do "${codes}\pregunta1.do"