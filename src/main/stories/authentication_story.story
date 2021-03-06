Description: The authentication system should be robust to attack

Meta:
@story Authentication

Scenario: Passwords should be case sensitive
Meta:
@Description Case sensitive passords reduce the risk of password guessing and brute force attacks
@id auth_case

When the default user logs in with credentials from: users.table
Then the user is logged in
When the case of the password is changed
And the user logs in from a fresh login page
Then the user is not logged in

Scenario: Authentication credentials should be transmitted over SSL  
Meta:
@Description If authentication credentials are submitted over clear text, then they could be compromised through network sniffing attacks
@Reference WASC-04 http://projects.webappsec.org/w/page/13246945/Insufficient%20Transport%20Layer%20Protection
@id auth_https

Given an HTTP logging driver
And clean HTTP logs
And the default user logs in with credentials from: users.table
And the HTTP request-response containing the default credentials
Then the protocol should be HTTPS

Scenario: Login should be secure against SQL injection bypass attacks in the password field
Meta:
@Description SQL injection vulnerabilities could be used to bypass the login
@Reference WASC-19 http://projects.webappsec.org/w/page/13246963/SQL%20Injection
@id auth_sql_bypass_password

Given the login page
And the default username from: users.table
When the password is changed to values from <value>
And the user logs in
Then the user is not logged in

Examples:
tables/sqlinjection.strings.table

Scenario: Login should be secure against SQL injection bypass attacks in the username field
Meta:
@Description SQL injection vulnerabilities could be used to bypass the login
@Reference WASC-19 http://projects.webappsec.org/w/page/13246963/SQL%20Injection
@id auth_sql_bypass_username

Given the login page
And the default username from: users.table
When an SQL injection <value> is appended to the username
And the user logs in
Then the user is not logged in

Examples:
tables/sqlinjection.strings.table

Scenario: The user account should be locked out after 4 incorrect authentication attempts  
Meta:
@Description This reduces the risk of password guessing or brute force attacks on a specific user account
@Reference WASC-21 http://projects.webappsec.org/w/page/13246938/Insufficient%20Anti-automation
@id auth_lockout
@webservice

Given the default username from: users.table
And an incorrect password
And the user logs in from a fresh login page 4 times
When the default password is used from: users.table
And the user logs in from a fresh login page
Then the user is not logged in

Scenario: Captcha should be displayed after 4 incorrect authentication attempts
Meta:
@Description Reduces the risk of automated brute force or dictionary attacks against the authentication form, but still allows manual password guessing attacks
@Reference WASC-21 http://projects.webappsec.org/w/page/13246938/Insufficient%20Anti-automation
@id auth_login_captcha
@skip

Given the default username from: users.table
And an incorrect password
And the user logs in from a fresh login page 4 times
When the login page is displayed
Then the CAPTCHA request should be present
