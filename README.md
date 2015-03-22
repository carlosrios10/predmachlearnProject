 PredmachlearnProject
==========================
## Synopsis

Using devices such as Jawbone Up, Nike FuelBand, and Fitbit it is now possible to collect a large amount of data about personal activity relatively inexpensively. These type of devices are part of the quantified self movement.
The goal of this project was predict how well a person perform barbell lifts. To perform the predicction we used three algoritms based in decision tree (rpart,J48 and random forest). The data set contains data from accelerometers on the belt, forearm, arm, and dumbell of 6 participants. More information is available from the website here: http://groupware.les.inf.puc-rio.br/har.
We found that the method random forest had the best accurancy.

## Modules

* main.R : Main script performs the sequence of steps required to predicct how well a person did an exercise.
* functions.R : Script that contains functions used by main.R. 

## Installation
To run this project you must perform these steps below. 

1. Download project.
2. Download [training data set][train] and [testing data set][test] and save them into a folder called "datos" into your working directory.
3. Execute the file main.R.

[train]:https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv
[test]:https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv 