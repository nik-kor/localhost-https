# Local https and the world of pain

*TL/DR;* Use the `./gen.sh` to generate and install everything you need to make https work on localhost.


## Why

Let's say you want to use https for your local development needs. Why would you need this - there can be multiple
reasons:
 - you want to have consistency with your live environment
 - feel 100% secure. It can be overkill for local development but we all use WiFi and sometimes secrets, and someone can easily sniff it
 - you want to use some 3d party API - e.g., social network logins
 - some APIs like service workers or HTTPv2 won't work with insecure HTTP

So initially the reason I got interested in setting things up was the consistency between all our environments.
I thought - ok - it's 2018 and all the vendors are pushing for https and it should be super smooth to do.
So how naive I was... and frustrated after realizing that the task is going to take more time than expected. However,
it's not so bad - it's even possible to automate most of it. A few words about it a bit later.


## Solutions

So what are the options I know:

 - the simplest solution is to use a self-signed certificate. The only thing to do is generate them and add to your
 http-server. The problem with this is that certificate can't be trusted and all the browsers show a warning message.
 It's kinda ok - you can "proceed insecure" once but if you have automation tests then you need to have one extra step
 so it won't really work imho
 - self-signed certificate backed up with self-generated root certificate authority. That means to tell the OS/browser
 trust your certificates. In my opinion, this is the only option we have


## Implementation

I wrote a simple script `gen.sh` as an essence of what I found on the internet. Feel free to use it to automate all
the steps,  but I encourage you to take a glance at it before. It should work well on your host machine(MacOS/Ubuntu)
or inside the task in a pipeline. It might need to do some additional preparations to make it work for your OS but
should be trivial. It's important to remember that *Firefox* uses its own list of root CAs and I didn't get how to
automate it too - so pick the generated `rootCA.pem` file and import to your FF installation manually.


## Credits

- [Bonca](https://www.bounca.org/index.html) was quite helpful
