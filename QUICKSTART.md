# Quick Start Guide

Get up and running in 5 minutes.

## 1️⃣ Clone & Install (2 minutes)

```bash
# Clone repository
git clone <repository-url>
cd toy_app

# Install gems
bundle install
```

## 2️⃣ Setup Database (1 minute)

```bash
# Create and initialize database
rails db:setup
```

## 3️⃣ Start Server (1 minute)

```bash
# Run development server
rails server -b 0.0.0.0

# Or short form
rails s -b 0.0.0.0
```

**Output should show:**
```
=> Booting Puma
=> Rails 7.1.4 application starting in development
=> Listening on http://127.0.0.1:3000
```

## 4️⃣ Open Browser (1 minute)

Visit: **http://localhost:3000**

## 🎯 What You Can Do

### Create a User
1. Click "New user"
2. Fill in name and email
3. Click "Create User"
4. ✅ User created!

### Create a Micropost
1. On user profile page, fill "Content" field
2. Type a message (max 140 characters)
3. Click "Create Micropost"
4. ✅ Micropost created!

### View Everything
- **Users List**: http://localhost:3000/users
- **Microposts**: http://localhost:3000/microposts
- **User Profile**: http://localhost:3000/users/1

### Delete Data
- Click "Destroy" button next to any user or micropost
- Click "Delete All Users" to remove all users

## 📚 Documentation

| Document | Purpose |
|----------|---------|
| [README.md](README.md) | **Complete overview** |
| [INSTALLATION.md](INSTALLATION.md) | **Detailed setup** |
| [API.md](API.md) | **All endpoints** |
| [DEVELOPMENT.md](DEVELOPMENT.md) | **For developers** |
| [PROJECT_SUMMARY.md](PROJECT_SUMMARY.md) | **Project info** |

## ❌ Troubleshooting

### "Port 3000 already in use"
```bash
rails server -p 3001
```

### "Bundler requires Ruby 3.1.2"
```bash
ruby --version  # Check your Ruby version
# Update Ruby if needed, then try again
```

### "SQLite error"
```bash
rails db:reset
rails db:setup
```

### "Migrations pending"
```bash
rails db:migrate
```

## 🔥 What's Happening?

**Behind the scenes:**

```
Browser Request
    ↓
Route (config/routes.rb)
    ↓
Controller (app/controllers/)
    ↓
Model (app/models/)
    ↓
Database (storage/development.sqlite3)
    ↓
View (app/views/)
    ↓
HTML Response
```

## 💡 Key Concepts

### Models
- **User**: Can have many microposts
- **Micropost**: Belongs to one user

### Actions
- **Create**: Add new user or micropost
- **Read**: View list or details
- **Update**: Edit user or micropost
- **Delete**: Remove user or micropost

### Validation
- User must have name & email
- Micropost must have content (max 140 chars)
- Micropost must have valid user

## 🚀 Next Steps

1. **Explore the code**: Check `app/` directory
2. **Try the console**: `rails console` to run code
3. **Read guides**: Check [DEVELOPMENT.md](DEVELOPMENT.md)
4. **Add features**: Try adding a new field to User
5. **Learn Rails**: Use [official guides](https://guides.rubyonrails.org/)

## 📞 Need Help?

1. Check [INSTALLATION.md](INSTALLATION.md) troubleshooting
2. Read [API.md](API.md) for endpoint details
3. Review [DEVELOPMENT.md](DEVELOPMENT.md) for code examples
4. Check Rails logs: `tail -f log/development.log`

---

**You're all set! Happy coding! 🎉**
