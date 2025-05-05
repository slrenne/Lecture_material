library(tidyverse)
library(ggdark)

db <- read.csv("Mediastinum/input/RodenSupp4.csv")

db %>% ggplot(mapping = aes(
  x = reorder(diagnosis, total),
  y = total)) + 
  geom_col() +
  coord_flip()+ 
  labs( title = 'Mediastinal Neoplasm',
        x = 'Histotype', 
        y = 'Number of cases')+
  dark_theme_gray()

ggsave('Mediastinum/output/total.png', 
       width = 16,
       height = 9,
       dpi = 300)


db %>% gather('Prevascular', 'Visceral', 'Para.vertebral',
              key = 'compartment', 
              value = 'cases') %>% 
  ggplot(mapping = aes(
    x = reorder(diagnosis, cases),
    y = cases)) + 
  geom_col() +
  coord_flip()+ 
  labs( title = 'Mediastinal Neoplasm',
        x = 'Histotype', 
        y = 'Number of cases')+
  facet_grid(.~ compartment)+
  dark_theme_gray()
  

ggsave('Mediastinum/output/total_facet.png', 
       width = 16,
       height = 9,
       dpi = 300)

tot <- sum(db$total)

db %>% gather('Prevascular', 'Visceral', 'Para.vertebral',
              key = 'compartment', 
              value = 'cases') %>% 
  filter(compartment == 'Prevascular') %>%
  arrange(desc('cases')) %>% head(10) %>%
  ggplot(mapping = aes(
    x = reorder(diagnosis, cases),
    y = cases/tot)) + 
  geom_col(fill = 'magenta') +
  coord_flip()+ 
  labs( title = 'Prevascular',
        x = 'Histotype', 
        y = 'Proportion of cases')+
  guides(fill='none')+
  dark_theme_gray()
  

ggsave('Mediastinum/output/topPrevascular.png', 
       width = 5,
       height = 9,
       dpi = 300,
       scale = .7)

db %>% gather('Prevascular', 'Visceral', 'Para.vertebral',
              key = 'compartment', 
              value = 'cases') %>% 
  filter(compartment == 'Visceral') %>%
  arrange(desc('cases')) %>% head(10) %>%
  ggplot(mapping = aes(
    x = reorder(diagnosis, cases),
    y = cases/tot)) + 
  geom_col(fill = 'dodgerblue') +
  coord_flip()+ 
  labs( title = 'Visceral',
        x = 'Histotype', 
        y = 'Proportion of cases')+
  guides(fill='none')+
  dark_theme_gray()


ggsave('Mediastinum/output/topVisceral.png', 
       width = 5,
       height = 9,
       dpi = 300,
       scale = .7)

db %>% gather('Prevascular', 'Visceral', 'Para.vertebral',
              key = 'compartment', 
              value = 'cases') %>% 
  filter(compartment == 'Para.vertebral') %>%
  arrange(desc('cases')) %>% head(10) %>%
  ggplot(mapping = aes(
    x = reorder(diagnosis, cases),
    y = cases/tot)) + 
  geom_col( fill = 'yellow') +
  coord_flip()+ 
  labs( title = 'Paravertebral',
        x = 'Histotype', 
        y = 'Proportion of cases')+
  guides(fill='none')+
  dark_theme_gray()


ggsave('Mediastinum/output/topParavertebral.png', 
       width = 5,
       height = 9,
       dpi = 300,
       scale = .7)

