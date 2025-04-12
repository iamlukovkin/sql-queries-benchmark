# Bash Script Setup for PostgreSQL Query Benchmarking

A bash-script for analyze executing SQL-queries in PostgreSQL.

## Required Utilities

Before running the script, you need to install the following utilities:

- psql: PostgreSQL command-line client.
- bc: Basic calculator for time calculations.
- jq: JSON processor for prettifying the output.
- sed: Stream editor for text manipulation (optional but useful for handling the trailing comma in JSON output).

## Instruction

### Installation

#### MacOS

```bash
brew install jq bc sed
```

#### Linux

##### Ubuntu/Debian-based Systems

```bash
sudo apt update
sudo apt install postgresql-client bc jq sed
```

##### Fedora-based Systems

```bash
sudo dnf install postgresql jq bc sed
```

##### Arch Linux-based Systems

```bash
sudo pacman -S postgresql jq bc sed
```

###  Requirements

1. Stable connection with PostgreSQL database;
3. List of SQL-queries in one file (e.g. ./querries_example.sql);

**Important**
> Queries must be written each in one row and divided by ';'.

### Parameters

Executing script you must to enter parameters:
- h - host (default localhost).
- p - port (default 5432).
- d — database name (default study_normal_form).
- u — PostgreSQL username (default is postgres).
- P — PostgreSQL user password (default is postgres).
- i — number of iterations (default 10).
- f - file with SQL queries (by default queries.sql).
- o — file for outputting results (results.json by default).

### Execution

For execute a script you must to add concrete permissions:

```bash
sudo chmod +x ./benchmark.sh
```

## Example

```bash
./benchmark.sh \
  -h localhost \
  -p 5432 \
  -d postgres \
  -u postgres \
  -P MyStrongPassword \
  -i 10 \
  -f querries_example.sql \
  -o results.json
```
