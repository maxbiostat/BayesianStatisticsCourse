# Bayesian Statistics
A PhD-level course at [EMAp](https://emap.fgv.br/en).

Syllabus [here](https://emap.fgv.br/disciplina/doutorado/estatistica-bayesiana) and tentative programme [here](https://docs.google.com/spreadsheets/d/1kuE-_NeSQzaBNnWc9vezXSbKfSIGQoLdmmb2zRDbOng/edit?usp=sharing). 

To compile the [slides](https://github.com/maxbiostat/BayesianStatisticsCourse/blob/main/slides/bayes_stats.pdf), you'll need to do

```bash
pdflatex -interaction=nonstopmode --shell-escape bayes_stats
```
a few times to get it right. 

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

### Acknowledgements
[Guido Moreira](http://github.com/GuidoAMoreira/) suggested topics, exercises and exam questions.

# Syllabus
## Lecture 0: Overview
- The LaplacesDemon introductory [vignette](https://cran.r-project.org/web/packages/LaplacesDemon/vignettes/BayesianInference.pdf) gives a very nice overview of Bayesian Statistics.
- [What is a statistical model?](https://projecteuclid.org/journals/annals-of-statistics/volume-30/issue-5/What-is-a-statistical-model/10.1214/aos/1035844977.full) by Peter McCullagh gives a good explanation of what a statistical model is. See also BC Ch1.
- There are a few [Interpretations of Probability](https://plato.stanford.edu/entries/probability-interpret/) and its important to understand them so the various schools of statistical inference make sense. 
- [WHAT IS BAYESIAN/FREQUENTIST INFERENCE?](https://normaldeviate.wordpress.com/2012/11/17/what-is-bayesianfrequentist-inference/) by [Larry Wasserman](https://www.stat.cmu.edu/~larry/) is a must read in order to understand what makes each inference paradigm tick.
- This [cross-validated post](https://stats.stackexchange.com/questions/444080/a-measure-theoretic-formulation-of-bayes-theorem) has a very nice, measure-theoretic proof of Bayes's theorem.

## Lecture 1: Principled Inference, decision-theoretical foundations

- Berger and Wolpert's 1988 [monograph](https://errorstatistics.files.wordpress.com/2016/04/berger-wolpert-1988.pdf) is the definitive text on the [Likelihood Principle](https://en.wikipedia.org/wiki/Likelihood_principle) (LP).
- See [this](https://arxiv.org/pdf/1906.10733.pdf) paper By Franklin and Bambirra for a generalised version of the LP.
- As advanced reading, one can consider [Birnbaum (1962)](https://www.tandfonline.com/doi/abs/10.1080/01621459.1962.10480660) and a helpful review [paper](https://link.springer.com/content/pdf/10.1007/978-1-4612-0919-5_31.pdf) published 30 years later by Bjornstad.
- Michael Evans has a few papers on the LP. See [Evans, Fraser & Monette (1986)](https://errorstatistics.files.wordpress.com/2017/12/evans-fraser-monette-1986.pdf) for an argument using a stronger version of CP and [Evans, 2013](https://projecteuclid.org/journals/electronic-journal-of-statistics/volume-7/issue-none/What-does-the-proof-of-Birnbaums-theorem-prove/10.1214/13-EJS857.full) for a flaw with the original 1962 paper by Birnbaum. 

## Lecture 2: Belief functions, coherence, exchangeability

- David Alvarez-Melis and Tamara Broderick were kind enough to provide an [English translation](https://arxiv.org/abs/1512.01229) of De Finetti's seminal 1930 [paper](http://www.brunodefinetti.it/Opere/funzioneCaratteristica.pdf).
-  [Heath and Sudderth (1976)](https://www.tandfonline.com/doi/abs/10.1080/00031305.1976.10479175?journalCode=utas20) provide a simpler proof of De Finetti's representation theorem for binary variables.

## Lecture 3: Priors I: rationale and construction; conjugate analysis
- The [SHeffield ELicitation Framework (SHELF)](http://tonyohagan.co.uk/shelf/) is a package for rigorous elicitation of probability distributions.
- John Cook provides a nice [compendium](https://www.johndcook.com/CompendiumOfConjugatePriors.pdf) of conjugate priors by Daniel Fink.

## Lecture 4: Priors II: types of priors; implementation
**Required reading**
- [Hidden Dangers of Specifying Noninformative Priors](https://www.tandfonline.com/doi/abs/10.1080/00031305.2012.695938) is a must-read for those who wish to understand the counter-intuitive nature of prior measures and their push-forwards.
- [The Prior Can Often Only Be Understood in the Context of the Likelihood](https://www.mdpi.com/1099-4300/19/10/555) explains that, from a practical perspective, priors can be seen as regularisation  devices and should control what the model _does_ rather than what values the parameter takes.
- [Penalising Model Component Complexity: A Principled, Practical Approach to Constructing Priors](https://projecteuclid.org/journals/statistical-science/volume-32/issue-1/Penalising-Model-Component-Complexity--A-Principled-Practical-Approach-to/10.1214/16-STS576.full) shows how to formalise the idea that one should prefer a simpler model by penalising deviations from a base model.

**Optional reading**
- [The Case for Objective Bayesian Analysis](https://www.ime.usp.br/~abe/lista/pdfTFOW5ADDD0.pdf) is a good read to try and put objective Bayes on solid footing. 

## Lecture 5: Bayesian point estimation
- The paper [The Federalist Papers As a Case Study](https://link.springer.com/chapter/10.1007/978-1-4612-5256-6_1) by Mosteller and Wallace (1984) is a very nice example of capture-recapture models. It is cited in Sharon McGrayne's book ["The Theory That Would Not Die"](https://www.amazon.com/Theory-That-Would-Not-Die/dp/0300188226) as triumph of Bayesian inference. It is also a serious contender for coolest paper abstract ever. 
- [This](https://statmodeling.stat.columbia.edu/2011/01/31/using_sample_si/) post in the Andrew Gelman blog discusses how to deal with the sample size (`n`) in a Bayesian problem: either write out a full model that specifies a probabilistic model for `n`  or write an approximate prior pi(theta|n).

## Lecture 6: Bayesian Testing I
**Required reading** 
- In their seminal 1995 [paper](https://www.tandfonline.com/doi/abs/10.1080/01621459.1995.10476572), [Robert Kass](http://www.stat.cmu.edu/people/faculty/rob-kass) and [Adrian Raftery](https://sites.stat.washington.edu/raftery/) give a nice overview of, along with recommendations for, Bayes factors.

**Optional reading**
- [This](https://arxiv.org/pdf/1303.5973.pdf) paper by Christian Robert gives a nice discussion of the Jeffreys-Lindley paradox.
- [Jaynes](https://en.wikipedia.org/wiki/Edwin_Thompson_Jaynes)'s 1976 monograph [Confidence Intervals vs Bayesian Intervals](https://link.springer.com/chapter/10.1007/978-94-009-6581-2_9) is a great source of useful discussion. [PDF](https://link.springer.com/content/pdf/10.1007/978-94-010-1436-6_6.pdf).

## Lecture 7: Bayesian Testing II
- [This](https://www.tandfonline.com/doi/pdf/10.1080/00031305.1999.10474443?casa_token=PvYUGVh0CjwAAAAA:B6UnfgSkoeUNQ5g4nh-D0DxaLTLAOOuoa2I37u33xdxIlair84fSzUuKUcsnHlC24BjRlfWWEcgZ3Q) paper by Lavine and Schervish provides a nice "disambiguation" for what Bayes factors can and cannot do inferentially.
- [Yao et al. (2018)](https://projecteuclid.org/journals/bayesian-analysis/volume-13/issue-3/Using-Stacking-to-Average-Bayesian-Predictive-Distributions-with-Discussion/10.1214/17-BA1091.full) along with ensuing discussion is a must-read for an understanding of modern prediction-based Bayesian model comparison.

## Lecture 8: Asymptotics

- The [entry](https://encyclopediaofmath.org/wiki/Bernstein-von_Mises_theorem) on the Encyclopedia of Mathematics on the Bernstein-von Mises theorem is nicely written. 
- The integrated nested Laplace approximation ([INLA](https://www.r-inla.org/)) methodology leverages Laplace approximations to provide accurate approximations to the posterior in latent Gaussian models, which cover a huge class of models used in applied modelling. [This](https://arxiv.org/pdf/1210.0333.pdf) by Thiago G. Martins and others, specially section 2, is a good introduction.

## Lecture 9: Applications I

- Ever wondered what to do when both the number of trials and success probability are unknown in a binomial model? Well, [this](https://pluto.mscc.huji.ac.il/~galelidan/52558/Material/Raftery.pdf) paper by Adrian Raftery has _an_ answer. See also [this](https://stats.stackexchange.com/questions/113851/bayesian-estimation-of-n-of-a-binomial-distribution) discussion with JAGS and Stan implementations.
- [This](https://mc-stan.org/users/documentation/case-studies/golf.html) case study shows how to create a model from first (physical) principles.

## Lecture 10: Applications II
- See [Reporting Bayesian Results](https://journals.sagepub.com/doi/abs/10.1177/0193841X20977619?journalCode=erxb) for a guide on which summaries are indispensable in a Bayesian analysis.
-  [Visualization in Bayesian workflow](https://rss.onlinelibrary.wiley.com/doi/abs/10.1111/rssa.12378) is a great paper about making useful graphs for a well-calibrated Bayesian analysis.

## Lecture 11: Discussion Bayes vs Frequentism
**Disclaimer**: everything in this section needs to be read with care so one does not become a zealot!

- See Jayne's monograph above.
- See [Frequentism and Bayesianism: A Practical Introduction](https://jakevdp.github.io/blog/2014/03/11/frequentism-and-bayesianism-a-practical-intro/) for a five-part discussion of the Bayesian vs Orthodox statistics.
- [Why isn't everyone a Bayesian?](https://www2.stat.duke.edu/courses/Spring10/sta122/Handouts/EfronWhyEveryone.pdf) is a nice discussion of the trade-offs between paradigms by [Bradley Efron](https://statweb.stanford.edu/~ckirby/brad/).
- [Holes in Bayesian statistics](https://iopscience.iop.org/article/10.1088/1361-6471/abc3a5#:~:text=Here%20are%20a%20few%20holes,Bayes%20factors%20fail%20in%20the) is a collection of holes in Bayesian data analysis, such as conditional probability in the quantum real, flat and weak priors, and model checking, written by Andrew Gelman and Yuling Yao.
- [Bayesian Estimation with Informative Priors is Indistinguishable from Data Falsification](https://www.cambridge.org/core/journals/spanish-journal-of-psychology/article/bayesian-estimation-with-informative-priors-is-indistinguishable-from-data-falsification/FFAB96BDC5EE3C64B144ECF8F90F31E9) is paper that attempts to draw a connection between strong priors and data falsification. Not for the faint of heart. 
