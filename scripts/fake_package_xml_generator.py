import os
import re
import sys

def find_deps_names(folder_path):
    deps_names = []

    cmake_file = os.path.join(folder_path, "CMakeLists.txt")
    if not os.path.isfile(cmake_file):
        return deps_names
        
    pattern = r'ign_find_package\s*\(\s*([a-zA-Z0-9_-]*|\w+)\s.*'
    with open(cmake_file, 'r') as file:
      for line in file:
          if "find_package(ignition-cmake2" in line:  # not using ign_find_package for this
              print("ignition-cmake2")
              deps_names.append("ignition-cmake2")
          matches = re.search(pattern, line)
          if matches:
              first_word = matches.group(1)
              if "IgnProtobuf" in first_word:
                  continue  # GZ wraps protobuf with their own cmake macro, ignore
              print(first_word)
              deps_names.append(first_word)
    return deps_names


def find_version(folder_path):
    cmake_file = os.path.join(folder_path, "CMakeLists.txt")
    if not os.path.isfile(cmake_file):
        raise Exception("CMakeLists.txt not found")

    pattern = r'project\s*\([^)]*\s+VERSION\s+(\d+\.\d+\.\d+)\)'
    with open(cmake_file, 'r') as file:
      for line in file:
          matches = re.search(pattern, line)
          if matches:
              first_word = matches.group(1)
              print(first_word)
              return first_word

    return "0.0.1"

def find_name(folder_path):
    cmake_file = os.path.join(folder_path, "CMakeLists.txt")
    if not os.path.isfile(cmake_file):
        raise Exception("CMakeLists.txt not found")

    pattern = r'project\s*\(\s*([0-9A-Za-z_-]*)\s*'
    with open(cmake_file, 'r') as file:
      for line in file:
          matches = re.search(pattern, line)
          if matches:
              first_word = matches.group(1)
              print(first_word)
              return first_word

    return "NOT_FOUND"

def generate_package_xml(folder_path, package, version, deps_names, xml_name="package.xml"):
    package_xml = os.path.join(folder_path, xml_name)
    with open(package_xml, "w") as f:
      f.write('<?xml version="1.0"?>\n')
      f.write('<package format="3">\n')
      f.write('  <name>{PACKAGE}</name>\n'.format(PACKAGE=package))
      f.write('  <version>{VERSION}</version>\n'.format(VERSION=version))
      f.write('  <description>WIP</description>\n')
      f.write('  <maintainer email="wip@wip.com">WIP</maintainer>\n')
      f.write('  <author>WIP</author>\n')
      f.write('  <license>WIP</license>\n')
      for package_name in deps_names:
          f.write(f"  <build_depend>{package_name}</build_depend>\n")
      f.write("</package>\n")

def subdirs(path):
    """Yield directory names not starting with '.' under given path."""
    for entry in os.scandir(path):
        if not entry.name.startswith('.') and entry.is_dir():
            yield entry.name

def process_folders(top_folder):
  for folder in os.listdir(top_folder):
      folder_path = os.path.join(top_folder, folder)
      print("Processing folder "+folder_path)
      deps_names = find_deps_names(folder_path)
      if deps_names:
          version = find_version(folder_path)
          name = find_name(folder_path)
          #generate_package_xml(folder_path, name, version, deps_names)
          generate_package_xml(top_folder, name, version, deps_names, folder+".xml")

# Read the top-level folder from command-line argument
if len(sys.argv) < 2:
    print("Please provide the top-level folder as a command-line argument.")
    sys.exit(1)

top_folder = sys.argv[1]
process_folders(top_folder)


