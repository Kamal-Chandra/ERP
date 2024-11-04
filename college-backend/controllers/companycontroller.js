const db = require('../models/db');

exports.getCompanies = (req, res) => {
  db.query('SELECT * FROM companies', (err, results) => {
    if (err) throw err;
    res.json(results);
  });
};
