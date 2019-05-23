#código

cd estaciones

#nombre de la estacion "estaciones_1.csv"
sed 's/;\([0-9],[0-9]\)/;\1;E1/' estacion1.csv > estacion_1.csv
sed 's/;\([0-9],[0-9]\)/;\1;E2/' estacion2.csv > estacion_2.csv
sed 's/;\([0-9],[0-9]\)/;\1;E3/' estacion3.csv > estacion_3.csv
sed 's/;\([0-9],[0-9]\)/;\1;E4/' estacion4.csv > estacion_4.csv
#wc -l nombre.archivo ==> me indica la cantidad de filas que tiene el archivo


#unir las bases de datos
tail +2 estacion_1.csv >> estaciones_agr.csv
tail +2 estacion_2.csv >> estaciones_agr.csv
tail +2 estacion_3.csv >> estaciones_agr.csv
tail +2 estacion_4.csv >> estaciones_agr.csv

#agregar nombre de campo de estacion
awk 'BEGIN{print "FECHA;HHMMSS;DIR;VEL;EST"}(NR>1){print $0}' estaciones_agr.csv>estaciones_agr1.csv

#separar DD/MM/AA y HH/MM/SS
tr '/' ';' <estaciones_agr1.csv>estaciones_agr2.csv
tr ':' ';' <estaciones_agr2.csv>estaciones_agr3.csv

#agregar todos los nombres de campos creados
awk 'BEGIN{print "DD;MM;AA;HH;MIN;SS;DIR;VEL;EST"}(NR>1){print $0}' estaciones_agr3.csv>estaciones_agr4.csv

#Formulas
csvsql --query "select EST,MM,avg(VEL) as VELPROM from 'estaciones_agr4.csv' group by EST,MM" estaciones_agr4.csv>velocidad-por-mes.csv
csvsql --query "select EST,AA,avg(VEL) as VELPROM from 'estaciones_agr4.csv' group by EST,AA" estaciones_agr4.csv>velocidad-por-ano.csv
csvsql --query "select EST,HH,avg(VEL) as VELPROM from 'estaciones_agr4.csv' group by EST,HH" estaciones_agr4.csv>velocidad-por-hora.csv

mkdir promedios
mv ./velocidad-por-mes.csv ./promedios/velocidad-por-mes.csv
mv ./velocidad-por-ano.csv ./promedios/velocidad-por-ano.csv
mv ./velocidad-por-hora.csv ./promedios/velocidad-por-hora.csv