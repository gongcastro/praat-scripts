# created by Ron Pomper (ron.pomper@gmail.com) on 01/12/15

# this Praat script will allow you to normalize the duration, pitch, and intensity of syllables in your artificial language
# the duration and pitch are normed to their averages across all the stimuli
# the intensity is normed to a specified value that you enter below ('desired_intensity =')

# the script will also output 3 text files:
# raw_values.txt - provides the duration, pitch, and intensity for each stimulus prior to norming
# average_values.txt - provides the average duration, pitch, and intensity of the raw stimuli
# normed_values.txt - provides the duration, pitch, and intensity for each stimulus after norming
# note: the normed durations will be exact, but the normed pitch will fluctuate around the average and the normed intensity
# will fluctuate around the specified value - this is normal

# what you need to do:
# place all of your stimuli that will be normed into a folder
# along with the stimuli, create a new folder titled 'normed' (this is where the normed stimuli will be saved to)

# what you need to enter:
# form NORMALIZE DURATION
# sentence Directory_to_read_from: 
# sentence Directory_to_save: 
# endform

# directory_to_read_from$="

# directory_to_save$ =

# desired_intensity$: 65

# after you've entered the values above click run (or Command+R). the rest of the script below is automated :)



#############################################################################################################################################################
# remove open files
clearinfo
select all
nocheck Remove

# create table to record the duration, pitch & intensity of the raw audio files
raw_values = Create Table with column names... Raw_Values 1 File Duration Pitch Intensity

# get files in the to read directory
# string = Create Strings as file list: "list", "/Users/Chiara/Desktop/normalized/*.wav" 


folder$ = ""
newfolder$ = folder$ + "/normed" 
strings = Create Strings as file list: "list", folder$ + "/*.wav" 

numberOfSounds = Get number of strings

appendInfoLine: numberOfSounds


# open all files and save durations, pitches, and intensities to table
for i to numberOfSounds
	select strings
	file$ = Get string: i
	file'i'$ = file$
	# file'i' = Read from file... /Utenti/Chiara/Scrivania/normalized/'file$'
	file'i' = Read from file: folder$ + "/" + file$ 
	syllableDuration'i' = Get total duration
	To Pitch... 0 75 600
	syllablePitch'i' = Get mean... 0 0 Hertz
	select file'i'
	To Intensity... 100 0 "yes"
	syllableIntensity'i' = Get mean... 0 0 dB
	select raw_values
	Set string value... i File 'file$'
	Set numeric value... i Duration syllableDuration'i'
	Set numeric value... i Pitch syllablePitch'i'
	Set numeric value... i Intensity syllableIntensity'i'

	select raw_values
		if (i < numberOfSounds)
			Append row
		endif
endfor

# save the table as a text file
Write to table file... newfolder$ + "/raw_values.txt"

# calculate the mean duration
select raw_values
meanDuration = Get mean... Duration
printline average duration'tab$''meanDuration'

# calculate the mean pitch
select raw_values
meanPitch = Get mean... Pitch
printline average pitch'tab$''meanPitch'

# calculate the mean intensity
select raw_values
meanIntensity = Get mean... Intensity
printline average Intensity'tab$''meanIntensity'

# save the average values as a text file
average_values = Create Table with column names... Average_Values 1 Duration Pitch Intensity
Set numeric value... 1 Duration meanDuration
Set numeric value... 1 Pitch meanPitch
Set numeric value... 1 Intensity meanIntensity
select average_values
	Append row
Write to table file... newfolder$ + "/" + "average_values.txt"


# edit the duration, pitch, & intensity
for i to numberOfSounds
	select file'i'
	syllableDuration'i' = Get total duration
	manipulation = To Manipulation... 0.01 75 600
	Extract duration tier
	durationRatio = meanDuration/syllableDuration'i'
	Add point... syllableDuration'i' durationRatio
	plus manipulation
	Replace duration tier

	#select manipulation
	#Extract pitch tier
	#Remove points between: 0, syllableDuration'i'
    #Add point: 0, meanPitch
	#plus manipulation
	#Replace pitch tier
	
	select manipulation
	Get resynthesis (overlap-add)
	
	#Scale intensity... 65

	file$ = file'i'$
	Write to WAV file... newfolder$ + "/" + "file$"

endfor


# create table to record the duration, pitch & intensity of the normed audio files
normed_values = Create Table with column names... Normed_Values 1 File Duration Pitch Intensity 

# get files in the save directory
string = Create Strings as file list... files  newfolder$ + "/" + "*.wav"
numberOfSounds = Get number of strings

# open all files and save durations & pitch to table
for i to numberOfSounds
	select string
	file$ = Get string... i
	file'i'$ = file$
	file'i' = Read from file... newfolder$ + "/" + "file$"
	syllableDuration'i' = Get total duration
	To Pitch... 0 75 600
	syllablePitch'i' = Get mean... 0 0 Hertz
	select file'i'
	To Intensity... 100 0 "yes"
	syllableIntensity'i' = Get mean... 0 0 dB
	select normed_values
	Set string value... i File 'file$'
	Set numeric value... i Duration syllableDuration'i'
	Set numeric value... i Pitch syllablePitch'i'
	Set numeric value... i Intensity syllableIntensity'i'

	select normed_values
		if (i < numberOfSounds)
			Append row
		endif
endfor

# save the table as a text file
Write to table file... newfolder$ + "/" + "normed_values.txt"



