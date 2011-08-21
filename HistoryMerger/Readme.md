Safari History Merger
================

Merges two "History.plist" files together, respecting the visit-counts for each website visited.

"History.plist" can be found in `~/Library/Safari/`


Purpose
-----------

I have my installs of Safari set to never remove my Web History. As such, I have years of browser history at my fingertips.

On my Lion install, the history accidentally diverged from my Snow Leopard install's history, so I wrote this tool to merge them.

Basically, it takes the two History.plist files, iterates over all the items in each, and combines their "Visit Count" properties. Voilà.

**Note** This is a very naiive approach, so if you were to keep merging with an already merged copy, it's not smart enough to recognize that, and it would just keep adding visit counts. So this is something you should probably only do once, and then keep going with the merged copy. Of course, you could always merge a *third* history file in, too.


Usage
--------

**Back up all the files before you start!**

(potentially require steps: you might not have to do these, but I didn't test **without these**)

1. Convert the Old and New Safari History.plist files from their default Binary format to the XML format. I don't know if this is required, but I did it and it worked for me. It might work fine if you skip this step, too.

    From Terminal:
    plutil -convert xml1 History.plist
	

Required steps

1. Build the app with Xcode
2. Browse and find both the Old and New History plist files
3. Choose an output directory for where the merged file will go.
4. Click Merge. Depending on how big the deflated plists are, this might take some time (and a *lot* of memory). Took about 250 seconds on my Mac Pro (9 GB of RAM). The spinner will stop when conversion is done.
5. (Optional) If you converted the plist files to XML (which you might have to do), then convert the Merged_History.plist file back to the binary format `plutil -convert binary1 Merged_History.plist`
6. Now rename the Merged file to "History.plist" and put it back in your current Safari prefs directory, replacing the orignal (you might have to delete the HistoryIndex.sk file, too).


Requirements
-------------------

This project is set to run build with Automatic Resource Counting (ARC) enabled, and as such requires at least Mac OS X 10.7 and Xcode 4.2.

I'm sure it would be trivial to get this project running on an earlier system, though.