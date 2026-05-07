const { Pool } = require('pg');

// Les valeurs proviennent des variables d'environnement définies dans Terraform
const pool = new Pool({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASS,
  database: process.env.DB_NAME,
  port: 5432,
});

// Test de connexion et récupération des données d'essai
async function getTasks() {
  const res = await pool.query('SELECT * FROM tasks');
  return res.rows;
}