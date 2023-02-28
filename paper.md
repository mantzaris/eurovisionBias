---
title: 'Foo Bar Zoo'
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
  - name: Author with no affiliation
    corresponding: true # (This is how to denote the corresponding author)
    affiliation: 3
affiliations:
 - name: Department of Statistics and Data Science, University of Central Florida
   index: 1
 - name: Department of Physics, University of Central Florida
   index: 2
date: 27 February 2023
bibliography: paper.bib

# Optional fields if submitting to a AAS journal too, see this blog post:
# https://blog.joss.theoj.org/2018/12/a-new-collaboration-with-aas-publishing
aas-doi: 10.3847/xxxxx <- update this with the DOI from AAS once you know it.
aas-journal: Astrophysical Journal <- The name of the AAS journal.
---

# Summary

The Eurovision Song Contest (ESC) is one of the largest annual events
on the planet gathering hundreds of millions of viewers for a single broadcasting.
It involves a set of participating countries to send representative musicians to
display an expression of music and then have the rest of the countries allocate a score.
Over the years it has been speculated that countries have not voted soley based
upon artistic merit but have been biased by national preferences. There has also
been speculation that collusion takes place where points are reciprocated in order
signal a mutual sentiment via the ESC platform.

# Statement of need

`EurovisionBias` is a tool to help social scientists examine the voting biases
present in the historical score data. Understanding biases in this competition
has been noted as being important by prominent political scientists who put
forward anthropological theories for how large scale affiliations evolve. This
study is also important for how in general biases and collusion in voting systems
can be studied and how taking a network approach can be useful.

The user can produce an analysis of the
data by supplying a starting year, and end year, a period of the time window, and
a p-value for the statistical significance of each association. The changes in
the voting schemes which changed are accounted for as well as the absence of a
country for a subset of the years in the time period. For the years selected,
the tool looks at the number of countries that participated for each year and the voting
scheme that is applicable to calculate a significance threshold $s_{\alpha,\mathbf{T}}$.
This is done via a Monte Carlo simulation of the null hypothesis of countries voting
uniformly. With the threshold each country voting pattern can be compared via



The results produced are a set of scatter plots for the votes a country received/delegated
with the number of biased associations received/delegated and network diagrams.
The network diagrams have countries as nodes and the associations as edges. The
types of edges investigated are single directed biases (directed blue edges),
and collusive (bi-directional blue edges) biases. This software takes the unique approach
of also calculated the negative side of the distribution representing 'neglect'
with red edges (directed for one-way and mutual neglect with bi-directional edges).

This tool is written in Julia Lang and uses graphviz for the production of
the networks of bias. It has been tested using version 1.8 and having graphviz installed
on a Linux system. 

`Gala` is an Astropy-affiliated Python package for galactic dynamics. Python
enables wrapping low-level languages (e.g., C) for speed without losing
flexibility or ease-of-use in the user-interface. The API for `Gala` was
designed to provide a class-based and user-friendly interface to fast (C or
Cython-optimized) implementations of common operations such as gravitational
potential and force evaluation, orbit integration, dynamical transformations,
and chaos indicators for nonlinear dynamics. `Gala` also relies heavily on and
interfaces well with the implementations of physical units and astronomical
coordinate systems in the `Astropy` package [@astropy] (`astropy.units` and
`astropy.coordinates`).

`Gala` was designed to be used by both astronomical researchers and by
students in courses on gravitational dynamics or astronomy. It has already been
used in a number of scientific publications [@Pearson:2017] and has also been
used in graduate courses on Galactic dynamics to, e.g., provide interactive
visualizations of textbook material [@Binney:2008]. The combination of speed,
design, and support for Astropy functionality in `Gala` will enable exciting
scientific explorations of forthcoming data releases from the *Gaia* mission
[@gaia] by students and experts alike.

# Mathematics


Double dollars make self-standing equations:

$$\Theta(x) = \left\{\begin{array}{l}
0\textrm{ if } x < 0\cr
1\textrm{ else}
\end{array}\right.$$

You can also use plain \LaTeX for equations
\begin{equation}\label{eq:fourier}
\hat f(\omega) = \int_{-\infty}^{\infty} f(x) e^{i\omega x} dx
\end{equation}
and refer to \autoref{eq:fourier} from text.

# Citations

Citations to entries in paper.bib should be in
[rMarkdown](http://rmarkdown.rstudio.com/authoring_bibliographies_and_citations.html)
format.
