Release the thing:
==================
Hey you, you are releasing Alchemy, awesome!  You can release the Alchemy by running:
```
grunt --release
```
The `release` flag is to prevent an accidental release when running the default `grunt` command.

In order for the release to work, please make sure the following is true:
* the documentation site is in a subfolder called **site**
* update the **package.json** file with the release version
    * the version should be in the format "X.Y.Z", for example "0.5.0", not "v0.5.0", "v0.5", "0.5"
    * make sure that the version is different than any other version that has been published to npm or the bower registry

The release task aliases to the following grunt tasks:
    * "test:dist": tests the site with sauce labs using your credentials.  See the [[BUILD.md]] file for more information on exporting sauce lab credentials to your OS ENV.
    * "build", build Alchemy vendor files and Alchemy.js
    * "string-replace", apply version to Alchemy.js
    * "bumpBower", bump bower version
    * "shell:commitBuild", commit dist files
    * "release", create tag and version
    * "archiveDist", create archive of files to zip for upload to github
    * "concat:s3", squash vendor and alchemy files for cdn.  The css and js files on CDN include all vendor, assuming that is what users who are not managing their own dependencies want.
    * "concat:s3Version", apply version numbers to files for cdn
    * "s3:production" publish files to s3 for cdn
    * "shell:docs", run grunt file that releases docs (see `./site/Gruntfile.coffee`) 