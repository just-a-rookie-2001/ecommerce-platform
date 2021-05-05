# SQL Ecommerce Platform
![Slots](screenshots/home.png)
A simple E-Commerce website to demonstrate relational database functionality

---
## Table of Contents
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
  - [Database Configuration](#database-configuration)
  - [Running Application](#Running-Application)
- [Built With](#built-with)
- [Authors](#authors)
- [License](#license)
---
## Getting Started
These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites
- [Docker](https://www.docker.com/)
- [Python](https://www.python.org/downloads/)
- [MySQL Community](https://dev.mysql.com/downloads/)
---
### Installation
Download and extract this repository or clone it using git
```
git clone https://github.com/just-a-rookie-2001/ecommerce-platform.git
```
Navigate into the repository
```
cd ecommerce-platform
```
---
### Database Configuration
Create a `.env` file in the root directory of the project. Use the below template for starter and replace the details with your system credentials.
```
#dont modify 
MYSQL_HOST=db
MYSQL_DATABASE=mydb
MYSQL_ROOT_USER=root

#please modify
MYSQL_USER=YourMySQLUserName
MYSQL_PASSWORD=YourMySQLUserPassword
MYSQL_ROOT_PASSWORD=YourMySQLRootPassword
```
---
### Running Application
- Make sure docker service is running in the backgroud <br>
  Verify by executing the command ```docker ps```
- Finally start build process by executing the command

      docker compose up --build
- The application will be visible on `localhost:5000`
- To stop the application run command

      docker compose down

---
## Built With
- [Docker](https://www.docker.com/)
- [Flask](https://flask.palletsprojects.com/en/1.1.x/)
- [PyMySQL](https://pymysql.readthedocs.io/en/latest/)
---
## Authors
- [**Jaimik Patel**](https://github.com/just-a-rookie-2001)
- [**Moksh Doshi**](https://github.com/mokshdoshi007)
- [**Nandish Patel**](https://github.com/NandishDPatel)
---
## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
