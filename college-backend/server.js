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

// Update student details
app.post('/students/update/:id', (req, res) => {
    const studentId = req.params.id;
    const { firstName, lastName, department_code } = req.body;
    const query = `
        UPDATE student 
        SET firstName = ?, lastName = ?, department_code = ? 
        WHERE id = ?
    `;
    db.query(query, [firstName, lastName, department_code, studentId], (err, result) => {
        if (err) {
            console.error('Error updating student:', err);
            res.status(500).json({ error: 'Failed to update student details' });
        } else if (result.affectedRows === 0) {
            res.status(404).json({ message: 'Student not found' });
        } else {
            res.status(200).json({ message: 'Student details updated successfully' });
        }
    });
});

// Update faculty details
app.post('/faculty/update/:id', (req, res) => {
    const instructorId = req.params.id;
    const { firstName, lastName, department } = req.body;
    const query = `
        UPDATE instructor 
        SET firstName = ?, lastName = ?, department = ? 
        WHERE id = ?
    `;
    db.query(query, [firstName, lastName, department, instructorId], (err, result) => {
        if (err) {
            console.error('Error updating faculty:', err);
            res.status(500).json({ error: 'Failed to update faculty details' });
        } else if (result.affectedRows === 0) {
            res.status(404).json({ message: 'Faculty not found' });
        } else {
            res.status(200).json({ message: 'Faculty details updated successfully' });
        }
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
    const dayScholarsQuery = "SELECT COUNT(*) AS day_scholars FROM hostel WHERE allocation_status = 'not allocated'";
  
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

// Endpoint to allocate or deallocate a room to a student
app.post('/allocate-room', (req, res) => {
    const { student_id, allocation_status, room_number } = req.body;
    const updateQuery = `
        INSERT INTO hostel (student_id, allocation_status, room_number)
        VALUES (?, ?, ?)
        ON DUPLICATE KEY UPDATE allocation_status = ?, room_number = ?
    `;
    db.query(updateQuery, [student_id, allocation_status, room_number, allocation_status, room_number], (err, result) => {
        if (err) return res.status(500).json({ error: err.message });
        res.json({ message: 'Room allocation status updated successfully' });
    });
}); 

// Endpoint to get unpaid fees details for a specific student
app.get('/unpaid-fees/details/:studentId', (req, res) => {
    const studentId = req.params.studentId;

    const sql = `
        SELECT f.fee_type, f.amount, f.due_date
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

// Fetch courses with instructor name and student marks
app.get('/students/:studentId/courses', async (req, res) => {
    const { studentId } = req.params;

    const query = `
        SELECT 
            course.name AS course_name,
            CONCAT(instructor.firstName, ' ', instructor.lastName) AS instructor_name,
            enrollment.marks
        FROM 
            enrollment
        INNER JOIN 
            course ON enrollment.course_id = course.id
        INNER JOIN 
            instructor ON course.instructor = instructor.id
        WHERE 
            enrollment.student_id = ?
    `;

    try {
        const [results] = await db.promise().execute(query, [studentId]);
        res.json(results);
    } catch (error) {
        console.error('Error fetching courses:', error.message);
        res.status(500).send('Error fetching courses');
    }
});

// Fetch books issued by a specific student
app.get('/students/:id/books', (req, res) => {
    const studentId = req.params.id;
    const query = `
        SELECT 
            b.title, 
            b.author, 
            DATE_FORMAT(ib.date_of_issue, '%Y-%m-%d') AS issue_date,  -- Format the issue date
            DATE_FORMAT(ib.date_of_return, '%Y-%m-%d') AS return_date -- Format the return date
        FROM 
            issued_books ib
        JOIN 
            books b ON ib.book_id = b.book_id
        WHERE 
            ib.issuer_type = 'student' AND ib.issuer_id = ?;
    `;

    db.query(query, [studentId], (err, result) => {
        if (err) {
            console.error('Error fetching issued books:', err);
            return res.status(500).json({ error: 'Failed to fetch issued books.' });
        }

        if (result.length > 0) {
            res.json(result);
        } else {
            res.status(404).json({ message: 'No books issued by this student.' });
        }
    });
});

app.get('/instructors/:id/books', (req, res) => {
    const instructorId = req.params.id;
    const query = `
        SELECT 
            b.title, 
            b.author, 
            DATE_FORMAT(ib.date_of_issue, '%Y-%m-%d') AS issue_date,
            DATE_FORMAT(ib.date_of_return, '%Y-%m-%d') AS return_date
        FROM 
            issued_books ib
        JOIN 
            books b ON ib.book_id = b.book_id
        WHERE 
            ib.issuer_type = 'faculty' AND ib.issuer_id = ?;
    `;

    db.query(query, [instructorId], (err, result) => {
        if (err) {
            console.error('Error fetching issued books:', err);
            return res.status(500).json({ error: 'Failed to fetch issued books.' });
        }

        if (result.length > 0) {
            res.json(result);
        } else {
            res.status(404).json({ message: 'No books issued' });
        }
    });
});


// Route to get hostel details for a student including roommates
app.get('/students/:studentId/hostel', (req, res) => {
    const studentId = req.params.studentId;

    
    const roomQuery = `
        SELECT room_number FROM hostel WHERE student_id = ?
    `;
    
    db.query(roomQuery, [studentId], (err, roomResults) => {
        if (err) {
            return res.status(500).json({ error: err.message });
        }
        
        
        if (roomResults.length === 0) {
            return res.json({ room_number: null, roommates: [] });
        }

        const roomNumber = roomResults[0].room_number;

        
        const roommatesQuery = `
            SELECT s.id AS student_id, s.firstName, s.lastName
            FROM hostel h
            JOIN student s ON h.student_id = s.id
            WHERE h.room_number = ? AND h.allocation_status = 'allocated'
        `;

        db.query(roommatesQuery, [roomNumber], (err, roommatesResults) => {
            if (err) {
                return res.status(500).json({ error: err.message });
            }

            res.json({
                room_number: roomNumber || null,
                roommates: roommatesResults
            });
        });
    });
});

// Feedback routes
app.post('/student-feedback', (req, res) => {
    const { giver_id, subject, feedback_text } = req.body;
    const date_posted = new Date().toISOString().split('T')[0];
  
    const insertQuery = `
      INSERT INTO student_feedback (giver_id, subject, status, date_posted, feedback_text)
      VALUES (?, ?, 'unresolved', ?, ?)`;
  
    db.query(insertQuery, [giver_id, subject, date_posted, feedback_text], (insertErr) => {
      if (insertErr) {
        return res.status(500).json({ error: 'Error inserting student feedback' });
      }
      res.status(200).json({ message: 'Student feedback submitted successfully' });
    });
  });

  app.post('/faculty-feedback', (req, res) => {
    const { giver_id, subject, feedback_text } = req.body;
    const date_posted = new Date().toISOString().split('T')[0];
  
    const insertQuery = `
      INSERT INTO faculty_feedback (giver_id, subject, status, date_posted, feedback_text)
      VALUES (?, ?, 'unresolved', ?, ?)`;
  
    db.query(insertQuery, [giver_id, subject, date_posted, feedback_text], (insertErr) => {
      if (insertErr) {
        return res.status(500).json({ error: 'Error inserting faculty feedback' });
      }
      res.status(200).json({ message: 'Faculty feedback submitted successfully' });
    });
});

// Fetch students with marks enrolled in a course
app.get('/courses/:courseId/students', (req, res) => {
    const courseId = req.params.courseId;
    const query = `
      SELECT s.id, CONCAT(s.firstName, ' ', s.lastName) AS name, e.marks
      FROM enrollment e
      JOIN student s ON e.student_id = s.id
      WHERE e.course_id = ?
    `;
    db.query(query, [courseId], (err, results) => {
      if (err) {
        console.error(err);
        res.status(500).json({ error: 'Failed to fetch students' });
      } else {
        res.json(results);
      }
    });
});

// Route to update a student's marks
app.put('/courses/:courseId/students/:studentId/marks', (req, res) => {
    const { courseId, studentId } = req.params;
    const { marks } = req.body;
    const query = `
      UPDATE enrollment
      SET marks = ?
      WHERE course_id = ? AND student_id = ?
    `;
    db.query(query, [marks, courseId, studentId], (err, results) => {
      if (err) {
        console.error(err);
        res.status(500).json({ error: 'Failed to update marks' });
      } else {
        res.json({ message: 'Marks updated successfully' });
      }
    });
});
  
  // Enroll a new student in a course
  app.post('/courses/:courseId/enroll-student', (req, res) => {
    const courseId = req.params.courseId;
    const { studentId } = req.body;
    const query = `INSERT INTO enrollment (student_id, course_id) VALUES (?, ?)`;
  
    db.query(query, [studentId, courseId], (err) => {
      if (err) {
        console.error(err);
        res.status(500).json({ error: 'Failed to enroll student' });
      } else {
        res.json({ message: 'Student enrolled successfully' });
      }
    });
  });

// Fetch all courses taught by a specific instructor along with their strength
app.get('/instructors/:instructorId/courses', (req, res) => {
    const instructorId = parseInt(req.params.instructorId, 10);
    const query = `
        SELECT 
            c.id AS course_id,
            c.name AS course_name,
            COUNT(e.student_id) AS student_strength 
        FROM 
            course c
        LEFT JOIN 
            enrollment e ON c.id = e.course_id
        WHERE 
            c.instructor = ?
        GROUP BY 
            c.id, c.name;
    `;

    db.query(query, [instructorId], (err, results) => {
        if (err) {
            console.error('Error fetching courses:', err);
            return res.status(500).json({ error: 'Database query failed' });
        }

        res.json(results);
    });
});

// Endpoint to get a student's details, including courses, unpaid fees, issued books, and hostel info
app.get('/student-details/:id', (req, res) => {
    const studentId = req.params.id;
  
    const studentDetailsQuery = `
      SELECT s.id, s.firstName, s.lastName, d.name AS department 
      FROM student s 
      JOIN department d ON s.department_code = d.code 
      WHERE s.id = ?;
    `;
  
    const coursesQuery = `
      SELECT c.name 
      FROM enrollment e 
      JOIN course c ON e.course_id = c.id 
      WHERE e.student_id = ?;
    `;
  
    const unpaidFeesQuery = `
      SELECT fee_type, due_date, status 
      FROM fee 
      WHERE student_id = ? AND status = 'unpaid';
    `;
  
    const issuedBooksQuery = `
      SELECT b.title, ib.date_of_issue, ib.date_of_return 
      FROM issued_books ib 
      JOIN books b ON ib.book_id = b.book_id 
      WHERE ib.issuer_type = 'student' AND ib.issuer_id = ?;
    `;
  
    const hostelInfoQuery = `
      SELECT allocation_status, room_number 
      FROM hostel 
      WHERE student_id = ?;
    `;
  
    db.query(studentDetailsQuery, [studentId], (err, studentResult) => {
      if (err) return res.status(500).send(err);
  
      if (studentResult.length === 0) return res.status(404).send({ error: 'Student not found' });
      
      const studentDetails = studentResult[0];
      const queries = [
        new Promise((resolve, reject) => db.query(coursesQuery, [studentId], (err, results) => err ? reject(err) : resolve(results))),
        new Promise((resolve, reject) => db.query(unpaidFeesQuery, [studentId], (err, results) => err ? reject(err) : resolve(results))),
        new Promise((resolve, reject) => db.query(issuedBooksQuery, [studentId], (err, results) => err ? reject(err) : resolve(results))),
        new Promise((resolve, reject) => db.query(hostelInfoQuery, [studentId], (err, results) => err ? reject(err) : resolve(results)))
      ];
  
      Promise.all(queries)
        .then(([courses, unpaidFees, issuedBooks, hostelInfo]) => {
          res.send({
            id: studentDetails.id,
            name: `${studentDetails.firstName} ${studentDetails.lastName}`,
            department: studentDetails.department,
            courses: courses.map(c => c.name),
            unpaidFees: unpaidFees,
            issuedBooks: issuedBooks,
            hostelRoom: hostelInfo.length ? hostelInfo[0] : null
          });
        })
        .catch((error) => res.status(500).send(error));
    });
});

// Endpoint to get faculty details by ID
app.get('/faculty/:id', (req, res) => {
    const facultyId = req.params.id;
    const query = `
        SELECT f.id, f.firstName, f.lastName, d.name AS department, GROUP_CONCAT(c.name SEPARATOR ', ') AS courses
        FROM instructor AS f
        LEFT JOIN department AS d ON f.department = d.code
        LEFT JOIN course AS c ON c.instructor = f.id
        WHERE f.id = ?
        GROUP BY f.id, d.name
    `;

    db.query(query, [facultyId], (error, results) => {
        if (error) {
        return res.status(500).json({ error: 'Database query error' });
        }
        if (results.length > 0) {
        // Assuming you have a function to get issued books based on faculty ID
        const issuedBooksQuery = `SELECT b.title FROM issued_books ib JOIN books b ON ib.book_id = b.book_id WHERE ib.issuer_type = 'faculty' AND ib.issuer_id = ?`;
        
        db.query(issuedBooksQuery, [facultyId], (error, booksResults) => {
            if (error) {
            return res.status(500).json({ error: 'Database query error' });
            }

            const facultyDetails = {
            ...results[0],
            issuedBooks: booksResults
            };

            return res.status(200).json(facultyDetails);
        });
        } else {
        return res.status(404).json({ error: 'Faculty not found' });
        }
    });
});

// Endpoint to get all notices
app.get('/notices', (req, res) => {
    const query = 'SELECT * FROM notice ORDER BY date DESC, time DESC';
    db.query(query, (err, results) => {
      if (err) {
        console.error(err);
        res.status(500).json({ message: 'Failed to fetch notices' });
      } else {
        res.status(200).json(results);
      }
    });
});

// Endpoint to save a notice
app.post('/add-notice', (req, res) => {
    const { title, text, type, priority, attachment } = req.body;
    const date = new Date().toISOString().slice(0, 10);
    const time = new Date().toLocaleTimeString('en-US', { hour12: false });
    const query = `INSERT INTO notice (date, time, title, notice_text, notice_type, priority, attachments)
                   VALUES (?, ?, ?, ?, ?, ?, ?)`;
  
    db.query(query, [date, time, title, text, type, priority, attachment], (err, result) => {
      if (err) {
        console.error(err);
        res.status(500).json({ message: 'Failed to save notice' });
      } else {
        res.status(200).json({ message: 'Notice saved successfully' });
      }
    });
});

// Endpoint to delete a notice by its ID
app.delete('/delete-notice/:id', (req, res) => {
    const noticeId = req.params.id;
    const query = `DELETE FROM notice WHERE notice_id = ?`;
    db.query(query, [noticeId], (err, result) => {
        if (err) {
            console.error(err);
            return res.status(500).json({ message: 'Failed to delete notice' });
        }
        if (result.affectedRows === 0) {
            return res.status(404).json({ message: 'Notice not found' });
        }
        res.status(200).json({ message: 'Notice deleted successfully' });
    });
});

// Endpoint to fetch all tickers
app.get('/tickers', (req, res) => {
    db.query('SELECT * FROM ticker', (err, results) => {
        if (err) return res.status(500).json({ error: err.message });
        res.json(results);
    });
});

// Endpoint to add a new ticker
app.post('/add-ticker', (req, res) => {
    const { message } = req.body;
    if (!message) {
        return res.status(400).json({ error: 'Ticker message is required' });
    }

    db.query('INSERT INTO ticker (message) VALUES (?)', [message], (err, result) => {
        if (err) return res.status(500).json({ error: err.message });
        res.status(200).json({ id: result.insertId, message });
    });
});

// Endpoint to delete a ticker by ID
app.delete('/delete-ticker/:id', (req, res) => {
    const tickerId = parseInt(req.params.id);
    db.query('DELETE FROM ticker WHERE ticker_id = ?', [tickerId], (err, result) => {
        if (err) return res.status(500).json({ error: err.message });
        if (result.affectedRows === 0) {
            return res.status(404).json({ error: 'Video not found' });
        }
        res.status(200).json({ message: 'Ticker deleted successfully' });
    });
});

// Endpoint to fetch all videos
app.get('/videos', (req, res) => {
    db.query('SELECT * FROM video', (err, results) => {
        if (err) return res.status(500).json({ error: err.message });
        res.json(results);
    });
});

// Endpoint to add a new video
app.post('/add-video', async (req, res) => {
    const { title, url } = req.body;
    if (!title || !url) {
        return res.status(400).json({ error: 'Title and URL cannot be empty' });
    }
    db.query('INSERT INTO video (title, url) VALUES (?, ?)', [title, url], (err, result) => {
        if (err) return res.status(500).json({ error: err.message });
        const message = 'Video added successfully';
        res.status(200).json({ id: result.insertId, message });
    });
});

// Endpoint to delete a video by ID
app.delete('/delete-video/:videoId', async (req, res) => {
    const videoId = parseInt(req.params.videoId, 10);

    db.query('DELETE FROM video WHERE id = ?', [videoId], (err, result) => {
        if (err) return res.status(500).json({ error: err.message });
        if (result.affectedRows === 0) {
            return res.status(404).json({ error: 'Video not found' });
        }
        res.status(200).json({ message: 'Video deleted successfully' });
    });
});

// Endpoint to fetch all images
app.get('/images', (req, res) => {
    db.query('SELECT * FROM image', (err, results) => {
        if (err) return res.status(500).json({ error: err.message });
        res.json(results);
    });
});

// Endpoint to add a new image
app.post('/add-image', async (req, res) => {
    const { url } = req.body;
    if (!url) {
        return res.status(400).json({ error: 'URL cannot be empty' });
    }
    db.query('INSERT INTO image (url) VALUES (?)', [url], (err, result) => {
        if (err) return res.status(500).json({ error: err.message });
        const message = 'Image added successfully';
        res.status(200).json({ id: result.insertId, message });
    });
});

// Endpoint to delete a image by ID
app.delete('/delete-image/:imageId', async (req, res) => {
    const imageId = parseInt(req.params.imageId, 10);

    db.query('DELETE FROM image WHERE id = ?', [imageId], (err, result) => {
        if (err) return res.status(500).json({ error: err.message });
        if (result.affectedRows === 0) {
            return res.status(404).json({ error: 'Image not found' });
        }
        res.status(200).json({ message: 'Image deleted successfully' });
    });
});

// Endpoint to fetch all sliders
app.get('/sliders', (req, res) => {
    db.query('SELECT * FROM slider', (err, results) => {
        if (err) return res.status(500).json({ error: err.message });
        res.json(results);
    });
});

// Endpoint to add a new slider
app.post('/add-slider', async (req, res) => {
    const { title, url } = req.body;
    if (!url || !title) {
        return res.status(400).json({ error: 'Title and URL cannot be empty' });
    }
    db.query('INSERT INTO slider (title, url) VALUES (?, ?)', [title, url], (err, result) => {
        if (err) return res.status(500).json({ error: err.message });
        const message = 'Slider added successfully';
        res.status(200).json({ id: result.insertId, message });
    });
});

// Endpoint to delete a slider by ID
app.delete('/delete-slider/:sliderId', async (req, res) => {
    const sliderId = parseInt(req.params.sliderId, 10);

    db.query('DELETE FROM slider WHERE id = ?', [sliderId], (err, result) => {
        if (err) return res.status(500).json({ error: err.message });
        if (result.affectedRows === 0) {
            return res.status(404).json({ error: 'Slider not found' });
        }
        res.status(200).json({ message: 'Slider deleted successfully' });
    });
});

// 1. Fetch departments with course counts
app.get('/departments-with-courses', (req, res) => {
    const query = `
        SELECT d.code AS department_code, d.name AS department_name, COUNT(c.id) AS course_count
        FROM department d
        LEFT JOIN course c ON d.code = c.department
        GROUP BY d.code;
    `;
    db.query(query, (err, results) => {
        if (err) {
        return res.status(500).json({ error: 'Failed to fetch departments.' });
        }
        res.json(results.map(row => ({
        id: row.department_code,
        name: row.department_name,
        course_count: row.course_count
        })));
    });
});

// 2. Search courses
app.get('/search-courses', (req, res) => {
    const query = req.query.q;
    const sql = `
        SELECT c.id, c.name, c.department AS department, c.instructor
        FROM course c
        WHERE c.name LIKE ? OR c.id LIKE ? OR c.department LIKE ?;
    `;
    db.query(sql, [`%${query}%`, `%${query}%`, `%${query}%`], (err, results) => {
        if (err) {
        return res.status(500).json({ error: 'Failed to search courses.' });
        }
        res.json(results);
    });
});

// 3. Get course details by ID
app.get('/courses/:id', (req, res) => {
    const courseId = req.params.id;
    const sql = `
    SELECT 
        c.id, 
        c.name, 
        d.name AS department, 
        i.id AS facultyId, 
        CONCAT(i.firstName, ' ', i.lastName) AS facultyName
    FROM course c
    LEFT JOIN department d ON c.department = d.code
    LEFT JOIN instructor i ON c.instructor = i.id
    WHERE c.id = ?;
    `;
    db.query(sql, [courseId], (err, results) => {
    if (err || results.length === 0) {
        return res.status(404).json({ error: 'Course not found.' });
    }
    res.json(results[0]);
    });
});  

// 4. Add a new course
app.post('/courses', (req, res) => {
    const { id, name, department, facultyId } = req.body;
    const sql = 'INSERT INTO course (id, name, department, instructor) VALUES (?, ?, ?, ?)';
    db.query(sql, [id, name, department, facultyId], (err, result) => {
    if (err) {
        return res.status(500).json({ error: 'Failed to add course.' });
    }
    res.status(201).json({ message: 'Course added successfully.' });
    });
});

// 5. Update course details
app.put('/courses/:id', (req, res) => {
    const { name, department, instructor } = req.body;
    const courseId = req.params.id;
  
    const sql = `
      UPDATE course
      SET name = ?, department = ?, instructor = ?
      WHERE id = ?;
    `;
    db.query(sql, [name, department, instructor, courseId], (err, result) => {
      if (err) {
        return res.status(500).json({ error: 'Failed to update course.' });
      }
      res.status(200).json({ message: 'Course updated successfully.' });
    });
});  

// Add a new alumni
app.post('/api/alumni', (req, res) => {
    const { id, name, graduationYear, currentCompany, contactNumber, email } = req.body;
    db.query(
      'INSERT INTO alumni (id, name, graduationYear, currentCompany, contactNumber, email) VALUES (?, ?, ?, ?, ?, ?)',
      [id, name, graduationYear, currentCompany, contactNumber, email],
      (err, result) => {
        if (err) {
          return res.status(500).json({ error: err });
        }
        res.json({ message: 'Alumni added successfully' });
      }
    );
  });
// Alumini routes

// Endpoint to get all alumni data
app.get('/api/alumni', (req, res) => {
    db.query('SELECT * FROM alumni', (err, results) => {
      if (err) {
        return res.status(500).send(err);
      }
      res.json(results);
    });
  });
  
  
  // Endpoint to update an alumni's information
  app.put('/api/alumni/:id', (req, res) => {
    const { id } = req.params;
    const { name, graduationYear, currentCompany, contactNumber, email } = req.body;
    db.query('UPDATE alumni SET name = ?, graduationYear = ?, currentCompany = ?, contactNumber = ?, email = ? WHERE id = ?', [name, graduationYear, currentCompany, contactNumber, email, id], (err) => {
      if (err) {
        return res.status(500).send(err);
      }
      res.send({ id, name, graduationYear, currentCompany, contactNumber, email });
    });
  });
  
  // Endpoint to delete an alumni
  app.delete('/api/alumni/:id', (req, res) => {
    const { id } = req.params;
    db.query('DELETE FROM alumni WHERE id = ?', [id], (err) => {
      if (err) {
        return res.status(500).send(err);
      }
      res.sendStatus(204);
    });
  });
    const companyRoutes = require('./routes/companyRoutes');
    const applicationRoutes = require('./routes/applicationRoutes');
    app.use('/api/companies', companyRoutes);
    app.use('/api/applications', applicationRoutes);

    // Search books by any attribute
app.get('/books/search', (req, res) => {
    const query = req.query.query;
    const sqlQuery = `
      SELECT * FROM books 
      WHERE 
        book_id LIKE ? OR 
        title LIKE ? OR 
        author LIKE ? OR 
        isbn LIKE ? OR 
        total_copies LIKE ? OR 
        copies_available LIKE ?
    `;
    db.query(sqlQuery, [
      '%${query}%',
      '%${query}%',
      '%${query}%',
      '%${query}%',
      '%${query}%',
      '%${query}%'
    ], (err, results) => {
      if (err) throw err;
      res.json(results);
    });
  });
  
  // Add new book to books table
  app.post('/books/add', (req, res) => {
    const { title, author, isbn, total_copies, copies_available } = req.body;
    const sqlInsert = `
      INSERT INTO books (title, author, isbn, total_copies, copies_available) 
      VALUES (?, ?, ?, ?, ?)
    `;
    db.query(sqlInsert, [title, author, isbn, total_copies, copies_available], (err, result) => {
      if (err) throw err;
      res.json({ message: 'Book added successfully', bookId: result.insertId });
    });
  });

  app.get('/search', (req, res) => {
    const { issuer_id } = req.query;
    let query = 'SELECT * FROM issued_books WHERE ';
  
    if (issuer_id) {
      query += ` issue_id = ${mysql.escape(issuer_id)}`;
    }
  
    db.query(query, (err, results) => {
      if (err) {
        res.status(500).send('Server error');
        return;
      }
      res.json(results);
    });
  });
  
  // Endpoint to update the return date
  app.post('/add-return-date', (req, res) => {
    const { issue_id, return_date } = req.body;
  
    if (!issue_id || !return_date) {
      return res.status(400).send('issue_id and return_date are required');
    }
  
    const query = 'UPDATE issued_books SET date_of_return = ? WHERE issue_id = ?';
    db.query(query, [return_date, issue_id], (err, result) => {
      if (err) {
        res.status(500).send('Server error');
        return;
      }
      res.send('Return date updated successfully');
    });
  });

app.listen(3000, () => {
    console.log('Server running on port 3000');
});