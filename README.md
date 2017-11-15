# Optimizing a Wedding Reception Seating Chart Using a Genetic Algorithm

This code uses a genetic algorithm to optimize a wedding reception seating chart based on how closely related the wedding guests are to each other. I chose to use the following key to determine closeness, although this can be modified to the author's preferences.

Closeness Key:
2000 = spouse/date
900 = sibling
700 = parent/child
500 = cousin
300 = aunt/niece
100 = friend
0 = don't know
5000 = Bride/Groom 

Notice how I had to create a special Bride/Groom score since both of us were so closely related to everyone attending the wedding, a score of 2000 was not enough to ensure we were sitting at the same table. And obviously you want to sit with your new spouse at your own wedding!

Once you have your key you must create a matrix of all the wedding guests x all the wedding guests and score each guest based on how they are related to the other guests. This is obviously very time consuming and is something that I think could be solved with some sort of GUI where the user enters their family tree. This would not solve assigning closeness of friends however, please reach out if you have suggestions!

Using this matrix, you can then create a genetic algorithm that maximizes the closeness of the entire table, subject to the limit on the number of guests at each table (in my case 10). In this example, I chose a binary chromosome(each guest is either chosed for the given table or they are not) that chooses one table at a time, removes these guests from the matrix, reduces the size of the chromosome, and then chooses the next table.

This produced excellent results, that I did use, in part, at my wedding reception. I was initally worried that the first table would be the most optimal and that closeness would decrease as each table was chosen. As it turns out, the first 6 tables has similar closeness scores and then the final 4 had lower ones. These last 4 tables were not less optimal, however, they were simply tables of friends, and thus their closeness score was lower based on my Closeness Key. So while the "closeness" score was lower, they were not less optimal.
