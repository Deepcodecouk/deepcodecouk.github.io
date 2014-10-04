---
layout: post
title: "The old double hop issue"
date: 2007-03-13 20:26:00 +0000
comments: true
categories: WCF
---
Recently I had a WCF service calling into a simple ASMX service, but I
got a 401 error each time it did so, even though my WCF service was
setup to impersonate correctly.

The problem boils down to something called "double-hopping", which is
where by default you're not allowed to pass network credentials beyond a
single network hop.

Assuming the client application, the WCF and the ASMX are on separate
servers, the client connects to the WCF, impersonating the client caller
identity. When the WCF then connects on to the ASMX however it isn't
allowed to pass up the impersonated credentials and instead uses the
process identity for the worker thread (commonly ASPNET or NETWORK
SERVICE).

Establishing trust for delegation is the answer - setting up the various
servers to allow them to pass on impersonated credentials. The following
support article at Microsoft covers how to configure everything:
<http://support.microsoft.com/default.aspx?scid=kb;en-us;810572>

For reference [here's a good posting](http://blogs.msdn.com/nunos/archive/2004/03/12/88468.aspx) about it.

Once you understand [double hop issues](http://support.microsoft.com/default.aspx?scid=kb;en-us;329986),
the problem is undeniably straight forward, however, if you're not "in-the-know" as I wasn't at
the time I was struggling, double hopping in service oriented environments can be a royal pain in the ass.
