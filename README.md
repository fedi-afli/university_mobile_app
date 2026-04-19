# ScholarCheck

A Flutter-based school attendance management system with role-based access for admins, teachers, and students.

---

## Features

- **Admin** — Manage students, teachers, classes, and sessions
- **Teacher** — View assigned sessions and take attendance (appel)
- **Student** — View personal profile and absence history, export PDF report

---

## Tech Stack

- **Frontend:** Flutter (Dart)
- **Backend:** PHP REST API
- **Database:** MySQL
- **Local Server:** XAMPP / WAMP

---

## Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) >= 3.11
- [XAMPP](https://www.apachefriends.org/) or any Apache + MySQL stack
- PHP >= 7.4

---

## Setup

### 1. Database

Open **phpMyAdmin** (or any MySQL client) and run the following SQL to create and populate the database:

```sql
CREATE DATABASE gest_absence;
USE gest_absence;

CREATE TABLE utilisateurs (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nom VARCHAR(100),
  prenom VARCHAR(100),
  email VARCHAR(150) UNIQUE,
  password VARCHAR(255),
  role ENUM('admin', 'enseignant', 'etudiant'),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE classes (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nom VARCHAR(100),
  niveau VARCHAR(100)
);

CREATE TABLE matieres (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nom VARCHAR(100)
);

CREATE TABLE enseignants (
  id INT AUTO_INCREMENT PRIMARY KEY,
  utilisateur_id INT,
  specialite VARCHAR(100),
  FOREIGN KEY (utilisateur_id) REFERENCES utilisateurs(id)
);

CREATE TABLE etudiants (
  id INT AUTO_INCREMENT PRIMARY KEY,
  utilisateur_id INT,
  classe_id INT,
  FOREIGN KEY (utilisateur_id) REFERENCES utilisateurs(id),
  FOREIGN KEY (classe_id) REFERENCES classes(id)
);

CREATE TABLE seances (
  id INT AUTO_INCREMENT PRIMARY KEY,
  enseignant_id INT,
  classe_id INT,
  matiere_id INT,
  date_seance DATE,
  heure_debut TIME,
  heure_fin TIME,
  appel BOOLEAN DEFAULT FALSE,
  FOREIGN KEY (enseignant_id) REFERENCES enseignants(id),
  FOREIGN KEY (classe_id) REFERENCES classes(id),
  FOREIGN KEY (matiere_id) REFERENCES matieres(id)
);

CREATE TABLE absences (
  id INT AUTO_INCREMENT PRIMARY KEY,
  seance_id INT,
  etudiant_id INT,
  statut ENUM('present', 'absent'),
  FOREIGN KEY (seance_id) REFERENCES seances(id),
  FOREIGN KEY (etudiant_id) REFERENCES etudiants(id)
);

-- Seed data
INSERT INTO utilisateurs (nom, prenom, email, password, role) VALUES
  ('Admin', 'Système', 'admin@school.tn', '$2y$10$examplehashedpassword', 'admin'),
  ('Ben Ali', 'Sami', 'sami@school.tn', '$2y$10$examplehashedpassword', 'enseignant'),
  ('Trabelsi', 'Amine', 'amine@school.tn', '$2y$10$examplehashedpassword', 'etudiant');

INSERT INTO classes (nom, niveau) VALUES ('CI2-A', 'Cycle Ingénieur 2');
INSERT INTO matieres (nom) VALUES ('Développement Mobile'), ('Réseaux'), ('BDD');
INSERT INTO enseignants (utilisateur_id, specialite) VALUES (2, 'Informatique');
INSERT INTO etudiants (utilisateur_id, classe_id) VALUES (3, 1);
```

> **Note:** Passwords are hashed using `password_hash()` in PHP. Use the login endpoint or phpMyAdmin to set real hashed passwords. Test credentials can be inserted by running the PHP API's POST `/auth/login.php` with plain passwords directly.

### 2. Backend (PHP API)

1. Copy the `htdocs/` folder into your XAMPP `htdocs` directory and rename it to `gest_absence_api`:
   ```
   xampp/htdocs/gest_absence_api/
   ```

2. Update the database credentials in `htdocs/config/database.php` if needed:
   ```php
   $cmx = mysqli_connect("localhost", "root", "your_password");
   $db  = mysqli_select_db($cmx, "gest_absence");
   ```

3. Start **Apache** and **MySQL** from the XAMPP control panel.

### 3. Flutter App

1. Clone the repository:
   ```bash
   git clone <repo-url>
   cd projet_mobile
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Update the API base URL in `lib/config/api_config.dart`:
   ```dart
   const String ip = 'localhost'; // or your machine's local IP for mobile devices
   ```

4. Run the app:

   ```bash
   # Web
   flutter run -d chrome --web-port=8080

   # Android emulator
   flutter run -d android

   # iOS simulator
   flutter run -d ios
   ```

---

## Default Test Accounts

| Role       | Email                  | Password  |
|------------|------------------------|-----------|
| Admin      | admin@school.tn        | admin123  |
| Teacher    | sami@school.tn         | prof123   |
| Student    | amine@school.tn        | etu123    |

---

## Project Structure

```
lib/
├── config/          # API base URL configuration
├── models/          # Data models (Etudiant, Enseignant, Seance, ...)
└── screens/
    ├── admin/       # Admin screens (students, teachers, classes, sessions)
    ├── enseignant/  # Teacher screens (sessions list, attendance)
    └── etudiant/    # Student screens (profile, absences)

htdocs/
├── auth/            # Login API
├── admin/           # Admin CRUD endpoints
├── enseignant/      # Teacher endpoints
├── etudiant/        # Student endpoints
└── config/          # Database connection
```

---

## License

This project is for educational purposes.
