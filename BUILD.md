Build this repo locally
=======================
Alchemy.js leverages yeoman.io heavily for workflow.  At the heart of Yeoman is the Gruntfile which is used to run tasks.  The Alchemy.js app `./app` builds a `./dist` folder containing Alchemy.js and dependencies, while the Alchemy.js site is built from a seperate Yeoman project in the `./site` folder which publishes to the gh-pages branch of this repo.  Additionally, we use [CoffeeScript](http://coffeescript.org), [Sass](http://sass-lang.com/), [d3](http://d3js.org/), and [lodash](http://lodash.com/).  If you are looking to contribute, each project has fantastic documentation.

##### Up and Running with Yeoman: 
(note, these instructions assume that you are running OSX. If you are running linux then you will not be using brew, instead use the package manager of your platform [Like yum or apt] to install, or install node from directly from the site. You will also need to have ruby installed in order for gem to work) 
```
# If you don't have Node find fast Wifi
brew update
brew doctor
brew install node
```
These instructions should work as long as you are using a *nix system and have node, npm, ruby and ruby development packages installed...

```
# If you don't have Yeoman find fast Wifi
npm install -g yo

# Install Coffee for compiling CoffeeScript into JavaScript
npm install -g coffee-script

# Install Compass for compiling Sass into css
gem install compass

# Download this directory
git clone https://github.com/GraphAlchemist/Alchemy.git
cd Alchemy
```

Building the Alchemy app
------------------------
Get Alchemy up and running locally:
```
# Make sure you are in the Alchemy directory and
# completed the Up and Running with Yeoman steps

# Install project specific Node dependencies
npm install

# Install project specific front end dependencies
bower install

# Fire up the grunt dev server
grunt serve
```

Alchemy will now be running at localhost:9000.  The Alchemy app that is running is based on the inline configuration in `./app/index.html`.  Additionally, there are a number of sample data sets to play with in the `./app/sample_data/` directory.

Testing
-------
Alchemy uses Karma to run test in the mocha framework.  There are a few different that tests are run:  

1. You can run Alchemy's test locally with the `grunt test` command
1. Continuous integrations runs the test on pull requests using the `grunt test:pr`
1. Commits made to the main [GraphAlchemist/Alchemy](https://github.com/GraphAlchemist/alchemy) directly are tested on sauce labs by travis using the `grunt test:travis` command
1. You can use sauce labs to test Alchemy locally by providing [sauce labs credentials](https://saucelabs.com/docs/onboarding) `export SAUCE_USERNAME=foo
export SAUCE_ACCESS_KEY=bar and runnnig `grunt test:dist`


Building the Docs
-----------------
One of the best ways to contribute is helping clean up the docs.

The Alchemy.js site is in angular and is hosted on gh-pages from this repo.  The site builds from the site folder `./site`.  All of the documentation is written in Markdown can be found in the docs folder `./site/app/docs`.

Here's how to get the docs up and running locally:
```
# Make sure you are in the site directory and 
# completed the Up and Running with Yeoman steps

# Install Node depedencies
npm install

# Install Bower depedencies
bower install

# Install Jekyll and its depedencies
gem install jekyll 
gem install coderay
gem install kramdown

# Run the documentation locally
grunt serve
```

The docs should now be running locally on port :9002.
