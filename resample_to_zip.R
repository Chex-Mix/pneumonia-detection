library(dplyr)
library(stringr)
library(zip)
library(readr)
library(imager)
library(foreach)

setwd("~/DATA472 Project/")
#df <- read_csv("Data_Entry_2017.csv", col_types = cols(`Height]` = col_skip(), 
#                                                       `OriginalImagePixelSpacing[x` = col_skip(), 
#                                                       `OriginalImage[Width` = col_skip(), `View Position` = col_skip(), 
#                                                       X12 = col_skip(), `y]` = col_skip()))
df <- read_csv("Data_Entry_2017.csv")
train_list <- read_csv("train_val_list.txt", col_names = "Image Index")
test_list <- read_csv("test_list.txt", col_names = "Image Index")

#df$Atelectasis = factor(str_detect(df[["Finding Labels"]], "Atelectasis")); table(df$Atelectasis)
#df$Cardiomegaly = factor(str_detect(df[["Finding Labels"]], "Cardiomegaly")); table(df$Cardiomegaly)
#df$Consolidation = factor(str_detect(df[["Finding Labels"]], "Consolidation")); table(df$Consolidation)
#df$Edema = factor(str_detect(df[["Finding Labels"]], "Edema")); table(df$Edema)
#df$Effusion = factor(str_detect(df[["Finding Labels"]], "Effusion")); table(df$Effusion)
#df$Emphysema = factor(str_detect(df[["Finding Labels"]], "Emphysema")); table(df$Emphysema)
#df$Fibrosis = factor(str_detect(df[["Finding Labels"]], "Fibrosis")); table(df$Fibrosis)
#df$Hernia = factor(str_detect(df[["Finding Labels"]], "Hernia")); table(df$Hernia)
#df$Infiltration = factor(str_detect(df[["Finding Labels"]], "Infiltration")); table(df$Infiltration)
#df$Mass = factor(str_detect(df[["Finding Labels"]], "Mass")); table(df$Mass)
#df$Nodule = factor(str_detect(df[["Finding Labels"]], "Nodule")); table(df$Nodule)
#df$Pleural_Thickening = factor(str_detect(df[["Finding Labels"]], "Pleural_Thickening")); table(df$Pleural_Thickening)
df$Pneumonia = factor(str_detect(df[["Finding Labels"]], "Pneumonia")); table(df$Pneumonia)
#df$Pneumothorax = factor(str_detect(df[["Finding Labels"]], "Pneumothorax")); table(df$Pneumothorax)

unbal_train <- merge(df, train_list); table(unbal_train$Pneumonia)
test <- merge(df, test_list); table(test$Pneumonia)

size <- table(unbal_train$Pneumonia)["TRUE"] * 3
set.seed(1)
df1 <- rbind(unbal_train[unbal_train$Pneumonia == T, ],
            sample_n(unbal_train[unbal_train$Pneumonia == F, ], replace = F, size = size),
            test)

# shuffle
df1 <- df1[sample(nrow(df1)), ]

table(df1$Pneumonia)

head(df1)

write.csv(select(df1, -Pneumonia), "balanced_set_labels.csv", quote = F, row.names = F)

# Files must be in same directory
setwd("images/")

fpaths <- system.file(df1$"Image Index"[1],package='imager')

a <- foreach(path = df1$"Image Index") %do% {
  img <- load.image(path)
  img <- resize(img, 224, 224)
  path <- paste("../resized/", path, sep = "")
  save.image(img, path)
}
setwd("../resized")
zip("../balanced_set.zip", as.character(df1[["Image Index"]]))

