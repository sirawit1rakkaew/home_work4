# Development Guide

Comprehensive guide for developers working on the Toy App project.

## Getting Started

### Initial Setup
```bash
# Clone and install
git clone <repository-url>
cd toy_app
bundle install
rails db:setup

# Start development
rails server -b 0.0.0.0
```

### File Structure Overview

```
toy_app/
├── app/                          # Application code
│   ├── controllers/              # Request handlers
│   │   ├── application_controller.rb
│   │   ├── users_controller.rb
│   │   └── microposts_controller.rb
│   ├── models/                   # Data models
│   │   ├── user.rb
│   │   └── micropost.rb
│   ├── views/                    # Templates
│   │   ├── layouts/
│   │   │   └── application.html.erb
│   │   ├── users/
│   │   └── microposts/
│   ├── helpers/                  # View helpers
│   └── jobs/                     # Background jobs
├── config/                       # Configuration
│   ├── routes.rb                 # Route definitions
│   ├── database.yml              # Database config
│   └── environments/             # Environment-specific config
├── db/                           # Database
│   ├── migrate/                  # Database migrations
│   ├── schema.rb                 # Current schema
│   └── seeds.rb                  # Sample data
├── test/                         # Test files
├── public/                       # Static files
├── Gemfile                       # Dependencies
└── README.md                     # Documentation
```

## Database

### Schema

**Users Table:**
```ruby
create_table "users" do |t|
  t.string "name"              # User's name
  t.string "email"             # User's email address
  t.datetime "created_at"      # Record creation time
  t.datetime "updated_at"      # Last modification time
end
```

**Microposts Table:**
```ruby
create_table "microposts" do |t|
  t.text "content"             # Post content (max 140 chars)
  t.integer "user_id"          # Foreign key to users
  t.datetime "created_at"      # Record creation time
  t.datetime "updated_at"      # Last modification time
end
```

### Migrations

#### Create a New Migration
```bash
# Generate migration
rails generate migration AddFieldToUsers field_name:type

# Example
rails generate migration AddPhoneToUsers phone:string

# Run migrations
rails db:migrate

# Rollback last migration
rails db:rollback

# Check status
rails db:migrate:status
```

#### Common Migration Types
```ruby
# In migration file
class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :name               # String field
      t.text :bio                  # Long text field
      t.integer :age               # Integer field
      t.boolean :active            # Boolean field
      t.datetime :joined_at        # DateTime field
      t.references :user           # Foreign key
      
      t.timestamps                 # created_at, updated_at
    end
  end
end
```

## Models

### User Model
```ruby
# app/models/user.rb
class User < ApplicationRecord
  # Associations
  has_many :microposts, dependent: :destroy
  
  # Validations
  validates :name, :email, presence: true
end
```

**Adding validation:**
```ruby
validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
validates :name, presence: true, length: { minimum: 2, maximum: 50 }
```

### Micropost Model
```ruby
# app/models/micropost.rb
class Micropost < ApplicationRecord
  # Associations
  belongs_to :user
  
  # Validations
  validates :content, length: { maximum: 140 }, presence: true
  validates :user_id, presence: true
end
```

**Adding scope (useful for queries):**
```ruby
scope :recent, -> { order(created_at: :desc) }
scope :by_user, ->(user_id) { where(user_id: user_id) }
```

## Controllers

### Users Controller Actions

```ruby
class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  def index
    @users = User.all  # Fetch all users
  end

  # GET /users/:id
  def show
    @micropost = Micropost.new  # For form on user page
    # @user is set by before_action
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # POST /users
  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to @user
    else
      render :new
    end
  end

  # More actions...
end
```

### Controller Flow

```
Request → Route → Controller Action → Model → View
  ↓
  └─ Validations/Errors → Re-render with errors
  └─ Success → Redirect to another page
```

### Common Controller Patterns

```ruby
# Fetch record
@user = User.find(params[:id])

# Respond to multiple formats
respond_to do |format|
  format.html { redirect_to @user }
  format.json { render json: @user }
end

# Flash messages
redirect_to users_path, notice: "User created successfully"
redirect_to users_path, alert: "Error occurred"
```

## Views

### ERB Template Syntax

```erb
<!-- Variables -->
<%= @user.name %>

<!-- Control flow -->
<% if @user %>
  User exists
<% else %>
  No user
<% end %>

<!-- Loops -->
<% @users.each do |user| %>
  <p><%= user.name %></p>
<% end %>

<!-- Links -->
<%= link_to "View User", user_path(@user) %>
<%= link_to "Delete", @user, method: :delete, data: { confirm: "Sure?" } %>

<!-- Forms -->
<%= form_with model: @user do |f| %>
  <%= f.text_field :name %>
  <%= f.text_area :content %>
  <%= f.submit "Save" %>
<% end %>
```

### View Partials

```erb
<!-- app/views/users/_form.html.erb -->
<%= form_with model: user do |form| %>
  <%= form.text_field :name %>
  <%= form.submit %>
<% end %>

<!-- app/views/users/new.html.erb -->
<h1>New User</h1>
<%= render "form", user: @user %>
```

## Routes

### Routes File
```ruby
# config/routes.rb
Rails.application.routes.draw do
  resources :users      # Creates 7 RESTful routes
  resources :microposts # Creates 7 RESTful routes
  
  # Custom route
  delete "users/destroy_all", to: "users#destroy_all"
  
  # Root route (home page)
  root "users#index"
end
```

### Generated Routes for `resources :users`

```
GET    /users             → users#index
GET    /users/new         → users#new
POST   /users             → users#create
GET    /users/:id         → users#show
GET    /users/:id/edit    → users#edit
PATCH  /users/:id         → users#update
DELETE /users/:id         → users#destroy
```

### Path Helpers
```erb
<!-- Generate URLs -->
<%= user_path(@user) %>           # /users/1
<%= users_path %>                 # /users
<%= new_user_path %>              # /users/new
<%= edit_user_path(@user) %>      # /users/1/edit
<%= root_path %>                  # /
```

## Testing

### Run Tests
```bash
# All tests
rails test

# Specific test file
rails test test/models/user_test.rb

# Specific test method
rails test test/models/user_test.rb:23

# Verbose output
rails test -v

# With coverage
bundle exec simplecov
```

### Write Tests

```ruby
# test/models/user_test.rb
require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "user must have name and email" do
    user = User.new
    assert_not user.valid?
    assert_includes user.errors.keys, :name
  end
  
  test "user with valid attributes" do
    user = User.new(name: "John", email: "john@example.com")
    assert user.valid?
  end
end
```

## Common Development Tasks

### Add a New Feature

1. **Create migration** (if adding fields)
   ```bash
   rails generate migration AddPhoneToUsers phone:string
   rails db:migrate
   ```

2. **Update model** with validations
   ```ruby
   # app/models/user.rb
   validates :phone, presence: true
   ```

3. **Create controller action**
   ```ruby
   def search
     @users = User.where(name: params[:query])
   end
   ```

4. **Add route**
   ```ruby
   # config/routes.rb
   resources :users do
     collection { get :search }
   end
   ```

5. **Create view**
   ```erb
   <!-- app/views/users/search.html.erb -->
   <%= form_with url: search_users_path do |f| %>
     <%= f.text_field :query %>
     <%= f.submit "Search" %>
   <% end %>
   ```

### Add a Validation

```ruby
# app/models/user.rb
class User < ApplicationRecord
  validates :email, presence: true, uniqueness: true
  validates :name, presence: true, length: { minimum: 2 }
end
```

### Add a Scope

```ruby
# app/models/micropost.rb
class Micropost < ApplicationRecord
  scope :recent, -> { order(created_at: :desc) }
  scope :by_user, ->(user_id) { where(user_id: user_id) }
end

# Usage
Micropost.recent
Micropost.by_user(1)
```

### Query Data

```ruby
# In controller or rails console
User.all                          # All users
User.find(1)                      # Find by ID
User.where(name: "John")          # Find by attribute
User.where.not(email: nil)        # Complex queries
User.order(:name)                 # Sort
User.limit(10)                    # Limit results
User.count                        # Count records

# Through association
@user.microposts                  # All microposts for user
@user.microposts.recent           # With scope
```

## Debugging

### Rails Console
```bash
# Start interactive console
rails console

# Create test data
user = User.create(name: "Test", email: "test@example.com")

# Query data
User.all
User.where(name: "Test")

# Update data
user.update(name: "Updated")

# Delete data
user.destroy
```

### Debugging Tools

```ruby
# In views
<%= debug @user %>              # Pretty print object
<%= @user.inspect %>            # Detailed inspection

# In console
puts @user.inspect              # Print to console
```

### Check Logs
```bash
tail -f log/development.log     # Follow log file
cat log/development.log | grep "ERROR"  # Show errors
```

## Performance Tips

### N+1 Query Prevention
```ruby
# Bad - causes N+1 queries
@users = User.all
@users.each { |u| u.microposts.count }

# Good - eager load
@users = User.includes(:microposts)
```

### Limit Database Queries
```ruby
# Use select to limit columns
User.select(:id, :name)

# Use pluck for arrays
User.pluck(:name)

# Pagination
User.limit(10).offset(20)
```

## Code Style

### Follow Rails Conventions

```ruby
# Models (singular)
class User < ApplicationRecord
end

# Controllers (plural)
class UsersController < ApplicationController
end

# Views (plural, snake_case)
app/views/users/index.html.erb

# Files (snake_case)
app/models/user.rb
app/controllers/users_controller.rb
```

### Naming Conventions

```ruby
# Model methods
def full_name                    # Instance method
  "#{first_name} #{last_name}"
end

def self.active                  # Class method
  where(active: true)
end

# Controller
def show                         # Action name (verb)
  @user = User.find(params[:id])
end

# Variables
@user        # Instance variable (for views)
user         # Local variable
USER_COUNT   # Constant
```

## Useful Commands

```bash
# Server
rails server -p 3000 -b 0.0.0.0

# Console
rails console
rails c

# Generate code
rails generate model User name:string email:string
rails generate migration AddPhoneToUsers

# Database
rails db:create
rails db:migrate
rails db:seed
rails db:reset

# Testing
rails test

# Help
rails --help
rails generate --help
```

## Resources

- [Rails Guides](https://guides.rubyonrails.org/)
- [API Documentation](https://api.rubyonrails.org/)
- [Active Record](https://guides.rubyonrails.org/active_record_basics.html)
- [Action Controller](https://guides.rubyonrails.org/action_controller_overview.html)
- [Action View](https://guides.rubyonrails.org/action_view_overview.html)

