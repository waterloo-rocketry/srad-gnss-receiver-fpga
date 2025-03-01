#!/usr/bin/python3

import sys
import pathlib

def main():
    list_of_flist = sys.argv[1:]

    for flist_path in list_of_flist:
        flist_file = open(flist_path, 'r')
        path_of_flist = pathlib.Path(flist_path)
        for item in flist_file:
            print(str(path_of_flist.parent) + '/' + item)
    
if __name__ == '__main__':
    main()
