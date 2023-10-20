
---

# SQL Interactive Query Tool

## Overview

The SQL Interactive Query Tool is an intuitive Java-based application designed for seamless interaction with databases. With a few clicks, users can select a database, choose a relevant query, and view the results in a well-structured JSON format. Leveraging the power of JDBC for database connectivity, the tool is not only robust but also user-friendly, making database exploration and data extraction a breeze.

## Features

- **Interactive Database Selection:** A dropdown list for quick database selection.
- **Relevant Query Display:** Dynamic loading of associated queries based on the chosen database.
- **Batched SQL Execution:** Ability to execute batched SQL commands separated by "GO" statements.
- **Formatted JSON Output:** Easy-to-read results displayed in JSON format.
- **Iterative Exploration:** Continuous exploration without restarting, offering a persistent experience.

## Demonstration

[Click here to watch the video demonstration.](URL_PLACEHOLDER)



## Getting Started

### Prerequisites

- Java JDK .
- JDBC driver for SQL Server (`mssql-jdbc-12.4.1.jre11.jar` or similar).
- Access to a SQL Server instance.

### Installation and Setup

1. Clone this repository to your local machine.
   ```
   git clone (https://github.com/ronimikhaylov/JDBCQueryTool.git)
   ```


2. Navigate to the directory and compile the Java files.
   ```
   javac project1.java
   ```

3. Run the application by specifying the classpath.
   ```
   java -cp ".:mssql-jdbc-12.4.1.jre11.jar" project1
   ```

## Usage

1. Start the application. You'll be prompted to select a database.
2. Upon selecting a database, you'll see a list of associated queries.
3. Choose a query and wait for the results to display in JSON format.
4. Opt to rerun the process as many times as you wish or exit the application.

## Contributions

While this project is primarily for personal use, contributions or suggestions are welcome. Create a pull request or raise an issue to contribute.

## License

This project is licensed under the MIT License.

---
