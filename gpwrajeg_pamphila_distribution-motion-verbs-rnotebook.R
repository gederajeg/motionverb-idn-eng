#' ---
#' title: "R Notebook for *Quantitative Distribution of English and Indonesian Motion Verbs and Its Typological Implications: A case study with the English and Indonesian versions of the* Twilight *novel*"
#' author: '*by* [Gede Primahadi Wijaya RAJEG](https://udayananetworking.unud.ac.id/lecturer/880-gede-primahadi-wijaya-rajeg) <a itemprop="sameAs" content="https://orcid.org/0000-0002-2047-8621" href="https://orcid.org/0000-0002-2047-8621" target="orcid.widget" rel="noopener noreferrer" style="vertical-align:top;"><img src="https://orcid.org/sites/default/files/images/orcid_16x16.png" style="width:1em;margin-right:.5em;" alt="ORCID iD icon"></a>^[Universitas Udayana, Bali, Indonesia] & Utei Charaleghy PAMPHILA^[SIT Study Abroad Indonesia]'
#' output: 
#'   html_notebook:
#'     code_folding: show
#'     fig_caption: yes
#'     fig_width: 6
#'     number_sections: yes
#'     toc: yes
#'     toc_float: no
#' ---
#' 
## ----setup, include = FALSE, message = FALSE, warning = FALSE, echo = FALSE------------
knitr::opts_chunk$set(fig.width = 7,
                      fig.asp = 0.618,
                      fig.retina = 2,
                      dpi = 300,
                      dev = "pdf",
                      tidy = FALSE,
                      echo = TRUE)

library(tidyverse)
library(RColorBrewer) # for the plotting

#' 
#' 
#' **keywords**: *open science*; *open notebook*; *open data*; *R programming*; *motion verbs*; *English*; *Indonesian*; *lexicalisation patterns*; *semantic typology*; *quantitative linguistics*
#' 
#' # Load the frequency list data
#' 
#' Below are the codes to read in the frequency list data for the <span style="font-variant:small-caps;">manner</span> and <span style="font-variant:small-caps;">path</span> Verbs in the English and Indonesian versions of the novel [*Twilight*](https://en.wikipedia.org/wiki/Twilight_(Meyer_novel)). Readers need to install the [tidyverse](https://www.tidyverse.org) suit of R packages as the codes heavily use functionality from this package, in addition to the [RColorBrewer](https://cran.r-project.org/web/packages/RColorBrewer/index.html) package used in the visualisation codes.
#' 
## ----read-in-data, message = FALSE-----------------------------------------------------
# Read in the manner verbs data in English and Indonesian
manner_eng_tokens <- readr::read_tsv("data-joll/manner_eng_tokens.txt") %>% 
  arrange(desc(n), lemma)
manner_idn_tokens <- readr::read_tsv("data-joll/manner_idn_tokens.txt") %>% 
  arrange(desc(n), lemma)

# Read in the path verbs data in English and Indonesian
path_eng_tokens <- readr::read_tsv("data-joll/path_eng_tokens.txt")
path_idn_tokens <- readr::read_tsv("data-joll/path_idn_tokens.txt")

#' 
#' 
#' # Quantitative analyses
#' 
#' The main quantitative analyses include computing and comparing the type frequency, token frequency, and type-per-token ratio (TTR) of the English and Indonesian <span style="font-variant:small-caps;">manner</span> ([§\@ref(manner)](#manner)) and <span style="font-variant:small-caps;">path</span> ([§\@ref(path)](#path)) verbs.
#' 
#' The codes below generate the data frame as the input for all figures/plots in the paper.
#' 
## ----data-manner-path-plot-------------------------------------------------------------
mnr <- tibble(tokens = c(sum(manner_eng_tokens$n), sum(manner_idn_tokens$n)),
              perc_token = (tokens/sum(tokens)) * 100,
              type = c(nrow(manner_eng_tokens), nrow(manner_idn_tokens)),
              perc_type = (type/sum(type)) * 100,
              ttr = type/tokens,
              language = c("English", "Indonesian"),
              verb_type = "manner-verb")
pth <- tibble(tokens = c(sum(path_eng_tokens$n), sum(path_idn_tokens$n)),
              perc_token = (tokens/sum(tokens)) * 100,
              type = c(nrow(path_eng_tokens), nrow(path_idn_tokens)),
              perc_type = (type/sum(type)) * 100,
              ttr = type/tokens,
              language = c("English", "Indonesian"),
              verb_type = "path-verb")

#' 
#' The following codes combine the previous codes to generate data for extracting percentages of <span style="font-variant:small-caps;">manner</span> and <span style="font-variant:small-caps;">path</span> verbs out of the total motion verbs in English and Indonesian.
#' 
## ----data-manner-path-proportion-------------------------------------------------------
mnr_pth <- bind_rows(mnr, pth) %>% 
  group_by(language) %>% 
  mutate(perc_token_lang = tokens/sum(tokens) * 100,
         perc_type_lang = type/sum(type) * 100,
         sum_type_lang = sum(type),
         sum_token_lang = sum(tokens)) %>% 
  ungroup()

# print out the content of the `mnr_pth` data frame
mnr_pth

#' 
#' The `tokens` column contains the total token-frequency of the <span style="font-variant:small-caps;">manner</span> and <span style="font-variant:small-caps;">path</span> verbs for English and Indonesian. The `perc_token` column represents percentages of the values in the `tokens` column, that is, the percentages of <span style="font-variant:small-caps;">manner</span> and <span style="font-variant:small-caps;">path</span> verbs respectively by `language`. So for instance, the value `r mnr_pth %>% filter(verb_type == "manner-verb", language == "English") %>% pull(perc_token) %>% round(2)`% in the `perc_token` column represents the percentage of the English <span style="font-variant:small-caps;">manner</span> out of the total `r mnr_pth %>% filter(verb_type == "manner-verb") %>% pull(tokens) %>% sum()` tokens of <span style="font-variant:small-caps;">manner</span> verbs across English and Indonesian. The same interpretation applies to the `type` and `perc_type` columns. The `ttr` column represents the Type-per-Token Ratio (TTR).
#' 
#' 
#' In our database of the English version of *Twilight*, we identified `r unique(pull(filter(mnr_pth, language == "English"), sum_type_lang))` types of MOTION verbs in general. From this total of English MOTION verbs (N~type~ ~motion~ = `r unique(pull(filter(mnr_pth, language == "English"), sum_type_lang))`), `r mnr_pth %>% filter(language == "English", verb_type == "manner-verb") %>% pull(perc_type_lang) %>% round(2)`% repesent the <span style="font-variant:small-caps;">manner</span> verbs and the remaining `r mnr_pth %>% filter(language == "English", verb_type == "path-verb") %>% pull(perc_type_lang) %>% round(2)`% are the <span style="font-variant:small-caps;">path</span> verbs. When we look at the Indonesian database of *Twilight*, the total number of the Indonesian MOTION verbs (N~type~ ~motion~ = `r unique(pull(filter(mnr_pth, language == "Indonesian"), sum_type_lang))`) is `r ifelse(unique(pull(filter(mnr_pth, language == "Indonesian"), sum_type_lang)) < unique(pull(filter(mnr_pth, language == "English"), sum_type_lang)), "lower", "greater")` than that of English (N~type~ ~motion~ = `r unique(pull(filter(mnr_pth, language == "English"), sum_type_lang))`), though it is not a significant difference (*p*~binomial~ = `r round(binom.test(c(unique(pull(filter(mnr_pth, language == "English"), sum_type_lang)), unique(pull(filter(mnr_pth, language == "Indonesian"), sum_type_lang))))$p.value, 3)`). From the total of `r unique(pull(filter(mnr_pth, language == "Indonesian"), sum_type_lang))` Indonesian MOTION verbs, the Indonesian <span style="font-variant:small-caps;">manner</span> verbs constitute `r mnr_pth %>% filter(language == "Indonesian", verb_type == "manner-verb") %>% pull(perc_type_lang) %>% round(2)`% of that total, while the Indonesian <span style="font-variant:small-caps;">path</span> verbs take the remaining `r mnr_pth %>% filter(language == "Indonesian", verb_type == "path-verb") %>% pull(perc_type_lang) %>% round(2)`%.
#' 
#' The codes below demonstrate how these percentages are extracted from the `mnr_pth` data frame.
#' 
## ----extract-motion-verbs-percentages, eval = FALSE------------------------------------
## # percentage of manner and path verbs out of the total motion verbs in English and Indonesian
## 
## ## % of the English manner verbs
## mnr_pth %>% filter(language == "English", verb_type == "manner-verb") %>% pull(perc_type_lang) %>% round(2)
## 
## ## % of the English path verbs
## mnr_pth %>% filter(language == "English", verb_type == "path-verb") %>% pull(perc_type_lang) %>% round(2)
## 
## ## % of the Indonesian manner verbs
## mnr_pth %>% filter(language == "Indonesian", verb_type == "manner-verb") %>% pull(perc_type_lang) %>% round(2)
## 
## ## % of the Indonesian path verbs
## mnr_pth %>% filter(language == "Indonesian", verb_type == "path-verb") %>% pull(perc_type_lang) %>% round(2)
## 
## ## p-value of the Exact Binomial Test (two-tailed) for comparing the number of MOTION verbs between English and Indonesian
## round(binom.test(c(unique(pull(filter(mnr_pth, language == "English"), sum_type_lang)),
##                    unique(pull(filter(mnr_pth, language == "Indonesian"), sum_type_lang))))$p.value, 3)
## 
## ## Get the total number of MOTION verbs in the English database
## unique(pull(filter(mnr_pth, language == "English"), sum_type_lang))
## 
## ## Get the total number of MOTION verbs in the Indonesian database
## unique(pull(filter(mnr_pth, language == "Indonesian"), sum_type_lang))

#' 
#' 
#' ## Manner verbs {#manner}
#' 
#' ### Binomial test for type frequencies {#binom-manner-type}
#' 
#' The following codes demonstrate the calculation of *p*-value of the Exact Binomial Test (two-tailed) for the type-frequencies comparison of <span style="font-variant:small-caps;">manner</span> verbs between English and Indonesian.
#' 
## ----binom-test-manner-type-freq-------------------------------------------------------
# get the number of manner verbs in Indonesian and English
sum_manner_idn_types <- nrow(manner_idn_tokens)
sum_manner_eng_types <- nrow(manner_eng_tokens)

# run the binomial test (two-tailed)
binom_manner_types <- binom.test(c(sum_manner_idn_types, sum_manner_eng_types))

# output only the p-value
binom_manner_types$p.value

#' 
#' As we see, the *p*-value is very small (*p* < 0.001).
#' 
#' ### Binomial test for token frequencies {#binom-manner-token}
#' 
#' The following codes demonstrate the calculation of *p*-value of the Exact Binomial Test (two-tailed) for the token-frequencies comparison of <span style="font-variant:small-caps;">manner</span> verbs between English and Indonesian.
#' 
## ----binom-test-manner-token-freq------------------------------------------------------
# get the summed token-frequencies of the manner verbs in Indonesian and English
sum_manner_idn_tokens <- sum(manner_idn_tokens$n)
sum_manner_eng_tokens <- sum(manner_eng_tokens$n)

# run the binomial test (two-tailed)
binom_manner_tokens <- binom.test(c(sum_manner_idn_tokens, sum_manner_eng_tokens))

# output only the p-value
binom_manner_tokens$p.value

#' 
#' As we see, the *p*-value is very small (*p* < 0.001).
#' 
#' ### Type-per-token Ratio (TTR) {#manner-ttr}
#' 
#' The TTR value of the English <span style="font-variant:small-caps;">manner</span> verbs (TTR~English~ = `r round(pull(filter(mnr_pth, verb_type == "manner-verb", language == "English"), ttr), 4)`) is higher than that of Indonesian (TTR~Indonesian~ = `r round(pull(filter(mnr_pth, verb_type == "manner-verb", language == "Indonesian"), ttr), 4)`), suggesting a greater lexical diversity of the Manner verbs inventory in English.
#' 
#' ### Visualisations {#manner-plot}
#' 
#' The following codes produce **Figure 1** in the paper.
#' 
## ----manner-type-freq-plot, fig.cap = "Type frequency of the Manner verb-lemmas in English and Indonesian versions of *Twilight*"----
mnr %>% 
  ggplot(aes(x = language, y = type)) + 
  geom_col(fill = RColorBrewer::brewer.pal(12, name = "Paired")[6:7]) +
  geom_text(aes(label = type), vjust = -.5) +
  theme_bw() +
  labs(y = "Number of verb-lemma", x = "", title = "Type frequency of Manner verb-lemmas") +
  ggsave("figs-joll/total-type-of-manner-verbs.png", width = 6, height = 5)

#' 
#' The following codes produce **Figure 2** in the paper.
#' 
## ----manner-token-freq-plot, fig.cap = "Summed token frequency of Manner verb-lemmas in English and Indonesian versions of *Twilight*"----
mnr %>% 
  ggplot(aes(x = language, y = tokens)) + 
  geom_col(fill = RColorBrewer::brewer.pal(12, name = "Paired")[2:3]) + 
  geom_text(aes(label = paste("number of verb-type = ", type, sep = "")), vjust = -.5) +
  theme_bw() +
  labs(y = "Token frequency", x = "", title = "Token frequency of Manner verb-lemmas") +
  ggsave("figs-joll/total-tokens-of-manner-verbs.png", width = 6, height = 5)

#' 
#' ### Data in Table 1
#' 
#' Here are the codes to generate the content of the cells in **Table 1** in the paper.
#' 
## ----table-1-data----------------------------------------------------------------------
mnr_idn_gloss <- c("walk", "run", "stride; take a step", "jump", "drive", "dash; rush", "slide/glide away", "glide/float in/through the air", "move along at a high speed", "sneak (into)", "race; move fast", "break through; force one's way into", "crawl", "hop up and down", "slip/slide away", "stroll around", "swing", "tiptoe", "fly", "stumbled; tripped over", "swim", "bounce around; jump repeatedly", "rock; sway; wave", "stalk", "slip/slide away", "fall headlong; slip/slide away")
eng_mnr_cell <- paste(paste("*", manner_eng_tokens$lemma, "*", " (", manner_eng_tokens$n, ")", sep = ""), collapse = ", ")
idn_mnr_cell <- paste(paste("*", manner_idn_tokens$lemma, "*", " '", mnr_idn_gloss, "' (", manner_idn_tokens$n, ")", sep = ""), collapse = ", ")
tibble(`---` = c("ENGLISH ...", eng_mnr_cell, "INDONESIAN ...", idn_mnr_cell)) %>% 
  knitr::kable(caption = "Manner verb-lemmas and their token frequencies in *Twilight*")


#' 
#' 
#' ## Path verbs {#path}
#' 
#' ### Binomial test for type frequencies {#binom-path-type}
#' 
#' Below are the codes to run the Exact Binomial Test (two-tailed) for the type-frequency comparison of <span style="font-variant:small-caps;">path</span> verbs between English and Indonesian. The resulting *p*-value is small (*p* < 0.05).
#' 
## ----binom-test-oath-type-freq---------------------------------------------------------
binom_path <- binom.test(c(nrow(path_idn_tokens), nrow(path_eng_tokens)))
binom_path$p.value

#' 
#' ### Binomial test for token frequencies {#binom-path-token}
#' 
#' The following codes demonstrate the calculation of *p*-value of the Exact Binomial Test (two-tailed) for the token-frequencies comparison of <span style="font-variant:small-caps;">path</span> verbs between English and Indonesian. The resulting *p*-value is also very small (*p* < 0.001)
#' 
## ----binom-test-path-token-freq--------------------------------------------------------
binom_path_tokens <- binom.test(c(sum(path_idn_tokens$n), sum(path_eng_tokens$n)))
binom_path_tokens$p.value

#' 
#' ### Type-per-token Ratio (TTR) {#path-ttr}
#' 
#' The TTR value of the English <span style="font-variant:small-caps;">path</span> verbs (TTR~English~ = `r round(pull(filter(mnr_pth, verb_type == "path-verb", language == "English"), ttr), 4)`) is only slightly lower than that of Indonesian (TTR~Indonesian~ = `r round(pull(filter(mnr_pth, verb_type == "path-verb", language == "Indonesian"), ttr), 4)`), suggesting a modestly greater lexical diversity of the Indonesian <span style="font-variant:small-caps;">path</span> verbs inventory.
#' 
#' ### Visualisations {#path-plot}
#' 
#' The following codes produce **Figure 3** in the paper.
#' 
## ----path-type-freq-plot, fig.caption = "Type frequency of the Path verb-lemmas in English and Indonesian versions of _Twilight_"----
pth %>% 
  ggplot(aes(x = language, y = type)) + 
  geom_col(fill = RColorBrewer::brewer.pal(12, name = "Paired")[6:7]) + 
  geom_text(aes(label = type), vjust = -.5) +
  theme_bw() +
  labs(y = "Number of verb-lemma", x = "", title = "Type frequency of Path verb-lemmas") +
  ggsave("figs-joll/total-type-of-path-verbs.png", width = 6, height = 5)

#' 
#' The following codes produce **Figure 4** in the paper.
#' 
## ----path-token-freq-plot, fig.cap = "Summed token frequency of Path verb-lemmas in English and Indonesian versions of _Twilight_"----
pth %>% 
  ggplot(aes(x = language, y = tokens)) + 
  geom_col(fill = RColorBrewer::brewer.pal(12, name = "Paired")[2:3]) + 
  geom_text(aes(label = paste("number of verb-type = ", type, sep = "")), vjust = -.5) +
  theme_bw() +
  labs(y = "Token frequency", x = "", title = "Token frequency of Path verb-lemmas") +
  ggsave("figs-joll/total-tokens-of-path-verbs.png", width = 6, height = 5)


#' 
#' ### Data in Table 2
#' 
#' Here are the codes to generate the content of the cells in **Table 2** in the paper.
#' 
## ----table-2-data----------------------------------------------------------------------
pth_idn_gloss <- c(menuju = "head toward/for", kembali = "return; go/come back", masuk = "go/come in; enter", berbalik = "turn over/upside down", keluar = "go/come out; exit", pulang = "return; go/come back", muncul = "emerge; appear", tiba = "arrive", turun = "go down; descend", jatuh = "fall", memasuki = "enter", menjauh = "move/get/stay (far) away", naik = "go up; rise; increase", mendekat = "approach; get close", berputar = "rotate; move around", menyusuri = "move along the edge/border/margin", meninggalkan = "leave behind/out; abandon", menuruni = "go down sth.; descend (into)", terjatuh = "fallend down (suddenly)", mengitari = "encircle; move in a circle around", maju = "move forward", menaiki = "go up (onto sth.)", pindah = "move; shift", beranjak = "move/shift one's position slightly", mundur = "go backward", melewati = "pass/go by/through", menghampiri = "come close/near to", menghambur = "scatter; disperse", menyeberangi = "go across/to the other side; cross sth.", membelok = "turn to the right/left", menelusuri = "follow/go along; trace", berpencar = "scatter; disperse", melintasi = "pass/flash by", mengelilingi = "go/revolve around")
pth_idn_gloss_df <- tibble(lemma = names(pth_idn_gloss),
                           gloss = unname(pth_idn_gloss))
path_idn_tokens1 <- path_idn_tokens %>% left_join(pth_idn_gloss_df, by = "lemma")
eng_pth_cell <- paste(paste("*", path_eng_tokens$lemma, "*", " (", path_eng_tokens$n, ")", sep = ""), collapse = ", ")
idn_pth_cell <- paste(paste("*", path_idn_tokens1$lemma, "*", " '", path_idn_tokens1$gloss, "' (", path_idn_tokens1$n, ")", sep = ""), collapse = ", ")

tibble(`---` = c("ENGLISH ...", eng_pth_cell, "INDONESIAN ...", idn_pth_cell)) %>% 
  knitr::kable(caption = "Path verb-lemmas and their token frequencies in *Twilight*")

#' 
