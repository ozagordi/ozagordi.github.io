---
layout: post
title: Breaking ground
author: Osvaldo
header-img: "img/crack.jpg"
tags: [mathematics, dataviz, d3]
customjs:
  - https://d3js.org/d3.v3.js
---


Some weeks ago I read a nice [article](http://www.nature.com/news/majority-of-mathematicians-hail-from-just-24-scientific-families-1.20491)
by Davide Castelvecchi on Nature News. It reports an analysis done on the
[Mathematics Genealogy Project](http://genealogy.math.ndsu.nodak.edu/), a database
aiming to list present and past mathematicians together with their advisor, in
order to build a _family tree_ of the advisor-advisee relationships. This
analysis shows that two thirds of all mathematicians present in the database can
be assigned to one of only 24 families, the biggest of which founded by the
Italian mathematician (physician and natural philosopher)
Sigismondo Polcastro, who lived between 14th and 15th century.

Although some physicists are present in MGP (where do you draw the line between
physics and mathematics, after all?) I don't have a genealogy myself, but
I had already explored the database in the past. After reading this report I
was more motivated into going really back in time by clicking multiple times on the
**Advisor** link and see if I could really end up on
[Euler](https://genealogy.math.ndsu.nodak.edu/id.php?id=38586) (over 96 thousand
descendants). While doing so I stumbled upon many many names that you learn
studying calculus, and all very closely connected to each other, something I
had not previously realized.

So I decided to save some of these advisor-advisee relationship and plot them
as a directed graph with [d3](https://d3js.org). The result is below,
an arrow from A to B means _A was advisor of B_.
You can (and probably have to) drag the points around to clarify some links.

<div id="d3graph"></div>

<style>

.box {
  font: 10px sans-serif;
}

.node {
    fill: #657b83;
    opacity: 0.4;
}
.node text {
    fill: #000;
    pointer-events: none;
    font: 13px sans-serif;
}
.link {
    stroke: #657b83;
    stroke-opacity: .7;
}
</style>

<script type="text/javascript" src="https://d3js.org/d3.v3.js"></script>

<script>
var links = [
    {source: "Marin Mersenne", target: "Blaise Pascal"},
    {source: "Marin Mersenne", target: "Frans van Schooten, Jr."},
    {source: "Frans van Schooten, Jr.", target: "Christiaan Huygens"},
//    {source: "Frans van Schooten, Jr.", target: "Johan de Witt"},
    {source: "Christiaan Huygens", target: "Gottfried W. Leibniz"},
    {source: "Gottfried W. Leibniz", target: "Nicolas Malebranche"},
    {source: "Nicolas Malebranche", target: "Jakob Bernoulli"},
    {source: "Jakob Bernoulli", target: "Nikolaus (I) Bernoulli"},
    {source: "Jakob Bernoulli", target: "Johann Bernoulli"},
    {source: "Johann Bernoulli", target: "Daniel Bernoulli"},
    {source: "Johann Bernoulli", target: "Leonhard Euler"},
    {source: "Leonhard Euler", target: "Joseph-Louis Lagrange"},
    {source: "Giovanni B. Beccaria", target: "Joseph-Louis Lagrange"},
    {source: "Joseph-Louis Lagrange", target: "Jean-Baptiste Fourier"},
    {source: "Joseph-Louis Lagrange", target: "Simeon D. Poisson"},
    {source: "Pierre-Simon Laplace", target: "Simeon D. Poisson"},
    {source: "Jean-Baptiste Fourier", target: "Gustav Dirichlet"},
    {source: "Simeon D. Poisson", target: "Gustav Dirichlet"},
    {source: "Simeon D. Poisson", target: "Joseph Liouville"},
    {source: "Jean-Baptiste Fourier", target: "Giovanni A. A. Plana"},
    {source: "Joseph-Louis Lagrange", target: "Giovanni A. A. Plana"},
    {source: "Gustav Dirichlet", target: "August Kramer"},
    {source: "Gustav Dirichlet", target: "Leopold Kronecker"},
    {source: "Gustav Dirichlet", target: "Rudolf Lipschitz"},
    {source: "Rudolf Lipschitz", target: "C. Felix Klein"}
];

var nodes = {};

// Compute the distinct nodes from the links.
links.forEach(function(link) {
  link.source = nodes[link.source] || (nodes[link.source] = {name: link.source});
  link.target = nodes[link.target] || (nodes[link.target] = {name: link.target});
});

var width = 740,
    height = 800;

var force = d3.layout.force()
    .nodes(d3.values(nodes))
    .links(links)
    .size([width, height])
    .linkDistance(55)
    .charge(-900)
    .start();

//var svg = d3.select("body")
var svg = d3.select("#d3graph")
		.append("svg")
    .attr("class", "box")
    .attr("width", width)
    .attr("height", height);

//Create all the line svgs but without locations yet
var link = svg.selectAll(".link")
    .data(force.links())
    .enter().append("line")
    .attr("class", "link")
    .style("marker-end",  "url(#advisor)"); //Added


var node = svg.selectAll(".node")
    .data(force.nodes())
    .enter().append("g")
    .attr("class", "node")
    .call(force.drag);

node.append("circle")
    .attr("r", 4)

node.append("text")
      .attr("dx", 8)
      .attr("dy", ".85em")
      .text(function(d) { return d.name });

force.on("tick", function () {

    link.attr("x1", function (d) {
        return d.source.x;
    })
        .attr("y1", function (d) {
        return d.source.y;
    })
        .attr("x2", function (d) {
        return d.target.x;
    })
        .attr("y2", function (d) {
        return d.target.y;
    });

    d3.selectAll("circle").attr("cx", function (d) {
        return d.x;
    })
        .attr("cy", function (d) {
        return d.y;
    });

    d3.selectAll("text").attr("x", function (d) {
        return d.x;
    })
        .attr("y", function (d) {
        return d.y;
    });

});

// this defines the marker-end programmatically
svg.append("defs").selectAll("marker")
    .data(["advisor"])
  .enter().append("marker")
    .attr("id", function(d) { return d; })
    .attr("viewBox", "0 -1 2 2")
    .attr("refX", 2)
    .attr("refY", 0)
    .attr("markerWidth", 6)
    .attr("markerHeight", 6)
    .attr("orient", "auto")
  .append("path")
    .attr("d", "M0,-1 L2,0 L0,1 z")
    //.style("stroke", "#f00")
    .style("fill", "#268bd2")
    .style("opacity", "1.0");
</script>

The selection of nodes is completely arbitrary, I only saved nodes that
somehow struck me because something important in mathematics is named after
them.

There should be other interesting cliques in the database. For example, where
are Gauss, Riemann, Dedekind? And waht about Cauchy and Hilbert?

#### Technical notes

I found the following links useful to draw the network:

- An A to Z of extra features for the D3 force layout, a
  [tutorial](http://www.coppelia.io/2014/07/an-a-to-z-of-extra-features-for-the-d3-force-layout/)
  by Simon Raper,
- a [question](http://stackoverflow.com/questions/22651346/how-to-embed-a-d3-js-example-to-the-jekyll-blog-post)
  on Stack Overflow, _How to embed d3 in a jekyll blog post_ and references therein.
- Last but not least, [this](http://stackoverflow.com/questions/13865606/append-svg-canvas-to-element-other-than-body-using-d3) helped me correct a fundamental mistake I was making in
  selecting the relevant html element.

_Header image from [Flickr](https://flic.kr/p/xZjJW)_
