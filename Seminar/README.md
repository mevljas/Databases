## PB seminar paper for 2019

### Travian

Travian is an online game developed by Travian Games GmbH. In 2006, Travian was the best
an online game (played by more than 10,000 players) in the category of Germany’s best internet
games. It is a tactical military game that takes place in real time. Along with two Englishmen
versions and with original German, has been translated into more than 30 languages. Today it has over 3
millions of players around the world. It is made in the PHP programming language and for it
we need an internet browser. It was the first game of its kind that could also be played over a
mobile phone. In Slovenia, it is currently played by around 10.000 players on eight servers
(maximum over 50,000).

### Players

The player can choose between different tribes such as: Romans, Teutons, Gauls, Huns, Egyptians.

Each tribe also has its own peculiarities, advantages and disadvantages. In addition to these tribes in the game
there is also a hostile tribe of Natars and a more or less unfriendly nature.

### Playground

The playing field comprises (x, y) coordinates from (-250, -250) to (250, 250). On each of the possible
coordinates may exist a settlement belonging to a particular player. The settlement can always be just on
one coordinate, cannot extend across multiple fields.

### Alliance

The game is designed for group play - players can trade, cities can be fortified with soldiers from
another player. We can form an alliance in the game. The sole purpose of this is to be able to get more players
unite against a common adversary. In an alliance, a player can see how many times other members of the alliance are attacked. 
But there are also special communication tools. In any alliance can be maximum 60 members. 
However, if the alliance is larger, it can set up wings that can fight together against
others (individual or alliances). Of course, they can also make alliances with each other,
pacts and also wars.

### Travian game (web) servers


The game takes place in a virtual world managed by a game server to which players
accessed through a web browser. For the purposes of making maps and statistics, at
publish to each server daily the current state of the world described by the SQL file with
named Xworld.sql.

### File description Xworld.sql

File contains the contents of the x_world table. Because the file was originally intended for MySQL, it
needs to be slightly corrected for more general use. The table contains data on
individual settlements.

The meaning of the x_world table attributes is as follows:

1. **id** - Field code
2. **x** - X coordinates (-250, 250)
3. **y** - Y coordinate (-250, 250)
4. **tid** - Tribe code:
    a. 1 = Romans, 2 = Teutons, 3 = Gauls, 4 = Nature, 5 = Natars, 6 = Huns, 7 = Egyptians
5. **vid** - Settlement code
6. **village** - Name of the settlement
7. **pid** - Player code
8. **player** - The name of the player
9. **aid** - Alliance code (0 means the player is not in a alliance)
10. **alliance** - The name of the alliance
11. **population** - Number of inhabitants.

### Using the x_world table (pb.fri.uni‐lj.si)

The table is ready on the server. All students can see and use it in the exercise scheme:
USE exercises;
DESCRIBE x_world;
SELECT COUNT (*) FROM x_world;
or
DESCRIBE exercises.x_world;
SELECT COUNT (*) FROM exercises.x_world;

### Creating an x_world table (for your own MySQL installation only)

Install the latest MySQL Workbench client (classroom first week instructions).
Run it, log in to your local database (eg tutorials), open the Xworld.sql SQL script with
classrooms and run it:

1. Creating and filling a table:
File‐> Open SQL Script
Select the Xworld.sql file (available in the classroom)
Query‐> Execute (All or Selection)
2. Wait a few minutes ...
If all went well, you can now use the x_world table.


### Task solving and report

Document all the work done in the form of a report containing the text of the task, solution (SQL or
Python (pseudo) code), display results (up to the first ten lines) and your potential
comments. Submit the report in an appropriate format in PDF format. Pay attention to spelling. In the text
slightly more demanding tasks are marked with asterisks (*).

## Tasks

### 1. Order (DDL) (10%)

From the x_world table described by the relational scheme

x_world (id, x, y, tid, vid, village, pid, player,
aid, alliance, population)

CREATE TABLE and fill the tables with the following relational schemes and means:

tribe (tid, tribe) - tribe code and name (can be filled in manually with values)

alliance (aid, alliance) - code and name of the alliance

player (pid, player, #tid, #aid) - code and name of the player, his tribe and
his alliance

settlement (vid, village, x, y, population, #pid) —village code, village name, x and y
coordinates, population, code of the village owner player

The alliance table should NOT contain rows with the value aid = 0. Replace all in the player table
values ​​of aid = 0 with missing value NULL. Also correct for all created tables
specify primary and foreign keys.

The values ​​of the keys and names of the tribes are: 1 = Romans, 2 = Teutons, 3 = Gauls, 4 = Nature, 5 = Natars, 6
= Huns, 7 = Egyptians

### When solving tasks from here on out use only tables from the first exercise and to the minimum extent required. Using the original x_world table is not allowed!


### 2. Account (DML) (30%)

Above the obtained tables from task 1 in SQL, write queries that will help you
be able to answer the following questions. Each point from a) to j) is worth 3% of the total
seminar assignments.

`` `
a) Print the code and name of the player with the largest settlement?
b) Which players have the most settlements? List their codes, names and number of settlements. Pri
exclude Natars (pid = 1).
c) How many settlements does each player have on average? (Excluding Natars)
d) How many players has an above-average size settlement? (Again without consideration
Natarjev)
e) Print data on all settlements of players without an alliance, in descending order of population,
then along the x and y coordinates.
f) List the codes and names of all alliances that end in a digit and contain at least one letter.
Arrange the results in alphabetical order.
g) Write a function that returns the sum for the range defined by the parameters x, y and distance
population of the area. The area is defined by a square (x-distance, y-distance),
(x + distance, y + distance). Use the created function to print the sum of the values
parameters (x = 0, y = 0, distance = 10), (x = 20, y = 20, distance = 5) and (x = 0, y = 0,
distance = 500).
h) List the codes and names of players who have all their settlements in the area where x is between
100 and 200 and y between 0 and 100.
i) Find the codes and names of players who have a dying settlement. For a dying settlement
take those settlements that have less than 3% of the average player population (average
player population is the total player population broken down by the number of its settlements).
j) * The pitt player wants to rename all their settlements as follows. He will arrange them after
population, the strongest will be “Terrier 00”, the next “Terrier 01” and so on. Task
you can solve in several steps (sequence of queries).
`` `
### 3. Order (DDL) (2 0%)

`` `
a) Write a save procedure CreateAlliance (nameAlliance, pid), which creates a new alliance
the name of the Alliance and the member with the code pid. The procedure must also check that the player
with the code pid is not already in the second alliance.
b) Write a transaction that will merge GM-H4N1TM and RS-H3N3TM alliance members into a new
an alliance called VirusTM.
`` `

### 4. Order (ODBC) (20%)

In Python or Java, write a program that connects to the database and
for the entire playing field, it calculates the population density and the population density of a particular alliance.
Calculate the density in areas of size 10x10 fields according to the formulas:

#### 퐺 표푠 푡표 푡푎 푝표 푝푢 푙푎 푐푖 푗푒 =

`` `
푢푝 푢푝 푛푎 푝표 푝푢 푙푎 푐푖 푗푎 푛푎 표푏 푚표 č 푗푢
100
`` `
#### 퐺 표푠 푡표 푡푎 푎 푙푖 푎푛 푠푒 =

`` `
푢푝 푢푝 푛푎 푝표 푝푢 푙푎 푐푖 푗푎 푖 푧푏 푟푎 푛푒 푎 푙푖 푎푛 푠푒 푛푎 표푏 푚표 č 푗푢
100
`` `
Save the calculated density results (for each of the 50x 50 = 25 00 ranges) in the appropriate one
table densityPopulations and densityAlliance and write them back to the database. To calculate the density
alliances you can choose any alliance. It is recommended to make a function that has an input
parameter alliance name.

### 5. Order (ODBC) (10%)

If you know, solve a), otherwise b). Point a) can bring you an extra bonus. Graphs can be
two-dimensional (higher point intensity means higher number) or three-dimensional (columnar).
They should definitely be clear enough.

`` `
a) * (Bonus additional 10% for demonstration) Write a GUI application in Python or Java,
which is connected to the database and plots the results of the calculated density in the form of graphs
settlement from the fourth task. As part of this task, you can also realize the entire fourth
task, without storing intermediate results.
b) Use Microsoft Excel to connect to the database and in the form of graphs
plot the results of the calculated population density from the fourth task.
`` `
### Task 6 (Planning) (10%)

`` `
a) In what normal form is the table x_wolrd?
b) In what normal form are the four created tables from Task 1.
c) Draw a conceptual model of the database according to Task 1.
`` `
