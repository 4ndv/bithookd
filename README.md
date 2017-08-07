bithookd
============

Git autodeploy for bitbucket.org

## Installation

You'll need Ruby 2.3+ and bundler

Clone this repo, run `bundle install` and add this to autorun.

Systemd example:

```
[Service]
ExecStart=/usr/bin/ruby /opt/bithookd/app.rb
Restart=always
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=bithookd
User=root
Group=root
Environment=RACK_ENV=production
Environment=PORT=1337

[Install]
WantedBy=multi-user.target
```

## Configuration

Create an bithookd.yml in the same folder as app.rb

Example config with all the options:

```
repos:
  user/repo:
    master:
      path: /var/www/apps/repo
      commands:
        - git pull
        - bash scripts/update
        - bash scripts/restart
```

## License

```
Copyright (c) 2017, Andrey Viktorov

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
