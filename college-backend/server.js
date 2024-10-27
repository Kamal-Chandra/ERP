const express = require('express');
const mysql = require('mysql2');
const bodyParser = require('body-parser');
const cors = require('cors');

const app = express();
app.use(cors());
app.use(bodyParser.json());

const db = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: 'MySQLRoot',
    database: 'college'
});

db.connect((err) => {
    if (err) throw err;
    console.log('Connected to the database');
});

// Login routes
app.post('/login/student', (req, res) => {
    const { username, password } = req.body;
    const query = 'SELECT * FROM student_login WHERE username = ?';
    
    db.query(query, [username], (err, result) => {
        if (err) throw err;

        if (result.length > 0) {
            if (password === result[0].password) {
                res.json({ message: 'Login successful', studentId: result[0].student_id });
            } else {
                res.status(401).json({ message: 'Incorrect password' });
            }
        } else {
            res.status(404).json({ message: 'Username not found' });
        }
    });
});

app.post('/login/instructor', (req, res) => {
    const { username, password } = req.body;
    const query = 'SELECT * FROM instructor_login WHERE username = ?';

    db.query(query, [username], (err, result) => {
        if (err) throw err;

        if (result.length > 0) {
            if (password === result[0].password) {
                res.json({ message: 'Login successful', instructorId: result[0].instructor_id });
            } else {
                res.status(401).json({ message: 'Incorrect password' });
            }
        } else {
            res.status(404).json({ message: 'Username not found' });
        }
    });
});

app.post('/login/admin', (req, res) => {
    const { username, password } = req.body;
    const query = 'SELECT * FROM admin_login WHERE username = ?';

    db.query(query, [username], (err, result) => {
        if (err) throw err;

        if (result.length > 0) {
            if (password === result[0].password) {
                res.json({ message: 'Login successful', adminId: result[0].admin_id });
            } else {
                res.status(401).json({ message: 'Incorrect password' });
            }
        } else {
            res.status(404).json({ message: 'Username not found' });
        }
    });
});

// Endpoint to fetch admin details by admin_id
app.get('/get-admin/:id', (req, res) => {
    const adminId = req.params.id;

    db.query('SELECT firstName, lastName, email, dob FROM admin WHERE admin_id = ?', [adminId], (error, results) => {
        if (error) {
            console.error(error);
            return res.status(500).send('Server error');
        }

        if (results.length > 0) {
            res.json(results[0]);
        } else {
            res.status(404).send('Admin not found');
        }
    });
});

app.post('/admission/new', (req, res) => {
    const { id, firstName, lastName, department_code } = req.body;
    const query = 'INSERT INTO student (id, firstName, lastName, department_code) VALUES (?, ?, ?, ?)';
  
    db.query(query, [id, firstName, lastName, department_code], (err, result) => {
      if (err) {
        console.error('Error inserting new student:', err);
        res.status(500).json({ message: 'Failed to add student' });
      } else {
        res.json({ message: 'Student added successfully' });
      }
    });
});  

// Endpoint to add a new faculty member
app.post('/faculty/new', (req, res) => {
    const { id, firstName, lastName, department } = req.body;
    if (!id || !firstName || !lastName || !department) {
        return res.status(400).json({ message: 'All fields are required.' });
    }
    const sql = 'INSERT INTO instructor (id, firstName, lastName, department) VALUES (?, ?, ?, ?)';
    db.query(sql, [id, firstName, lastName, department], (err, result) => {
        if (err) {
            console.error('Error inserting faculty:', err);
            return res.status(500).json({ message: 'Error adding faculty.' });
        }
        res.status(200).json({ message: 'Faculty added successfully!', facultyId: result.insertId });
    });
});

// Fetch student data along with enrolled courses
app.get('/students/:id', (req, res) => {
    const studentId = req.params.id;
    const query = `
        SELECT s.id, s.firstName, s.lastName, c.id AS course_id, c.name AS course_name, e.marks
        FROM student s
        JOIN enrollment e ON s.id = e.student_id
        JOIN course c ON e.course_id = c.id
        WHERE s.id = ?
    `;
    db.query(query, [studentId], (err, result) => {
        if (err) throw err;
        res.json(result);
    });
});

// Fetch instructor data along with all courses they teach
app.get('/instructors/:id', (req, res) => {
    const instructorId = req.params.id;
    const query = `
        SELECT 
            i.id AS instructor_id, 
            i.firstName AS instructor_firstName, 
            i.lastName AS instructor_lastName, 
            d.name AS department_name, 
            c.id AS course_id, 
            c.name AS course_name
        FROM 
            instructor i
        JOIN 
            department d ON i.department = d.code
        LEFT JOIN 
            course c ON i.id = c.instructor
        WHERE 
            i.id = ?
    `;

    db.query(query, [instructorId], (err, result) => {
        if (err) throw err;

        if (result.length > 0) {
            const instructor = {
                id: result[0].instructor_id,
                firstName: result[0].instructor_firstName,
                lastName: result[0].instructor_lastName,
                department: result[0].department_name,
                courses: []
            };

            result.forEach(row => {
                if (row.course_id && row.course_name) {
                    instructor.courses.push({
                        id: row.course_id,
                        name: row.course_name
                    });
                }
            });

            res.json(instructor);
        } else {
            res.status(404).json({ message: 'Instructor not found' });
        }
    });
});

// Fetch exam schedule for a student's enrolled courses
app.get('/students/:id/exam-schedule', (req, res) => {
    const studentId = req.params.id;
    const query = `
        SELECT c.id AS course_id, c.name AS course_name, DATE_FORMAT(es.exam_date, '%d-%m-%Y') AS exam_date
        FROM enrollment e
        JOIN course c ON e.course_id = c.id
        JOIN exam_schedule es ON c.id = es.course_id
        WHERE e.student_id = ?
    `;

    db.query(query, [studentId], (err, result) => {
        if (err) throw err;

        if (result.length > 0) {
            res.json(result);
        } else {
            res.status(404).json({ message: 'No exam schedule found for this student' });
        }
    });
});

// Admin Panel Student Count per Department
app.get('/departments-with-students', (req, res) => {
    const query = `
        SELECT d.name AS department_name, COUNT(s.id) AS student_count
        FROM department d
        LEFT JOIN student s ON d.code = s.department_code
        GROUP BY d.name;
    `;

    db.query(query, (err, result) => {
        if (err) throw err;
        res.json(result);
    });
});

// Search Students
app.get('/search-students', (req, res) => {
    const searchQuery = req.query.query || '';
    const query = `
        SELECT id, firstName, lastName, department_code
        FROM student
        WHERE id LIKE ? 
          OR firstName LIKE ? 
          OR lastName LIKE ? 
          OR department_code LIKE ?
          OR CONCAT(firstName, ' ', lastName) LIKE ?
    `;
    const queryParams = [
        `%${searchQuery}%`, 
        `%${searchQuery}%`, 
        `%${searchQuery}%`, 
        `%${searchQuery}%`, 
        `%${searchQuery}%`
    ];

    db.query(query, queryParams, (err, results) => {
        if (err) {
            console.error('Error searching students:', err);
            res.status(500).json({ error: 'Failed to search students' });
        } else {
            res.json(results);
        }
    });
});

// Fetch departments with faculty count
app.get('/departments-with-faculty', (req, res) => {
    const query = `
        SELECT d.name, COUNT(i.id) AS faculty_count
        FROM department d
        LEFT JOIN instructor i ON d.code = i.department
        GROUP BY d.code
    `;

    db.query(query, (err, results) => {
        if (err) {
            console.error('Error fetching departments:', err);
            res.status(500).json({ error: 'Failed to load departments' });
        } else {
            res.json(results);
        }
    });
});

// Search faculty by ID, name, or department
app.get('/search-faculty', (req, res) => {
    const searchQuery = req.query.query || '';
    const query = `
        SELECT id, firstName, lastName, department
        FROM instructor
        WHERE id LIKE ? 
          OR firstName LIKE ? 
          OR lastName LIKE ? 
          OR department LIKE ?
          OR CONCAT(firstName, ' ', lastName) LIKE ?
    `;
    const queryParams = [
        `%${searchQuery}%`, 
        `%${searchQuery}%`, 
        `%${searchQuery}%`, 
        `%${searchQuery}%`, 
        `%${searchQuery}%`
    ];

    db.query(query, queryParams, (err, results) => {
        if (err) {
            console.error('Error searching faculty:', err);
            res.status(500).json({ error: 'Failed to search faculty' });
        } else {
            res.json(results);
        }
    });
});

// Endpoint to get paid and unpaid counts for distinct students
app.get('/students-fee-counts', (req, res) => {
    const query = `
      SELECT 
        SUM(CASE WHEN has_unpaid_fees = 0 THEN 1 ELSE 0 END) AS paid_count,
        SUM(CASE WHEN has_unpaid_fees = 1 THEN 1 ELSE 0 END) AS unpaid_count
      FROM (
        SELECT 
          s.id,
          MAX(CASE WHEN f.status = 'unpaid' OR f.status IS NULL THEN 1 ELSE 0 END) AS has_unpaid_fees
        FROM student s
        LEFT JOIN fee f ON s.id = f.student_id
        GROUP BY s.id
      ) AS fee_status;
    `;

    db.query(query, (error, results) => {
        if (error) {
            return res.status(500).json({ error: 'Failed to fetch student fee counts.' });
        }
        res.json(results[0]);
    });
});

// Endpoint to search students with fees
app.get('/search-students-fee', (req, res) => {
    const query = req.query.query;

    const sql = `
        SELECT s.id, s.firstName, s.lastName, MAX(f.status) AS status
        FROM student s
        LEFT JOIN fee f ON s.id = f.student_id
        WHERE s.id LIKE ? 
          OR s.firstName LIKE ? 
          OR s.lastName LIKE ? 
          OR CONCAT(s.firstName, ' ', s.lastName) LIKE ?
        GROUP BY s.id, s.firstName, s.lastName
    `;
    
    const searchQuery = `%${query}%`;

    db.query(sql, [searchQuery, searchQuery, searchQuery, searchQuery], (err, results) => {
        if (err) {
            console.error(err);
            return res.status(500).json({ error: 'Database query failed' });
        }

        res.json(results);
    });
});

// Endpoint to fetch students with fee statuses
app.get('/students-with-fees', (req, res) => {
    const query = `
      SELECT s.id, s.firstName, s.lastName, MAX(f.status) AS status
      FROM student s
      LEFT JOIN fee f ON s.id = f.student_id
      GROUP BY s.id
      HAVING status = 'unpaid' OR status IS NULL;
    `;

    db.query(query, (error, results) => {
        if (error) {
            return res.status(500).json({ error: 'Failed to fetch students with unpaid fees.' });
        }
        res.json(results);
    });
});

// Endpoint to get unpaid fees for a specific student
app.get('/unpaid-fees/:studentId', (req, res) => {
    const studentId = req.params.studentId;

    const sql = `
        SELECT f.fee_type 
        FROM fee f 
        WHERE f.student_id = ? AND f.status = 'unpaid'
    `;

    db.query(sql, [studentId], (err, results) => {
        if (err) {
            console.error(err);
            return res.status(500).json({ error: 'Database query failed' });
        }

        res.json(results);
    });
});

// Endpoint to update fee status
app.post('/update-fee-status', (req, res) => {
    const { student_id, transaction_id, fee_type } = req.body;
    
    if (!student_id || !transaction_id || !fee_type) {
        return res.status(400).json({ error: 'Student ID, Transaction ID, and Fee Type are required.' });
    }

    const query = `
      UPDATE fee 
      SET status = 'paid', transaction_id = ?, fee_type = ?
      WHERE student_id = ? AND status = 'unpaid' AND fee_type = ?;
    `;

    db.query(query, [transaction_id, fee_type, student_id, fee_type], (error, results) => {
        if (error) {
            return res.status(500).json({ error: 'Failed to update fee status.' });
        }
        if (results.affectedRows === 0) {
            return res.status(404).json({ error: 'No matching unpaid record found for this student and fee type.' });
        }
        res.json({ message: 'Fee status updated successfully.' });
    });
});

// Introduce fee endpoint
app.post('/introduce-fee', (req, res) => {
    const { fee_type, amount, due_date } = req.body;
  
    if (!fee_type || !amount || !due_date) {
      return res.status(400).json({ message: 'All fields are required.' });
    }
  
    // Fetch all students to introduce fee for each
    const getStudentsQuery = 'SELECT id FROM student';
    
    db.query(getStudentsQuery, (err, students) => {
      if (err) {
        return res.status(500).json({ message: 'Error fetching students.' });
      }
  
      const introduceFeeQueries = students.map(student => {
        return new Promise((resolve, reject) => {
          const insertFeeQuery = 'INSERT INTO fee (student_id, fee_type, amount, due_date) VALUES (?, ?, ?, ?)';
          db.query(insertFeeQuery, [student.id, fee_type, amount, due_date], (err) => {
            if (err) reject(err);
            resolve();
          });
        });
      });
  
      // Execute all promises to introduce fee for each student
      Promise.all(introduceFeeQueries)
        .then(() => {
          res.status(200).json({ message: 'Fees introduced successfully for all students.' });
        })
        .catch(() => {
          res.status(500).json({ message: 'Error introducing fees.' });
        });
    });
  });

// Endpoint to get hostel statistics
app.get('/hostel-stats', (req, res) => {
    const totalQuery = 'SELECT COUNT(*) AS total_students FROM student';
    const hostellersQuery = "SELECT COUNT(*) AS hostellers FROM hostel WHERE allocation_status = 'allocated'";
    const dayScholarsQuery = "SELECT COUNT(*) AS day_scholars FROM hostel WHERE allocation_status = 'not_allocated'";
  
    db.query(totalQuery, (err, totalResult) => {
      if (err) return res.status(500).json({ error: err.message });
  
      db.query(hostellersQuery, (err, hostellersResult) => {
        if (err) return res.status(500).json({ error: err.message });
  
        db.query(dayScholarsQuery, (err, dayScholarsResult) => {
          if (err) return res.status(500).json({ error: err.message });
  
          res.json({
            total_students: totalResult[0].total_students,
            hostellers: hostellersResult[0].hostellers,
            day_scholars: dayScholarsResult[0].day_scholars,
          });
        });
      });
    });
});
  
// Endpoint to get students with hostel info
app.get('/students-with-hostel-info', (req, res) => {
    const query = `
        SELECT s.id, s.firstName, s.lastName, h.room_number, h.allocation_status 
        FROM student s
        LEFT JOIN hostel h ON s.id = h.student_id
    `;
    db.query(query, (err, results) => {
        if (err) return res.status(500).json({ error: err.message });
        res.json(results);
    });
});

// Endpoint to search students by name, room number, ID, or allocation status
app.get('/search-hostel-students', (req, res) => {
    const query = req.query.query.trim();

    const searchQuery = `
        SELECT s.id, s.firstName, s.lastName, h.room_number, h.allocation_status 
        FROM student s
        LEFT JOIN hostel h ON s.id = h.student_id
        WHERE LOWER(s.firstName) LIKE LOWER(?) 
           OR LOWER(s.lastName) LIKE LOWER(?) 
           OR h.room_number = ? 
           OR s.id = ? 
           OR LOWER(h.allocation_status) = LOWER(?)
           OR LOWER(REPLACE(h.allocation_status, '_', ' ')) = LOWER(?)
    `;
    
    db.query(searchQuery, [`%${query}%`, `%${query}%`, query, query, query, query], (err, results) => {
        if (err) return res.status(500).json({ error: err.message });
        res.json(results);
    });
});

// Endpoint to allocate a room to a student
app.post('/allocate-room', (req, res) => {
    const { student_id, room_number } = req.body;
    const updateQuery = `
        INSERT INTO hostel (student_id, allocation_status, room_number)
        VALUES (?, 'allocated', ?)
        ON DUPLICATE KEY UPDATE allocation_status = 'allocated', room_number = ?
    `;
    db.query(updateQuery, [student_id, room_number, room_number], (err, result) => {
        if (err) return res.status(500).json({ error: err.message });
        res.json({ message: 'Room allocated successfully' });
    });
});  

app.listen(3000, () => {
    console.log('Server running on port 3000');
});