import os
import subprocess
import hashlib

SOURCE_DIR = "svg/"
TARGET_DIR = "png/"


def convert_file(original_path, new_path):
    command = [
         "inkscape",
         "--export-type=png",
        f"{original_path}",
         "-o",
        f"{new_path}"
    ]

    # print(command)

    subprocess.run(
        command,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT
    )

def get_previous_hashes(target_directory):
    if os.path.exists(TARGET_DIR + ".hashes"):
        with open(TARGET_DIR + ".hashes") as hash_file:
            hash_iterator = map(
                lambda x: x.split(),
                hash_file.readlines()
            )

            prev_hashes = {}
            for (file_name, hashing) in hash_iterator:
                prev_hashes[file_name] = hashing
    else:
        prev_hashes = {}

    return prev_hashes

def get_current_hashes(source_directory):
    current_hashes = {}
    walker = os.walk(SOURCE_DIR)

    for (directory, _, files) in walker:
        split_path = directory.split("/", 1)
        if len(split_path) == 1:
            partial_dir_path = ""
        else:
            partial_dir_path = split_path[1] + "/"
        
        for file in files:
            if not file.endswith("svg"):
                continue

            partial_file_path = partial_dir_path + file.split(".")[0]

            with open(SOURCE_DIR + partial_file_path + ".svg") as file:
                hasher = hashlib.sha256()
                hasher.update(file.read().encode())
                current_hashes[partial_file_path] = hasher.digest().hex()
                
    return current_hashes

def clone_directory_structure(source_dir, target_dir):
    for (directory_path, _, _) in os.walk(source_dir):
        partial_path = directory_path.split("/",1)
        if len(partial_path) == 1:
            partial_path = ""
        else:
            partial_path = partial_path[1]

        os.makedirs(target_dir + partial_path, exist_ok = True)

def rewrite_hash_file(target_directory, hashes):
    with open(target_directory + ".hashes", "w") as hash_file:
        for filename in hashes.keys():
            hash_file.write(f"{filename} {hashes[filename]}\n")

def get_diff(prev_hashes, current_hashes):
    diff = {
        "no_change": [],
        "change": [],
        "new": [],
        "removed": []
    }
    for filename in current_hashes.keys():
        current_hash = current_hashes.get(filename)
        previous_hash = prev_hashes.get(filename)

        if previous_hash is None:
            diff["new"].append(filename)

        elif previous_hash != current_hash:
            diff["change"].append(filename)

        else:
            diff["no_change"].append(filename)

        prev_hashes.pop(filename, None)


    # These are the files that were in the hash register, but has been removed.
    # We remove the png as well
    for filename in prev_hashes.keys():
        diff["removed"].append(filename)

    n_no_changes = len(diff["no_change"])
    n_changes = len(diff["change"])
    n_new = len(diff["new"])
    n_removed = len(diff["removed"])

    print(f"Files with no changes: {n_no_changes}")
    print(f"Files with changes:    {n_changes}")
    print(f"New files:             {n_new}")
    print(f"Files removed:         {n_removed}")

    return diff

def perform_transformations(source_dir, target_dir, diff):
    for filename in diff["new"]:
        print(f"File '{filename}' has been created, converting...")
        convert_file(source_dir+filename+".svg", target_dir+filename+".png")

    for filename in diff["change"]:
        print(f"File '{filename}' has changed, converting...")
        convert_file(source_dir+filename+".svg", target_dir+filename+".png")

    for filename in diff["removed"]:
        os.remove(TARGET_DIR + filename + ".png")
        print(f"Removing '{filename}'")


prev_hashes = get_previous_hashes(TARGET_DIR)
current_hashes = get_current_hashes(SOURCE_DIR)

clone_directory_structure(SOURCE_DIR, TARGET_DIR)

rewrite_hash_file(TARGET_DIR, current_hashes)

diff = get_diff(prev_hashes, current_hashes)

perform_transformations(SOURCE_DIR, TARGET_DIR, diff)

#                       | In current_hashes                         | Not in current hashes
# ----------------------+-------------------------------------------+----------------------------
# In prev_hashes        | Export if hashes are different (changed)  | Remove file (removed)
# ----------------------+-------------------------------------------+----------------------------
# Not in prev_hashes    | Export (new file)                         | 
#


print("Finished")
