---
title: "Análisis de brotes en tiempo real: el ébola como estudio de caso - parte 1"
author: Anne Cori, Natsuko Imai, Finlay Campbell, Zhian N. Kamvar, Thibaut Jombart
authors: ["Anne Cori", "Natsuko Imai", "Finlay Campbell", "Zhian N. Kamvar", "Thibaut Jombart"]
categories: ["practicals"]
topics: ["simulation", "response", "ebola", "epicurve", "reproduction number"]
date: 2021-05-05
image: img/highres/ebola-strikes-back.jpg
slug: real-time-response-1-spanish
showonlyimage: yes
bibliography: null
licenses: CC-BY
always_allow_html: yes
output:
  md_document:
    variant: markdown_github
    preserve_yaml: yes
params:
  full_version: true
---

## Introducción

Esta práctica (en tres partes) simula la evaluación temprana y la
reconstrucción de un brote de enfermedad por el virus del Ébola (EVE).
Introduce varios aspectos del análisis de la etapa inicial de un brote,
incluida la tasa de letalidad (CFR por sus siglas en inglés de Case
Fatality Ratio), curvas epidemiológicas ([parte
1](./real-time-response-1-spanish.html)), estimación de la tasa de
crecimiento, datos del rastreo de contactos, retrasos y estimaciones de
transmisibilidad ([parte 2](./real-time-response-2.html)), así como la
reconstrucción de la cadena de transmisión mediante el uso de
outbreaker2 ([parte 3](./real-time-response-3.html)).

> Nota: Esta práctica se deriva de las prácticas [Ebola simulation part
> 1: early outbreak assessment](./simulated-evd-early.html) y [Ebola
> simulation part 2: outbreak
> reconstruction](./practical-ebola-reconstruction.html)

## Resultados del aprendizaje

Al final de esta práctica, usted será capaz de:

-   Cargar y limpiar datos de brotes en R ([parte
    1](./real-time-response-1-spanish.html))

-   Estimar la tasa de letalidad (CFR) ([parte
    1](./real-time-response-1-spanish.html))

-   Calcular y graficar la incidencia de la lista de líneas ([parte
    1](./real-time-response-1-spanish.html))

-   Estimar e interpretar la tasa de crecimiento y el tiempo de
    duplicación de la epidemia ([parte 2](./real-time-response-2.html))

-   Estimar el intervalo de serie a partir de los datos pareados de
    infectadas / personas infectadas ([parte
    2](./real-time-response-2.html))

-   Estimar e interpretar el número de reproducción de la epidemia
    ([parte 2](./real-time-response-2.html))

-   Pronóstico de la incidencia futura a corto plazo ([parte
    2](./real-time-response-2.html))

-   Reconstruir quién infectó a quién utilizando datos epidemiológicos y
    genéticos ([parte 3](./real-time-response-3.html))

## Un nuevo brote de EVE en un país ficticio de África occidental

Se ha notificado un nuevo brote de EVE en un país ficticio de África
occidental. El Ministerio de Salud se encarga de coordinar la respuesta
al brote, y lo ha contratado como consultor en análisis epidémico para
informar la respuesta en tiempo real.

## Paquetes necesarios

Los siguientes paquetes, disponibles en CRAN o github, son necesarios
para este análisis. Para instalarlos, ejecute los siguientes códigos:

``` r
# install.packages("remotes")
# install.packages("readxl")
# install.packages("outbreaks")
# install.packages("incidence")
# remotes::install_github("reconhub/epicontacts@ttree")
# install.packages("distcrete")
# install.packages("epitrix")
# remotes::install_github("annecori/EpiEstim")
# remotes::install_github("reconhub/projections")
# install.packages("ggplot2")
# install.packages("magrittr")
# install.packages("binom")
# install.packages("ape")
# install.packages("outbreaker2")
# install.packages("here")
```

Una vez instalados los paquetes, es posible que deba abrir una nueva
sesión de R. Ahora cargue las bibliotecas de la siguiente manera:

``` r
library(readxl)
library(outbreaks)
library(incidence)
library(epicontacts)
library(distcrete)
library(epitrix)
library(EpiEstim)
library(projections)
library(ggplot2)
library(magrittr)
library(binom)
library(ape)
library(outbreaker2)
library(here)
```

## Datos iniciales (lectura de datos en R)

Se le ha proporcionado la siguiente lista de líneas y datos de contacto:

[linelist_20140701.xlsx](https://github.com/reconhub/learn/raw/master/static/data/linelist_20140701.xlsx):
una lista de líneas que contiene información de casos hasta el 1 de
julio de 2014; y

[contact_20140701.xlsx](https://github.com/reconhub/learn/raw/master/static/data/contacts_20140701.xlsx):
una lista de contactos reportados por los casos hasta el 1 de julio de
2014. “infector” indica una fuente potencial de infección y “case_id”
con quién se tuvo el contacto.

Para leer en R, descargue estos archivos y use la función `read_xlsx()`
del paquete `readxl` para importar los datos. Cada grupo de datos
importados creará una tabla de datos almacenada como el objeto `tibble`.

-   Llame primero la `linelist`, y  
-   después los `contacts`.

Por ejemplo, su primera línea de comando podría verse así:

<!--
ZNK: These two chunks are needed because of the way the documents are structured
in blogdown. The source that we edit is not the same as the site that is
rendered. Everything in this directory will end up in the same directory as the
"static" when the website is displayed, but the current directory structure is
present when the practicals are built, so we have to do this silly 
song-and-dance to appease the directory gods.
-->

``` r
linelist <- read_excel(here("data/linelist_20140701.xlsx"), na = c("", "NA"))
```

``` r
contacts <- read_excel(here("data/contacts_20140701.xlsx"), na = c("", "NA"))
```

Tómese su tiempo para mirar los datos y la estructura aquí.

-   ¿Son los datos y el formato similares a las listas de líneas que ha
    visto en el pasado?
-   Si fuera parte del equipo de investigación de un brote, ¿qué otra
    información le gustaría recopilar?

``` r
dim(linelist)
```

    ## [1] 169  11

``` r
head(linelist)
```

    ## # A tibble: 6 x 11
    ##   case_id generation date_of_infection date_of_onset date_of_hospitalisation
    ##   <chr>        <dbl> <chr>             <chr>         <chr>                  
    ## 1 d1fafd           0 NA                2014-04-07    2014-04-17             
    ## 2 53371b           1 2014-04-09        2014-04-15    2014-04-20             
    ## 3 f5c3d8           1 2014-04-18        2014-04-21    2014-04-25             
    ## 4 6c286a           2 NA                2014-04-27    2014-04-27             
    ## 5 0f58c4           2 2014-04-22        2014-04-26    2014-04-29             
    ## 6 49731d           0 2014-03-19        2014-04-25    2014-05-02             
    ## # ... with 6 more variables: date_of_outcome <chr>, outcome <chr>,
    ## #   gender <chr>, hospital <chr>, lon <dbl>, lat <dbl>

-   You may want to also collect data on date of report, age, household
    identifier, occupation, etc.

Tenga en cuenta que para análisis posteriores, deberá asegurarse de que
todas las fechas estén almacenadas correctamente como `Date` objects.
Puede hacer esto usando la función `as.Date`, por ejemplo:

``` r
linelist$date_of_onset <- as.Date(linelist$date_of_onset, format = "%Y-%m-%d")
```

``` r
linelist$date_of_infection <- as.Date(linelist$date_of_infection, format = "%Y-%m-%d")
linelist$date_of_hospitalisation <- as.Date(linelist$date_of_hospitalisation, format = "%Y-%m-%d")
linelist$date_of_outcome <- as.Date(linelist$date_of_outcome, format = "%Y-%m-%d")
```

Los datos ahora deberían verse así:

    ## # A tibble: 6 x 11
    ##   case_id generation date_of_infection date_of_onset date_of_hospitalisation
    ##   <chr>        <dbl> <date>            <date>        <date>                 
    ## 1 d1fafd           0 NA                2014-04-07    2014-04-17             
    ## 2 53371b           1 2014-04-09        2014-04-15    2014-04-20             
    ## 3 f5c3d8           1 2014-04-18        2014-04-21    2014-04-25             
    ## 4 6c286a           2 NA                2014-04-27    2014-04-27             
    ## 5 0f58c4           2 2014-04-22        2014-04-26    2014-04-29             
    ## 6 49731d           0 2014-03-19        2014-04-25    2014-05-02             
    ## # ... with 6 more variables: date_of_outcome <date>, outcome <chr>,
    ## #   gender <chr>, hospital <chr>, lon <dbl>, lat <dbl>

    ## # A tibble: 6 x 3
    ##   infector case_id source 
    ##   <chr>    <chr>   <chr>  
    ## 1 d1fafd   53371b  other  
    ## 2 f5c3d8   0f58c4  other  
    ## 3 0f58c4   881bd4  other  
    ## 4 f5c3d8   d58402  other  
    ## 5 20b688   d8a13d  funeral
    ## 6 2ae019   a3c8b8  other

## Limpieza de datos y análisis descriptivo

Mire más de cerca los datos contenidos en este `linelist`.

-   ¿Qué observa?

``` r
head(linelist)
```

    ## # A tibble: 6 x 11
    ##   case_id generation date_of_infection date_of_onset date_of_hospitalisation
    ##   <chr>        <dbl> <date>            <date>        <date>                 
    ## 1 d1fafd           0 NA                2014-04-07    2014-04-17             
    ## 2 53371b           1 2014-04-09        2014-04-15    2014-04-20             
    ## 3 f5c3d8           1 2014-04-18        2014-04-21    2014-04-25             
    ## 4 6c286a           2 NA                2014-04-27    2014-04-27             
    ## 5 0f58c4           2 2014-04-22        2014-04-26    2014-04-29             
    ## 6 49731d           0 2014-03-19        2014-04-25    2014-05-02             
    ## # ... with 6 more variables: date_of_outcome <date>, outcome <chr>,
    ## #   gender <chr>, hospital <chr>, lon <dbl>, lat <dbl>

``` r
names(linelist)
```

    ##  [1] "case_id"                 "generation"             
    ##  [3] "date_of_infection"       "date_of_onset"          
    ##  [5] "date_of_hospitalisation" "date_of_outcome"        
    ##  [7] "outcome"                 "gender"                 
    ##  [9] "hospital"                "lon"                    
    ## [11] "lat"

Puede notar que faltan entradas. Un paso importante en el análisis es
identificar cualquier error en la entrada de datos. Aunque puede ser
difícil evaluar los errores en los nombres de los hospitales, es de
esperar que la fecha de la infección sea siempre anterior a la fecha de
aparición de los síntomas.

Limpie este conjunto de datos para eliminar cualquier entrada con
períodos de incubación negativo o de 0 días.

``` r
## identificar errores en la entrada de datos (período de incubación negativo)
mistakes <- 
mistakes
linelist[mistakes, ]
```

``` r
## identificar errores en la entrada de datos (período de incubación negativo)
mistakes <- which(linelist$date_of_onset <= linelist$date_of_infection)
mistakes
```

    ## [1]  46  63 110

``` r
linelist[mistakes, ] # muestre solo las primeras entradas en las que haya tiempos de incubación negativos o 0.
```

    ## # A tibble: 3 x 11
    ##   case_id         generation date_of_infection date_of_onset date_of_hospitalis~
    ##   <chr>                <dbl> <date>            <date>        <date>             
    ## 1 3f1aaf                   4 2014-05-18        2014-05-18    2014-05-25         
    ## 2 ce9c02                   5 2014-05-27        2014-05-27    2014-05-29         
    ## 3 7.000000000000~          6 2014-06-10        2014-06-10    2014-06-16         
    ## # ... with 6 more variables: date_of_outcome <date>, outcome <chr>,
    ## #   gender <chr>, hospital <chr>, lon <dbl>, lat <dbl>

Guarde su lista de líneas “limpia” como un objeto nuevo:
`linelist_clean`

``` r
linelist_clean <- linelist[-mistakes, ]
```

¿Qué otras fechas negativas o errores podría querer verificar si tuviera
el conjunto de datos completo?

-   Es posible que desee ver si hay errores que incluyen, entre
    otros: i) aparición de síntomas negativos en la hospitalización o
    retrasos en los resultados y ii) errores de ortografía en hospitales
    y nombres

## Calculemos la tasa de letalidad (CFR)

Aquí está el número de casos por estado de resultado. ¿Cómo calcularía
el CFR a partir de esto?

``` r
table(linelist_clean$outcome, useNA = "ifany")
```

    ## 
    ##   Death Recover    <NA> 
    ##      60      43      63

Piense en qué hacer con los casos cuyo resultado es NA.

``` r
n_dead <- sum(linelist_clean$outcome %in% "Death")
n_known_outcome <- sum(linelist_clean$outcome %in% c("Death", "Recover"))
n_all <- nrow(linelist_clean)
cfr <- n_dead / n_known_outcome
cfr_wrong <- n_dead / n_all
cfr_with_CI <- binom.confint(n_dead, n_known_outcome, method = "exact")
cfr_wrong_with_CI <- binom.confint(n_dead, n_all, method = "exact")
```

-   No contabilizar adecuadamente los casos con un estado de resultado
    desconocido generalmente conduce a una subestimación del CFR. Esto
    es particularmente problemático al principio de un brote en el que
    aún no se ha observado el estado final de una gran proporción de
    casos.

## Miremos las curvas de incidencia

La primera pregunta que queremos saber es simplemente: ¿qué tan mal
está? El primer paso del análisis es descriptivo: queremos dibujar una
epicurva o curva epidemiológica. Esto permite visualizar la incidencia a
lo largo del tiempo por fecha de inicio de los síntomas.

Usando el paquete`incidence` calcular la incidencia diaria a partir del
`linelist_clean` basado en las fechas de inicio de los síntomas.
Almacene el resultado en un objeto llamado i_daily; el resultado debería
verse así:

``` r
i_daily <- incidence(linelist_clean$date_of_onset) # daily incidence
```

``` r
i_daily
```

    ## <incidence object>
    ## [166 cases from days 2014-04-07 to 2014-06-29]
    ## 
    ## $counts: matrix with 84 rows and 1 columns
    ## $n: 166 cases in total
    ## $dates: 84 dates marking the left-side of bins
    ## $interval: 1 day
    ## $timespan: 84 days
    ## $cumulative: FALSE

``` r
plot(i_daily, border = "black")
```

![](practical-real-time-response-1-spanish_files/figure-markdown_github/show_incidence-1.png)

Es posible que observe que las fechas de incidencia `i_daily$dates` se
detienen en la última fecha en la que tenemos datos sobre la fecha de
inicio de los síntomas (29 de junio de 2014). Sin embargo, una
inspección minuciosa de la lista de líneas muestra que la última fecha
de la lista de líneas (de cualquier entrada) es, de hecho, un poco
posterior (1 de julio de 2014). Puede usar el argumento `last_date` en
la función `incidence` para cambiar esto.

``` r
#extend last date:
i_daily <- incidence(linelist_clean$date_of_onset, 
                     last_date = as.Date(max(linelist_clean$date_of_hospitalisation, na.rm = TRUE)))
i_daily
```

    ## <incidence object>
    ## [166 cases from days 2014-04-07 to 2014-07-01]
    ## 
    ## $counts: matrix with 86 rows and 1 columns
    ## $n: 166 cases in total
    ## $dates: 86 dates marking the left-side of bins
    ## $interval: 1 day
    ## $timespan: 86 days
    ## $cumulative: FALSE

``` r
plot(i_daily, border = "black")
```

![](practical-real-time-response-1-spanish_files/figure-markdown_github/update_last_date-1.png)

Otro problema es que puede ser difícil interpretar las tendencias al
observar la incidencia diaria, por lo que también calcule y grafique la
incidencia semanal `i_weekly`, como se ve a continuación:

``` r
i_weekly <- incidence(linelist_clean$date_of_onset, interval = 7, 
                      last_date = as.Date(max(linelist_clean$date_of_hospitalisation, na.rm = TRUE)))
i_weekly
```

    ## <incidence object>
    ## [166 cases from days 2014-04-07 to 2014-06-30]
    ## [166 cases from ISO weeks 2014-W15 to 2014-W27]
    ## 
    ## $counts: matrix with 13 rows and 1 columns
    ## $n: 166 cases in total
    ## $dates: 13 dates marking the left-side of bins
    ## $interval: 7 days
    ## $timespan: 85 days
    ## $cumulative: FALSE

``` r
plot(i_weekly, border = "black")
```

![](practical-real-time-response-1-spanish_files/figure-markdown_github/show_weekly_incidence-1.png)

## Guardar datos y resultados

Este es el final de la práctica de la [parte
1](./real-time-response-1-spanish.html). Antes de pasar a la [parte
2](./real-time-response-2.html), deberá guardar los siguientes objetos:

``` r
dir.create(here("data/clean")) # cree un directorio de datos limpio si no existe
saveRDS(i_daily, here("data/clean/i_daily.rds"))
saveRDS(i_weekly, here("data/clean/i_weekly.rds"))
saveRDS(linelist, here("data/clean/linelist.rds"))
saveRDS(linelist_clean, here("data/clean/linelist_clean.rds"))
saveRDS(contacts, here("data/clean/contacts.rds"))
```
