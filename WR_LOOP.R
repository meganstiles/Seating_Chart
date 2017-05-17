##Megan Stiles

library(genalg)
setwd('/Users/meganstiles/Desktop/Data_Science/Spring_2017/Machine Learning/Final Project/')

##Matrix of 90 guests for the Wedding Reception, 9 Tables of 10
#Closeness Key:
# 2000 = spouse/date
# 900 = sibling
#700 = parent/child
#500 = cousin
#300 = aunt/niece
#100 = friend
#0 = don't know
#5000 = Bride/Groom 

#Read in closeness Matrix
rd_matrix<- read.csv('Wedding_Guest Matrix_Final .csv')

##The Chromosome will be binary, with the number of genes corresponding to the number of guests. 1s indicate
## the guest is at the current table and 0s indicate they are not. The model will seat one table at a time
## and iterate until all the tables are filled

###Define Fitness Function

evalFunc <- function(x) {
  #Total Table Closeness, initialize to 0
  closeness = 0
  
  #Number of people at the table
  current_table_1 = sum(x ==1)
  
  #Calculate Index of each person at the tablen (This corresponds to the closeness matrix)
  i=0
  Table_1_POS<- vector()
  
  for (i in 1:(length(x-1))) {
    if (x[i] ==1) {
      Table_1_POS<-append(Table_1_POS,i)
    }
  }
  i=0
  
  #This calculates the closeness for the table
  
  Table_1 = 0
  i=0
  for (i in 1: length(x)) {
    if (x[i] == 1) {
      j =0
      for (j in 1: length(Table_1_POS-1)) {
        Table_1 = Table_1 + rd_matrix[i, Table_1_POS[[j]]+1]
      }
    }
  }
  #Total Closeness
  closeness = Table_1
  
  #Restrict Number of guests at each table
  if (current_table_1 > 10) 
    return(0) else return(-closeness)
  
}


#################################
###### Iteratively seat Tables###
#################################

#Initialze interations to 300
iters = 300
i =0

#initialize chromosome size to 60
size = 90

#Initialze seating vector to store seating vector
Seating_Order<- vector()
for (i in 1:8) {
  
  #Increase Generations for final two tables 
  if ( i > 8) {
    iters = 1000
  }
  
  #Run GA
  ga.model<- rbga.bin(size = size, popSize = 200, evalFunc = evalFunc, iters = iters, elitism = TRUE)
  
  #Best Solution
  solution<-ga.model$population[which.min(ga.model$evaluations),]
  
  # Print Which Table we are on, The closeness, and how many people are at each table to keep track
  print(i)
  print(sum(solution ==1))
  closeness<- min(ga.model$evaluations)
  print(closeness)
  
  #Append Seated Guests to Seating_Order Vector
  seated<- rd_matrix[solution==1,]
  Seating_Order<- append(Seating_Order, as.character(seated$X))
  
  
  #Remove seated guests from the df before rerunning the model for the next table
  seated.index = vector()
  
  for (j in 1:(length(solution))) {
    if (solution[j] ==1) {
      seated.index<- append(seated.index, j)
    }
  }
  rd_matrix = rd_matrix[-c(seated.index[[1]],seated.index[[2]], seated.index[[3]], seated.index[[4]], seated.index[[5]], seated.index[[6]], seated.index[[7]], seated.index[[8]], seated.index[[9]], seated.index[[10]]), 
                        -c((seated.index[[1]]+1),(seated.index[[2]]+1), (seated.index[[3]]+1), (seated.index[[4]]+1), (seated.index[[5]]+1), (seated.index[[6]]+1), (seated.index[[7]]+1), (seated.index[[8]]+1), (seated.index[[9]]+1), (seated.index[[10]]+1))]
  
  #Reduce size of chromosome by 10 for next run
  size = size -10
  
}

#Separate Tables
One = Seating_Order[1:10]
Two = Seating_Order[11:20]
Three = Seating_Order[21:30]
Four = Seating_Order[31:40]
Five = Seating_Order[41:50]
Six = Seating_Order[51:60]
Seven = Seating_Order[61:70]
Eight = Seating_Order[71:80]
Nine = as.character(rd_matrix$X)


#Combine Tables into DF
Chart<- as.data.frame(cbind(One, Two, Three, Four, Five, Six, Seven, Eight, Nine))

#Save Completed Seating Chart
write.csv(Chart, "Final_Wedding_Seating_Chart.csv")
