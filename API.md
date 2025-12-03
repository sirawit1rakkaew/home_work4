# API Usage Guide

Complete guide for using the Toy App API and understanding REST conventions.

## Overview

The Toy App implements RESTful architecture with standard HTTP methods for managing Users and Microposts.

## REST Principles

| HTTP Method | CRUD Operation | Purpose |
|-------------|----------------|---------|
| GET | Read | Retrieve resource(s) |
| POST | Create | Create a new resource |
| PATCH/PUT | Update | Modify existing resource |
| DELETE | Delete | Remove resource |

## Users API

### List All Users
**GET `/users`**

```bash
curl http://localhost:3000/users
```

**Response:**
- Returns HTML page with all users
- Or JSON if `Accept: application/json` header

### Get User Details
**GET `/users/:id`**

Example: `GET /users/1`

```bash
curl http://localhost:3000/users/1
```

**Response:**
- Shows user profile
- Displays all microposts for that user
- Shows form to add new micropost

### Create New User
**GET `/users/new`**

Returns form page

**POST `/users`**

```bash
curl -X POST http://localhost:3000/users \
  -d "user[name]=John Doe" \
  -d "user[email]=john@example.com"
```

**Required Parameters:**
- `user[name]` - User's name (required, presence)
- `user[email]` - User's email (required, presence)

**Response:**
- Success: Redirects to user profile (`/users/:id`)
- Error: Re-renders form with error messages

**Validation Rules:**
```
- name: must be present
- email: must be present
```

### Update User
**GET `/users/:id/edit`**

Returns edit form

**PATCH `/users/:id`** or **PUT `/users/:id`**

```bash
curl -X PATCH http://localhost:3000/users/1 \
  -d "user[name]=Jane Doe" \
  -d "user[email]=jane@example.com" \
  -d "_method=patch"
```

**Parameters:**
- `user[name]` - Updated name (optional)
- `user[email]` - Updated email (optional)

**Response:**
- Success: Redirects to user profile
- Error: Re-renders form with error messages

### Delete Single User
**DELETE `/users/:id`**

```bash
curl -X DELETE http://localhost:3000/users/1
```

**Response:**
- Redirects to users list
- Cascades to delete all user's microposts

### Delete All Users
**DELETE `/users/destroy_all`**

```bash
curl -X DELETE http://localhost:3000/users/destroy_all
```

**Note:**
- Deletes all users in database
- Cascades to delete all microposts
- Uses database transaction

**Response:**
- Redirects to users list with success message

### Users API Summary

| Endpoint | Method | Action | Returns |
|----------|--------|--------|---------|
| `/users` | GET | index | User list page |
| `/users/new` | GET | new | Create form |
| `/users` | POST | create | Redirect or form with errors |
| `/users/:id` | GET | show | User profile & microposts |
| `/users/:id/edit` | GET | edit | Edit form |
| `/users/:id` | PATCH | update | Redirect or form with errors |
| `/users/:id` | DELETE | destroy | Redirect to list |
| `/users/destroy_all` | DELETE | destroy_all | Redirect to list |

## Microposts API

### List All Microposts
**GET `/microposts`**

```bash
curl http://localhost:3000/microposts
```

**Response:**
- HTML page with all microposts
- Shows user association for each micropost

### Get Micropost Details
**GET `/microposts/:id`**

Example: `GET /microposts/1`

```bash
curl http://localhost:3000/microposts/1
```

**Response:**
- Shows micropost content
- Shows associated user
- Shows edit and delete options

### Create New Micropost
**GET `/microposts/new`**

Returns form page with user dropdown

**POST `/microposts`**

```bash
curl -X POST http://localhost:3000/microposts \
  -d "micropost[content]=Hello, World!" \
  -d "micropost[user_id]=1"
```

**Required Parameters:**
- `micropost[content]` - Post content (required, max 140 chars)
- `micropost[user_id]` - User ID (required, must exist)

**Response:**
- Success: Redirects to micropost (`/microposts/:id`)
- Error: Re-renders form with validation errors

**Validation Rules:**
```
- content: must be present, max 140 characters
- user_id: must be present, must reference existing user
```

**Error Examples:**
- Missing content: "Content can't be blank"
- Content too long: "Content is too long (maximum is 140 characters)"
- Invalid user: "User must exist"

### Update Micropost
**GET `/microposts/:id/edit`**

Returns edit form with user dropdown

**PATCH `/microposts/:id`** or **PUT `/microposts/:id`**

```bash
curl -X PATCH http://localhost:3000/microposts/1 \
  -d "micropost[content]=Updated content" \
  -d "micropost[user_id]=1"
```

**Parameters:**
- `micropost[content]` - Updated content (optional, max 140 chars)
- `micropost[user_id]` - Updated user (optional)

**Response:**
- Success: Redirects to micropost
- Error: Re-renders form with errors

### Delete Micropost
**DELETE `/microposts/:id`**

```bash
curl -X DELETE http://localhost:3000/microposts/1
```

**Response:**
- Redirects to microposts list
- Removes micropost from database

### Microposts API Summary

| Endpoint | Method | Action | Returns |
|----------|--------|--------|---------|
| `/microposts` | GET | index | All microposts page |
| `/microposts/new` | GET | new | Create form |
| `/microposts` | POST | create | Redirect or form with errors |
| `/microposts/:id` | GET | show | Micropost details |
| `/microposts/:id/edit` | GET | edit | Edit form |
| `/microposts/:id` | PATCH | update | Redirect or form with errors |
| `/microposts/:id` | DELETE | destroy | Redirect to list |

## Root Route

| Endpoint | Redirects To |
|----------|------------|
| `/` | `/users` (Users list) |

## Response Formats

### HTML Response
Default response format (used in browser)

```bash
curl http://localhost:3000/users
# Returns: HTML page
```

### JSON Response
Add `Accept: application/json` header

```bash
curl -H "Accept: application/json" http://localhost:3000/users
# Returns: JSON data
```

## Status Codes

| Code | Meaning | Example |
|------|---------|---------|
| 200 | OK | GET request successful |
| 201 | Created | Resource created successfully |
| 302 | Found (Redirect) | After POST/PATCH/DELETE |
| 422 | Unprocessable | Validation errors |
| 404 | Not Found | Resource doesn't exist |
| 500 | Server Error | Application error |

## Common Workflows

### Complete User & Micropost Creation Workflow

```
1. GET /users
   → View all users
   
2. GET /users/new
   → Display new user form
   
3. POST /users
   → Create user (redirect to /users/1)
   
4. GET /microposts/new
   → Display new micropost form
   → Dropdown shows User #1
   
5. POST /microposts
   → Create micropost (redirect to /microposts/1)
   
6. GET /users/1
   → View user profile
   → Shows micropost created
```

### User Deletion Workflow

```
1. GET /users
   → View users list
   
2. DELETE /users/1
   → User deleted
   → All user's microposts deleted (cascade)
   
3. GET /users/1
   → Error: User not found (404)
```

### Bulk Delete Workflow

```
1. GET /users
   → Click "Delete All Users"
   
2. DELETE /users/destroy_all
   → All users deleted
   → All microposts deleted
   
3. GET /users
   → Empty users list
```

## Form Submission

### HTML Form to POST

```html
<form action="/users" method="POST">
  <input type="hidden" name="_csrf_token" value="...">
  <input name="user[name]" value="John Doe">
  <input name="user[email]" value="john@example.com">
  <button type="submit">Create User</button>
</form>
```

### Form Data Format

```
application/x-www-form-urlencoded

user[name]=John Doe&user[email]=john@example.com
```

## URL Parameters

### Query Parameters
Used in GET requests

```
GET /users?sort=name&page=2

Accessed in controller:
params[:sort]  # "name"
params[:page]  # "2"
```

### URL Segments
Dynamic parts of URL

```
GET /users/1

Accessed in controller:
params[:id]  # 1
```

## Headers

### CSRF Token
Required for POST/PATCH/DELETE (web forms)

```
X-CSRF-Token: <token>
```

Automatically included in Rails forms

### Content-Type

```
Content-Type: application/x-www-form-urlencoded  (forms)
Content-Type: application/json  (JSON API)
```

### Accept

```
Accept: text/html               (HTML response)
Accept: application/json        (JSON response)
```

## Error Handling

### Validation Errors

When submitting invalid data:

```
POST /users
  - user[name] = ""  (empty)

Response: 422 Unprocessable
Displays form with errors:
  "Name can't be blank"
```

### Not Found Errors

When accessing non-existent resource:

```
GET /users/999

Response: 404 Not Found
```

## Rails Conventions

### Parameter Nesting

```ruby
# Nested parameters follow Rails convention
# form[field] maps to params[:form][:field]

<input name="user[name]">
→ params[:user][:name]

<input name="micropost[content]">
→ params[:micropost][:content]
```

### Method Override

```html
<!-- HTML forms only support GET/POST -->
<!-- Rails uses _method parameter to override -->

<form method="POST" action="/users/1">
  <input name="_method" value="patch">
  <!-- This becomes a PATCH request -->
</form>
```

## Testing API with cURL

### Create User
```bash
curl -X POST http://localhost:3000/users \
  -d "user[name]=Alice" \
  -d "user[email]=alice@example.com"
```

### Get User
```bash
curl http://localhost:3000/users/1
```

### List Users
```bash
curl http://localhost:3000/users
```

### Update User
```bash
curl -X PATCH http://localhost:3000/users/1 \
  -d "user[name]=Alice Updated" \
  -d "_method=patch"
```

### Delete User
```bash
curl -X DELETE http://localhost:3000/users/1
```

### Create Micropost
```bash
curl -X POST http://localhost:3000/microposts \
  -d "micropost[content]=Hello World" \
  -d "micropost[user_id]=1"
```

## Browser Testing

### Direct URL Access
```
http://localhost:3000/users                    → List users
http://localhost:3000/users/new                → New user form
http://localhost:3000/users/1                  → View user
http://localhost:3000/users/1/edit             → Edit user
http://localhost:3000/microposts               → List microposts
http://localhost:3000/microposts/new           → New micropost form
http://localhost:3000/microposts/1             → View micropost
```

## Advanced: Building Custom Requests

### Using Rails Helpers in Console

```ruby
rails console

# Generate URL
user_path(@user)          # "/users/1"
edit_user_path(@user)     # "/users/1/edit"
new_user_path             # "/users/new"
users_path                # "/users"

# Generate URL parameters
url_for(@user)            # Full URL with protocol
polymorphic_path(@user)   # Smart path generation
```

