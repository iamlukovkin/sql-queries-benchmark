# SQL queries benchmark

A bash-script for analyze executing SQL-queries in PostgreSQL.

## Instruction

###  Requirements

1. Stable connection with PostgreSQL database;
2. List of SQL-queries in one file (e.g. ./querries_example.sql);

*> [!IMPORTANT]
> Queries must be written each in one row and divided by ';'.

### Psarameters

Executing script you must to enter parameters:
- -h - host (default localhost).
- -p - port (default 5432).
- -d — database name (default study_normal_form).
- -u — PostgreSQL username (default is postgres).
- -P — PostgreSQL user password (default is postgres).
- -i — number of iterations (default 10).
- -f - file with SQL queries (by default queries.sql).
- -o — file for outputting results (results.json by default).
