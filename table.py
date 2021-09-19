#!/usr/bin/python3
import argparse
import sys
import os

PROG_NAME=os.path.basename(__file__)

MAX_LENGTH=68

def notify(arg):
    print("{}: {}".format(PROG_NAME, str(arg)))

def get_line(prompt):
    value = input(PROG_NAME + ": "  + str(prompt) + " ")
    return value.split(",")

def to_table(rows, args):
    num_rows = len(rows)
    num_cols = len(rows[0])
    col_sizes = []
    for i in range(0, num_cols):
        col_sizes.append(max(len(row[i]) for row in rows))
    
    spaces_left = MAX_LENGTH - 2 - num_cols + 1 - sum(col_sizes)
    if spaces_left < 0:
        notify("cannot create table")

    while spaces_left > 0:
        for i in reversed(range(0, num_cols)):
            if spaces_left > 0:
                spaces_left -= 1
                col_sizes[i] += 1
            
    divider = "+"
    for size in col_sizes:
        divider += "-"*size
        divider += "+"

    table = divider + "\n"
    

    for row_i,row in enumerate(rows):
        simple_row = "|"
        for i,col in enumerate(row):
            simple_row += col.center(col_sizes[i], " ") + "|"
        table += simple_row
        if args["content"] or row_i == 0:
            table += "\n"
            table += divider
        table += "\n"

    if not args["content"]:
        table += divider
        table += "\n"
        
    return table
    
def main(args):

    table = []

    line = get_line("input a csv header line:")
    header = line
    table.append(line)
    while len(line) != 0:
        line = get_line("input a csv line:")
        if len(line) != len(header):
            break
        table.append(line)

    print(to_table(table, args))
    return
    
if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("-c", "--content", help="Divider between content rows", action="store_true")
    args = parser.parse_args()
    main(vars(args))
    
