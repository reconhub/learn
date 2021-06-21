---
title: "Visualización y Análisis de datos espaciales en salud pública"
authors: ["Gabriel Carrasco-Escobar", "Antony Barja", "Jesus Quispe"]
categories: ["practicals"]
topics: ["spatial analysis", "COVID19", "sf", "clustering", "Spanish"]
date: '2019-06-01'
image: img/highres/spat-cover.png
slug: spatial-analysis-1-spanish
showonlyimage: yes
licenses: CC-BY
always_allow_html: yes
output:
  md_document:
    variant: gfm
    preserve_yaml: yes
params:
  full_version: true
editor_options: 
  chunk_output_type: console
---

## Introducción

Este taller consiste en 3 partes que buscan exponer al alumno a
múltiples técnicas de análisis espacial en el contexto de brotes
epidemiológicos. Utilizaremos datos ficticios de la pandemia de COVID-19
en Lima metropolitana para aprender a manejar datos espaciales en ‘R’,
visualizar múltiples formatos de datos espaciales y analizar la
variación espacial del riesgo de COVID-19 incluyendo la detección de
clústers (agrupaciones) de casos.

## Resultados del aprendizaje

Al final de este taller, usted será capaz de:

-   Cargar y manejar datos espaciales en R
-   Visualizar múltiples formatos de datos espaciales y sus atributos
    (variables) correspondientes
-   Generar gráficos dinámicos para la exploración de procesos
    espaciales
-   Calcular la densidad kernel para determinar la variación espacial de
    casos de una enfermedad.
-   Determinar clústers (agrupaciones) de eventos distribuidos
    espacialmente en formato de puntos o polígonos.

## Introducción a epidemiología espacial

Desde hace dos décadas se ha dedicado mucho interés a la modelación de
datos espaciales, estos análisis se han hecho en múltiples áreas del
conocimiento, incluyendo a la geografía, geología, ciencias ambientales,
economía, **epidemiología** o medicina. En esta sección explicaremos
brevemente conceptos generales de análisis espacial aplicados a
epidemiología.

> Puede expandir cada sección para revisar los detalles.

<br>

<details>
<summary>
**1. ¿Qué son los datos espaciales?**
</summary>

Son todos los datos que presentan un sistema de referencia de
coordenadas (SRC, *CRS por sus siglas en inglés* ).

</details>
<details>
<summary>
**2. ¿Qué son los Sistemas de Referencia de Coordenadas?**
</summary>

La Tierra tiene forma de un geoide y las proyecciones cartográficas
intentan representar su superficie o una parte de ella en un plano (como
el papel o la pantalla del computador).

Los ***Sistemas de Referencia de Coordenadas (SRC ó CRS)*** nos ayuda a
establecer una relación entre cualquier punto de la superficie terrestre
con un plano de referencia mediante las proyecciones cartográficas. En
general, los SRC se pueden dividir en:

-   Geográficas.

-   Proyectados (también denominados Cartesianos o rectangulares)

<img src="https://user-images.githubusercontent.com/23284899/120653992-dbd73100-c446-11eb-836f-0a37a827ab7e.png" width="70%" style="display: block; margin: auto;" />

</details>
<details>
<summary>
**3. Proyecciones geográficas**
</summary>

El uso de **SRC geográficos** es muy común y el más empleado. Están
representadas por la **latitud** y **longitud** y tienen como unidad de
medida a los grados sexagesimales. El sistema más popular se denomina
**WGS 84**.

<div class="figure" style="text-align: center">

<img src="https://ambarja.github.io/OsgeoLiveUNMSM/Sesi%C3%B3n01/img/latlon.png" alt="Créditos: A. Barja, 2021" width="70%" />
<p class="caption">
Créditos: A. Barja, 2021
</p>

</div>

</details>
<details>
<summary>
**4. Proyecciones cartográficas**
</summary>

Entre todas las proyecciones que existen, ninguna es la mejor en un
sentido absoluto, depende de las necesidades específicas a la hora de
usar el mapa.

La mayoría de las proyecciones que se emplean hoy en día en la
cartografía son proyecciones modificadas, híbridos entre varios tipos de
proyecciones que minimizan las deformaciones y permiten alcanzar
resultados predeterminados.

Según sus propiedades prevalecientes, las proyecciones se distinguen
entre equidistantes, equivalentes y conformes; dependiendo de si
mantienen la fidelidad representando ***distancias***, ***áreas*** o
***ángulos*** respectivamente.

Según el tipo de superficie sobre el que se realiza la proyección,
existen tres proyecciones básicas:

-   Las proyecciones cilíndricas; son efectivas para representar las
    áreas entre los trópicos.

-   La proyecciones cónicas; sirven para representar áreas en latitudes
    medias.

-   Las proyecciones azimutales; sirven para representar zonas en altas
    latitudes.

<div class="figure" style="text-align: center">

<img src="https://mapnetico.com/wp-content/uploads/2018/05/proyecciones-cartograficas.jpg" alt="Créditos: mapnetico, 2020" width="70%" />
<p class="caption">
Créditos: mapnetico, 2020
</p>

</div>

**Proyección cartográfica más empleada**

-   Universal Tranverse Mercator (UTM)

Proyección cilíndrica conforme que gira el cilindro en 90 ° y divide el
elipsoide de referencia en segmentos de 6 grados de ancho (60 segmentos
para llegar a los 360°). UTM está diseñado para minimizar las
distorsiones dentro de la misma área. cerca del meridiano central, la
distorsión es mínima y aumenta alejándose del meridiano. Es recomendable
utilizar UTM sólo con mapas muy detallados.

</details>
<details>
<summary>
**5. Códigos EPSG**
</summary>

Todos los Sistemas de Referencia de Coordenadas (SRC ó CRS) llevan
asociados un código que los identifica de forma única y que a través del
cual podemos conocer los parámetros asociados al mismo. Se conoce como
[Spatial Reference System Identifier
(SRID)](https://spatialreference.org/) inicialmente impulsado por el
European Petroleum Survey Group (EPSG).

Los códigos EPSG más conocidos son: - WGS84: 4326 - UTM zona 17N: 32617
- UTM zona 18N: 32618 - UTM zona 18S: 32718

</details>
<details>
<summary>
**6. Introducción a la estadística espacial**
</summary>

Las técnica de estadística clásica suponen estudiar variables aleatorias
que se consideran independientes e idénticamente distribuidas (i.i.d.).
Por ello, al momento de analizar fenómenos que varían en tiempo y
espacio se requiere una modelación que considere la
***(auto)correlación*** espacial o temporal.

Cuando se tienen datos espaciales intuitivamente se tiene la noción de
que las observaciones cercanas están correlacionadas, por ello es
necesario utilizar herramientas de análisis que consideren dicha
estructura.

</details>
<details>
<summary>
**7. ¿Por qué es especial lo espacial?**
</summary>

**Primera Ley de Waldo Tobler**

“Todo está relacionado con todo lo demás, pero las cosas más cercanas
están más relacionadas que las distantes”. (Tobler,1970)

**Autocorrelación espacial**

Es la correlación entre los valores de una sola variable estrictamente
atribuible a sus posiciones de ubicación cercanas en una superficie
bidimensional. Esto introduce una desviación del supuesto de iid.

Para medir la autocorrelación espacial existen test estadísticos, entre
ellos:

-   Test de Mantel

-   Test de Moran

-   Test C Geray

</details>

<br>

Para mayor detalle recomendamos la introducción del libro
[Geocomputation with R](https://geocompr.robinlovelace.net/intro.html)
de Robin Lovelace, Jakub Nowosad, Jannes Muenchow.

## Paquetes requeridos

Los siguientes paquetes (disponibles en CRAN o gitHub) son necesarios
para el análisis.

``` r
# install.packages("remotes")
# install.packages("tidyverse")
# install.packages("sf")
# install.packages("mapview")
# install.packages("GADMTools")
# remotes::install_github("paleolimbot/ggspatial")
# install.packages("leaflet")
# install.packages("leaflet.extras2")
# install.packages("spdep")
# install.packages("spatstat")
# install.packages("raster")
# install.packages("smacpod")
# install.packages("ggspatial")
```

Cuando los paquetes estén instalados se necesita abrir una nueva sesión
de R. Luego, cargar las siguientes librerías:

``` r
library(tidyverse)
library(sf)
library(mapview)
library(GADMTools)
library(ggspatial)
library(leaflet)
library(leaflet.extras2)
library(spdep)
library(spatstat)  
library(raster)
library(smacpod)
library(ggspatial)
```

## Caso de estudio

Para este taller utilizaremos una base de datos ficticia que fue creada
usando como referencia los [datos abiertos del Gobierno
Peruano](https://www.datosabiertos.gob.pe/group/datos-abiertos-de-covid-19).
Esta base contiene los registros de cada persona diagnosticada de
COVID-19 por el Ministerio de Salud (MINSA) hasta el `24-MAY-2020`.

> Los datos de georefenciación (coodenadas) de los casos fueron
> simulados para los propósitos de este taller. Puede descargar
> directamente la base de datos del repositorio de
> [Zenodo](https://zenodo.org/record/4915889#.YMBxoTZKhjw)

``` r
covid <- read_csv(url("https://zenodo.org/record/4915889/files/covid19data.csv?download=1"))
```

<table class="table" style="margin-left: auto; margin-right: auto;">
<thead>
<tr>
<th style="text-align:left;">
FECHA\_CORTE
</th>
<th style="text-align:left;">
UUID
</th>
<th style="text-align:left;">
DEPARTAMENTO
</th>
<th style="text-align:left;">
PROVINCIA
</th>
<th style="text-align:left;">
DISTRITO
</th>
<th style="text-align:left;">
METODODX
</th>
<th style="text-align:right;">
EDAD
</th>
<th style="text-align:left;">
SEXO
</th>
<th style="text-align:left;">
FECHA\_RESULTADO
</th>
<th style="text-align:left;">
rango\_edad
</th>
<th style="text-align:right;">
lon
</th>
<th style="text-align:right;">
lat
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
2021-05-22
</td>
<td style="text-align:left;">
c66bf87eadf9c1a4bb60cc06674bc0ff
</td>
<td style="text-align:left;">
LIMA
</td>
<td style="text-align:left;">
LIMA
</td>
<td style="text-align:left;">
ANCON
</td>
<td style="text-align:left;">
PR
</td>
<td style="text-align:right;">
66
</td>
<td style="text-align:left;">
MASCULINO
</td>
<td style="text-align:left;">
2020-04-03
</td>
<td style="text-align:left;">
60-79
</td>
<td style="text-align:right;">
-77.10665
</td>
<td style="text-align:right;">
-11.78599
</td>
</tr>
<tr>
<td style="text-align:left;">
2021-05-22
</td>
<td style="text-align:left;">
bee5549e6caae07009d3845471721dc9
</td>
<td style="text-align:left;">
LIMA
</td>
<td style="text-align:left;">
LIMA
</td>
<td style="text-align:left;">
ANCON
</td>
<td style="text-align:left;">
PR
</td>
<td style="text-align:right;">
47
</td>
<td style="text-align:left;">
FEMENINO
</td>
<td style="text-align:left;">
2020-05-28
</td>
<td style="text-align:left;">
40-59
</td>
<td style="text-align:right;">
-77.06849
</td>
<td style="text-align:right;">
-11.70551
</td>
</tr>
<tr>
<td style="text-align:left;">
2021-05-22
</td>
<td style="text-align:left;">
b40562fc3db1160bab9d0f0ef46d57ef
</td>
<td style="text-align:left;">
LIMA
</td>
<td style="text-align:left;">
LIMA
</td>
<td style="text-align:left;">
ANCON
</td>
<td style="text-align:left;">
PR
</td>
<td style="text-align:right;">
29
</td>
<td style="text-align:left;">
MASCULINO
</td>
<td style="text-align:left;">
2020-09-11
</td>
<td style="text-align:left;">
20-39
</td>
<td style="text-align:right;">
-77.07175
</td>
<td style="text-align:right;">
-11.75761
</td>
</tr>
<tr>
<td style="text-align:left;">
2021-05-22
</td>
<td style="text-align:left;">
494a959a21abea9d197dccdc553150d4
</td>
<td style="text-align:left;">
LIMA
</td>
<td style="text-align:left;">
LIMA
</td>
<td style="text-align:left;">
ANCON
</td>
<td style="text-align:left;">
PR
</td>
<td style="text-align:right;">
36
</td>
<td style="text-align:left;">
MASCULINO
</td>
<td style="text-align:left;">
2020-09-11
</td>
<td style="text-align:left;">
20-39
</td>
<td style="text-align:right;">
-77.08505
</td>
<td style="text-align:right;">
-11.67503
</td>
</tr>
<tr>
<td style="text-align:left;">
2021-05-22
</td>
<td style="text-align:left;">
8f0d79f9de7a2e949ff755f62ceec80b
</td>
<td style="text-align:left;">
LIMA
</td>
<td style="text-align:left;">
LIMA
</td>
<td style="text-align:left;">
ANCON
</td>
<td style="text-align:left;">
PR
</td>
<td style="text-align:right;">
33
</td>
<td style="text-align:left;">
MASCULINO
</td>
<td style="text-align:left;">
2020-09-11
</td>
<td style="text-align:left;">
20-39
</td>
<td style="text-align:right;">
-77.06757
</td>
<td style="text-align:right;">
-11.67211
</td>
</tr>
<tr>
<td style="text-align:left;">
2021-05-22
</td>
<td style="text-align:left;">
78c435fe9d3401a0f3ac305b9d3c04ed
</td>
<td style="text-align:left;">
LIMA
</td>
<td style="text-align:left;">
LIMA
</td>
<td style="text-align:left;">
ANCON
</td>
<td style="text-align:left;">
PR
</td>
<td style="text-align:right;">
39
</td>
<td style="text-align:left;">
FEMENINO
</td>
<td style="text-align:left;">
2020-09-30
</td>
<td style="text-align:left;">
20-39
</td>
<td style="text-align:right;">
-77.17340
</td>
<td style="text-align:right;">
-11.67811
</td>
</tr>
<tr>
<td style="text-align:left;">
2021-05-22
</td>
<td style="text-align:left;">
397e6e6091f8c92086969e49ada5a6c4
</td>
<td style="text-align:left;">
LIMA
</td>
<td style="text-align:left;">
LIMA
</td>
<td style="text-align:left;">
ANCON
</td>
<td style="text-align:left;">
PR
</td>
<td style="text-align:right;">
44
</td>
<td style="text-align:left;">
FEMENINO
</td>
<td style="text-align:left;">
2020-09-30
</td>
<td style="text-align:left;">
40-59
</td>
<td style="text-align:right;">
-77.11325
</td>
<td style="text-align:right;">
-11.75787
</td>
</tr>
<tr>
<td style="text-align:left;">
2021-05-22
</td>
<td style="text-align:left;">
e323742fdffd02a1e7ec0dba2a1a8c5d
</td>
<td style="text-align:left;">
LIMA
</td>
<td style="text-align:left;">
LIMA
</td>
<td style="text-align:left;">
ANCON
</td>
<td style="text-align:left;">
PR
</td>
<td style="text-align:right;">
45
</td>
<td style="text-align:left;">
FEMENINO
</td>
<td style="text-align:left;">
2020-09-30
</td>
<td style="text-align:left;">
40-59
</td>
<td style="text-align:right;">
-77.04202
</td>
<td style="text-align:right;">
-11.63406
</td>
</tr>
<tr>
<td style="text-align:left;">
2021-05-22
</td>
<td style="text-align:left;">
eed80d87469c769c32483350b2e1e569
</td>
<td style="text-align:left;">
LIMA
</td>
<td style="text-align:left;">
LIMA
</td>
<td style="text-align:left;">
ANCON
</td>
<td style="text-align:left;">
PR
</td>
<td style="text-align:right;">
49
</td>
<td style="text-align:left;">
FEMENINO
</td>
<td style="text-align:left;">
2020-09-30
</td>
<td style="text-align:left;">
40-59
</td>
<td style="text-align:right;">
-77.13583
</td>
<td style="text-align:right;">
-11.81147
</td>
</tr>
<tr>
<td style="text-align:left;">
2021-05-22
</td>
<td style="text-align:left;">
82fc799ec2aa425d0e5405adb62ad31f
</td>
<td style="text-align:left;">
LIMA
</td>
<td style="text-align:left;">
LIMA
</td>
<td style="text-align:left;">
ANCON
</td>
<td style="text-align:left;">
PR
</td>
<td style="text-align:right;">
49
</td>
<td style="text-align:left;">
FEMENINO
</td>
<td style="text-align:left;">
2020-09-30
</td>
<td style="text-align:left;">
40-59
</td>
<td style="text-align:right;">
-77.11790
</td>
<td style="text-align:right;">
-11.80319
</td>
</tr>
<tr>
<td style="text-align:left;">
2021-05-22
</td>
<td style="text-align:left;">
70b6e956e6f2812f037979fca2abc019
</td>
<td style="text-align:left;">
LIMA
</td>
<td style="text-align:left;">
LIMA
</td>
<td style="text-align:left;">
ANCON
</td>
<td style="text-align:left;">
PR
</td>
<td style="text-align:right;">
49
</td>
<td style="text-align:left;">
FEMENINO
</td>
<td style="text-align:left;">
2020-09-30
</td>
<td style="text-align:left;">
40-59
</td>
<td style="text-align:right;">
-77.13552
</td>
<td style="text-align:right;">
-11.77465
</td>
</tr>
<tr>
<td style="text-align:left;">
2021-05-22
</td>
<td style="text-align:left;">
7cb47912dafe1aa8018888bfe9109197
</td>
<td style="text-align:left;">
LIMA
</td>
<td style="text-align:left;">
LIMA
</td>
<td style="text-align:left;">
ANCON
</td>
<td style="text-align:left;">
PR
</td>
<td style="text-align:right;">
45
</td>
<td style="text-align:left;">
FEMENINO
</td>
<td style="text-align:left;">
2020-10-01
</td>
<td style="text-align:left;">
40-59
</td>
<td style="text-align:right;">
-77.05448
</td>
<td style="text-align:right;">
-11.60338
</td>
</tr>
<tr>
<td style="text-align:left;">
2021-05-22
</td>
<td style="text-align:left;">
ef13e230a1bbd58e893250846d340dd8
</td>
<td style="text-align:left;">
LIMA
</td>
<td style="text-align:left;">
LIMA
</td>
<td style="text-align:left;">
ANCON
</td>
<td style="text-align:left;">
PR
</td>
<td style="text-align:right;">
30
</td>
<td style="text-align:left;">
FEMENINO
</td>
<td style="text-align:left;">
2020-09-16
</td>
<td style="text-align:left;">
20-39
</td>
<td style="text-align:right;">
-77.19165
</td>
<td style="text-align:right;">
-11.78114
</td>
</tr>
<tr>
<td style="text-align:left;">
2021-05-22
</td>
<td style="text-align:left;">
bdb2677329adb2c4f604aeda50fc8e8f
</td>
<td style="text-align:left;">
LIMA
</td>
<td style="text-align:left;">
LIMA
</td>
<td style="text-align:left;">
ANCON
</td>
<td style="text-align:left;">
PR
</td>
<td style="text-align:right;">
32
</td>
<td style="text-align:left;">
FEMENINO
</td>
<td style="text-align:left;">
2020-09-30
</td>
<td style="text-align:left;">
20-39
</td>
<td style="text-align:right;">
-77.11297
</td>
<td style="text-align:right;">
-11.81771
</td>
</tr>
<tr>
<td style="text-align:left;">
2021-05-22
</td>
<td style="text-align:left;">
755186c6529502fd4615a6a0c49e16cf
</td>
<td style="text-align:left;">
LIMA
</td>
<td style="text-align:left;">
LIMA
</td>
<td style="text-align:left;">
ANCON
</td>
<td style="text-align:left;">
PR
</td>
<td style="text-align:right;">
37
</td>
<td style="text-align:left;">
FEMENINO
</td>
<td style="text-align:left;">
2020-09-16
</td>
<td style="text-align:left;">
20-39
</td>
<td style="text-align:right;">
-77.09455
</td>
<td style="text-align:right;">
-11.65914
</td>
</tr>
<tr>
<td style="text-align:left;">
2021-05-22
</td>
<td style="text-align:left;">
e949cab78173cdfc5a6e0c5c5e71b5b2
</td>
<td style="text-align:left;">
LIMA
</td>
<td style="text-align:left;">
LIMA
</td>
<td style="text-align:left;">
ANCON
</td>
<td style="text-align:left;">
PR
</td>
<td style="text-align:right;">
44
</td>
<td style="text-align:left;">
FEMENINO
</td>
<td style="text-align:left;">
2020-09-16
</td>
<td style="text-align:left;">
40-59
</td>
<td style="text-align:right;">
-77.02234
</td>
<td style="text-align:right;">
-11.63633
</td>
</tr>
<tr>
<td style="text-align:left;">
2021-05-22
</td>
<td style="text-align:left;">
007de2f79d821c5a6875bb1465c2f2f7
</td>
<td style="text-align:left;">
LIMA
</td>
<td style="text-align:left;">
LIMA
</td>
<td style="text-align:left;">
ANCON
</td>
<td style="text-align:left;">
PR
</td>
<td style="text-align:right;">
40
</td>
<td style="text-align:left;">
FEMENINO
</td>
<td style="text-align:left;">
2020-09-16
</td>
<td style="text-align:left;">
40-59
</td>
<td style="text-align:right;">
-77.15927
</td>
<td style="text-align:right;">
-11.76954
</td>
</tr>
<tr>
<td style="text-align:left;">
2021-05-22
</td>
<td style="text-align:left;">
f90fb726b97e3fd5bdc956ae66f2751f
</td>
<td style="text-align:left;">
LIMA
</td>
<td style="text-align:left;">
LIMA
</td>
<td style="text-align:left;">
ANCON
</td>
<td style="text-align:left;">
PR
</td>
<td style="text-align:right;">
44
</td>
<td style="text-align:left;">
FEMENINO
</td>
<td style="text-align:left;">
2020-09-16
</td>
<td style="text-align:left;">
40-59
</td>
<td style="text-align:right;">
-77.18581
</td>
<td style="text-align:right;">
-11.69466
</td>
</tr>
<tr>
<td style="text-align:left;">
2021-05-22
</td>
<td style="text-align:left;">
a0d2f7cf23e2a989a5d18e4f857156b4
</td>
<td style="text-align:left;">
LIMA
</td>
<td style="text-align:left;">
LIMA
</td>
<td style="text-align:left;">
ANCON
</td>
<td style="text-align:left;">
PR
</td>
<td style="text-align:right;">
33
</td>
<td style="text-align:left;">
FEMENINO
</td>
<td style="text-align:left;">
2020-09-24
</td>
<td style="text-align:left;">
20-39
</td>
<td style="text-align:right;">
-77.15870
</td>
<td style="text-align:right;">
-11.72663
</td>
</tr>
<tr>
<td style="text-align:left;">
2021-05-22
</td>
<td style="text-align:left;">
b160905c9fa1c1bcfcdd917ada970016
</td>
<td style="text-align:left;">
LIMA
</td>
<td style="text-align:left;">
LIMA
</td>
<td style="text-align:left;">
ANCON
</td>
<td style="text-align:left;">
PR
</td>
<td style="text-align:right;">
35
</td>
<td style="text-align:left;">
FEMENINO
</td>
<td style="text-align:left;">
2020-09-16
</td>
<td style="text-align:left;">
20-39
</td>
<td style="text-align:right;">
-77.08235
</td>
<td style="text-align:right;">
-11.76282
</td>
</tr>
</tbody>
</table>

## Manejo de datos espaciales

`R` tiene un gran universo de paquetes para representación y análisis
espacial. Actualmente existen 2 formatos predominantes:
[`sp`](https://cran.r-project.org/web/packages/sp/vignettes/intro_sp.pdf)
y [`sf`](https://r-spatial.github.io/sf/). Para los fines de este taller
utilizaremos `sf` ya que tiene una integración natural con el ecosistema
`tidyverse`.

Existen múltiples variedades de representaciones gráficas con datos
espaciales. En este curso nos enfocaremos en la representación espacial
de 1) patrones de puntos y 2) datos de polígonos ( *e.j. por áreas
administrativas* ).

### Patrones de puntos

Si tenemos una base de datos georeferenciada (con coordenadas
geográficas para cada observación) podemos utilizar estos valores (
*coordenadas* ) para transformar nuestra base de datos tabular en una
base de datos espacial.

> Usaremos la función `st_as_sf()` para especificar los valores de
> latitud y longitud. Adicionalmente, tenemos que especificar el
> *sistema de referencia de coordenadas (CRS en ingles)* con que fueron
> georeferenciados nuestros datos en el área de estudio ( *ej. crs =
> 4326* ).

``` r
covid_p <- covid %>%
  st_as_sf(coords = c("lon", "lat"), crs = 4326)
```

Haremos un gráfico simple usando `ggplot2` y la geometría `geom_sf()`.

``` r
covid_p %>%
  filter(FECHA_RESULTADO == "2020-12-11") %>%
  ggplot() +
  geom_sf() 
```

![](practical-spatial-analysis-spanish_files/figure-gfm/unnamed-chunk-7-1.png)<!-- -->

Para visualizar nuestro mapa de una forma dinámica podemos usar el
paquete `mapview()`.

``` r
m_p <- covid_p %>% 
  filter(FECHA_RESULTADO == "2020-12-10") %>%
  mapview(layer.name = "puntos")

m_p
```

<!--html_preserve-->
<iframe src="widgets/m_p.html" width="100%" height="500px">
</iframe>
<!--/html_preserve-->

### Datos en polígonos

Para realizar las representaciones de las áreas necesitamos un archivo
que contiene la geometría espacial (los bordes), hay varios formatos
pero el más conocido es el `shapefile (.shp)`.

> Uno puede cargar los datos del archivo `.shp` usando la función
> `st_read()`. Para este taller utilizaremos el paquete
> [`GADMTools`](https://github.com/Epiconcept-Paris/GADMTools) que
> contiene los datos espaciales de las divisiones políticas de todos los
> países. `GADMTools` descarga datos en formato `gadm_sf` del cual
> extraeremos el objeto **sf** con la función `pluck()`.

``` r
peru <- gadm_sf_loadCountries("PER", level=3)
lima_sf <- peru %>%
  pluck("sf") %>%
  # Filtramos los datos espaciales solo de Lima metropolitana
  filter(NAME_2 == "Lima") %>%
  # Editamos algunos errores en nuestros datos espaciales
  mutate(NAME_3 = ifelse(NAME_3 == "Magdalena Vieja",
                         "Pueblo Libre", NAME_3))
```

Ahora procesaremos los datos de la base `covid` y los datos espaciales
`lim_sf` para poder hacer la unión.

> Como nuestra base de datos es a nivel individual, haremos el conteo
> del número de observaciones para cada fecha y distrito. Construiremos
> unos datos de tipo `panel`, para lo cual completaremos con `0` todas
> las fechas de las unidades geográficas que no reportaron casos.

``` r
covid_count <- covid %>%
  group_by(DISTRITO, FECHA_RESULTADO) %>%
  summarise(casos = n()) %>%
  ungroup() %>%
  complete(FECHA_RESULTADO = seq.Date(min(FECHA_RESULTADO, na.rm =T),
                                      max(FECHA_RESULTADO, na.rm = T),
                                      by="day"),
           nesting(DISTRITO), fill = list(n = 0))

covid_sf <- lima_sf %>%
  mutate(DISTRITO = toupper(NAME_3)) %>%
  full_join(covid_count, by = "DISTRITO", "FECHA_RESULTADO")

class(covid_sf)
```

    ## [1] "sf"         "data.frame"

Haremos un gráfico simple para verificar que nuestros datos estén
proyectados en el lugar correcto.

``` r
covid_sf %>%
  filter(FECHA_RESULTADO == "2020-12-11") %>%
  ggplot() +
  geom_sf()
```

![](practical-spatial-analysis-spanish_files/figure-gfm/unnamed-chunk-12-1.png)<!-- -->

``` r
m_sf <- covid_sf %>% 
  filter(FECHA_RESULTADO == "2020-12-11") %>%
  mapview(layer.name = "distritos")

m_sf
```

<!--html_preserve-->
<iframe src="widgets/m_sf.html" width="100%" height="500px">
</iframe>
<!--/html_preserve-->

### Múltiples capas

Los contenidos en los mapas suelen representarse como capas, las cuales,
podemos combinarlas y sobreponerlas para entender el evento de interés.

> Cada capa es agregada como una geometría diferente con `geom_sf()`. En
> mapview podemos usar el símbolo `+` para graficar ambas capas.

``` r
ggplot() +
  geom_sf(data = covid_sf %>% 
            filter(FECHA_RESULTADO == "2020-12-11")) + 
  geom_sf(data = covid_p %>% 
            filter(FECHA_RESULTADO == "2020-12-11"))
```

![](practical-spatial-analysis-spanish_files/figure-gfm/unnamed-chunk-15-1.png)<!-- -->

``` r
m_p + m_sf
```

<!--html_preserve-->
<iframe src="widgets/m_p_sf.html" width="100%" height="500px">
</iframe>
<!--/html_preserve-->

## Visualización de datos espaciales

Ahora exploraremos algunas variables de interés en la base de datos para
comprender mejor la transmisión de la enfermedad.

### Patrones de puntos

Al utilizar la base de datos a nivel individual podemos cambiar las
características de nuestra geometría (puntos) de acuerdo a los atributos
que deseamos graficar.

**Una variable**

> Usaremos el color de la geometría (argumento `col`) para representar
> el sexo de los pacientes con COVID-19 la base de datos.

``` r
covid_p %>%
  filter(FECHA_RESULTADO == "2020-12-11") %>%
  ggplot() +
  geom_sf(aes(col = SEXO), alpha = .2) +
  facet_wrap(.~SEXO)
```

![](practical-spatial-analysis-spanish_files/figure-gfm/unnamed-chunk-18-1.png)<!-- -->

En el caso de la visualización dinámica con `mapview` el color se asigna
con el argumento `zcol`. Usaremos el argumento `burst = T` para que cada
categoría (de la variable asignada en `zcol`) se visualice como una capa
separa y pueda seleccionarse u ocultarse en el mapa.

``` r
covid_p %>% 
  filter(FECHA_RESULTADO == "2020-12-11") %>%
  mapview(layer.name = "points", zcol = "SEXO", burst = T)
```

<!--html_preserve-->
<iframe src="widgets/m_uni.html" width="100%" height="500px">
</iframe>
<!--/html_preserve-->

**Dos o mas variable**

Al igual que con los gráficos de datos tabulares, podemos explorar las
visualizaciones con facetas y dividir los datos de acuerdo a sub-grupos
focalizados.

``` r
covid_p %>%
  filter(FECHA_RESULTADO == "2020-04-11" |
         FECHA_RESULTADO == "2020-12-11") %>%
  ggplot() +
  geom_sf(aes(col = SEXO), alpha = .2) +
  facet_grid(SEXO~FECHA_RESULTADO) +
  guides(col = F)
```

![](practical-spatial-analysis-spanish_files/figure-gfm/unnamed-chunk-21-1.png)<!-- -->

`mapview` permite agrupar múltiples capas con los operadores `+` y `|`.
Más detalles en la [documentación del
paquete](https://r-spatial.github.io/mapview/reference/ops.html).

``` r
m1 <- covid_p %>%
  filter(FECHA_RESULTADO == "2020-04-11") %>%
  mapview(zcol = "SEXO", layer.name = "2020-04-11 - SEXO")

m2 <- covid_p %>%
  filter(FECHA_RESULTADO == "2020-12-11") %>%
  mapview(zcol = "SEXO", layer.name = "2020-12-11 - SEXO")
```

``` r
m1 + m2
```

<!--html_preserve-->
<iframe src="widgets/m1_2.html" width="100%" height="500px">
</iframe>
<!--/html_preserve-->

**Composición**

Podemos usar las mismas herramientas usadas para la creación gráficos de
datos tabulares para generar una mejor composición de nuestra
representación espacial. Podemos modificar las escalas de color (
`scale_color_*()` ) y el tema ( `theme_*()` ) entro otros. Cuando
representamos datos espaciales es importante representar la ***escala
espacial*** de los datos y ***el norte***. Ambas características pueden
ser graficadas con el paquete `ggspatial`.

``` r
covid_p %>%
  filter(FECHA_RESULTADO == "2020-12-11") %>%
  ggplot() +
  geom_sf(data = covid_sf) +
  geom_sf(aes(col = EDAD), alpha = .2) +
  scale_color_viridis_c(option = "B") +
  annotation_scale() +
  annotation_north_arrow(location = "tr",
                         style = north_arrow_nautical)+
  theme_bw()
```

![](practical-spatial-analysis-spanish_files/figure-gfm/unnamed-chunk-25-1.png)<!-- -->

### Datos en polígonos

La forma de reporte más común de los sistemas de vigilancia de
enfermedades infecciosas es la agrupación de casos por unidades
geográficas o administrativas. En esta sección exploraremos la
representación de datos en polígonos espaciales.

**Una variable**

> Usaremos el relleno de la geometría (argumento `fill`) para
> representar el número de casos de COVID-19 por distritos en Lima
> metropolitana. Importante notar que el argumento color (`col`) se usa
> para definir el color de los bordes de la geometría.

``` r
covid_sf %>%
  filter(FECHA_RESULTADO == "2020-12-11") %>%
  ggplot() +
  geom_sf(aes(fill = casos))
```

![](practical-spatial-analysis-spanish_files/figure-gfm/unnamed-chunk-26-1.png)<!-- -->

En el caso de la visualización dinámica con `mapview` el relleno también
se asigna con el argumento `zcol`.

``` r
covid_sf %>% 
  filter(FECHA_RESULTADO == "2020-12-11") %>%
  mapview(layer.name = "casos", zcol = "casos")
```

<!--html_preserve-->
<iframe src="widgets/m_casos.html" width="100%" height="500px">
</iframe>
<!--/html_preserve-->

**Dos o mas variable**

Seleccionaremos 2 fechas para comparar la evolución de la epidemia.

``` r
covid_sf %>%
  filter(FECHA_RESULTADO == "2020-04-11" |
         FECHA_RESULTADO == "2020-12-11") %>%
  ggplot() +
  geom_sf(aes(fill = casos)) +
  facet_grid(.~FECHA_RESULTADO)
```

![](practical-spatial-analysis-spanish_files/figure-gfm/unnamed-chunk-29-1.png)<!-- -->

También podemos visualizar la distribución espacial de ambas fechas de
forma dinámica.

``` r
d1 <- covid_sf %>%
  filter(FECHA_RESULTADO == "2020-04-11") %>%
  mapview(zcol = "casos", layer.name = "2020-04-11 - casos")

d2 <- covid_sf %>%
  filter(FECHA_RESULTADO == "2020-12-11") %>%
  mapview(zcol = "casos", layer.name = "2020-12-11 - casos")
```

``` r
d1 + d2
```

<!--html_preserve-->
<iframe src="widgets/d1_2.html" width="100%" height="500px">
</iframe>
<!--/html_preserve-->

**Composición**

Al igual que con los datos de puntos, podemos usar las mismas
herramientas para generar una mejor composición de nuestra
representación espacial.

``` r
covid_sf %>%
  filter(FECHA_RESULTADO == "2020-12-11") %>%
  ggplot() +
  geom_sf(aes(fill = casos)) +
  scale_fill_viridis_c(option = "F", direction = -1) +
  annotation_scale() +
  annotation_north_arrow(location = "tr",
                         style = north_arrow_nautical)+
  theme_void()
```

![](practical-spatial-analysis-spanish_files/figure-gfm/unnamed-chunk-33-1.png)<!-- -->

> Otro paquete importante de revisar para la representación de
> estructuras espaciales es:
> [`tmap`](https://cran.r-project.org/web/packages/tmap/vignettes/tmap-getstarted.html).

## Variación espacial del riesgo

En esta sección se brindará una introducción a una metodologías para
obtener representaciones gráficas de procesos espaciales como el riesgo
de una enfermedad. En este taller exploraremos la ***estimación de la
densidad kernel*** para datos espaciales que representan procesos
discretos (ej. brotes). Existen otras técnicas para datos espaciales que
representan procesos continuos (ej. precipitación) como ***Kriging***.

Para estimar la densidad del kernel definiremos una **ventana** espacial
de análisis usando la función `owin` del paquete
[`spatstat`](https://spatstat.org/)

``` r
covid_subset <- covid %>%
  filter(FECHA_RESULTADO == "2020-05-05")

covid_win <- owin(xrange = range(covid_subset$lon),
                  yrange = range(covid_subset$lat))
```

Luego, definiremos el objeto patrón de puntos ( ***ppp*** ) a partir de
los registros de casos.

``` r
covid_ppp  <-  ppp(covid_subset$lon, 
                   covid_subset$lat, 
                   window = covid_win)
```

Finalmente, el objeto de la clase densidad lo convertiremos a uno de
clase **rasterLayer**. Eliminaremos las áreas fuera de nuestra zona de
estudio usando la función `mask` y utilizando nuestro objeto espacial de
los limites de Lima metropolitana (`lima_sf`).

``` r
densidad_raster_cov <- raster(density(covid_ppp, bw.ppl), 
                              crs = 4326) %>%
  mask(lima_sf)
```

La densidad puede ser representada de la siguiente forma:

``` r
densidad_raster_cov %>% 
  mapview()
```

<!--html_preserve-->
<iframe src="widgets/densidad.html" width="100%" height="500px">
</iframe>
<!--/html_preserve-->

## Detección de clústers

En esta sección se brindará una introducción a algunos métodos para
detectar la agrupación espacial de casos o ***clústers*** en diferentes
tipos de datos espaciales.

### Datos de patrones puntuales:

#### Estadísticas de escaneo espacial (Spatial Scan Statistics-SSS):

Para realizar el cálculo de las estadísticas de escaneo espacial,
primero es necesario emplear datos de la clase patrones de puntos o
***ppp*** :

> En este ejemplo, para definir una variable binaria, usaremos los casos
> detectados por PCR como infecciones recientes (positivo) y por otros
> métodos (ej. Prueba de Anticuerpos - PR) como infecciones pasadas
> (negativos).

``` r
covid_subset_posi <- covid %>%
  filter(FECHA_RESULTADO == "2020-05-05") %>%
  mutate(positividad = ifelse(METODODX == "PCR", 1, 0))

covid_scan_ppp <- ppp(covid_subset_posi$lon, 
                      covid_subset_posi$lat,
                      range(covid_subset_posi$lon),
                      range(covid_subset_posi$lat),
                      marks = as.factor(covid_subset_posi$positividad))
```

Aplicaremos la prueba de escaneo espacial propuesto por ***M.
Kulldorff*** en [SatScan](https://www.satscan.org/) e implementada en
`R` en el paquete `smacpod`.

> Por motivos de costo computacional utilizaremos **49 simulaciones**
> (`nsim`) de Monte Carlo para determinar el valor-p de la prueba de
> hipótesis. Para otros propósitos se recomienda incrementar el número
> de simulaciones.

``` r
covid_scan_test <- spscan.test(covid_scan_ppp,
                               nsim = 49, case = 2, 
                               maxd=.15, alpha = 0.05)
```

El objeto de tipo `spscan` contiene información del clúster detectado:

-   `locids`: las localizaciones incluidas en el clúster
-   `coords`: las coordenadas del centroide del clúster
-   `r`: el radio del clúster
-   `rr`: el riesgo relativo (RR) dentro del clúster
-   `pvalue`: valor=p de la prueba de hipótesis calculado por
    simulaciones de Monte Carlo

entre otros.

``` r
covid_scan_test
```

    ## $clusters
    ## $clusters[[1]]
    ## $clusters[[1]]$locids
    ##  [1] 1103 1371 1092 1375 1381 1104 1380 1378 1091 1074 1097 1376 1089 1076 1373
    ## [16] 1379 1096 1087 1088 1095 2093 2122 2117 2102 2106 1105 2121 1107  605 2086
    ## [31] 1098  592 1101 2111  596 2096 1070  599 2120  597  971 2094 2119  607
    ## 
    ## $clusters[[1]]$coords
    ##          [,1]      [,2]
    ## [1,] -77.0472 -12.11374
    ## 
    ## $clusters[[1]]$r
    ## [1] 0.02709301
    ## 
    ## $clusters[[1]]$pop
    ## [1] 44
    ## 
    ## $clusters[[1]]$cases
    ## 110344 
    ##     31 
    ## 
    ## $clusters[[1]]$expected
    ## [1] 11.17098
    ## 
    ## $clusters[[1]]$smr
    ##   110344 
    ## 2.775046 
    ## 
    ## $clusters[[1]]$rr
    ##   110344 
    ## 2.873837 
    ## 
    ## $clusters[[1]]$propcases
    ##    110344 
    ## 0.7045455 
    ## 
    ## $clusters[[1]]$loglikrat
    ## [1] 20.05829
    ## 
    ## $clusters[[1]]$pvalue
    ## [1] 0.02
    ## 
    ## 
    ## 
    ## $ppp
    ## Marked planar point pattern: 2316 points
    ## Multitype, with levels = 0, 1 
    ## window: rectangle = [-77.18195, -76.64829] x [-12.468713, -11.634232] units
    ## 
    ## attr(,"class")
    ## [1] "spscan"

Para representar gráficamente el clúster detectado, el subconjunto de
análisis es convertido a una clase adecuada para la representación
espacial.

``` r
# Construimos el centroide del clúster
cent <- tibble(lon = covid_scan_test$clusters[[1]]$coords[,1],
               lat = covid_scan_test$clusters[[1]]$coords[,2]) %>%
  st_as_sf(coords = c("lon", "lat"), crs = 4326, remove = F)  

# Construimos el área del clúster en base al radio
clust <- cent %>%
  st_buffer(dist = covid_scan_test$clusters[[1]]$r)
```

Graficaremos el clúster detectado empleando el paquete `mapview`:

``` r
cluster <- mapview(clust, alpha.regions = 0, color = "red") 

points <- covid_subset_posi %>%
  st_as_sf(coords = c("lon", "lat"), crs = 4326) %>%
  mapview(zcol = "positividad", alpha.regions = .4, alpha = 0) 

cluster + points 
```

<!--html_preserve-->
<iframe src="widgets/plot1.html" width="100%" height="500px">
</iframe>
<!--/html_preserve-->

### Datos agregados (en polígonos)

#### Autocorrelación espacial (global): Moran I

Para llevar a cabo el cálculo de estadístico de ***Moran I*** global, en
primer lugar establecemos el conjunto de datos de análisis. Debido a la
estructura longitudinal de la base de datos, filtraremos por una fecha
en específico.

``` r
covid_sf_subset <- covid_sf %>%
  filter(FECHA_RESULTADO == "2020-05-05") %>%
  mutate(casos = replace_na(casos, 0))
```

Luego, a partir de la distribución de los polígonos (distritos) en el
área de estudio definiremos la matriz de vecindad.

``` r
covid.nb <- poly2nb(covid_sf_subset, queen=TRUE,snap = 0.13)
```

Con la matriz de vecindad llevamos a cabo el cálculo de la matriz de
pesos espaciales

``` r
covid.lw <- nb2listw(covid.nb, style="W", zero.policy=TRUE)
```

Finalmente, realizamos el cálculo de la **prueba de Moran global I**:

``` r
moran.test(covid_sf_subset$casos, covid.lw)
```

    ## 
    ##  Moran I test under randomisation
    ## 
    ## data:  covid_sf_subset$casos  
    ## weights: covid.lw    
    ## 
    ## Moran I statistic standard deviate = 3.0548, p-value = 0.001126
    ## alternative hypothesis: greater
    ## sample estimates:
    ## Moran I statistic       Expectation          Variance 
    ##       0.090491242      -0.023809524       0.001399995

> nota: La prueba implementada por defecto utiliza un cálculo analítico
> del estadístico de Moran I. Esta prueba, sin embargo, es muy
> susceptible a polígonos distribuidos irregularmente. Por ello
> actualmente el paquete `spdep` cuenta con una versión de la prueba que
> se basa en simulaciones de Monte Carlo, la cual puede ser llevada a
> cabo con la función `moran.mc`.

#### Autocorrelación espacial (local): Getis Ord

Para el cálculo de la autocorrelación espacial local, en primer lugar
establecemos los umbrales (del estadístico z) a partir de las cuales se
definen lo clúster de valores altos y bajos.

``` r
breaks <- c(-Inf, -1.96, 1.96, Inf)
labels <- c("Cold spot",
            "Not significant",
            "Hot spot")
```

Realizamos el cálculo del estadístico de **Getis Ord**

``` r
covid_lg <- localG(covid_sf_subset$casos, covid.lw)

covid_sf_lisa<-covid_sf_subset %>% 
  mutate(cluster_lg=cut(covid_lg, include.lowest = TRUE,
                        breaks = breaks, 
                        labels = labels))
```

Finalmente realizamos el gráfico:

``` r
covid_sf_lisa %>%
          ggplot() + 
          geom_sf(aes(fill=cluster_lg)) +
          scale_fill_brewer(name="Clúster", 
                            palette = "RdBu", direction=-1) +
  theme_bw()
```

![](practical-spatial-analysis-spanish_files/figure-gfm/unnamed-chunk-51-1.png)<!-- -->

Se puede visualizar que en la zona central y sur de lima la existencia
de **clústers** espaciales de alta y baja concentración de casos
respectivamente.

## Sobre este documento

### Contribuciones

-   Gabriel Carrasco-Escobar, Antony Barja & Jesus Quispe: Versión
    inicial

Contribuciones son bienvenidas vía [pull
requests](https://github.com/reconhub/learn/pulls).
