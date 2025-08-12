console.log("Arrancamos el script");
d3.json("https://gist.githubusercontent.com/double-thinker/817b155fd4fa5fc865f7b32007bd8744/raw/13068b32f82cc690fb352f405c69c156529ca464/partidos2.json").then(function (datosCompletos) {

    var datosPartidos = datosCompletos.partidos;

    // definimos anchura y altura del contenedor
    var width = 400;
    var height = 600;

    // variable para que se vean los círculos íntegramente
    var margen = {
        arriba: 60,
        abajo:35,
        izquierda:40,
        derecha:50
    }

    // Escala del eje X
    var escalaX = d3.scaleLinear()
        .domain([0, 10])
        .range([margen.izquierda, width-margen.derecha])

    // Escala del eje Y
    var escalaY = d3.scaleLinear()
        .domain(d3.extent(datosPartidos, function(d){return d.votantes}))
        .range([height - margen.abajo, margen.arriba])

    // Creamos escala de color
    var escalaColor = d3.scaleLinear()
        .domain([0,10])
        .range(["red", "blue"])

    // Creamos escala de tamaño
    var escalaTamano = d3.scaleLinear()
        .domain(d3.extent(datosPartidos, function(d){return d.votantes}))
        .range([5,50])

    // Creamos el contenedor SVG
    var dibujoSVG = d3.select("body")
        .append("svg")
        .attr("id", "miSVG_d3")
        .attr("width", width)
        .attr("height", height)

    // Hacemos el join de los datos con los círculos
    dibujoSVG.selectAll("circle")
        .data(datosPartidos)
        .join("circle")
        .attr("cx", function(d){return escalaX(d.mediaAutoubicacion)})
        .attr("cy", function(d){return escalaY(d.votantes)})
        .attr("r", function(d){return escalaTamano(d.votantes)})
        .attr("fill", function(d){return escalaColor(d.mediaAutoubicacion)})
        // definomos el evento de cada círculo
        .on("click", (event, d) => pintarHistograma(d.partido))
        // tooltips
        .on("mouseover", (event, d) => pintarTooltip(event, d))
        .on("mouseout", borrarTooltip)

    // Definimos variable tooltip
    var tooltip = d3.select("body")
        .append("div")
        .attr("class", "tooltip")

    // Hacemos el eje X
    var ejeX = d3.axisBottom(escalaX)
    dibujoSVG.append("g")
        .attr("transform", "translate (0," + (height - margen.arriba/2) + ")")
        .call(ejeX)

    // Hacemos el eje Y
    var ejeY = d3.axisLeft(escalaY)
    dibujoSVG.append("g")
        .attr("transform", "translate (" + margen.izquierda + ",0)")
        .call(ejeY)
    
    // Creamos el Histograma de la derecha
    var svgHistograma = d3.select("body")
        .append("svg")
        .attr("width", width)
        .attr("height", height)
        .attr("id", "svgHistograma")

    // definimos ejeX
    var ejeXHistograma = d3.axisBottom(escalaX)
        .ticks(5) //controlamos el número de intervalos
        .tickFormat(d3.format(".3s")) // número de números con decimales

    svgHistograma.append("g")
        .attr("transform", "translate (0," + (height - margen.arriba / 2) + ")")
        .call(ejeXHistograma);

    // ejeY
    var gEjeYHistograma = svgHistograma.append("g")
        .attr("transform", "translate (" + margen.izquierda + ",0)")

    // Creamos la función pintarHistograma
    function pintarHistograma(partidoseleccionado) {
        // Qué datos a usar
        var datosHistograma = datosCompletos.histogramas[partidoseleccionado]

        // Seguimos con la escala Y dinámica
        var escalaYHistograma = d3.scaleLinear()
            .domain(d3.extent(datosHistograma, d => d.y))
            .range([height - margen.abajo, 0 + margen.arriba]);
        
        // Creamos el ejeY
        var ejeYHistograma = d3.axisLeft(escalaYHistograma)
            .ticks(5)
            .tickFormat(d3.format(".3s"));

        // Pintamos la escala Y
        gEjeYHistograma
            .transition()
            .delay(500)
            .ease(d3.easeBounce)
            .call(ejeYHistograma)

        // Pintamos los círculos
        svgHistograma 
            .selectAll("circle")
            .data(datosHistograma)
            .join("circle")
            // Añadimos animación
            .transition()
            .duration(1000)
            .ease(d3.easeElastic.period(0.4))
            .attr("r", d => escalaTamano(d.y))
            .attr("cx", d => escalaX(d.x))
            .attr("cy", d => escalaYHistograma(d.y))
            .attr("fill", d => escalaColor(d.x));
        
        // Borrado de texto
        svgHistograma.select(".title-label").remove()

        // Añadimos los nombres del partido político
        svgHistograma.append("text")
            .attr("class", "title-label")
            .attr("x", (width / 2))
            .attr("y", height)
            .attr("text-anchor", "middle")
            .style("font-size", "16px")
            .style("text-decoration", "underline")
            .text(function (d) { return partidoseleccionado; });
    }

      // Funciones para que aparezca y desaparezca el tooltip

    function borrarTooltip() {
        tooltip.style("opacity", 0)
    }

    function pintarTooltip(event, d) {
        tooltip.text(d.partido + ": " + d.mediaAutoubicacion)
            .style("top", event.y + "px")
            .style("left", event.x + "px")
            .style("opacity", 1)
    }

});
