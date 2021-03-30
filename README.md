# Bayesian Statistics
A PhD-level course at [EMAp](https://emap.fgv.br/en).

Syllabus [here](https://emap.fgv.br/disciplina/doutorado/estatistica-bayesiana) and tentative programme [here](https://docs.google.com/spreadsheets/d/1kuE-_NeSQzaBNnWc9vezXSbKfSIGQoLdmmb2zRDbOng/edit?usp=sharing). 

## Pre-requisites
- Probability theory with measure. [Jeff Rosenthal](http://probability.ca/jeff/)'s book, [A First Look at Rigorous Probability Theory](http://probability.ca/jeff/grprobbook.html), is a good resource.
- Classical Statistics at the same level as [Mathematical Statistics](https://emap.fgv.br/disciplina/doutorado/mathematical-statistics). For a review, I suggest 
[Theory of Statistics](https://www.springer.com/gp/book/9780387945460) by [Mark Schervish](http://www.stat.cmu.edu/people/faculty/mark-schervish). 

# Books
- [The Bayesian Choice](https://link.springer.com/book/10.1007/0-387-71599-1) (BC) by [Christian Robert](https://stats.stackexchange.com/users/7224/xian) will be our main source.
- [A first course in Bayesian statistical methods](https://pdhoff.github.io/book/) (FC) by [Peter Hoff](https://stat.duke.edu/research/hoff#:~:text=Hoff,-Professor%20of%20Statistical&text=Peter%20Hoff%20develops%20statistical%20methodology,area%20inference%2C%20and%20multigroup%20analysis.) is a good all-purpose introduction. 
- [Bayesian Theory](https://onlinelibrary.wiley.com/doi/book/10.1002/9780470316870) (BT) by [José Bernardo](https://www.uv.es/bernardo/) and [Adrian Smith](https://en.wikipedia.org/wiki/Adrian_Smith_(statistician)) is a technical behemoth, suitable for use as a reference guide. 

# Resources
- An overview of computing techniques for Bayesian inference can be found [here](https://arxiv.org/pdf/2004.06425.pdf).
- See Esteves, Stern and Izbicki's [course notes](https://github.com/rbstern/bayesian_inference_book/raw/gh-pages/book.pdf).
- Rafael Stern's excellent [course](https://www.rafaelstern.science/classes/2021_1_bayes/).
- [Principles of Uncertainty](https://www.taylorfrancis.com/books/principles-uncertainty-joseph-kadane/10.1201/9781315167565) by the inimitable [J. Kadane](https://en.wikipedia.org/wiki/Joseph_Born_Kadane) is a book about avoiding being a sure loser. See [this](https://www.ceremade.dauphine.fr/~xian/uncertain.pdf) review by Christian Robert.
- [Bayesian Learning](https://github.com/mattiasvillani/BayesLearnCourse) by [Mattias Vilani](mattiasvillani.com) is a book for a computation-minded audience. 
- Michael Betancourt's website is a treasure trove of rigorous, modern and insightful applied Bayesian statistics. See [this](https://betanalpha.github.io/assets/case_studies/principled_bayesian_workflow.html#1_Questioning_Authority) as a gateway drug.

# Syllabus
## Lecture 0: Overview
- The LaplacesDemon introductory [vignette](https://cran.r-project.org/web/packages/LaplacesDemon/vignettes/BayesianInference.pdf) gives a very nice overview of Bayesian Statistics.
- [What is a statistical model?](https://projecteuclid.org/journals/annals-of-statistics/volume-30/issue-5/What-is-a-statistical-model/10.1214/aos/1035844977.full) by Peter McCullagh gives a good explanation of what a statistical model is. See also BC Ch1.
- There are a few [Interpretations of Probability](https://plato.stanford.edu/entries/probability-interpret/) and its important to understand them so the various schools of statistical inference make sense. 
- [WHAT IS BAYESIAN/FREQUENTIST INFERENCE?](https://normaldeviate.wordpress.com/2012/11/17/what-is-bayesianfrequentist-inference/) by [Larry Wasserman](https://www.stat.cmu.edu/~larry/) is a must read in order to understand what makes each inference paradigm tick.

## Lecture 1: Principled Inference, decision-theoretical foundations

- Berger and Wolpert's 1988 [monograph](https://errorstatistics.files.wordpress.com/2016/04/berger-wolpert-1988.pdf) is the definitive text on the [Likelihood Principle](https://en.wikipedia.org/wiki/Likelihood_principle) (LP).
- See [this](https://arxiv.org/pdf/1906.10733.pdf) paper By Franklin and Bambirra for a generalised version of the LP.
- As advanced reading, one can consider [Birnbaum (1962)](https://www.tandfonline.com/doi/abs/10.1080/01621459.1962.10480660) and a helpful review [paper](https://link.springer.com/content/pdf/10.1007/978-1-4612-0919-5_31.pdf) published 30 years later by Bjornstad.
- Michael Evans has a few papers on the LP. See [Evans, Fraser & Monette (1986)](https://errorstatistics.files.wordpress.com/2017/12/evans-fraser-monette-1986.pdf) for an argument using a stronger version of CP and [Evans, 2013](https://projecteuclid.org/journals/electronic-journal-of-statistics/volume-7/issue-none/What-does-the-proof-of-Birnbaums-theorem-prove/10.1214/13-EJS857.full) for a flaw with the original 1962 paper by Birnbaum. 


## Lecture 2: Belief functions, coherence, exchangeability

- David Alvarez-Melis and Tamara Broderick were kind enough to provide an [English translation](https://arxiv.org/abs/1512.01229) of De Finetti's seminal 1930 [paper](http://www.brunodefinetti.it/Opere/funzioneCaratteristica.pdf).
-  [Heath and Sudderth (1976)](https://www.tandfonline.com/doi/abs/10.1080/00031305.1976.10479175?journalCode=utas20) provide a simpler proof of De Finetti's representation theorem for binary variables.

## Lecture 3: Priors I: rationale and construction
- The [SHeffield ELicitation Framework (SHELF)](http://tonyohagan.co.uk/shelf/) is a package for rigorous elicitation of probability distributions.
- John Cook provides a nice [compendium](https://www.johndcook.com/CompendiumOfConjugatePriors.pdf) of conjugate priors by Daniel Fink.


## Lecture 4: Priors II: types of priors; implementation, conjugate analysis

- [Hidden Dangers of Specifying Noninformative Priors](https://www.tandfonline.com/doi/abs/10.1080/00031305.2012.695938) is a must-read for those who wish to understand the counter-intuitive nature of prior measures and their push-forwards.
- [The Case for Objective Bayesian Analysis](https://www.ime.usp.br/~abe/lista/pdfTFOW5ADDD0.pdf) is a good read to try and put objective Bayes on solid footing. 

## Lecture 5: Bayesian point estimation

## Lecture 6: Bayesian interval estimation
- [Jaynes](https://en.wikipedia.org/wiki/Edwin_Thompson_Jaynes)'s 1976 monograph [Confidence Intervals vs Bayesian Intervals](https://link.springer.com/chapter/10.1007/978-94-009-6581-2_9) is a great source of useful discussion. [PDF](https://link.springer.com/content/pdf/10.1007/978-94-010-1436-6_6.pdf).

## Lecture 7: Bayesian Testing
- [This](https://www.tandfonline.com/doi/pdf/10.1080/00031305.1999.10474443?casa_token=PvYUGVh0CjwAAAAA:B6UnfgSkoeUNQ5g4nh-D0DxaLTLAOOuoa2I37u33xdxIlair84fSzUuKUcsnHlC24BjRlfWWEcgZ3Q) paper by Lavine and Schervish provides a nice "disambiguation" for what Bayes factors can and cannot do inferentially.

## Lecture 8: Asymptotics

## Lecture 9: Model choice

## Lecture 10: Applications
- See [Reporting Bayesian Results](https://journals.sagepub.com/doi/abs/10.1177/0193841X20977619?journalCode=erxb) for a guide on which summaries are indispensable in a Bayesian analysis.
-  [Visualization in Bayesian workflow](https://rss.onlinelibrary.wiley.com/doi/abs/10.1111/rssa.12378) is a great paper about making useful graphs for a well-calibrated Bayesian analysis.

## Lecture 11: Discussion Bayes vs Frequentism
**Disclaimer**: everything in this section needs to be read with care so one does not become a zealot!

- See Jayne's monograph above.
- See [Frequentism and Bayesianism: A Practical Introduction](https://jakevdp.github.io/blog/2014/03/11/frequentism-and-bayesianism-a-practical-intro/) for a five-part discussion of the Bayesian vs Orthodox statistics.
