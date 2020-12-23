# Scripts
Add export PATH=${PATH}:"/PATH/TO/Scripts/" to .bash_profile in your home directory.

#### For example:
export PATH=${PATH}:"~/Documents/Scripts/"

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

#### [renamer.py](renamer.py)
Replaces a substring in files, file names and/or folder names.

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

#### [mkjava](mkjava)
Creates a Makefile and a java file to easily test some java code.

**$** mkjava [options...]

#### [runkt](runkt)
Compiles and runs a .kt file (requires camelcase naming of file).

**$** runkt <file>

#### [rmbom](rmbom)
Removes the Byte-Order-Mark (BOM) from all files in a given path.

**$** rmbom <path> [options...]

#### [rmdocker](rmdocker)
Cleans up the docker environment locally.

**$** rmdocker [option]

#### [cmac](cmac)
Searches a directory for files matching a given string and deletes them.

**$** cmac <search> [options...]

#### [rmcrlf](rmcrlf)
Replaces the CRLF with LF from all files in a given path.

**$** rmcrlf <path> [options...]


