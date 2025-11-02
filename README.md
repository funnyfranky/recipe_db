# Overview

I have been learning about databases through a class project and found it very interesting, but this one was postgres and even though I know all about SQL databases, I found that I didn't even have the tools installed on my laptop to touch the data inside this database. I decided to work on this project so I'd have a little better chance at having a rounded education on multiple kinds of databases.

I have created a schema for a cloud database that can be hosted and accessed on a non-local machine that can be queried and interacted with to effeciently store and quickly retrieve recipes.

I did this because I don't currently have a good solution to saving and retrieving good recipes. Currently I use a notes app where I have meticulously typed all recipe data in, and half the time I get measurements wrong because it's a non-standardized format.

[Software Demo Video](https://youtu.be/C2mk7ufEsek)

# Cloud Database

I'm hosting a docker image on a non-local machine.

The format of the database is postgres which is sql based.

# Development Environment

I used visual studio code to explore the tables and postgres data. I used psql ( on the command line ) to interact with the database, run queries, and do general testing. I used ChatGPT to double check my code and fix small problems.

I wrote completely in postgresql. The whole schema, data file, and CRUD statements are fully in postgresql.

# Useful Websites

- [ChatGPT](chatgpt.com)
- [Postgres Docker page](https://hub.docker.com/_/postgres/)

# Future Work

- I would like to make a frontend app using Swiftcode in a future sprint.
- I need to improve this by creating some important views.
- I would like to make it multi-user so it can be hosted and many people can use it and share recipes, rather than the current format which is directed toward one user collecting all recipes in a database by and for themselves only.