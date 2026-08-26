import re

def fix_user_service():
    fpath = 'tests/ItsTool.UnitTests/Services/UserServiceTests.cs'
    with open(fpath, 'r') as f:
        content = f.read()

    # CreateUserDto: new CreateUserDto("username", "email", "first", "last", "pass", null) -> add null for ProfilePhoto
    # Just a simple regex or string replace if we know the exact line
    content = content.replace('new CreateUserDto("newuser", "new@test.com", "New", "User", "Pass123!", null)', 
                              'new CreateUserDto("newuser", "new@test.com", "New", "User", "Pass123!", null, null)')
    
    # UpdateUserDto: new UpdateUserDto("updated@test.com", "Updated", "Name", true, null) -> add null for ProfilePhoto
    content = content.replace('new UpdateUserDto("updated@test.com", "Updated", "Name", true, null)',
                              'new UpdateUserDto("updated@test.com", "Updated", "Name", true, null, null)')

    with open(fpath, 'w') as f:
        f.write(content)

def fix_project_service():
    fpath = 'tests/ItsTool.UnitTests/Services/ProjectServiceTests.cs'
    with open(fpath, 'r') as f:
        content = f.read()
    
    # UpdateProjectDto: new UpdateProjectDto("Updated", "UPD", "Desc", true) -> new UpdateProjectDto("Updated", "UPD", "Desc", "Active")
    content = content.replace('new UpdateProjectDto("Updated Project", "UPD", "Desc", true)',
                              'new UpdateProjectDto("Updated Project", "UPD", "Desc", "Active")')

    with open(fpath, 'w') as f:
        f.write(content)

fix_user_service()
fix_project_service()

