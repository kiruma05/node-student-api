# Node.js Student and Subjects API

This is a Node.js API that provides endpoints for retrieving student and subject information from a MySQL database.

## Project Description

The API exposes two endpoints:

* `/students`: Returns a list of students, including their names and enrolled programs.
* `/subjects`: Returns a list of subjects for the "Software Engineering" program, including their names and academic years.

## Setup Instructions

1.  **Prerequisites:**
    * Node.js (v18 or later)
    * npm (Node Package Manager)
    * MySQL Server
    * AWS EC2 Instance (Ubuntu)

2.  **Clone the Repository:**

    ```bash
    git clone https://github.com/kiruma05/node-student-api.git
    cd node-student-api.git
    ```


3.  **Install Dependencies:**

    ```bash
    npm install
    ```

    * This will install the necessary Node.js packages (Express, mysql, dotenv).

4.  **Database Setup:**

    * Create a MySQL database named `students`.
    * Import the `students.sql` file into the database.
    * The `students.sql` file creates two tables: `student` and `subjects`.
    * The `student` table contains student information (name, enrolled_program).
    * The `subjects` table contains subject information (name, academic_year) for the "Software Engineering" program.
    * **Important:** Table names are case sensitive. The student table is named `student` not `students`.
    * Example import command:

        ```bash
        mysql -u your_mysql_user -p students < students.sql
        ```


5.  **Environment Variables:**

    * Create a `.env` file in the project's root directory.
    * Add the following database connection details:

        ```
        DB_HOST=your_db_host
        DB_USER=your_db_user
        DB_PASSWORD=your_db_password
        DB_DATABASE=students
        ```


6.  **Start the API:**

    * Use PM2 to start the application.

        ```bash
        pm2 start index.js
        ```

7.  **Nginx Configuration:**

    * Configure Nginx as a reverse proxy to forward requests to your Node.js application.
    * Example Nginx configuration:

        ```nginx
        server {
            listen 80;
            server_name 13.61.27.17;

            location / {
                proxy_pass http://localhost:3000;
                proxy_http_version 1.1;
                proxy_set_header Upgrade $http_upgrade;
                proxy_set_header Connection 'upgrade';
                proxy_set_header Host $host;
                proxy_cache_bypass $http_upgrade;
            }
        }
        ```


## API Endpoints

### `/students`

* **Description:** Returns a list of all students.
* **Method:** GET
* **Example Response:**

    ```json
    [
        {
            "name": "John kitwangwa",
            "enrolled_program": "Software Engineering"
        },
        {
            "name": "Janet kimalo",
            "enrolled_program": "Computer Science"
        },
        // ... more students
    ]
    ```

### `/subjects`

* **Description:** Returns a list of subjects for the "Software Engineering" program.
* **Method:** GET
* **Example Response:**

    ```json
    [
        {
            "name": "Programming 101",
            "academic_year": 1
        },
        {
            "name": "Data Structures",
            "academic_year": 2
        },
        // ... more subjects
    ]
    ```

## Dependencies

* Node.js
* Express
* mysql
* dotenv
* PM2
* Nginx



## Submission

* GitHub Repository URL: https://github.com/kiruma05/node-student-api
* API Endpoints:
    *` `http://13.61.27.17/students
    * `http://13.61.27.17/subjects`







# CS 421 - Assignment 2: Server Management Scripts

## Script Descriptions

This assignment includes the following Bash scripts for automating server management tasks:

### 1. health_check.sh

This script monitors the server's health by checking CPU usage, memory usage, disk space, and the status of the web server (Apache). It also tests the API endpoints (/students and /subjects) to ensure they are responding with a 200 OK status. The script logs all results to `/home/ubuntu/bash_scripts/server_health.log`. If any check fails, a warning is logged.

### 2. backup_api.sh

This script creates a backup of the API project directory and the MySQL database. The API directory is backed up to `/home/ubuntu/backups/api_backup_$(date +%F).tar.gz`, and the database is exported to `/home/ubuntu/backups/db_backup_$(date +%F).sql`.  It automatically deletes backups older than 7 days.  Logs of the backup process are written to `/home/ubuntu/bash_scripts/backup.log`.

### 3. update_server.sh

This script automates the process of updating the server and the API. It updates the Ubuntu package list and upgrades installed packages, pulls the latest changes from the Assignment 1 GitHub repository, and restarts the web server (Apache) to apply the updates. The script logs the update process to `/home/ubuntu/bash_scripts/update.log`. If the `git pull` command fails, the script logs an error and exits without restarting the web server.


## Setup and Usage Instructions

1.  **Clone the Repository:**

    Clone this repository to your AWS Ubuntu server:

    ```bash
    git clone <your_repository_url>
    ```

    Replace `<your_repository_url>` with the actual URL of your repository.

2.  **Navigate to the `bash_scripts` Directory:**

    ```bash
    cd bash_scripts
    ```

3.  **Set Execute Permissions:**

    Make the scripts executable:

    ```bash
    chmod +x health_check.sh
    chmod +x backup_api.sh
    chmod +x update_server.sh
    ```

4.  **Run the Scripts:**

    Execute the scripts from the command line:

    ```bash
    ./health_check.sh
    ./backup_api.sh
    ./update_server.sh
    ```

5.  **View Log Files:**

    The log files are located in the `bash_scripts` directory:

    ```bash
    cat server_health.log
    cat backup.log
    cat update.log
    ```

6.  **Cron Setup (Automated Execution):**

    To automate the execution of the scripts, use `cron`.

    * Edit the crontab:

        ```bash
        crontab -e
        ```

    * Add the following lines to schedule the scripts:

        ```cron
        0 */6   * * * /home/ubuntu/bash_scripts/health_check.sh
        0 2     * * * /home/ubuntu/bash_scripts/backup_api.sh
        0 3     */3 * * /home/ubuntu/bash_scripts/update_server.sh
        ```

    * Save the crontab.


## Dependencies

The scripts require the following dependencies:

* **Bash:** The scripts are written in Bash, which is the default shell on most Linux systems.
* **curl:** Used in `health_check.sh` to test the API endpoints.
* **MySQL Client (mysqldump):** Used in `backup_api.sh` to export the MySQL database.  If you are using a different database, you will need the appropriate client tools.
* **Git:** Used in `update_server.sh` to pull the latest changes from the repository.
* **Apache2 (or Nginx):** The web server that hosts the API.  The `update_server.sh` script restarts this service.
* **Ubuntu:** The scripts are designed to run on Ubuntu.
* **cron:** For scheduling the automatic execution of the scripts.



# Node Student API 

This project is a simple **student management API** built with **Node.js** and **MySQL**, containerized using **Docker**.

##  Features
- Retrieve student records (`/students`)
- Fetch subjects related to Software Engineering (`/subjects`)
- MySQL database integration
- Deployed on AWS using Docker

-GitHub Repository: https://github.com/kiruma05/node-student-api
- API Public URL: http://ec2-13-61-27-17.eu-north-1.compute.amazonaws.com:3000/
- API for students : http://ec2-13-61-27-17.eu-north-1.compute.amazonaws.com:3000/students
- API for subjects : http://ec2-13-61-27-17.eu-north-1.compute.amazonaws.com:3000/subjects
- Docker Hub Repository: https://hub.docker.com/r/kiruma05/node-student-api

---

## 🔧 Setup & Deployment

### 1️⃣ **Clone Repository**
```sh
git clone https://github.com/kiruma05/node-student-api.git
cd node-student-api

