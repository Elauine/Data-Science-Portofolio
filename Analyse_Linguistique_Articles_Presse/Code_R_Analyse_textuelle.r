Liste des packages
library(tm)
library(qdap)
library(qdapTools)
library(readtext)
library(SnowballC)
library(wordcloud)
library(ggplot2)
library(ggthemes)
library(plotrix)
Script R Création dataframe du corpus
Text <- read_docx('AGRI_Express_2022.docx')
N <- length(Text)
titre <- rep("AGRI_Express_2022",N)
Doc1 <- data.frame(titre,Text)
Text <- read_docx('AGRI_Sciences_et_Avenir_2022.docx')
N <- length(Text)
titre <- rep("AGRI_Sciences_et_Avenir_2022",N)
Doc2 <- data.frame(titre,Text)
Text <- read_docx('AGRI_Usine_Nouvelle_2022.docx')
N <- length(Text)
titre <- rep("AGRI_Usine_Nouvelle_2022",N)
Doc3 <- data.frame(titre,Text)
Text <- read_docx('EDU_Formiris_2021.docx')
N <- length(Text)
titre <- rep("EDU_Formiris_2021",N)
Doc4 <- data.frame(titre,Text)
Text <- read_docx('EDU_Gobookmart_2023.docx')
N <- length(Text)
titre <- rep("EDU_Gobookmart_2023",N)
Doc5 <- data.frame(titre,Text)
Text <- read_docx('EDU_Management_DS_2023.docx')
N <- length(Text)
titre <- rep("EDU_Management_DS_2023",N)
Doc6 <- data.frame(titre,Text)
Text <- read_docx('FINC_Les_Echos_2021.docx')
N <- length(Text)
titre <- rep("FINC_Les_Echos_2021",N)
Doc7 <- data.frame(titre,Text)
Text <- read_docx('FINC_Mind_Fintech_2022.docx')
N <- length(Text)
titre <- rep("FINC_Mind_Fintech_2022",N)
Doc8 <- data.frame(titre,Text)
Text <- read_docx('FINC_Revue_Banque_2022.docx')
N <- length(Text)
titre <- rep("FINC_Revue_Banque_2022",N)
Doc9 <- data.frame(titre,Text)
Text <- read_docx('SANTE_2_Sciences_et_Avenir_2022.docx')
N <- length(Text)
titre <- rep("SANTE_2_Sciences_et_Avenir_2022",N)
Doc10 <- data.frame(titre,Text)
Text <- read_docx('SANTE_OMS_2021.docx')
N <- length(Text)
titre <- rep("SANTE_OMS_2021",N)
Doc11 <- data.frame(titre,Text)
Text <- read_docx('SANTE_Sciences_et_Avenir_2022.docx')
N <- length(Text)
titre <- rep("SANTE_Sciences_et_Avenir_2022",N)
Doc12 <- data.frame(titre,Text)
Doc <- rbind.data.frame(Doc1, Doc2, Doc3, Doc4, Doc5, Doc6, Doc7, Doc8, Doc9, Doc10, Doc11, Doc12)
nrow(Doc)

Script R traitement du corpus

# 2.1- Créer un vecteur qui contiendra les phrases des articles
Phrase<-Doc$Text
# 2.2- Dictionnaire de mots outils
# 2.2.1- Création d'un dictionnaire de mots outils
mots_outils <- stopwords("french")
mots_outils
#2.2.2- Enlever des mots-outils du dictionnaire
# Nous allons enlever les pronoms personnels du dictionnaire.
pronoms <- c("nous")
M <- length(pronoms)
N <- length(mots_outils)
mots_outils2 <- mots_outils
# imbrication d'une boucle 
for(i in 1:N) {
  for(j in 1:M) {
    if(mots_outils[i]==pronoms[j]) {
      mots_outils2[i] <- ""
      j <- M+1
    } 
  }
}
mots_outils2

# 2.3- Apauvrir les textes
# 2.3.1- Mettre les textes en minuscules
Phrase <- tolower(Phrase)
Phrase[400]
# 2.3.2- Enlever les mots outils
Phrase <- removeWords(Phrase,mots_outils2 )
Phrase[400]
## 2.3.3 Remplacer les ponctuations par des blancs
enlever <- c("," , "!" , "?" , "." , ":" , ";" , "/", "'", "’", "…", "«", "»")
remplacer <- c(" " , " " , " " , " " , " " , " " , " ", " ", " ", " ", " ", " ")
Phrase <- multigsub(enlever, remplacer, Phrase)
Phrase[400]
# 2.3.4- Remplacer certains mots au pluriel par leur singulier
# 12 mots très lié au problématique
pluriel <- c("intelligences" , "artificielles" , "risques" , "technologies" , "numériques" , "algorithmes" , "apprentissages", "décisions", "informations", "éthiques", "avantages", "systèmes")
singulier <- c("intelligence" , "artificielle" , "risque" , "technologie" , "numérique" , "algorithme" , "apprentissage", "décision", "information", "éthique", "avantage", "système")
Phrase <- multigsub(pluriel, singulier, Phrase)

Script R Création lexique global
# transformation de vecteur Phrase en table
y <- data.frame(doc_id=seq(1:nrow(Doc)), text=Phrase)
# l'objet corpus 
corpus_global <- SimpleCorpus(DataframeSource(y), control = list(language = "fr"))
# Enlever les nombres en chiffres
corpus_global <- tm_map(corpus_global, removeNumbers)
# Enlever la ponctuation
corpus_global <- tm_map(corpus_global, removePunctuation)
# Enlever les blancs inutiles 
corpus_global <- tm_map(corpus_global, stripWhitespace)
# le tableau lexical entier global
tdm_global <-TermDocumentMatrix(corpus_global, control = list(encoding="latin1"))
# on le transforme en objet matrice pour faire des calculs de fréquences
tdm_global.mat <-as.matrix(tdm_global)
# Obtenir la dimension de la matrice
dim(tdm_global.mat)
# Obtenir la fréquence de chaque mot 
term.freq <- rowSums(tdm_global.mat)
# Création de la table du lexique globale 
lexic_global <-data.frame(mot=names(term.freq), freq=term.freq)
# on sauve le lexique dans un classeur excel
write.csv2(lexic_global, "lexic_global.csv", fileEncoding="latin1",row.names = F)

Script R Nuage de mots lexique global
# importer lexique global traité
lexfreq<- read.csv2(file="lexic_global1.csv", encoding="latin1" )
# on passe en minuscules, plus lisible dans un nuage de mots
lexfreq$mot <- tolower(lexfreq$mot)
pal <- brewer.pal(8, "Purples")
pal <- pal[-(1:4)]
wordcloud(lexfreq$mot,lexfreq$freq, max.words = 300, random.order=FALSE, colors=pal)

Script R extraction textes avec un mot spécifique
# Extraction de textes avec le mot risque
RISQUE <- grep("risque", Doc$Text, ignore.case=TRUE)
NN <- length(AVANTAGE)
lire2 <- rep("text",NN)
for(i in 1:NN) {
  j <- RISQUE[i]
  lire2[i] <- Doc$Text[j]
}
lire2

