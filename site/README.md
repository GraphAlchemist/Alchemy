Alchemy Site
=======
## Quick Start
Alchemy uses [yeoman](http://yeoman.io/) for scaffolding and work flow and [mkdocs](http://www.mkdocs.org/) to actually generate our documentation.

### Yeoman
```bash
git clone <this repo>
cd <this repo>/site

# Note, you MUST be in the site directory to run the following commands.
# Otherwise you will be running commands from the main alchemy app.

# install node modules
npm install
# install bower depedencies
bower install

# install python dependencies
mkvirtualenv alchemydocs
pip install mkdocs

# fire up the develoment server
grunt serve
# package the site to go live
grunt
```

*Note:* There are a few custom tasks that run the mkdocs build process. `shell` and `copy:docs`.


### mkdocs
All of the configurations for the mkdocs reside in the `mkdocs.yml` file and the build process can be run manually with `mkdocs build`.
