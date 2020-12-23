#!/usr/bin/python3
import argparse
import sys
import os
import codecs
import mimetypes
import subprocess

PROG_NAME=os.path.basename(__file__)
NO_ERR="2>/dev/null"

def notify(arg):
    print("{}: {}".format(PROG_NAME, str(arg)))

def to_array(bash_out):
    
    if bash_out == None:
        return []
    
    stripped = bash_out.strip()

    if not stripped:
        return []
    
    array = stripped.split("\n")
    
    return array

def to_dict(files, files_rows):
    res = {}

    for f in files:
        if f not in res:
            if not files_rows:
                res[f] = [f]
            else:
                res[f] = []

    for f, r in [(f.split(":")[0], f.split(":")[1]) for f in files_rows]:
        res[f].append(r)

    return res

def run(cmd):
    res = subprocess.run(cmd, universal_newlines=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    
    if res.returncode:
        return "", res.returncode

    return res.stdout, res.returncode

def get_yes_no(prompt):
    value = input(PROG_NAME + ": "  + str(prompt) + " (y/n or h for help)? ")

    if value == "h":
        notify("answer [y] Yes, [n] No, [y!] Yes to rest or [n!] No to rest")
        return get_yes_no(prompt)

    if value == "y":
        return (True, False)

    if value == "y!":
        return (True, True)

    if value == "n":
        return (False, False)

    if value == "n!":
        return (False, True)

    notify("answer [y] Yes, [n] No, [y!] Yes to rest or [n!] No to rest")
    return get_yes_no(prompt)

def has_encoding(filename, encoding):
    try:
        f = codecs.open(filename, encoding=encoding, errors="strict")
        for line in f:
            pass
        return True
    except:
        return False
        
def is_binary(filename):
    res = has_encoding(filename, "utf-8")
    res = res or has_encoding(filename, "utf-16")

    return not res

def main(args):
    cmd = ["find", args["path"], "-name", "*{}*".format(args["old"])]
    if not args["recursive"]:
        cmd.append("-maxdepth 1")
    files_name, _ = run(cmd)
    files_name = to_array(files_name)
    
    cmd = ["grep", "-rlI", args["old"], args["path"]]
    if not args["recursive"]:
        cmd.append("--include-dir")
        cmd.append(args["path"])

    files_content, _ = run(cmd)
    files_content = to_array(files_content)
    
    cmd = ["grep", "-rI", args["old"], args["path"]]
    if not args["recursive"]:
        cmd.append("--include-dir")
        cmd.append(args["path"])

    files_content_rows, _ = run(cmd)
    files_content_rows = to_array(files_content_rows)
    
    if args["content"]:
        files_content = to_dict(files_content, files_content_rows)
    else:
        files_content = to_dict(files_content, [])

    yes_to_rest = False if args["all"] else args["force"]
    no_to_rest = False
    for f, c in files_content.items():
        if len(c) != 1 or f != c[0]:
            notify("--- {} ---".format(f))
            for i, row in enumerate(c):
                notify("occurance {}: {}".format(i + 1, row))
        if yes_to_rest:
            run(["perl", "-pi", "-e", "s/{}/{}/g".format(args["old"], args["new"]), f])
            notify("modified {}".format(f))
        elif args["all"]:
            notify("would modify {}".format(f))
        elif no_to_rest:
            notify("did not modify {}".format(f))
        else:
            yes, to_rest = get_yes_no("modify {} to {} in {}".format(args["old"], args["new"], f))
            if yes or yes_to_rest:
                run(["perl", "-pi", "-e", "s/{}/{}/g".format(args["old"], args["new"]), f])
                notify("modified {}".format(f))
            else:
                notify("did not modify {}".format(f))
                
            if yes and to_rest:
                yes_to_rest = True
            if not yes and to_rest:
                no_to_rest = True
    
    yes_to_rest = False if args["all"] else args["force"]
    no_to_rest = False
    for root, dirs, files in os.walk(args["path"], topdown=False):
        for i in files:
            if args["old"] in i and (args["recursive"] or root == "."):
                file_old = os.path.join(root, i)
                file_new = os.path.join(root, i.replace(args["old"], args["new"]))
                if yes_to_rest:
                    os.rename(file_old, file_new)
                    notify("renamed file {} to {}".format(file_old, file_new))
                elif args["all"]:
                    notify("would rename file {} to {}".format(file_old, file_new))
                elif no_to_rest:
                    notify("did not rename file: {} to {}".format(file_old, file_new))
                else:
                    yes, to_rest = get_yes_no("rename file: {} to {}".format(file_old, file_new))
                    if yes or yes_to_rest:
                        os.rename(file_old, file_new)
                        notify("renamed file: {} to {}".format(file_old, file_new))
                    else:
                        notify("did not rename file: {} to {}".format(file_old, file_new))
                        
                    if yes and to_rest:
                        yes_to_rest = True
                    if not yes and to_rest:
                        no_to_rest = True
                        
    yes_to_rest = False if args["all"] else args["force"]
    no_to_rest = False
    for root, dirs, files in os.walk(args["path"], topdown=False):
        for i in dirs:
            if args["old"] in i and (args["recursive"] or root == "."):
                dir_old = os.path.join(root, i)
                dir_new = os.path.join(root, i.replace(args["old"], args["new"]))
                if yes_to_rest:
                    os.rename(dir_old, dir_new)
                    notify("renamed dir: {} to {}".format(dir_old, dir_new))
                elif args["all"]:
                    notify("would rename dir {} to {}".format(dir_old, dir_new))
                elif no_to_rest:
                    notify("did not rename dir: {} to {}".format(dir_old, dir_new))
                else:
                    yes, to_rest = get_yes_no("rename dir: {} to {}".format(dir_old, dir_new))
                    if yes or yes_to_rest:
                        os.rename(dir_old, dir_new)
                        notify("renamed dir: {} to {}".format(dir_old, dir_new))
                    else:
                        notify("did not rename dir: {} to {}".format(dir_old, dir_new))
                        
                    if yes and to_rest:
                        yes_to_rest = True
                    if not yes and to_rest:
                        no_to_rest = True
                    
    return
    
if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("old", help="String to replace")
    parser.add_argument("new", help="String to replace 'old' with")
    parser.add_argument("-p", "--path", help="The path to search from; defaults to current directory", default=".")
    parser.add_argument("-r", "--recursive", help="Recursive search", action="store_true")
    parser.add_argument("-c", "--content", help="Prints all content lines that will be changed in prompt", action="store_true")
    parser.add_argument("-f", "--force", help="Does not prompt before modifying (-a, --all takes priority)", action="store_true")
    parser.add_argument("-a", "--all", help="Prints all modifications but does not prompt (dry run)", action="store_true")
    args = parser.parse_args()
    main(vars(args))
    
