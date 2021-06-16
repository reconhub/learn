---
title: "Taller R Markdown"
authors: ["Carlos Javier Rincon"]
categories: ["practicals"]
topics: ["Reproducibilidad","R","R Markdown","Spanish"]
date: '2019-06-01'
image: img/highres/IR.jpg
showonlyimage: yes
bibliography: practical-rmarkdown-spanish.bib
licenses: CC-BY
always_allow_html: yes
output:
  md_document:
    variant: gfm
    preserve_yaml: yes
params:
  full_version: true
---

# Inicio.

Para comenzar, abra *RStudio* y cree un proyecto definiendo la carpeta
de trabajo donde se van a colocar todos los archivos relacionados con
esta práctica (ver figura 1).

![Figura 1: Ruta para crear un proyecto](../../img/Proyecto.png)

(**Figura 1.** Ruta para crear un proyecto)

A continuación, siguiendo la ruta **File&gt;New File&gt;R Markdown**
(figura 2) cree un archivo de *R Markdown* definiendo: título, autores y
con formato de salida html.

![Figura 2: Ruta para crear archivo .Rmd](../../img/CrearRmark.png)

(**Figura 2.** Ruta para crear archivo .Rmd)

Aparecerá en el panel superior izquierdo, un nuevo archivo con un
encabezado delimitado por `---` que incluye las definiciones anteriores
más la fecha actual. Borre todo el texto que se presenta después del
encabezado y guarde este archivo en la carpeta de trabajo.

En las secciones que se presentan a continuación, encontrará la
**información** requerida para empezar a generar un documento en *R
Markdown* seguido de un **reto** que busca poner en práctica lo
aprendido.

Para tener una vista del documento a medida que va escribiendo, en la
barra de herramientas seleccione la opción **Preview in Viewer Pane** y
marque el botón **Knit** como se muestra en la figura 3, así irá
*“tejiendo”* su documento.

![Figura 3: Tejer archivo .Rmd](../../img/tejer.png)

(**Figura 3.** Tejer archivo .Rmd)

En el panel inferior derecho aparecerá la vista correspondiente. Como
notará, en el botón “Knit” hay otras alternativas distintas al formato
de .html como .pdf y .Word; en este taller trabajaremos en el formato
.html pero las instrucciones descritas en general aplican para los demás
formatos.

# Herramientas de texto

## Información 1:

1.  Para incluir el títulos de una sección, se coloca el símbolo `#` y a
    continuación el nombre de la sección en una linea única. Para
    colocar sub-títulos se utiliza `##` y para cada sub-título adicional
    se agrega otro `#`.
2.  Para escribir palabra en negrillas o cursiva coloque `**palabra**` o
    `*palabra*` respectivamente.
3.  Un superíndice se colocar así: `palabra^2^` y un subíndice se coloca
    así:`palabra~2~`.
4.  Así se tacha una palabra:`~~palabra~~`.
5.  Para colocar texto en un bloque aparte, se antecede este texto con
    el símbolo `>` en una línea única, así: `> texto en bloque`.

## Reto 1.

Reproduzca el siguiente fragmento:

<span style="color:purple
">
\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*
</span>

# Primera práctica en R Markdown

## Herramientas de texto

Se puede usar **negrillas** o también letra *cursiva*. De igual forma
podemos escribir palabras con<sup>super-índices</sup> y palabras con
<sub>sub-índices</sub>. Aunque no queremos cometer ~~erores~~, perdón
errores, siempre podemos resaltar términos importantes, así:

> ¡TÉRMINOS IMPORTANTE!

<span style="color:purple
">
\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*
</span>

## Información 2

1.  Para incluir un pie de página colocamos: `palabra [^1]` y en una
    linea aparte escribimos:`[^1]: texto del pie de página.`

2.  Para incluir un enlace a una página de internet tenemos las dos
    siguientes opciones:

-   `<https://www.rstudio.com/resources/cheatsheets/#rmarkdown>`
-   `[ayuda](https://www.rstudio.com/resources/cheatsheets/#rmarkdown)`

1.  Una listas pueden ser **sin orden** o **con orden**. Para crear una
    lista sin orden se coloca:

<!-- -->

    * texto1
        + texto2
        + texto2
            - texto 3
    * texto 4
        + texto 5

y para una lista con orden:

    1. texto1
    2. texto 2
        a. texto 3
            i) texto 4
            ii) texto 5
        b. texto 6
    3. texto 7

En ambos tipos de lista, para identificar cada subítem adicional se
requieren exactamente 4 espacios adicionales.

## Reto 2

Reproducir el siguiente fragmento:

<span style="color:purple
">
\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*
</span>

## Herramientas de texto 2

Coloquemos un pie de página a esta palabra: *palabra*[1]. Ahora en el
siguiente enlace podemos consultar información relevante sobre casos de
covid 19 en el mundo [ourworldindata](https://ourworldindata.org/). En
esta página encontrará aspectos relevantes como:

1.  Casos reportados
    1.  Por países
    2.  Acumulados o diarios
2.  Mortalidad
    1.  Por países
    2.  Acumulados o diarios
        1.  En diferentes escalas.

<span style="color:purple
">
\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*
</span>

## Información 3

Las fórmulas se debe escribir entre dos signos de `$` y, si se quiere
colocar en un reglón a parte y centrada se coloca entre doble signo
`$$`. Dos ejemplos:

-   `la siguiente expresión $\frac{e^\pi}{\sqrt[n]{a}}$ representa...`

-   `$$` `\frac{e^\pi}{\sqrt[n]{a}}` `$$`

Como se observa en los dos ejemplos anteriores, las fórmulas se deben
escribir en lenguaje de **LaTeX** (“LaTeX - A Document Preparation
System” n.d.). Para facilitar esta tarea se pueden utilizar editores de
ecuaciones disponibles en páginas de internet como esta: [editor de
fórmulas](https://www.rinconmatematico.com/latexrender/)

Si se requiere enumerar las fórmulas dentro del documento se puede
reemplazar los signos de `$` por la siguiente sintaxis:

    \begin{equation}
    \tag{eq.1}
       y = \frac{\lambda}{\sqrt{x_i}}
    \end{equation}

## Reto 3

Reproduzca el siguiente fragmento:

<span style="color:purple
">
\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*
</span>

## Fórmulas

Sea `$x_{i}$` una variable de naturaleza continua y
`$x_{ij}\sim N(\mu,\sigma^2)$`; la media y varianza muestral se obtienen
a partir de las siguientes expresiones:

<!-- \begin{equation} -->
<!-- \tag{1} -->
<!--     \bar{x}=\frac{\sum^{n}_{i=1}x_i}{n} -->
<!-- \end{equation} -->

`$$ \bar{x}=\frac{\sum^{n}_{i=1}x_i}{n} $$`

y

<!-- \begin{equation} -->
<!-- \tag{2} -->
<!-- s^2=\frac{\sum^{n}_{i=1}(x_i -\bar{x})^2}{n-1} -->
<!-- \end{equation} -->

`$$ s^2=\frac{\sum^{n}_{i=1}(x_i -\bar{x})^2}{n-1} $$`

<span style="color:purple
">
\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*
</span>

## Información 4.

Se pueden construir tablas escribiendo uno a uno los valores en cada
celda, así:

    :Tabla 1. título

    |derecha|izquierda|centrada|
    |:---|---:|:---:|:---|
    |texto 1|23.5|28.6|na|
    |texto 2|65.4|-5.6|BOGOTA D.C.|
    |texto 3|$\bar{x}$|Cund.|

la ubicación de los : en la segunda línea de la tabla define la
alineación del texto en las columnas y la cantidad de - que se coloquen
definen el ancho de cada columna.

## Reto 4

Reproduzca el siguiente fragmento

<span style="color:purple
">
\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*
</span>

## Tablas

A continuación se presenta los primeros resultados.

|    Lugar | Prevalencia D | n   |
|---------:|--------------:|:----|
| Ciudad 1 |          0.35 | 156 |
| Ciudad 2 |          0.31 | 285 |
| Ciudad 3 |          0.25 | 465 |
| Ciudad 4 |          0.58 | 118 |
| Ciudad 5 |     `$\mu^2$` | 456 |

Tabla 1. Estimación de la prevalencia del desenlace **D**

Ahora, se presentan otros resultados.

| Lugar    | Prevalencia O |  n  |
|:---------|:-------------:|:---:|
| Ciudad 1 |     0.25      | 356 |
| Ciudad 2 |     0.32      | 485 |
| Ciudad 3 |     0.21      | 365 |
| Ciudad 4 |     0.18      | 218 |
| Ciudad 5 | `$\Sigma^2$`  | 456 |

Tabla 2. Estimación de la prevalencia del desenlace **O**

<span style="color:purple
">
\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*\*
</span>

# Código y resultados de R

Para incluir código de R tenemos que introducir un “trozo” en el
documento marcando en la barra de herramientas el icono **insert** como
se muestra en la figura 4.

![Figura 4. Insertar Chunk](../../img/chunk.png)

(**Figura 4.** Insertar Chunk)

Aparecerá un espacio delimitado por \`\`\`, todo lo escrito al interior
se ejecutará como código de R.

Para poder realizar los siguientes ejemplos, necesitamos instalar los
paquetes `rio` (Becker et al. 2021) y `tidyverse` (Wickham and RStudio
2019) ejecutando en la consola (panel inferior izquierdo), en caso de
que no las tenga instaladas, las siguientes instrucciones:

-   `install.packages("rio")`
-   `install.packages("tidyverse")`

Para nuestros ejemplos también necesitamos datos, entonces vamos a
utilizar el reporte de casos de covid 19 consolidados por la universidad
de Oxford (Max Roser and Hasell 2020) que se encuentra en el siguiente
enlace: <https://covid.ourworldindata.org/data/owid-covid-data.csv>

A continuación, vamos a cargar estos datos directamente desde la página
utilizando el paquete `rio`, colocando la siguiente instrucción al
interior del “trozo” creado, así:

``` r
library(rio)
data<-import("https://covid.ourworldindata.org/data/owid-covid-data.csv", format ="csv")
```

Puede correr el código anterior, como se hace habitualmente en un script
de R, colocando el cursor en cualquier parte de la instrucción y
tecleando Ctrl+Enter (si está en Windows) o Ctrl + Command (si está en
Mac). Podrá ver como en el panel superior derecho aparece el objeto
**data**; seleccione este objeto para familiarizarse con las variables
que contiene.

Teniendo datos, ya podemos generar algunos resultados y gráficos; se
recomienda ir copiando y pegando el código en distintos “trozos” en su R
Markdown, e ir *“tejiendo”* su documento.

# Información 5

Primero, obtengamos las primeras 20 localizaciones con el mayor número
de casos de covid a la fecha de descargue del archivo (es decir hoy:
2021-06-16).

``` r
library(tidyverse)
## Warning: package 'tidyverse' was built under R version 4.0.4
## Warning: package 'dplyr' was built under R version 4.0.5

A<-group_by(data,location)%>%
  summarise(casos=sum(new_cases,na.rm = TRUE))%>%
  arrange(desc(casos))

B<-A[1:20,];B
## # A tibble: 20 x 2
##    location           casos
##    <chr>              <dbl>
##  1 World          176168718
##  2 Asia            52965244
##  3 Europe          47885988
##  4 North America   39303369
##  5 United States   33486037
##  6 European Union  32889091
##  7 South America   30885017
##  8 India           29633105
##  9 Brazil          17533221
## 10 France           6154922
## 11 Russia           5176051
## 12 Africa           5077344
## 13 United Kingdom   4596994
## 14 Turkey           4518803
## 15 Italy            4247032
## 16 Argentina        4172742
## 17 Colombia         3802052
## 18 Spain            3745199
## 19 Germany          3725328
## 20 Iran             3049648
```

Se puede utilizar la función `ktable` del paquete `knitr` (Xie \[aut et
al. 2021) (no olvide instalar este paquete primero) para editar la tabla
anterior:

``` r
library(knitr)
kable(B, caption = "Tabla usando kable")
```

| location       |     casos |
|:---------------|----------:|
| World          | 176168718 |
| Asia           |  52965244 |
| Europe         |  47885988 |
| North America  |  39303369 |
| United States  |  33486037 |
| European Union |  32889091 |
| South America  |  30885017 |
| India          |  29633105 |
| Brazil         |  17533221 |
| France         |   6154922 |
| Russia         |   5176051 |
| Africa         |   5077344 |
| United Kingdom |   4596994 |
| Turkey         |   4518803 |
| Italy          |   4247032 |
| Argentina      |   4172742 |
| Colombia       |   3802052 |
| Spain          |   3745199 |
| Germany        |   3725328 |
| Iran           |   3049648 |

Tabla usando kable

Ahora, incluyamos un gráfico de barras de la tabla anterior.

``` r
B$location<-factor(B$location,levels = B$location[order(B$casos)])

ggplot(data=B,aes(x=location,y=casos/1000000))+
  geom_bar(fill="darkblue",alpha=0.7,col="purple",size=0.5,stat = "identity")+
  coord_flip()+
  labs(title="Gráfico 1. Número de casos de covid", y="Número de casos (por millón de hab.)",x="paises con mayor número de casos",caption="Fuente: ourworldindata.org")
```

![](practical-rmarkdown-spanish_files/figure-gfm/unnamed-chunk-4-1.png)<!-- -->

## Reto 5

Usando los datos ya cargados en el objeto **data**, incluya en su
documento de R Markdown dos medida de resumen y dos gráfico que usted
haya creado.

## Información 6 - Múltiples gráficos

Para describir el comportamiento del número de muertes reportados por
millón de habitantes por semana, a continuación se escribe la función
`tasa.muertes` que permite obtener este resultado indicando la
localización de interés. Primero cree la función con el siguiente
código:

``` r
data$date<-as.Date(data$date)
data$week<-as.numeric(strftime(data$date, format = "%U")) 
data$year<-strftime(data$date, format = "%y")

tasa.muertes<-function(A){
ggplot(filter(data,location==A)%>%
         group_by(week,year) %>%
         summarise(Tasa=(sum(new_deaths)/(sum(population)/n()))*1000000,n=n()),
       aes(x=week,y=Tasa))+
  geom_point(alpha=0.9,color="black")+
  geom_smooth(col="purple")+
  labs(title=A, y="tasa", x="semana")+
  facet_wrap(~year)
}
```

pruebe la función, por ejemplo con **Colombia** escribiendo:

``` r
tasa.muertes("Colombia")
```

![](practical-rmarkdown-spanish_files/figure-gfm/unnamed-chunk-6-1.png)<!-- -->

Ahora, podemos incluir múltiples gráficos de la siguiente forma:

``` r
par(mar = c(4, 4, .1, .1)) # Margenes del gráfico general: Abajo, derecha, superior e izquierda.
tasa.muertes("Spain")
tasa.muertes("Italy")
tasa.muertes("Germany")
tasa.muertes("France")
```

<img src="practical-rmarkdown-spanish_files/figure-gfm/unnamed-chunk-7-1.png" width="50%" /><img src="practical-rmarkdown-spanish_files/figure-gfm/unnamed-chunk-7-2.png" width="50%" /><img src="practical-rmarkdown-spanish_files/figure-gfm/unnamed-chunk-7-3.png" width="50%" /><img src="practical-rmarkdown-spanish_files/figure-gfm/unnamed-chunk-7-4.png" width="50%" />

## Reto 6

1.  Seleccione un grupo de localizaciones de su interés e incluya sus
    gráficos en su documento de RMarkdown.
2.  Una los gráficos que elaboró en el reto 5 en un solo gráfico.

El libro de referencia para conocer todas las herramientas disponibles
en RMarkdown se pueden consultar en este enlace:
<https://bookdown.org/yihui/rmarkdown-cookbook/> (Riederer n.d.)

# Dashboard y Shiny

A continuación, vamos a construir un tablero de control. Para ello
utilizaremos el paquete `flexdashboard` (Iannone et al. 2020)
(`install.packages("flexdashboard")`). Luego de instalarlo, cree un
nuevo archivo de R Markdow como se presentó en la figura 2, pero ahora
seleccione **From Template&gt;FlexDashboard** (figura 5).

![Figura 5. Crear tablero de control](../../img/CrearDash.png)

(**Figura 5.** Crear tablero de control)

Aparecerá una plantilla (figura 6) que permite crear un documento
organizado por secciones de columna o filas dentro de las cuales se
podrán colocar distintos objetos como tablas, gráficos, texto e incluso
entradas de valores que permitan realizar por ejemplo, gráficos
dinámicos. En la figura 6 se presenta esta plantillas con una breve
explicación de cada sección.

![Figura 6. Plantilla Dashboard](../../img/PlantillaDash.png)

(**Figura 6.** Plantilla Dashboard)

Pruebe “tejiendo” esta plantilla para conocer la vista preliminar.

Ahora, utilizando el registro de casos de covid reportados por la
universidad de Oxford y la función **tasa.muertes** creada previamente,
vamos de construir un primer tablero de control que incluya un botón
para seleccionar una localización y a continuación se genere el gráfico
de esta localización utilizando nuestra función. Para ello, nos vamos a
apoyar del paquete `Shiny` (“Shiny” n.d.) agregando una instrucción en
el encabezado. En la figura 7 se presenta el código necesario para esto,
junto con una breve descripción.

![Figura 7. Plantilla Dashboard](../../img/Ejem.DashShiny.png)

(**Figura 7.** Plantilla Dashboard)

En *Instrucción para definir las entradas* de la figura anterior, los
parámetros de la función selectInput son:

-   lugar: Es el nombre con el que se va a guardar la opción que se
    seleccione.
-   Localización: Es la etiqueta que aparece sobre las opciones de
    selección.
-   unique(): Define el listado de opciones para seleccionar[2]

En *Instrucciones para definir la salida* de la figura 7, tenemos la
función `renderPlot` que permite incluir gráfico en nuestro tablero de
control. Entre los (), colocamos la función tasa.muertes y la evaluamos
con el nombre input$lugar, que fue donde definimos se guardaría la
selección en `selectInput`.

## Reto 7

Reconstruir el ejemplo de la figura 7.

> Existen muchas opciones a incluir en un tableros de control. En el
> siguiente enlace se presenta una descripción detallada de los paquetes
> que utilizamos: <https://rmarkdown.rstudio.com/flexdashboard/>

# Publicación

Podrá encontrar el ejemplo anterior en la siguiente dirección:
<https://cjrr.shinyapps.io/prueba/>. Es decir, que se puede compartir un
tablero de control utilizando la plataforma **shinyapp.io** a la que se
puede acceder desde el siguiente enlace
<https://www.shinyapps.io/admin/#/login>. Para esto, primero cree una
cuenta en la página y a continuación, al ingresar por primera vez a la
cuenta encontrará las instrucciones necesarias para enlazar su RStudio a
esta cuenta, así siempre que publique (como se describe en la figura 8)
su cuadro de mando quedará en esta plataforma y podrá generar un enlace
que podrá compartir con cualquier persona.

![Figura 8. Publicar](../../img/publicar.png)

(**Figura 8.** Publicar)

# Bibliografía

<div id="refs" class="references csl-bib-body hanging-indent">

<div id="ref-becker_rio_2021" class="csl-entry">

Becker, Jason, Chung-hong Chan, Geoffrey CH Chan, Thomas J. Leeper,
Christopher Gandrud, Andrew MacDonald, Ista Zahn, et al. 2021. “Rio: A
Swiss-Army Knife for Data I/O.”
<https://CRAN.R-project.org/package=rio>.

</div>

<div id="ref-iannone_flexdashboard_2020" class="csl-entry">

Iannone, Richard, J. J. Allaire, Barbara Borges, RStudio, Keen IO
(Dashboard CSS), Abdullah Almsaeed (Dashboard CSS), Jonas Mosbech
(StickyTableHeaders), et al. 2020. “Flexdashboard: R Markdown Format for
Flexible Dashboards.”
<https://CRAN.R-project.org/package=flexdashboard>.

</div>

<div id="ref-noauthor_latex_nodate" class="csl-entry">

“LaTeX - A Document Preparation System.” n.d. Accessed April 7, 2021.
<https://www.latex-project.org/>.

</div>

<div id="ref-owidcoronavirus" class="csl-entry">

Max Roser, Esteban Ortiz-Ospina, Hannah Ritchie, and Joe Hasell. 2020.
“Coronavirus Pandemic (COVID-19).” *Our World in Data*.

</div>

<div id="ref-riederer_r_nodate" class="csl-entry">

Riederer, Emily, Christophe Dervieux. n.d. *R Markdown Cookbook*.
Accessed April 7, 2021.
<https://bookdown.org/yihui/rmarkdown-cookbook/>.

</div>

<div id="ref-noauthor_shiny_nodate" class="csl-entry">

“Shiny.” n.d. Accessed April 7, 2021. <https://shiny.rstudio.com/>.

</div>

<div id="ref-wickham_tidyverse_2019" class="csl-entry">

Wickham, Hadley, and RStudio. 2019. “Tidyverse: Easily Install and Load
the ’Tidyverse’.” <https://CRAN.R-project.org/package=tidyverse>.

</div>

<div id="ref-xie__aut_knitr_2021" class="csl-entry">

Xie \[aut, Yihui, cre, Adam Vogt, Alastair Andrew, Alex Zvoleff, Andre
Simon (the CSS files under inst/themes/ were derived from the Highlight
package http://www.andre-simon.de), Aron Atkins, et al. 2021. “Knitr: A
General-Purpose Package for Dynamic Report Generation in R.”
<https://CRAN.R-project.org/package=knitr>.

</div>

</div>

# Sobre este documento

## Contribuciones

-   Carlos Javier Rincon: Versión inicial
-   Andree Valle-Campos: Ediciones menores

Contribuciones son bienvenidas vía [pull
requests](https://github.com/reconhub/learn/pulls).

## Asuntos legales

**Licencia**: [CC-BY](https://creativecommons.org/licenses/by/3.0/)
**Copyright**: Carlos Javier Rincon, 2021

[1] información clave explicado **palabra**

[2] Para nuestro ejemplo, será el listado de localizaciones disponibles
en **data**.
