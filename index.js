const express = require('express');
const mysql = require('mysql');
const app = express();
const port = 3000;
require('dotenv').config(); 

// MySQL Connection with Retry Logic
const connectWithRetry = () => {
  const db = mysql.createConnection({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD, 
    database: process.env.DB_DATABASE
  });

  db.connect((err) => {
    if (err) {
      console.error(`Database connection failed: ${err.message}`);
      console.log('Retrying in 5 seconds...');
      setTimeout(connectWithRetry, 5000); // Retry after 5 seconds
    } else {
      console.log('Connected to MySQL!');
    }
  });

  return db;
};

const db = connectWithRetry(); // Establish connection with retry

// Endpoint 1: /students
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

// Endpoint 2: /subjects
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

//Start the server
app.listen(port, () => {
  console.log(`Server listening on port ${port}`);
});
