import os
import subprocess
import hashlib

OLD_DIR = "wea"
NEW_DIR = "test"

with open("wea/.hashes") as hash_file:
    hash_gen = map(
        lambda x: x.split(),
        hash_file.readlines()
    )

    hashes = {}
    for (file_name, hashing) in hash_gen:
        hashes[file_name] = hashing

walker = os.walk("wea")

for (directory, _, files) in walker:
    split_path = directory.split("/")
    if len(split_path) == 1:
        new_dir = NEW_DIR
    else:
        new_dir = NEW_DIR + "/" + split_path[1]

    os.makedirs(new_dir, exist_ok = True)

    for file in files:
        if not file.endswith("svg"):
            continue

        file_no_extension = file.split(".")[0]

        original_path = directory + "/" + file_no_extension + ".svg"
        new_path = new_dir + "/" + file_no_extension + ".png"

        print(original_path)
        print(new_path)

        command = [
             "inkscape",
             "--export-type=png",
            f"{original_path}",
             "-o",
            f"{new_path}"
        ]

        print(command)

        subprocess.run(
            command,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT
        )
