---
title: 'EurovisionBias, a tool to investigate voting patterns in the Eurovision Song Contest'
tags:
  - Eurovision
  - Collusion Detection
  - Voting System
  - Computational Social Science
  - Julia Lang
authors:
  - name: Alexander V. Mantzaris
    orcid: 0000-0002-0026-5725
    corresponding: true
    #equal-contrib: false
    affiliation: 1
  - name: Theodoros Panagiotakopoulos
    orcid: 0000-0002-4603-3110
    #equal-contrib: true # (This is how you can denote equal contributions between multiple authors)
    affiliation: 2
affiliations:
 - name: Department of Statistics and Data Science, University of Central Florida
   index: 1
 - name: Department of Physics, University of Central Florida
   index: 2
date: 28 February 2023
bibliography: paper.bib


---

# Summary

The Eurovision Song Contest (ESC) is one of the largest annual events
on the planet gathering hundreds of millions of viewers for a single broadcasting.
It involves a set of participating countries to send representative musicians to
display an expression of music and then have the rest of the countries allocate a score.
Over the years it has been speculated that some countries have not voted soley based
upon artistic merit but have been biased by national preferences. There has also
been speculation that collusion takes place where points are reciprocated in order
signal a mutual sentiment via the ESC platform. A need to be able to analyze the score
data exists, and to progress the study of identifying biases in general.

# Statement of need

`EurovisionBias` is a tool to help social scientists examine the voting biases
present in the ESC competition's historical score data. Understanding biases in this competition
has been noted as being important by prominent political scientists who put
forward anthropological theories for how large scale affiliations evolve [@yair1995unite].
This methodological implementation is also important to investigate how in general biases
and collusion in voting systems can be studied and how taking a network approach
can be useful [@ginsburgh2008eurovision].

The user can produce an analysis of the
data by supplying a starting year, and end year, a period of the time window, and
a p-value for the statistical significance of each association. The changes in
the voting schemes which changed are accounted for as well as the absence of a
country for a subset of the years in the time period. For the years selected,
the tool looks at the number of countries that participated for each year and the voting
scheme that is applicable to calculate a significance threshold $s_{\alpha,\mathbf{T}}$.
This is done via a Monte Carlo simulation of the null hypothesis of countries voting
uniformly. With the threshold each country voting pattern can be compared via
$$E_{i\rightarrow j,\mathbf{T}} = \sum^{\mathbf{T}}_{t=\mathbf{T}[1]}(c_{i\rightarrow j,t}> s_{\alpha,\mathbf{T}}).$$

Details about the equations implemented in this tool can be found in
[@mantzaris2018preference] and [@mantzaris2017examining].
The results produced are a set of scatter plots for the votes a country received/delegated
with the number of biased associations received/delegated and the accompanying network diagrams.
The network diagrams have countries as nodes and the associations as edges.
The types of edges investigated are single directed biases (directed blue edges),
and collusive biases (bi-directional blue edges). This software takes the unique approach
of also calculating the negative side of the distribution representing 'neglect'
with red edges (directed for one-way and mutual neglect with bi-directional edges).
Since the time of the methodological exploration publications this package has undergone changes so
that the users can run the tool using a single command and have all the models run for the
selected time periods.

This tool is written in Julia Lang [@bezanson2017julia] and uses graphviz [@ellson2004graphviz]
for the production of the networks of bias. It has been tested using version 1.8 of Julia and
having graphviz installed on a Linux system. The program can be started by starting the Julia
REPL, including the main script via `include("main.jl")`, and then running `main(1980,1990,5,0.05)`.
This will run and analyze the data for the years 1980 till 1990 with 2 consecutive time windows
of 5 years each. The last argument (0.05) is the pvalue for the significance of the biased associations 
to be included in the results, where each association is represented as an edge in the graph
connecting ESC participants. 


# Citations

[rMarkdown](http://rmarkdown.rstudio.com/authoring_bibliographies_and_citations.html)
