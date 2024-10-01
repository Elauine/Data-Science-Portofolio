# Linguistic Analysis of Press Articles on the Advantages and Risks of Artificial Intelligence

## University of Lille
### Faculty of Economic, Social, and Territorial Sciences

### Assignment: Introduction to Text Data Analysis

**Date:** May 15, 2023  
**Author:** Elauïne Bernard

## Project Context
This project was completed as part of the course "Introduction to Text Data Analysis" at the University of Lille. 
The goal is to analyze the linguistic characteristics of a corpus of press articles discussing the advantages and risks related to the use of artificial intelligence (AI).

The primary objective is to process and analyze textual data from these articles to extract key lexical information, while identifying terms frequently associated with the advantages and risks of AI.

## Project Overview
This project involves processing, analyzing, and visualizing textual data from a collection of articles. 
It uses R to perform a comprehensive lexical analysis, including cleaning the text, generating a global lexicon, and visualizing the results through word clouds.
Additionally, the project includes the extraction of specific texts based on keywords.

## Requirements

### R Packages:
The following R packages are required to run the project:
- `tm`: Text mining package
- `qdap`: Quantitative discourse analysis package
- `qdapTools`: Additional tools for qdap
- `readtext`: Reading text files
- `SnowballC`: Stem completion and stemming
- `wordcloud`: Create word cloud visualizations
- `ggplot2`: Data visualization package
- `ggthemes`: Additional themes for `ggplot2`
- `plotrix`: Additional plotting functions

To install the necessary packages, run:
```R
install.packages(c("tm", "qdap", "qdapTools", "readtext", "SnowballC", "wordcloud", "ggplot2", "ggthemes", "plotrix"))
