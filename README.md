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
    * `http://13.61.27.17/students`
    * `http://13.61.27.17/subjects`