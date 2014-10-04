---
layout: post
title: "WCF Impersonation"
date: 2007-03-12 20:25:00 +0000
comments: true
categories: WCF
---
Impersonation (running code as the invoking user) under WCF is
configured slightly differently to ASMX services. You need to first of
all tell your binding to use windows authentication to identify the
caller as follows;

``` xml
<bindings>
    <wsHttpBinding>
        <binding name="AuthBinding">
            <security>
                <transport clientCredentialType="Windows"/>
            </security>
        </binding>
    </wsHttpBinding>
</bindings>
```

However, impersonation wise this won't do a thing - when your service
code attempts to do something like write to the file system, it will do
this as the user your worker processes are configured to use (normally
ASPNET or NETWORK SERVICE).

Normally in ASMX you'd configure impersonation using web.config's
`<identity impersonate="true"/\>`, but WCF appears to ignore this.
Instead you're individual methods in WCF need to be marked up by adding
the following attribute onto the method;

``` c#
[OperationBehvior(Impersonation=ImpersonationOption.Required)]
```

When you consume the service on the client just add this code;

``` c#
ClientCredentials.Windows.AllowedImpersonationLevel = System.Security.Principal.TokenImpersonationLevel.Impersonation;
```

The service will now impersonate the calling client user.
