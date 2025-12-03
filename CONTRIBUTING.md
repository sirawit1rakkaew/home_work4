# Contributing Guide

Welcome to the Toy App project! This guide helps you contribute effectively.

## Before You Start

- Review [README.md](README.md) for project overview
- Check [PROJECT_SUMMARY.md](PROJECT_SUMMARY.md) for project structure
- Read [DEVELOPMENT.md](DEVELOPMENT.md) for development guidelines
- Set up your environment with [INSTALLATION.md](INSTALLATION.md)

## Development Setup

```bash
# Clone the repository
git clone <repository-url>
cd toy_app

# Install dependencies
bundle install

# Setup database
rails db:setup

# Start development server
rails server
```

## Workflow

### 1. Create Feature Branch
```bash
git checkout -b feature/your-feature-name
# or
git checkout -b fix/your-bug-fix
```

**Branch naming convention:**
- `feature/` - New features
- `fix/` - Bug fixes
- `docs/` - Documentation
- `refactor/` - Code improvements

### 2. Make Changes

```bash
# Edit files in app/ directory
vim app/models/user.rb
vim app/controllers/users_controller.rb
vim app/views/users/show.html.erb
```

### 3. Test Your Changes

```bash
# Run all tests
rails test

# Run specific test file
rails test test/models/user_test.rb

# Check in browser
# http://localhost:3000
```

### 4. Commit Changes

```bash
# Check what changed
git status
git diff

# Stage changes
git add .

# Commit with clear message
git commit -m "Add feature: description of changes"
```

**Commit message format:**
```
[Type] Brief description

- Details about the change
- Why it's needed
- Any related issues

Type: Feature, Fix, Docs, Refactor
```

### 5. Push & Create Pull Request

```bash
# Push to your fork
git push origin feature/your-feature-name

# Go to GitHub and create Pull Request
```

## Code Guidelines

### Rails Conventions

```ruby
# Models (singular, CamelCase)
class User < ApplicationRecord
end

# Controllers (plural, CamelCase)
class UsersController < ApplicationController
end

# Views (plural, snake_case)
app/views/users/index.html.erb

# Files (snake_case)
app/models/user.rb
app/controllers/users_controller.rb
```

### Code Style

```ruby
# Use 2-space indentation
def create
  @user = User.new(user_params)
  if @user.save
    redirect_to @user
  else
    render :new
  end
end

# Use meaningful variable names
@users = User.all  # Good
@u = User.all      # Bad

# Use single quotes when no interpolation needed
'Hello World'      # Good
"Hello World"      # Also ok

# Use double quotes with interpolation
"User: #{@user.name}"  # Good
```

### View Guidelines

```erb
<!-- Use meaningful variable names -->
<%= @user.name %>         <!-- Good -->
<%= @u.name %>            <!-- Bad -->

<!-- Add whitespace for readability -->
<% @users.each do |user| %>
  <p><%= user.name %></p>
<% end %>

<!-- Use indentation for clarity -->
<div class="user">
  <h2><%= @user.name %></h2>
  <p><%= @user.email %></p>
</div>
```

### Comments

```ruby
# Good: Explains WHY, not WHAT
# Users can only create microposts if they're verified
if @user.verified?
  @user.microposts.create(content: @content)
end

# Bad: States the obvious
# Get the user
@user = User.find(params[:id])

# Good: Document complex logic
# Cascade delete: Remove all microposts when user is deleted
# This is handled by dependent: :destroy in the model
```

## Testing

### Write Tests for New Features

```ruby
# test/models/user_test.rb
require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "valid user" do
    user = User.new(name: "John", email: "john@example.com")
    assert user.valid?
  end

  test "user requires name" do
    user = User.new(email: "john@example.com")
    assert_not user.valid?
  end
end
```

### Run Tests

```bash
# Run all tests
rails test

# Run with verbose output
rails test -v

# Run specific test
rails test test/models/user_test.rb:5
```

## Feature Checklist

Before submitting a pull request:

- [ ] Code follows Rails conventions
- [ ] Tests are written and passing
- [ ] No console errors in development
- [ ] Changes work in browser
- [ ] Comments explain complex logic
- [ ] Commit messages are clear
- [ ] Branch is up-to-date with main

## Types of Contributions

### 1. Bug Fixes

```bash
git checkout -b fix/user-validation-error

# Fix the bug and test it
# Then commit and push
```

**Include in PR description:**
- What was the bug?
- How did you fix it?
- How can others test it?

### 2. New Features

```bash
git checkout -b feature/user-authentication

# Add the feature with tests
# Update documentation
# Then commit and push
```

**Include in PR description:**
- What does this feature do?
- Why is it useful?
- How do you use it?

### 3. Documentation

```bash
git checkout -b docs/improve-readme

# Update documentation files
# Add code examples
# Improve clarity
```

**Files to update:**
- README.md (if changing overview)
- INSTALLATION.md (if changing setup)
- DEVELOPMENT.md (if changing development)
- API.md (if changing routes)

### 4. Code Refactoring

```bash
git checkout -b refactor/improve-controllers

# Improve code quality
# Make it more readable
# Optimize performance
```

**Keep refactoring focused:**
- Don't change behavior
- Keep tests passing
- Write clear commit messages

## Documentation

### Update README when:
- Changing project overview
- Adding new major features
- Changing installation steps
- Adding new API endpoints

### Update INSTALLATION.md when:
- Changing setup process
- Adding new dependencies
- Updating troubleshooting

### Update DEVELOPMENT.md when:
- Adding new models
- Creating new patterns
- Documenting practices

### Update API.md when:
- Adding new endpoints
- Changing route parameters
- Adding new validations

## Pull Request Template

```markdown
## Description
Brief description of changes

## Changes
- Change 1
- Change 2

## Testing
How to test this change

## Checklist
- [ ] Code follows conventions
- [ ] Tests are passing
- [ ] Documentation updated
- [ ] No breaking changes

## Related Issues
Closes #123
```

## Code Review

### Review Process
1. Maintainers review your PR
2. You address feedback
3. Tests must pass
4. Code must follow conventions
5. PR gets merged

### Tips for Getting Approved
- Keep changes focused
- Write clear commit messages
- Test thoroughly
- Respond to feedback
- Ask questions if unclear

## Common Issues

### Issue: "Tests failing"
```bash
# Run tests locally
rails test

# Check specific test
rails test test/models/user_test.rb

# Fix the issue
# Commit again
```

### Issue: "Conflicts with main"
```bash
# Update your branch
git fetch origin
git rebase origin/main

# Resolve conflicts
# Force push
git push -f origin feature/your-feature
```

### Issue: "Need to change commit message"
```bash
# For last commit
git commit --amend

# For older commits
git rebase -i HEAD~3
```

## Community

### Be Respectful
- Use respectful language
- Accept constructive criticism
- Help other contributors
- Follow code of conduct

### Ask Questions
- It's okay to ask
- Provide context
- Show what you've tried
- Be patient for responses

## Resources

- [Rails Guides](https://guides.rubyonrails.org/)
- [Ruby Style Guide](https://rubystyle.guide/)
- [Git Documentation](https://git-scm.com/doc)
- [GitHub Help](https://docs.github.com/en)

## Becoming a Maintainer

After contributing consistently:
- Make several quality contributions
- Help review other PRs
- Show commitment to the project
- Ask maintainers about roles

## Questions?

- Check [README.md](README.md)
- Review [DEVELOPMENT.md](DEVELOPMENT.md)
- Look at closed PRs for examples
- Ask in issues or discussions

---

**Thank you for contributing! 🙏**

Your help makes this project better for everyone.
