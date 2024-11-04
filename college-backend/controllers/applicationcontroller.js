const db = require('../models/db');

exports.submitApplication = (req, res) => {
  const { studentId, companyId } = req.body;
  db.query('INSERT INTO applications (student_id, company_id) VALUES (?, ?)', [studentId, companyId], (err, results) => {
    if (err) throw err;
    res.json({ message: 'Application submitted', id: results.insertId });
  });
};
