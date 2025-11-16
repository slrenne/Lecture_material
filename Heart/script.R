library(tidyverse)
library(ggdark)

db <- read.csv("Heart/input/heart_tumors_adults_children.csv")
db <- db[-4,] #likely angioma duplicated
db%>%   ggplot(mapping = aes(
  x = reorder(Tumor, Children),
  y = Children)) + 
  geom_col() +
  coord_flip()+ 
  labs( title = 'Children',
        x = 'Histotype', 
        y = 'Percentage')+
  dark_theme_gray()

ggsave('Heart/output/children.png', 
       width = 3,
       height = 4,
       dpi = 300)

db%>%   ggplot(mapping = aes(
  x = reorder(Tumor, Adults),
  y = Adults)) + 
  geom_col() +
  coord_flip()+ 
  labs( title = 'Adults',
        x = 'Histotype', 
        y = 'Percentage')+
  dark_theme_gray()

ggsave('Heart/output/Adults.png', 
       width = 3,
       height = 4,
       dpi = 300)

db%>% pivot_longer(cols = 2:3) %>% 
  ggplot(mapping = aes(
  x = reorder(Tumor, value),
  y = value)) + 
  geom_col() +
  coord_flip()+ 
  labs( title = 'Cardiac Primary Tumors',
        x = 'Histotype', 
        y = 'Percentage')+
  dark_theme_gray()

