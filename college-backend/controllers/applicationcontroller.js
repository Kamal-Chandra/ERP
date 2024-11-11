const db = require('../models/db');

// Add application with manual student_id entry
exports.addApplication = (req, res) => {
  const { student_id, company_id, application_details } = req.body;
  db.query(
    'INSERT INTO applications (student_id, company_id, application_details) VALUES (?, ?, ?)',
    [student_id, company_id, application_details],
    (err, result) => {
      if (err) return res.status(500).send(err);
      res.status(201).json({ id: result.insertId });
    }
  );
};

// Update status
exports.updateApplicationStatus = (req, res) => {
  const { student_id, status } = req.body;
  db.query(
    'UPDATE students SET status = ? WHERE id = ?',
    [status, student_id],
    (err) => {
      if (err) return res.status(500).send(err);
      res.json({ message: 'Status updated successfully' });
    }
  );
};
