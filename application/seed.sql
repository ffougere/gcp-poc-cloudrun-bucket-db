CREATE TABLE IF NOT EXISTS tasks (
  id SERIAL PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  completed BOOLEAN DEFAULT FALSE
);

INSERT INTO tasks (title) VALUES ('Déployer sur Cloud Run'), ('Tester la connexion VPC'), ('Vérifier le stockage GCS');