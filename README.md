# GCM Proxy

This is a Rails application which orchestrates the sending of push notifications
from applications to the Google Cloud Messaging Service (GCM). Rather than
individual applications talking to GCM directly, they send an HTTP request to
this service which logs and proxies the request.

* Manage multiple applications
* Control access from multiple clients to each application
* Keep track of the notifications sent.
* Monitors for device unsubscriptions and alerts the sending application next
  time it tries to send a message.

## Installation

To install this service, just follow these instructions. Before you run these
be sure to set up a backend database. At present only MySQL has been tested.

```
git clone git://github.com/catphish/gcm-proxy.git
cd gcm-proxy
bundle install --without development
# Open config/database.yml and add appropriate DB connection details
rake db:schema:load
rake gcm_proxy:setup
```

Once this is setup, you can then run the tasks outlined in the next section.
The default username is **admin** and the default password is **password**.

## Server Tasks

* **Web Server** - you should run the web server to provide an admin interface
  as well as the HTTP API service used for sending notifications. This runs
  continuously.
  
  ```
  rails server
  ```
  
* **Worker** - the worker is responsible for sending notifications from the 
  local system to the GCM backend. This runs continuously.
  
  ```
  rake gcm_proxy:worker
  ```

## API Methods

This section outlines the HTTP API methods which are available to you and are
used for sending notifications and registering devices.

This is an HTTP JSON API and parameters should be sent as JSON in the body of
the HTTP request. It is recommended that you use the POST HTTP verb for all
requests. Any parameters shown below which include periods represent a hash
which should be passed.

### Sending Notifications

In order to send a notification, you will need an `auth_key` and a device
identifier.

```
POST /api/notify
```

* `auth_key` - your auth key (string, required)
* `device` - the device identifier (string, required)
* `data` - a hash of data to send to the device

When you submit this, you will receive either a `201 Created` status which
means that your notification was added and delivery will be attempted. If there
is an error, you'll receive a `422 Unprocessable Entity` status and the response
body will contain an array of `errors`. 

The most significant thing to look out for is information that a device you
are sending notifications for has been unsubscribed. Such an issue will look 
this like in the response body:

```javascript
{
  "errors": {
    "device": [ "unsubscribed" ]
  }
}
```

## Licence

This software is licenced under the MIT-LICENSE.

