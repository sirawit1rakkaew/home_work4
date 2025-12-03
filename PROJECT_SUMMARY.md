# Project Summary

## Overview

**Toy App** is a beginner-friendly Rails application demonstrating core concepts:
- Model creation and associations
- RESTful routing and controllers
- Form handling and validations
- Database relationships (1-to-many)

## Quick Facts

- **Framework**: Ruby on Rails 7.1.4
- **Language**: Ruby 3.1.2
- **Database**: SQLite3
- **Architecture**: MVC (Model-View-Controller)
- **Code Lines**: ~200 (excluding tests and dependencies)

## Core Components

### Models (2)
1. **User**
   - Fields: name, email
   - Relationships: has_many microposts
   - Validations: name & email required

2. **Micropost**
   - Fields: content (max 140 chars), user_id
   - Relationships: belongs_to user
   - Validations: content required & limited, user must exist

### Controllers (2)
1. **UsersController** (8 actions)
   - index, new, create, show, edit, update, destroy, destroy_all

2. **MicropostsController** (7 actions)
   - index, new, create, show, edit, update, destroy

### Views
- 5 user views (index, show, new, edit, _form)
- 5 micropost views (index, show, new, edit, _form)
- 1 layout template

## Key Features

✅ **CRUD Operations**
- Create users and microposts
- Read/view all data
- Update existing records
- Delete individual or bulk records

✅ **Validations**
- Presence validation (required fields)
- Length validation (micropost limit)
- Association validation (user must exist)

✅ **Database Relationships**
- One-to-many (User has many Microposts)
- Foreign key constraints
- Cascading deletes

✅ **RESTful Routing**
- Standard HTTP methods (GET, POST, PATCH, DELETE)
- Resource-based URLs
- Proper response handling

✅ **Error Handling**
- Form validation errors
- Not found (404) errors
- Unprocessable entity (422) errors

## Technology Stack

| Layer | Technology |
|-------|-----------|
| **Frontend** | HTML/ERB, CSS (basic) |
| **Backend** | Ruby on Rails 7.1 |
| **Database** | SQLite3 |
| **Server** | Puma |
| **Build** | Bundler, Sprockets |

## File Statistics

```
Controllers:      2 files     ~250 lines
Models:           2 files      ~20 lines
Views:           10 files     ~300 lines
Config:          10+ files    ~200 lines
Tests:           Basic Rails setup
Database:        2 migrations  ~30 lines
Total:           ~1000 lines (with Rails framework)
```

## Installation

```bash
git clone <repository-url>
cd toy_app
bundle install
rails db:setup
rails server
```

Visit: http://localhost:3000

## Common Use Cases

### For Learning
- Understand Rails structure
- Learn model associations
- Practice RESTful design
- Try form handling
- Explore validations

### For Practice
- Add new features (e.g., likes, comments)
- Implement authentication
- Add styling with CSS
- Write tests
- Deploy to production

### For Reference
- View Rails conventions
- See controller examples
- Study view templates
- Check migration format

## Learning Path

1. **Start Here**: Read [README.md](README.md)
2. **Installation**: Follow [INSTALLATION.md](INSTALLATION.md)
3. **Understanding**: Review [API.md](API.md)
4. **Development**: Study [DEVELOPMENT.md](DEVELOPMENT.md)
5. **Explore**: Check the code in `app/`

## Database Diagram

```
┌──────────────────┐           ┌──────────────────────┐
│     Users        │           │    Microposts        │
├──────────────────┤           ├──────────────────────┤
│ id (PK)          │◄──────────│ id (PK)              │
│ name             │   1:N     │ content              │
│ email            │           │ user_id (FK)         │
│ created_at       │           │ created_at           │
│ updated_at       │           │ updated_at           │
└──────────────────┘           └──────────────────────┘

PK = Primary Key
FK = Foreign Key
1:N = One-to-Many relationship
```

## Code Examples

### Create User
```ruby
# Controller
user = User.new(name: "John", email: "john@example.com")
user.save

# Or in one line
User.create(name: "John", email: "john@example.com")
```

### Create Micropost
```ruby
# Controller
micropost = Micropost.new(content: "Hello!", user_id: 1)
micropost.save

# Or through association
user.microposts.create(content: "Hello!")
```

### Query Data
```ruby
# Get all users
User.all

# Get user by ID
User.find(1)

# Get user's microposts
@user.microposts

# Get all microposts for a user
Micropost.where(user_id: 1)
```

## Routes Summary

```
Verb   URI Pattern            Controller#Action
─────────────────────────────────────────────────
GET    /                      users#index
GET    /users                 users#index
GET    /users/:id             users#show
GET    /users/new             users#new
GET    /users/:id/edit        users#edit
POST   /users                 users#create
PATCH  /users/:id             users#update
DELETE /users/:id             users#destroy
DELETE /users/destroy_all     users#destroy_all

GET    /microposts            microposts#index
GET    /microposts/:id        microposts#show
GET    /microposts/new        microposts#new
GET    /microposts/:id/edit   microposts#edit
POST   /microposts            microposts#create
PATCH  /microposts/:id        microposts#update
DELETE /microposts/:id        microposts#destroy
```

## Next Steps

### To Extend the App
- Add user authentication (login/signup)
- Add timestamps for microposts
- Add pagination for lists
- Add likes/favorites
- Add comments on microposts
- Add user profiles
- Add search functionality

### To Deploy
- Set up production database
- Configure environment variables
- Deploy to Heroku, AWS, or DigitalOcean
- Set up SSL certificate
- Configure domains

### To Test
- Write model tests
- Write controller tests
- Write integration tests
- Set up CI/CD pipeline

## Key Learning Points

1. **Model Associations**: Understanding belongs_to and has_many
2. **Validations**: Ensuring data integrity
3. **RESTful Design**: Using HTTP methods properly
4. **MVC Pattern**: Separating concerns
5. **Cascading Deletes**: Managing related data
6. **Error Handling**: User-friendly error messages

## Troubleshooting Quick Links

- Database issues → [INSTALLATION.md](INSTALLATION.md#troubleshooting)
- API issues → [API.md](API.md#error-handling)
- Development issues → [DEVELOPMENT.md](DEVELOPMENT.md#debugging)

## Resources

- [Rails Official Docs](https://guides.rubyonrails.org/)
- [Ruby Documentation](https://www.ruby-lang.org/en/documentation/)
- [SQLite Documentation](https://www.sqlite.org/docs.html)
- [HTTP Status Codes](https://httpwg.org/specs/rfc7231.html#status.codes)

## Support

If you need help:

1. Check the documentation files (README, INSTALLATION, DEVELOPMENT, API)
2. Review Rails logs: `tail -f log/development.log`
3. Use Rails console to debug: `rails console`
4. Check the source code in `app/` directory

## License

This project is for educational purposes.

---

**Last Updated**: December 3, 2025
**Rails Version**: 7.1.4
**Ruby Version**: 3.1.2
