# Mediasiteps_Tools

# Module required: Mediasiteps
Some scripts in here require the Mediasiteps module already be loaded.  The module can be found here: https://github.com/wunde005/MediasitePS

# Slide count report
Powershell script slidecountreport.ps1 reports on slide count and slides per minute for the last X amount of days  
<sub><sup>Note: Requires mediasiteps module be loaded</sup></sub>
---

- NAME: **slidecountreport.ps1**
- SYNOPSIS: Reports on slide count and slides per minute for the last X amount of days
- SYNTAX: ```slidecountreport.ps1 [[-days] <int>] [[-minslides] <int>] [[-minslidespermin] <single>]```
- DESCRIPTION: Reports on slide count and slides per minute for presentations recordeded in the last X amount of days(Default is 1 day).  
    It also allows filtering by mininum slide count (-minslides) and minimum slides per minute (-minslidespermin)
    
---

# Folder Tools:
Powershell scripts savefolders.ps1 and loadfolderfrom.ps1 allow you to save and load folders on a Mediasite server  
<sub><sup>Note: Requires mediasiteps module be loaded</sup></sub>
---

- NAME: **savefolders.ps1**
- SYNOPSIS: reads folder list from mediasite server and outputs it as an object or saves it to a file.
- SYNTAX: ```savefolders.ps1 [[-filename] <String>] [[-rootfolderid] <String>] [-quiet] [-readmediasiteusers] [<CommonParameters>]```
- DESCRIPTION: 
    Reads folder list from mediasite server.
    If no rootfolderid is specified it will find the root of the server and start from there.
    If the "-filename" isn't specified it will output a object with folder name, it's id and all sub folders
    If a file is specifed it will save the folder structure to a json file
    quiet will supress output

---

- NAME: **loadfoldersfromfile.ps1**
- SYNOPSIS: Reads folder list from json file and recreates it on the mediasite server.
- SYNTAX: ```loadfoldersfromfile.ps1 [-filename] <String> [<CommonParameters>]```
- DESCRIPTION:
    Reads folder list from a json file.
    Uses "ParentFolderId" from json file to specify starting folder on mediasite server.  Empty value means mediasite
    root folder.
    The "id" value for the folders in json file is only used if an error is thrown on creation to see if the folder is
    in the recycle bin.

---
# Example
![Example](/docs/images/folder_dump_example.JPG)



---
# Srt Caption Time Adjuster:

- NAME: **bin\srt-time-shift.ps1**
- SYNOPSIS: Reads SRT file and outputs new one with time shifted by cut time
- SYNTAX: ```bin\srt-time-shift.ps1 -file <String> -cuttime <string> -outfile <string> ```
- DESCRIPTION:
    Reads an SRT file and outputs a new SRT file with the time shifted by the cut time.
    The cut time can be found in the Mediasite web editor.  When you're editing the video put the time line marker to the new begining of the video.  In the time area on the right copy the time (highlighted yellow in the example) and use it as the "cuttime". 
    
---
# Example
![Example](/docs/images/srt_time_example.jpg)

