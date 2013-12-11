OWASP is a project that catalogues and analyses security issues in web applications.
Let's go through their Top 10 vulnerabilities and talk about what they are and how to avoid them.
Pretty much everything here is an oversimplification, and this doesn't even cover all of the common security holes. The most powerful attacks are those that exploit multiple vectors at once.

Glossary:
OWASP: The Open Web Application Security Project
Unsafe data: Any data that comes from the user, the database, externally controlled files - anything outside the application itself. This includes user-entered fields in the database, 

Attacker: Someone who is deliberately attempting to harm either the site or the site's users.
Victim: A user who is the target of an attack.
Authentication: Checking a user is who they claim to be.
Authorisation: Checking a known user has permission to do what they want to do.

Privilige: The permission to do a risky thing. For instance, a user with admin priviliges might access the admin part of the site. A server-side user may have read privilges but not write priviliges, or perhaps only for certain folders.
Root: Usually refers to the root user in *nix systems; the most prviliged user. The root user can do anything.
Execute: To run, referring to a program, script or command.


10: Unvalidated Redirects and Forwards
======================================

Unvalidated here means not checked by either site developers, or the user. Fundamentally, it refers to tricking users into leaving your site and visiting another.

If you use Chrome or Firefox, you may have seen the "malware site" warning, preventing you from viewing a webpage that has been flagged as malicious. (Many other browsers don't have this warning, and not all sites are flagged.)

Broadly speaking, there are two kinds of hostile sites: phishing or forged sites, and attack or malware sites. Phishing sites look like copies of legitimate sites (often the site the user was just on), tricking users into entering their details. Attack sites exploit security vulnerabilities in the browser or download malicious scripts without the user's permission (among other things).

Redirects and forwards - in Rails terms, the `redirect_to` method - tell the browser to make a request to another page. Normally this would be one of our pages, but if the redirect uses unsafe data, it can send the user to a malicious site.

Examples
--------

```
# params = {host: 'http://my.malicious.site.com'}
redirect_to params
redirect_to params.merge(action: :show)

# params = {host: 'http://my.malicious.site.com', loan_id: 1}
redirect_to loans_url(params)

location = RedirectLocations.find(1234)
# set by someone hostile to have a url of "http://my.malicious.site.com"
redirect_to location.url

```

How to avoid it
---------------

Try to not use untrusted input. (It's actually pretty rare to use it anyway.)
Things that don't set the host won't redirect away from your site.
`redirect_to` has an :only_path option that removes the host from any url.
The `_path` helpers never set the host, so they are safe.
You can also explicitly set the host in the params hash.

```
redirect_to 'http://www.google.com/'
redirect_to root_url

# params = {host: 'http://my.malicious.site.com', loan_id: 1}
redirect_to loans_path(params)

redirect_to params, :only_path => true

redirect_to params.merge(host: 'myhost.com')
```

9: Using Components with Known Vulnerabilities
==============================================

AKA "not updating things". There are always vulnerabilities in software, and there will always be as-yet-unknown exploits. But when a problem is reported, categorised, published, or otherwise becomes widely known, the odds of them being used increases massively. Vulnerability-finding software often uses a scatter-gun approach, trying a host of known exploits in the hope of one of them working.

It's not just top-level things like Ruby or Rails - underlying framework components such as databases, apache, or operating systems can also be vulnerable.

Examples
--------

In January last year, the YAML parsing vulnerabilty (https://groups.google.com/forum/#!topic/rubyonrails-security/61bkgvnSGTQ/discussion) affected pretty much every Rails site on the web; within an hour, sites were facing widespread attacks. Four months later it was reported that sites that still hadn't upgraded were being recruited into a botnet using the vulnerability.

How to avoid it
---------------

Follow the security notice boards & mailing lists for Ruby, Rails, and any other popular gems you use. (https://groups.google.com/forum/?fromgroups#!forum/ruby-security-ann, https://groups.google.com/forum/?fromgroups#!forum/rubyonrails-security)
When you see a new vulnerability, tell people on your team about it.
Unsupported software (e.g. Ruby 1.8) won't have security patches released; sometimes people will backport them, but don't rely on it. Try to update things as soon as they become unsupported; don't wait until there's a security hole.
Upgrading software regularly reduces the risk of you being stuck with an outdated or unsupported version, but it's not required.
Update vulnerable software (or implement workarounds) as soon as you can.
Even if you aren't exposed to a vulnerability now doesn't mean a code change won't expose it later.
Obscurity (of your site, or the exploit) may give you more time to fix it, but it doesn't mean it won't happen.

8: Cross-site Request Forgery (CSRF)
====================================

"A CSRF attack forces a logged-on victim’s browser to send a forged HTTP request, including the victim’s session cookie and any other automatically included authentication information, to a vulnerable web application. This allows the attacker to force the victim’s browser to generate requests the vulnerable application thinks are legitimate requests from the victim."

This means tricking the user's browser into making a request to a website the user is logged in to, in order to perform an action that the user didn't want to do.

Websites can't access cookies for other sites, so they can't make the request themselves, but they can trick the browser into doing so.

Examples
--------

Assume a user, Bob, is logged in to our.nice.site.com. They visit another site which, unknown to them, is malicious.

The site has a crafted image tag on it:

`<img src="http://our.nice.site.com/loans/1/destroy">`

The browser dutifully makes the request - sending along Bob's "I'm logged in" cookie. We don't return an image, but the browser doesn't mind, it just displays nothing or the 'broken image' link. Unless Bob is looking carefully at the requests he'll never know anything happened.

If we have a GET path matching loans/1/destroy to an action that deletes that loan, even if we are checking that the current user has permission to delete that loan, it will be deleted.

Let's say we don't have a GET path, but it's restricted to POST. HTML can't trick browsers into sending POST requests, but Javascript can build forms on the fly & then submit them, so we are still vulnerable.

How to avoid it
---------------

Make "log out" links prominent, and on every page.
Use POST, PUT and DELETE for routes that change data.
Use `protect_from_forgery` where appropriate.
Not all sites are vulnerable to this - for instance, CoDAS has no forgery protection, because there is no 'login'; the application is restricted to only get requests from our servers. Some forms can't affect the data or aren't restricted to logged-in users (search forms, perhaps) so there's no need to 'forge' a request.

7: Missing Function-level Access Control
========================================

This one is pretty straightforward; if a user needs to be authenticated to do something (either logged in, or an admin, or an owner etc) then a) hide the links or form fields and b) lock down the controller actions & column data too.

Examples
--------

Not checking authorisation everwhere:
```
# We successfully check the permissions in the view...
<% if current_user.admin? %>
  <%= link_to "Delete loan", loan_path(@loan), method: :destroy %>
<% end %>

# But don't check in the controller. :(
def destroy
  loan = Loan.find(params[:loan])
  loan.destroy!
end
```

Not using attr_accessible or strong parameters, allowing a crafted request to change the loan's owner:
```
# params = {loan_id: 1234, loan: {title: "A loan", user_id: 666}}
loan = Loan.find(params[:loan_id])
loan.update(params[:loan])
```

How to avoid it
---------------

Be meticulous when building restricted features - controller-level testing can help check that the requests are safe.
Don't assume that because you have a 'gateway' check, subsequent pages are safe (e.g checking authentication for the edit page, but not the update action).
Use attr_accessible or strong parameters (depending on your version of Rails).

6: Sensitive Data Exposure
==========================

This covers both restricting data incorrectly as well as storing data in a form that is easy to access. It has some similarities with #5: Security Misconfiguration but is not the same.

"Sensitive data" will mean different things depending on the website, but is usually things such as passwords, credit card or bank details, personal emails, financial accounts, etc.

Examples
--------

Allowing someone untrusted to access the data, from website visitors up to and including employees - sometimes things are so secret even we can't be trusted with them.
Storing sensitive data in plaintext, either in the DB or in logs - anyone who can gain access will get everyone's data.
Using insufficient cryptography that can be easily broken.
Not salting encrypted data (it allows for use of 'rainbow table' attacks).
Not using SSL for authenticated data (the attacker can snoop on the request & steal the authentication cookie).

How to avoid it
---------------

Don't write your own authentication solution for production unless you really know what you are doing.
Avoid storing data, or encrypt & salt sensitive data. (Things like Devise will encrypt things for you safely.)
Use up-to-date & sufficient encryption (this means use SHA-2 or SHA-3 rather than MD5.)
Try to use SSL for all authenticated requests.
Be aware of the laws around storing & transportation of sensitive data.
Don't send passwords in plaintext, either to the browser or in emails.

5: Security Misconfiguration
============================

It's no good having security if it isn't set up right.
Also known as "Environmental Security", this usually affects lower-level infrastructure than application code, or to applications that run using other frameworks. The main thing for you to be worried about is letting configuration data (such as the user and password for the production database) or secrets (such as ssh details or the Rails secret key) out into the public domain.
This is less critical in closed-source projects (FCA) or public-source projects that aren't hosted anywhere (miniloans).

Examples
--------

Servers that allow anyone to log in & poke around.
Application processes that run under a user with too much privilige (e.g. as root).
Leaving apache's directory listing on, allowing any user to see all the files on the server.
Allowing multiple people to share an account on a server, preventing logs from showing who actually did what.

Default accounts that never get removed or updated - *particularly* if these are stored in the seeds.rb file and *double particularly* if the code is public source!
Checking application secrets into version control or leaving them in plain text files.
Sending server or database passwords through an insecure medium (email, chatrooms, paper planes).
Allowing an attacker to see your internal code by showing them overly-detailed error messages.

How to avoid it
---------------

When the sysadmin asks you to do something a certain way, do it, even if it's more arduous or annoying.
Don't check production configuration or secret keys into version control, if you can avoid it - rely on environment variables.
Don't show detailed errors or stack traces to users (PHP, we're looking at you.)
Create the first admin accounts etc for your application through the console, not in seeds.rb.

```
# No!
Miniloans::Application.config.secret_key_base = '6d1c...'

# Yes!
Miniloans::Application.config.secret_key_base = ENV["RAILS_SECRET_KEY"]
```

4: Insecure Direct Object References
====================================

This refers to not checking a user's permissions to view a certain resource: a database record, file, etc. We're going to assume writing authorisation checks is basic enough we can all do it, and look at the similar but-not-quite-the-same problem of file access.

If you use unsafe data to generate a filename or file path, you are at risk of malicious users reading files they shouldn't. If you allow file uploads at all, you may be vlnerable to users uploading malicious files, or uploading files to locations they shouldn't (& possibly overwriting existing files).

Examples
--------

```
# params = {filename: '../../../etc/passwd'}
send_file('/var/www/uploads/' + params[:filename])

# or
File.write params[:filename], ReportData.generate(...)
```

Some locations allow any file present to be executed upon request; namely, the applications' /public directory if that is where Apache's home directory is set.
```
# params = {filename: "malicious.php", data: ...}
name = sanitize(params[:filename])
path = "#{Rails.root}/public/images/#{name}"
File.write(path, uploaded_data)
```

How to avoid it
---------------

Build authorisation checks into your application.

If possible, use well-known and reliable libraries to handle file uploads, such as paperclip or attachment_fu.
Use whitelists or regexes to validate requested files are allowed to be read.
If you do use regexes, make sure to use \A and \z, NOT ^ and $.
Carefully sanitize - or replace - filenames of uploaded files.
Only permit files with whitelisted file extentions to be uploaded.
Don't allow files to be written to Rails' /public folder. Store them somewhere else.

3: Cross-site Scripting (XSS)
=============================

"XSS enables attackers to inject client-side script into Web pages viewed by other users. A cross-site scripting vulnerability may be used by attackers to bypass access controls such as the same origin policy. Cross-site scripting carried out on websites accounted for roughly 84% of all security vulnerabilities documented by Symantec as of 2007."



Examples
--------

How to avoid it
---------------

*Sanitize all unsafe data you output.* Rails 2 and earlier required the use of `h` but 3 & 4 will santize output in erb by default.

2: Broken Authentication & Session Management
=============================================

Examples
--------

How to avoid it
---------------

1: Injection
====================================

Examples
--------

How to avoid it
---------------
