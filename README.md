<img src="title.gif" width="500"/>

# Study group based on the Statistical Rethinking book and course

Instructor of the original course: Richard McElreath

Discussion: Wednesdays 2pm-4pm at the Kokomo room

# Purpose

This course teaches data analysis, but it focuses on scientific models. The unfortunate truth about data is that nothing much can be done with it, until we say what caused it. We will prioritize conceptual, causal models and precise questions about those models. We will use Bayesian data analysis to connect scientific models to evidence. And we will learn powerful computational tools for coping with high-dimension, imperfect data of the kind that biologists and social scientists face.

In our study group, I intend to add hands-on analysis and simulation based on datasets of the people participating, and extending the disucssion in aspects that are more applicable to ecological problems. I also would like to make the parallels between bayesian analysis and methods people are more familiar with, I think that will make it easier to understand the material.

# Format

Online, flipped instruction. We will use the book and lectures available on youtube, and complement with a discussion and some hands-on activity each week.

We'll use the 2nd edition of the \<[Statistical Rethinking](https://xcelab.net/rm/statistical-rethinking/)\> book and the lectures available on youtube: \<[Statistical Rethinking 2023 Playlist](https://www.youtube.com/watch?v=FdnMWdICdRs&list=PLDcUM9US4XdPz-KxHM4XHt7uUVGWWVSus)\>

# Calendar & Topical Outline

| Week       | Chapter | Lectures                                                                                                                                                                                                             |
|-----------------|-----------------|---------------------------------------|
| 11/10/2023 | 1       | \<[Science Before Statistics](https://www.youtube.com/watch?v=FdnMWdICdRs&list=PLDcUM9US4XdPz-KxHM4XHt7uUVGWWVSus&index=1)\> \<[Slides](https://speakerdeck.com/rmcelreath/statistical-rethinking-2023-lecture-01)\> |
| 18/10/2023 | 2       | \<[Garden of Forking Data](https://www.youtube.com/watch?v=R1vcdhPBlXA&list=PLDcUM9US4XdPz-KxHM4XHt7uUVGWWVSus&index=2)\> \<[Slides](https://speakerdeck.com/rmcelreath/statistical-rethinking-2023-lecture-02)\>    |
| 25/10/2023 | 3       | \<[Garden of Forking Data](https://www.youtube.com/watch?v=R1vcdhPBlXA&list=PLDcUM9US4XdPz-KxHM4XHt7uUVGWWVSus&index=2)\> \<[Slides](https://speakerdeck.com/rmcelreath/statistical-rethinking-2023-lecture-02)\>    |
| 01/11/2023 |         |                                                                                                                                                                                                                      |
| 08/11/2023 |         |                                                                                                                                                                                                                      |
| 15/11/2023 |         |                                                                                                                                                                                                                      |
| 22/11/2023 |         |                                                                                                                                                                                                                      |
| 29/11/2023 |         |                                                                                                                                                                                                                      |
| 06/12/2023 |         |                                                                                                                                                                                                                      |
| 13/12/2023 |         |                                                                                                                                                                                                                      |

# Coding

This course involves a lot of scripting. Students can engage with the material using either the original R code examples or one of several conversions to other computing environments. The conversions are not always exact, but they are rather complete. Each option is listed below.

Do note I'll be using the original R flavor, and if people are interested, use *stan* directly as much as possible instead of the functions in the *rethinking* package. I might also use *brms* in some instances, as it's a much more simple package implementing similar bayesian methods in an *lme4*-like syntax.

## Original R Flavor

For those who want to use the original R code examples in the print book, you need to install the `rethinking` R package. The code is all on github <https://github.com/rmcelreath/rethinking/> and there are additional details about the package there, including information about using the more-up-to-date `cmdstanr` instead of `rstan` as the underlying MCMC engine.

## R + Tidyverse + ggplot2 + brms

The \<[Tidyverse/brms](https://bookdown.org/content/4857/)\> conversion is very high quality and complete through Chapter 14.

## Python and PyMC3

The \<[Python/PyMC3](https://github.com/pymc-devs/resources/tree/master/Rethinking_2)\> conversion is quite complete.

## Julia and Turing

The \<[Julia/Turing](https://github.com/StatisticalRethinkingJulia)\> conversion is not as complete, but is growing fast and presents the Rethinking examples in multiple Julia engines, including the great \<[TuringLang](https://github.com/StatisticalRethinkingJulia/TuringModels.jl)\>.

## Other

The are several other conversions. See the full list at <https://xcelab.net/rm/statistical-rethinking/>.

# Homework and solutions

I will also post problem sets and solutions. Check the folders at the top of the repository.
