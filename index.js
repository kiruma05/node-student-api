const express = require('express');
const mysql = require('mysql');
const app = express();
const port = 3000;
require('dotenv').config(); 

// MySQL Connection with Automatic Retry Logic
const connectWithRetry = () => {
  let retries = 5;

  const db = mysql.createConnection({
    host: process.env.DB_HOST || 'db',  // Ensure this matches docker-compose.yml
    user: process.env.DB_USER || 'root',
    password: process.env.DB_PASSWORD || 'rootpass',
    database: process.env.DB_DATABASE || 'students'
  });

  const tryConnect = () => {
    db.connect((err) => {
      if (err) {
        console.error(`Database connection failed: ${err.message}`);
        if (retries > 0) {
          retries--;
          console.log(`Retrying in 5 seconds... (${retries} attempts left)`);
          setTimeout(tryConnect, 5000);  // Retry connection after 5 seconds
        } else {
          console.error('Database connection failed permanently. Exiting.');
          process.exit(1);  // Exit if all retries fail
        }
      } else {
        console.log('Connected to MySQL!');
      }
    });
  };

  tryConnect();
  return db;
};

const db = connectWithRetry();  // Establish connection with retry logic

// API Endpoint: Get Students
app.get('/students', (req, res) => {
  const sql = 'SELECT * FROM student';
  db.query(sql, (err, results) => {
    if (err) {
      console.error(`Error fetching students: ${err.message}`);
      res.status(500).json({ error: 'Database query failed' });
      return;
    }
    res.json(results);
  });
});

// API Endpoint: Get Subjects
app.get('/subjects', (req, res) => {
  const sql = 'SELECT * FROM subjects WHERE program = "Software Engineering"';
  db.query(sql, (err, results) => {
    if (err) {
      console.error(`Error fetching subjects: ${err.message}`);
      res.status(500).json({ error: 'Database query failed' });
      return;
    }
    res.json(results);
  });
});

//  Start the Server
app.listen(port, () => {
  console.log(`Server listening on port ${port}`);
});
