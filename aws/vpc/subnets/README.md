## What is this?
This is something we should not be doing but have to since modules don't accept `count.index`.
Our code wraps the vpc module from the terraform registry and the registry module requires you
to include the subnets cidrs which isn't a big deal but we want a way to just automatically count
the cidrs for you. This module does that and gets around the issue of modules not accepting `count.index`

## Caveats
There are potential issues with this module if we want more than just a private and public subnet
