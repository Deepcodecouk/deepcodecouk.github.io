---
layout: post
title: "Moving my blog to github pages"
date: 2014-05-11 18:23:38 +0100
comments: true
categories: blogging
---

I've been hosting my blog at blogger.com for a long time now, but it all feels a bit "old" hat. I think one of the reasons I don't blog so much now is, whilst live writer is cool an'all, it's all a bit too word-like.

When I write blog articles for work, I seem to churn them out faster than I do for my own blog, so why? I think it's the workflow - I just fire up sublime, write a load of stuff and then send it to our chap who makes it look pretty. Working in a pure text editor, I don't seem to faff around with style and formatting, I just get on with a bit of content.

I'm also not keen on the fact that my articles, on blogger, aren't so portable. I can't decide tomorrow to just move to something else? Ideally I want all my posts in markdown format that I can just take wherever I like, whenever I like.

I read [this article from Phil Haack](http://haacked.com/archive/2013/12/02/dr-jekyll-and-mr-haack/) about moving to github pages using [OctoPress](http://www.octopress.com) and decided I'd give it a shot.

If you're reading this, it worked! :)

## Step 1 - Let's get [chocolatey](http://chocolatey.org).

First thing I need is Ruby. I have this on my Mac and on my linux VMs, but I've never even thought about playing with Ruby on my primary laptop running windows. I've also been looking for an excuse to try out chocolatey package manager.

I installed chocolatey from powershell - like this;

``` powershell
iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))
```

## Step 2 - get ruby

Octopress needs ruby. Now I've got chocolatey installed, that's a breeze:

``` powershell
cinst ruby
```

Done....

## Step 3 - get octopress

Pretty straight forward (I already had git by the way) - from the octopress docs;

``` powershell
git clone git://github.com/imathis/octopress.git octopress
cd octopress

gem install bundler
bundle install
rake install
```

Ah piddle - we got an error at the bundle install part....

## Step 3a - fix the problem with bundle install

Not as straight forward as I hoped. When I ran the bundle install command I got an error;

> Gem::InstallError: The 'RedCloth' native gem requires installed build tools.

> Please update your PATH to include build tools or download the DevKit from 'http://rubyinstaller.org/downloads' and follow the instructions at 'http://github.com/oneclick/rubyinstaller/wiki/Development-Kit' An error occurred while installing RedCloth (4.2.9), and Bundler cannot continue. Make sure that `gem install RedCloth -v '4.2.9'` succeeds before bundling.

Ok, what now. I'll save you reading an hour worth of me going back and forth with chocolatey and the ruby devkit package - basically on the chocolatey gallery, the devkit is for ruby 1.8 and 1.9, but we're using 2.0. The quick answer is to go and download the 64bit ruby dev kit manually and unpack it somewhere.

Then, from that directory, run;

``` powershell
ruby dk.rb init
```

Then edit the generated config.yml to add the path to ruby 2.0 - for me that's in C:\Ruby200. Next, run:

``` powershell
ruby dk.rb install
```
And the problem is solved.

## Step 3b - the error about rake versions

I got an error running "rake install" - seems the one installed with ruby 2 is 0.9.6, the gem file for octopress installs 0.9.2.2, but if you run rake on the command line, it'll use the 0.9.6 version. Each fix to this is to run it through the bundler command;

``` powershell
bundle exec rake install
```

## Step 4 - generate and preview the site

Now we can take a look at how our blog looks;

``` powershell
bundle exec rake generate
bundle exec rake preview
```

Browsing to http://localhost:4000 then shows your, rather empty blog.

## Step 5 - getting some content in

You simply drop a .markdown file into /source/_posts/ following the formatting information found on the octopress site. You can then run the generate and preview commands to view your content.

## Interesting stuff

Install python. If you use any code blocks, your site will just start generating as empty html.... this confused the hell out of me until I saw 
[this post on stack overflow](http://stackoverflow.com/questions/11804471/octopress-generating-blank-files) - Again, you can use chocolatey to get python going.

Note - pygments (syntax highlighting) requires python, but don't just install the latest one - install python 2.7.6 instead, otherwise, bluntly - it just won't work....

``` powershell
cinst python -Version 2.7.6
```
When you're running the preview - you don't have to keep re-generating - it does it for you.

## Next
Next time I'll start looking at how to get this published on github pages, check it into my repo and also work out what to do with all my content that is on blogger!
