# Municipal To-Do Application

A modern task management system tailored for municipal services.

This application integrates the functionality of a classic To-Do app with advanced features designed to address municipal-level challenges. It serves as a platform for city residents to submit requests for resolving various issues and for municipal workers to manage and execute these tasks efficiently.

---

## 📖 Project Overview

The goal of the project was to develop a robust to-do application that meets the following requirements:

1. View a list of to-do items with filtering options (e.g., open, in-progress, closed).
2. Create new to-do items.
3. Edit existing to-do items.
4. Delete to-do items.
5. Complete to-do items.

Instead of building a basic to-do app, this project introduces an advanced **Issue Management System**, specifically tailored for municipal use. This system significantly extends the functionality of a standard to-do app by integrating features such as role-based access control, dynamic filtering and sorting, pagination, and enhanced UI/UX.

---

## 🌟 Features

### 1. View a List of To-Do Items
- Comprehensive list of issues, enhanced with additional attributes like **status** and **priority**.
- Filtering options:
    - **Status:** Open, In-Progress, Closed, or All.
    - **Priority:** High, Medium, or Low (available for employees and admins).
- Search functionality to find issues by **title** or **associated users** (creator or worker).

### 2. Create a New To-Do Item
- **Residents:** Create issues with a title, description, and optional image.
- **Employees and Admins:** Create issues with additional fields like priority and status.

### 3. Edit a To-Do Item
- Residents can update their submitted issues.
- Employees and admins can modify status, priority, and assign tasks.

### 4. Delete a To-Do Item
- Employees and admins can remove resolved or irrelevant issues.

### 5. Complete a To-Do Item
- Update an issue's status to "Closed."
- Employees can take ownership of issues by assigning them to themselves and updating their status throughout the process.

### 6. Role-Based Access Control
- **Residents:** Create and track issues.
- **Employees:** Manage issues by updating their status, priority, and assigning themselves tasks.
- **Administrators:** Have full control over all issues and access to a detailed admin panel.

### 7. Advanced Search and Filtering
- Dynamic filtering by status and priority.
- Sorting by title, creation date, status, or priority.

### 8. Pagination
- Powered by **Kaminari**, ensuring efficient performance with large datasets.

### 9. Clean and Responsive UI
- Built with **Bootstrap**, providing a modern and user-friendly interface.
- Buttons for actions such as “View,” “Edit,” and “Delete” are clearly styled and easy to use.

---

## 🚀 Local Development Guide

### Prerequisites
1. **Ruby**: Ensure you have Ruby `3.3.4` installed. Use [rbenv](https://github.com/rbenv/rbenv) or [rvm](https://rvm.io/).
2. **PostgreSQL**: Install and configure PostgreSQL.
3. **Node.js** and **Yarn**: For JavaScript dependencies.
4. **Bundler**: Manage Ruby gems (`gem install bundler`).

### Step-by-Step Installation

1. **Clone the Repository**
   ```bash
   git clone git@github.com:TsikhanauDzmitry/municipalities_app.git
   cd municipal-todo-app
   ```

2. **Install Dependencies**
   ```bash
   bundle install
   ```

3. **Configure the Database**
    - Update `config/database.yml` with your local database credentials.

4. **Set Up the Database**
   ```bash
   rails db:create db:migrate db:seed
   ```

5. **Start the Server**
   ```bash
   rails server
   ```
    - Visit `http://localhost:3000` to access the application.

---

## 🛠 Commands

### Run Rails Console
```bash
rails console
```

### Run Tests
```bash
rspec
```

### Database Management
- **Migrate**: `rails db:migrate`
- **Roll Back**: `rails db:rollback`
- **Seed**: `rails db:seed`

---

## 👩‍💻 User Roles

### Resident
- Can create and track their issues.

### Employee
- Manage statuses, priorities, and task assignments.
- **Credentials**:
    - **Email:** `employee@ex.com`
    - **Password:** `emp-password`

### Administrator
- Full control over all data and processes via the admin panel.
- **Credentials**:
    - **Email:** `admin@ex.com`
    - **Password:** `admin-password`
