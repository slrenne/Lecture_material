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


db <- read.csv("Heart/input/mass_by_site.csv")
db$Location <- factor(db$Location,
                      levels = c("RA/SVC", "RA/IVC", "RA", "TV",
                                 "RV", "LA", "LAA", "MV", "LV", "AV"))

lookup <- c(
  "AV"     = "Aortic valve",
  "IVC"    = "Inferior vena cava",
  "LA"     = "Left atrium",
  "LAA"    = "Left atrial appendage",
  "LV"     = "Left ventricle",
  "MV"     = "Mitral valve",
  "RA"     = "Right atrium",
  "RV"     = "Right ventricle",
  "SVC"    = "Superior vena cava",
  "TV"     = "Tricuspid valve"
)

db$Location_full <- sapply(as.character(db$Location), function(x) {
  parts <- unlist(strsplit(x, "/"))
  paste(lookup[parts], collapse = "/")
})

db$Location_full <- factor(
  db$Location_full,
  levels = c(
    "Right atrium/Superior vena cava",
    "Right atrium/Inferior vena cava",
    "Right atrium",
    "Tricuspid valve",
    "Right ventricle",
    "Left atrium",
    "Left atrial appendage",
    "Mitral valve",
    "Left ventricle",
    "Aortic valve"
  )
)


db %>% filter(Type == " p") %>% ggplot(mapping = aes(
  x = reorder(Tumor, Number),
  y = Number)) + 
  geom_col() +
  coord_flip()+ 
  labs( title = 'Location of Cardiac Primary Masses',
        x = 'Diagnosis', 
        y = 'Number')+
  facet_wrap(vars(Location_full), dir = 'v', ncol = 2 )+
  dark_theme_gray()


ggsave('Heart/output/Mass_by_site.png', 
       width = 7,
       height = 6,
       dpi = 300)
