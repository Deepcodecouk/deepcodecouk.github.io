---
layout: post
title: "Moving my blog to github pages - part 2"
date: 2014-05-18 11:10:15 +0100
comments: true
categories: blogging
---

Here is a [link]({% my_post 2014-05-11-Moving-my-blog-to-github-pages %}) 

As I mentioned in my previous post, I've decided to move my blog to github pages and use octopress. The idea being, I want to write my posts quickly, in markdown, and I want them to be portable.

In the first post, I described getting octopress up and running for the first time, and a few little problems encountered along the way. In this post I'm going to talk about getting the thing published on github.

## Step 1 - getting your repo ready

Assuming of course you did the same as me and cloned the octopress repository, your code presently doesn't push to your github pages repo. This is nice'n'easy though!

Just run;

``` powershell
bundle exec rake setup_github_pages
```

It will ask you for some details about your github repo and then set things up for you. The key things it does

* Switch the active branch from "master" to "source"
* Add your github repo as the default origin remote
* Setup a subfolder "_deploy" that maps to your master branch in your repo

You then have your main source for your blog in the "source" branch, your main directory, the published version of your site in the "master" branch, mapped to the _deploy subdirectory (which is then .gitignored in the parent folder)
    
It does other stuff too, the exact detail can be found [here](http://octopress.org/docs/deploying/github/).

## Step 2 - generate and publish

Now you can re-generate/publish the site by running;

``` powershell
bundle exec rake generate
```

as before, but then to actually publish your site you can run;

``` powershell
bundle exec rake deploy
```

Which will copy the generated files into the _deploy directory, add them to git, commit and push them.

## Step 3 - don't forget your source!

Of course the last thing to do after you've deployed - don't forget to commit and push the source!

## Next steps
In the next article, I'll look at getting all my existing content out of blogger, into markdown format and ready to re-publish. I'll also think about how to keep my old URLs so any google love still comes my way and consider pulling things like images down from blogger too... we'll see.

Cheerio!
