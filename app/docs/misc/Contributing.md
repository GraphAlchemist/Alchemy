### Some Things to Know
Alchemy.js uses [Yeoman.io](http://yeoman.io/) to manage workflow, and their documentation is a great resource to get up and running quickly.

If you are familiar with Yeoman already, it will be helpful to know how Alchemy's grunt tasks are configured.  The main grunt task, `build`, whether being used in development or to build the dist does the following:
* Copies all coffee script files into `.tmp` directory
* Concats all of the coffee script files with the `start.coffee` at the beginning and the `end.coffee` file at (you guessed it) the end

In development, there is an `alchemy.src.coffee` file in the `.tmp` directory, making it easy to use mapping files to debug the coffeescript directly.

### Overriding Default Functions
...

### Including Your Code
We'd love to include that awesome new feature you've built.  Here is the process:
* Fork this repo
* `git clone <my_fork_of_this_repo>`
* `git checkout -b <my_awesome_new_feature>`
* `git branch -D master`

When you feel like your contribution is battle ready, run the tests:
`grunt ...` 
If everything passes, feel free to submit a pull request.  We may have come conversations about pieces of it, or we may merge it right away.

Ahead of us merging your code, you will will need to have signed our [contributor agreement](https://docs.google.com/a/graphalchemist.com/forms/d/1ypqMsBPrfzPpvQPXYdfw12u9xK5pNiHeMAuYImzEli4/viewform).  It is pretty minor, feel free to reach out if you have questions.


