from concurrent import futures
from os import path, system
import threading
import concurrent.futures
import os
import re, sys, collections
import time
from typing import Counter
from concurrent.futures import ThreadPoolExecutor


#read all text files into the directory
#https://www.codegrepper.com/code-examples/python/python+read+all+text+files+in+directory
def textfile_list():
    arr = os.listdir(os.getcwd())
    strtxt = ".txt"
    files = []
    for txtfile in arr:
        if txtfile.__contains__(strtxt):
           files.append(txtfile) 

    return files

#process the counting for words in each text file in seperate thread
def process(files):
    stopwords = set(open('stop_words').read().split(','))
    counts = Counter()

    for file in files:
        words = re.findall('\w{3,}', open(file).read().lower())
        for word in words: #https://docs.python.org/3/library/collections.html
            if word not in stopwords:
                counts[word] += 1
    for (w, c) in counts.most_common(40):   
        print(w, '-', c)

def main():
    # num_of_threads = os.cpu_count() #https://www.geeksforgeeks.org/python-os-cpu_count-method/
    # executor = ThreadPoolExecutor(num_of_threads)
    
    start = time.time()
    myFile = textfile_list()
    with concurrent.futures.ThreadPoolExecutor(max_workers=4) as executor: #https://www.digitalocean.com/community/tutorials/how-to-use-threadpoolexecutor-in-python-3
        executor.submit(process(myFile)) 
    end = time.time()
    elapsed = end - start
    print("Elapsed time: " + str(elapsed) + "s")

main()
    





