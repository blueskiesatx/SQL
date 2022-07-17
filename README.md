## SQL
The Sakila sample database, developed by Mike Hillyer, is a great tool to learn and practice MySQL.

dev.mysql.com/doc/sakila/en/sakila-installation.html


## Joins
Join (Inner, Left, Right and Full Joins)

The SQL Join statement is used to combine data or rows from two or more tables based on a common field between them.  
INNER JOIN
LEFT JOIN
RIGHT JOIN
FULL JOIN

![SQL](img/ytO9K.png)

## homweork solutions
I included the homework solutions to basic MySQL practice questions. For example:

# 1a Display the first and last names of all actors from the table actor

USE sakila;

SELECT first_name, last_name FROM actor;


# 1b Display the first and last name of each actor in a single column

# in upper case letters. Name the column Actor Name

SELECT upper(concat(first_name,' ', last_name)) AS Actor_Name

FROM actor;
