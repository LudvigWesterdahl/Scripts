# Scripts

#### [TEMPLATE](TEMPLATE)
Script template.

#### [sourcer.bash](sourcer.bash)
Sources all scripts in this folder. Assumes the location is: ~/Scripts

#### [aliases.txt](aliases.txt)
Contains some handy aliases.

#### [create_venv](create_venv.bash)
Creates a python virtual environment from a requirements.txt file.

**$** create_venv

#### [rename](rename.bash)
Renames all files in a given path that has a string to another string.

**$** rename &lt;path&gt; &lt;search string&gt; &lt;replace string&gt;

#### [swap](swap.bash)
Swaps the content in two files.

**$** swap &lt;file1&gt; &lt;file2&gt;

#### [bas](bas)
Dumps a sqlite3 table on an android device using the adb.

**$** bas &lt;path&gt; [options...]

#### [basl](basl)
A version of [bas](bas) but read-only by downloading and using db locally.

**$** basl &lt;package&gt; &lt;r_path&gt; &lt;l_path&gt; &lt;file&gt; [options...]

#### [basr](basr)
A version of [bas](bas) which works without rooting adb by using "run-as".

**$** basr &lt;package&gt; &lt;path&gt; [options...]
