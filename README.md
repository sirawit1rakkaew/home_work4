# Toy App - Rails Users & Microposts

A simple Rails 7 application demonstrating **CRUD operations** with **Users and Microposts** with proper model associations and validations.

## 📋 Table of Contents

- [Quick Start](#quick-start)
- [System Requirements](#system-requirements)
- [Installation](#installation)
- [Running the Application](#running-the-application)
- [Features](#features)
- [API Documentation](#api-documentation)
- [Database Schema](#database-schema)
- [Project Architecture](#project-architecture)
- [Troubleshooting](#troubleshooting)

## 🚀 Quick Start

```bash
# Clone the repository
git clone <repository-url>
cd toy_app

# Install dependencies
bundle install

# Setup database
rails db:setup

# Start the server
rails server -b 0.0.0.0

# Visit http://localhost:3000
```

## 💻 System Requirements

- **Ruby**: 3.1.2 or later
- **Rails**: 7.1.4 or later
- **SQLite3**: 3.8.0 or later
- **Bundler**: Latest version
- **Node.js**: 14.0 or later (for asset compilation)
- **npm**: 6.0 or later

### Check your system:
```bash
ruby --version          # Should be 3.1.2+
rails --version         # Should be 7.1.4+
sqlite3 --version       # Should be 3.8.0+
node --version          # Should be 14.0+
```

## 📦 Installation

### 1. Clone Repository
```bash
git clone <repository-url>
cd toy_app
```

### 2. Install Ruby Dependencies
```bash
# Install all gems from Gemfile
bundle install

# If bundle install fails, update bundler first
gem update bundler
bundle install
```

### 3. Setup Database
```bash
# Create and initialize database
rails db:setup

# Or manually:
rails db:create          # Create database
rails db:migrate         # Run migrations
rails db:seed            # (Optional) Seed sample data
```

### 4. Verify Installation
```bash
# Run tests
rails test

# Check for errors
rails db:migrate:status
```

## ▶️ Running the Application

### Start Development Server
```bash
# Standard port 3000
rails server

# Or with explicit IP binding (for remote access)
rails server -b 0.0.0.0

# Or on a different port
rails server -p 3001
```

### Access the Application
- **Home/Users List**: http://localhost:3000
- **Microposts List**: http://localhost:3000/microposts
- **Create New User**: http://localhost:3000/users/new
- **Create New Micropost**: http://localhost:3000/microposts/new

## ✨ Features

### User Management
- ✅ Create new users with name and email
- ✅ View all users in a list
- ✅ View individual user profile
- ✅ Edit user information
- ✅ Delete individual users
- ✅ Delete all users at once
- ✅ Validation: Name and email are required

### Micropost Management
- ✅ Create microposts associated with users
- ✅ View all microposts in a list
- ✅ View individual micropost
- ✅ Edit existing microposts
- ✅ Delete microposts
- ✅ Limit micropost content to 140 characters
- ✅ Auto-delete microposts when user is deleted (cascading delete)
- ✅ User selection via dropdown (synced with User list)

### Advanced Features
- ✅ RESTful API architecture
- ✅ Model validations for data integrity
- ✅ Proper error handling and display
- ✅ Transaction-based bulk delete operations
- ✅ Responsive form validation

## 📡 API Documentation

### Users Endpoints

| Method | Endpoint | Action | Description |
|--------|----------|--------|-------------|
| GET | `/users` | index | List all users |
| GET | `/users/:id` | show | Show user details & their microposts |
| GET | `/users/new` | new | Form to create new user |
| POST | `/users` | create | Create a new user |
| GET | `/users/:id/edit` | edit | Edit user form |
| PUT/PATCH | `/users/:id` | update | Update user information |
| DELETE | `/users/:id` | destroy | Delete a user |
| DELETE | `/users/destroy_all` | destroy_all | Delete all users |

### Microposts Endpoints

| Method | Endpoint | Action | Description |
|--------|----------|--------|-------------|
| GET | `/microposts` | index | List all microposts |
| GET | `/microposts/:id` | show | Show micropost details |
| GET | `/microposts/new` | new | Form to create new micropost |
| POST | `/microposts` | create | Create a new micropost |
| GET | `/microposts/:id/edit` | edit | Edit micropost form |
| PUT/PATCH | `/microposts/:id` | update | Update micropost content |
| DELETE | `/microposts/:id` | destroy | Delete a micropost |

### Root Route
| Route | Endpoint |
|-------|----------|
| / | Users index page (default home) |

## 🗄️ Database Schema

### Users Table
```sql
CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL,
  created_at DATETIME NOT NULL,
  updated_at DATETIME NOT NULL
);
```

**Validations:**
- `name`: Required (must be present)
- `email`: Required (must be present)

**Associations:**
- `has_many :microposts, dependent: :destroy` - When a user is deleted, all their microposts are automatically deleted

### Microposts Table
```sql
CREATE TABLE microposts (
  id INTEGER PRIMARY KEY,
  content TEXT,
  user_id INTEGER NOT NULL,
  created_at DATETIME NOT NULL,
  updated_at DATETIME NOT NULL
);
```

**Validations:**
- `content`: Required, maximum 140 characters
- `user_id`: Required (must reference an existing user)

**Associations:**
- `belongs_to :user` - Each micropost belongs to exactly one user

## 🏗️ Project Architecture

### Directory Structure
```
toy_app/
├── app/
│   ├── controllers/
│   │   ├── application_controller.rb
│   │   ├── users_controller.rb
│   │   └── microposts_controller.rb
│   ├── models/
│   │   ├── application_record.rb
│   │   ├── user.rb
│   │   └── micropost.rb
│   ├── views/
│   │   ├── layouts/
│   │   │   └── application.html.erb
│   │   ├── users/
│   │   │   ├── index.html.erb
│   │   │   ├── show.html.erb
│   │   │   ├── new.html.erb
│   │   │   ├── edit.html.erb
│   │   │   └── _form.html.erb
│   │   └── microposts/
│   │       ├── index.html.erb
│   │       ├── show.html.erb
│   │       ├── new.html.erb
│   │       ├── edit.html.erb
│   │       ├── _form.html.erb
│   │       └── _micropost.html.erb
│   └── helpers/
├── config/
│   ├── routes.rb
│   ├── database.yml
│   ├── cable.yml
│   └── environments/
├── db/
│   ├── migrate/
│   │   ├── *_create_users.rb
│   │   └── *_create_microposts.rb
│   ├── schema.rb
│   └── seeds.rb
├── Gemfile
├── Gemfile.lock
├── README.md
└── Rakefile
```

### Key Files

#### Models
- **`app/models/user.rb`**: User model with associations and validations
- **`app/models/micropost.rb`**: Micropost model with associations and validations

#### Controllers
- **`app/controllers/users_controller.rb`**: Handles user CRUD operations + bulk delete
- **`app/controllers/microposts_controller.rb`**: Handles micropost CRUD operations

#### Views
- **User Views**: Forms for creating/editing users, display user list and details
- **Micropost Views**: Forms for creating/editing microposts, display all microposts
- **Layouts**: Base HTML layout template

#### Configuration
- **`config/routes.rb`**: Defines all route mappings
- **`config/database.yml`**: SQLite3 configuration for different environments
- **`Gemfile`**: Ruby dependencies

### Model Relationships

```
┌─────────────────────────────────────────────┐
│             User Model                      │
├─────────────────────────────────────────────┤
│ - id (Primary Key)                          │
│ - name (String)                             │
│ - email (String)                            │
│ - created_at (DateTime)                     │
│ - updated_at (DateTime)                     │
│                                             │
│ has_many :microposts (dependent: :destroy) │
│ Validations: name, email (presence)         │
└─────────────────────────────────────────────┘
                     ▲
                     │ 1:N relationship
                     │
                     │
┌─────────────────────────────────────────────┐
│          Micropost Model                    │
├─────────────────────────────────────────────┤
│ - id (Primary Key)                          │
│ - content (Text)                            │
│ - user_id (Integer - Foreign Key)           │
│ - created_at (DateTime)                     │
│ - updated_at (DateTime)                     │
│                                             │
│ belongs_to :user                            │
│ Validations: content (presence, max 140),   │
│             user_id (presence)              │
└─────────────────────────────────────────────┘
```

## 🔍 Workflow Example

### Creating a User and Micropost

1. **Go to Home Page**
   - Navigate to http://localhost:3000
   - Click "New user" link

2. **Create User**
   - Fill in name (e.g., "John Doe")
   - Fill in email (e.g., "john@example.com")
   - Click "Create User"
   - User is created and you're redirected to user's profile page

3. **Create Micropost**
   - On the user's profile page, fill in "Content" textarea
   - Click "Create Micropost"
   - Micropost is created and displayed on the user's profile

4. **View All Microposts**
   - Click "Back to microposts" to see all microposts across all users
   - Click on any micropost to see details

5. **Edit/Delete**
   - Click "Edit" to modify any user or micropost
   - Click "Destroy" to delete

## 🐛 Troubleshooting

### Problem: `bundle install` fails
**Solution:**
```bash
gem update bundler
gem install bundler
bundle install
```

### Problem: Database errors
**Solution:**
```bash
# Reset database completely
rails db:reset

# Or manually:
rm storage/development.sqlite3
rails db:create
rails db:migrate
```

### Problem: Port 3000 already in use
**Solution:**
```bash
# Use a different port
rails server -p 3001

# Or find and kill the process
lsof -i :3000
kill -9 <PID>
```

### Problem: "User must exist" error when creating micropost
**Solution:**
- Ensure you have created at least one user first
- In the micropost form, select a valid user from the dropdown
- If dropdown is empty, create a user first

### Problem: Migrations not running
**Solution:**
```bash
rails db:migrate:status
rails db:migrate RAILS_ENV=development
```

### Problem: Assets not loading
**Solution:**
```bash
rails assets:precompile
rails assets:clobber
```

### Problem: "Can't find executable gem"
**Solution:**
```bash
which ruby
ruby -v
gem env
```

## 📝 Development Notes

### Key Implementation Details

1. **User Deletion Cascade**: When a user is deleted, all associated microposts are automatically deleted (dependent: :destroy)

2. **Micropost User Selection**: The micropost form uses a dropdown that dynamically loads all available users from the database. When you add/delete users, the dropdown updates when you refresh the form.

3. **Content Limit**: Microposts are limited to 140 characters (like Twitter's original limit)

4. **Validation Flow**:
   - User creation requires both name and email
   - Micropost creation requires content and valid user_id
   - Form displays all validation errors with details

5. **Bulk Delete**: Users can delete all users at once using the "Delete All Users" button, which uses database transactions to ensure consistency

### Database Transactions

The bulk delete operation uses `User.transaction` to ensure all-or-nothing deletion:
```ruby
User.transaction do
  User.find_each do |user|
    user.destroy!
  end
end
```

## 🧪 Running Tests

```bash
# Run all tests
rails test

# Run specific test file
rails test test/models/user_test.rb

# Run with verbose output
rails test -v
```

## 📚 Additional Resources

- [Rails Official Guides](https://guides.rubyonrails.org/)
- [Active Record Associations](https://guides.rubyonrails.org/association_basics.html)
- [Rails Routing](https://guides.rubyonrails.org/routing.html)
- [Rails Form Helpers](https://guides.rubyonrails.org/form_helpers.html)

## 📄 License

This project is for educational purposes.

#   h o m e _ w o r k 4  
 