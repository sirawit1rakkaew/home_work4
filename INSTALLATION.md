# Installation Guide

Complete step-by-step installation guide for the Toy App.

## Prerequisites Checklist

Before starting, ensure you have:

- [ ] Git installed
- [ ] Ruby 3.1.2+ installed
- [ ] Ruby gems working
- [ ] SQLite3 installed
- [ ] Node.js 14+ installed
- [ ] npm installed

## Step-by-Step Installation

### 1. System Preparation

#### macOS
```bash
# Install Homebrew if not already installed
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install dependencies
brew install ruby@3.1 sqlite3 node
brew link ruby@3.1
```

#### Ubuntu/Debian
```bash
# Update package manager
sudo apt update
sudo apt upgrade

# Install dependencies
sudo apt install -y ruby-full ruby-dev sqlite3 nodejs npm
```

#### Windows (WSL Recommended)
Follow Ubuntu/Debian instructions within Windows Subsystem for Linux (WSL2)

### 2. Clone Repository

```bash
# Choose a directory
cd ~/projects  # or your preferred location

# Clone the repository
git clone <repository-url>

# Navigate to project
cd toy_app
```

### 3. Install Ruby Gems

```bash
# Update bundler
gem update bundler

# Install gems from Gemfile
bundle install

# If errors occur, try:
bundle install --local
```

**Common Gem Installation Issues:**

| Error | Solution |
|-------|----------|
| `sqlite3` compilation fails | `gem install sqlite3 -- --with-sqlite3-dir=/usr/local/opt/sqlite3` |
| `Nokogiri` fails | `bundle config build.nokogiri --use-system-libraries` |
| Permission denied | Use `rbenv` or `rvm` instead of system Ruby |

### 4. Database Setup

```bash
# Create and initialize database
rails db:setup

# Verify setup
rails db:migrate:status

# Should show: database.yml is not present
# (This is normal, Rails uses SQLite directly)
```

**What db:setup does:**
1. Creates `storage/development.sqlite3` database file
2. Runs all migrations in `db/migrate/`
3. Populates initial schema from `db/schema.rb`

### 5. Start Development Server

```bash
# Standard startup (port 3000)
rails server

# Or with full binding (allows remote connections)
rails server -b 0.0.0.0

# Or on specific port
rails server -p 3001 -b 0.0.0.0
```

**Server Output:**
```
=> Booting Puma
=> Rails 7.1.4 application starting in development
=> Run `rails server --help` for more startup options
Puma starting in single mode...
* Listening on http://127.0.0.1:3000
```

### 6. Verify Installation

Open your browser and visit:
- **Home Page**: http://localhost:3000
- **Users List**: http://localhost:3000/users
- **Microposts List**: http://localhost:3000/microposts

You should see:
- Users page with "New user" link
- Ability to create a new user
- Ability to create microposts

## Verification Tests

### Test 1: Create a User
1. Go to http://localhost:3000
2. Click "New user"
3. Fill in: Name: "Test User", Email: "test@example.com"
4. Click "Create User"
5. ✅ You should see the user profile page

### Test 2: Create a Micropost
1. On the user profile page, fill in "Content" field
2. Type a message (max 140 characters)
3. Click "Create Micropost"
4. ✅ You should see the micropost on the user's profile

### Test 3: List All Microposts
1. Click "Back to microposts"
2. ✅ You should see the micropost you just created

## Database Backup & Reset

### Backup Current Database
```bash
cp storage/development.sqlite3 storage/development.sqlite3.backup
```

### Reset Database
```bash
rails db:reset          # Resets and runs all migrations
# Or manually:
rm storage/development.sqlite3
rails db:setup
```

## Troubleshooting Installation

### Issue: "Command not found: ruby"
```bash
# Check Ruby installation
which ruby
ruby --version

# If not found, install Ruby:
# macOS: brew install ruby@3.1
# Ubuntu: sudo apt install ruby ruby-dev
```

### Issue: "Bundler requires Ruby 3.1.2"
```bash
# Update Ruby version
rbenv install 3.1.2          # If using rbenv
rvm install 3.1.2            # If using rvm
ruby --version               # Verify
bundle install               # Try again
```

### Issue: "SQLite3 gem failed to compile"
```bash
# macOS
brew install sqlite3
bundle config build.sqlite3 --with-sqlite3-dir=/usr/local/opt/sqlite3
bundle install

# Ubuntu
sudo apt install libsqlite3-dev
bundle install
```

### Issue: "Port 3000 already in use"
```bash
# Find process using port 3000
lsof -i :3000

# Kill the process
kill -9 <PID>

# Or use different port
rails server -p 3001
```

### Issue: "Can't find database file"
```bash
# Ensure database exists
rails db:create

# Check file location
ls -la storage/development.sqlite3

# If missing, recreate:
rails db:setup
```

### Issue: "Migration pending"
```bash
# Run pending migrations
rails db:migrate

# Check migration status
rails db:migrate:status
```

## Development Environment Variables

### Create `.env` file (Optional)
```bash
# .env file (add to .gitignore)
RAILS_ENV=development
RAILS_LOG_TO_STDOUT=true
PORT=3000
```

Load with bundler:
```bash
bundle exec rails server
```

## Docker Setup (Alternative)

If you prefer Docker:

```bash
# Build image
docker build -t toy_app .

# Run container
docker run -p 3000:3000 toy_app

# With volume mounting
docker run -p 3000:3000 -v $(pwd):/app toy_app
```

## IDE Setup Recommendations

### Visual Studio Code
```bash
# Install extensions
- Ruby
- Rails Intellisense
- SQLite
- ERB
```

### RubyMine
- Install RubyMine
- Open project folder
- Configure Ruby interpreter to 3.1.2
- Configure Rails project

### Vim/Neovim
```bash
# Install relevant plugins for Ruby/Rails
# Recommended: vim-rails, vim-ruby
```

## Next Steps

After successful installation:

1. **Create test data**: Create users and microposts
2. **Explore code**: Review models, controllers, views
3. **Run tests**: `rails test`
4. **Read documentation**: See README.md for API documentation
5. **Make changes**: Modify code and test in browser

## Support

If you encounter issues:

1. Check this guide's troubleshooting section
2. Review Rails logs: `tail -f log/development.log`
3. Check database: `sqlite3 storage/development.sqlite3 ".tables"`
4. Run in verbose mode: `rails server -v`

## What's Next?

Refer to the main [README.md](README.md) for:
- API Documentation
- Feature Overview
- Project Architecture
- Usage Examples
