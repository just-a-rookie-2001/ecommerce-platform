# SQL Ecommerce Platform
![Slots](screenshots/home.png)
A simple E-Commerce website to demonstrate relational database functionality

---
## Table of Contents
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
  - [Database Configuration](#database-configuration)
  - [Populating Database](#Populating-Database)
  - [Backend (Flask) Configuration](#Backend-Configuration)
- [Built With](#built-with)
- [Authors](#authors)
- [License](#license)
---
## Getting Started
These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites
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
- Create a mysql database(with name *mydb*) before running the backend
- Navigate to `./Python/dbConnect.py` and edit the file to match the credentials of your database
```
host = "your host name" 
# "localhost" is running on a personal computer

user = "public"
# database user name

password = "password123"
# password of the user

database = "mydb"
# name of the database
```
- Replace the details with your system credentials. **NOTE**: Make sure that everything is enclosed in " " or ' ' as shown above
- If you change the **name of database** here, make sure to change it in the *DB_SCRIPT.sql* file
---
### Populating Database
- Open DB_SCRIPT.sql file in MySQL Workbench and run it or use command line to do so
```
mysql -u yourusername -p yourpassword yourdatabasename < /pathtothisrepo/Database/DB_SCRIPT.sql
```
---
### Backend Configuration
Navigate to the python directory and install packages
```
cd ./Python
pip install -r requirements.txt 
```
Finally start the server by executing ```App.py``` file

---
## Built With
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
