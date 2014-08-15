---
position: 7
title: Contributing
---

# Contributing: Overview

 <p></p>

 If you're eager to contribute, that's great! Check out our [build file](https://github.com/GraphAlchemist/Alchemy/blob/master/BUILD.md) for more info on how to get started.

### Some Things to Know
Alchemy.js uses [Yeoman.io](http://yeoman.io/) to manage workflow, and [their documentation](http://yeoman.io/learning/index.html) is a great resource to get up and running quickly.

If you are familiar with Yeoman already, it will be helpful to know how Alchemy's grunt tasks are configured.  The main grunt task, `buildAlchemy`, whether being used in development or to build Alchemy.js for distribution, does the following:

* Copies all coffee script files into `.tmp` directory
* Concats all of the coffee script files with the `start.coffee` at the beginning and the `end.coffee` file at (you guessed it) the end

In development, there is an `alchemy.src.coffee` file in the `.tmp` directory, making it easy to use mapping files to debug the coffeescript directly.

### How to contribute
First off - [get in touch](mailto:robot@graphalchemist.com)!  It is helpful to hear from you - especially if you are planning to contribute some large, amazing feature.  It is always great to touch base and make sure that what you are planning is in sync with the road map.

We'd love your help in making Alchemy.js better.  A good place to start is always with the existing issues.  Did you notice a bug that wasn't there or a feature that should REALLY exist?  Ticket it, and let's start a conversation.

If you'd like to contribute code for a bug fix or even a feature, here is the process:


~~~ bash
# Fork Alchemy.js repo
git clone <my_fork_of_this_repo>
git checkout -b <my_awesome_new_feature>
# delete master and name your branch after the feature
# or bug you are getting after to avoid confusion
git branch -D master
#node and bower dependencies
npm install
bower install
~~~

When you feel like your contribution is battle ready, run the tests locally
`grunt test.`  If everything passes, feel free to submit a pull request.  We may have some conversations about pieces of it, or we may merge it right away.

Before we merge your code, you'll need to sign our [contributor agreement](https://docs.google.com/a/graphalchemist.com/forms/d/1ypqMsBPrfzPpvQPXYdfw12u9xK5pNiHeMAuYImzEli4/viewform).  It's pretty minor; feel free to reach out if you have questions.

______
