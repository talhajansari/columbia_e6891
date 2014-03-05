# -*- coding: utf-8 -*-
# <nbformat>3.0</nbformat>

# <codecell>

# A python script to download sound files from Macaulay Library.
# Talha J. Ansari 2014
# tja2117@columbia.edu

# <codecell>

# Download URL = 'http://macaulaylibrary.org/order_items/<index_number>/download' where index_number is a code related to the soundfile

# <codecell>

# Print useful info
print('Python script is starting...')
import sys
print(sys.version)

# <codecell>

# Define Variables
URL_first = 'http://macaulaylibrary.org/order_items/'
index_start = 187950
index_end = index_start-4
URL_last = '/download'
num_files = index_start - index_end

# download the files using a loop
import webbrowser
index = index_start
while index>index_end:
    print("Inside the " + str(index) + " iteration of while-download loop...")
    URL = URL_first + str(index) + URL_last
    webbrowser.open(URL)
    index = index - 1;
print('While loop ended.')




