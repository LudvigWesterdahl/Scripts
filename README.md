# Scripts
Add export PATH="/PATH/TO/Scripts/:${PATH}" to .bash_profile in your
home directory.

#### [TEMPLATE](TEMPLATE)
Script template.

#### [init](init)
Init script to make all other scripts in this folder executable.

**$** init

#### [cvenv](cvenv)
Creates a python3 virtual environment.

**$** cvenv [options...]

#### [rmc](rmc)
Removes emacs temporary files.

**$** rmc

#### [sgi](sgi)
Synchronizes the remote repository with the local .gitignore file.

**$** sgi [options...]

#### [bas](bas)
Dumps a sqlite3 table on an android device using the adb.

**$** bas &lt;path&gt; [options...]

#### [ren](ren)
Replaces a substring in all file names in a folder.

**$** ren &lt;old&gt; &lt;new&gt; &lt;path&gt;

#### [basl](basl)
A version of [bas](bas) but read-only by downloading and using db locally.

**$** basl &lt;package&gt; &lt;r_path&gt; &lt;l_path&gt; &lt;file&gt; [options...]

#### [basr](basr)
A version of [bas](bas) which works without rooting adb by using "run-as".

**$** basr &lt;package&gt; &lt;path&gt; [options...]

#### [cag](cag)
Cache git credentials locally in a repository.

**$** cag [options...]