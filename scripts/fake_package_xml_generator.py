import os
import re
import sys

"""
Manual script to pre-fill all the needed package.xml files for the snap generation.
The generated xml files are not production ready and have to be edited manually to fix quirks and corner cases
Use this script when a new update to the gazebo upstream source requires to bump the xmls in this repository:
- clone all the gazebo packages into a folder
- run this script using the top folder as input
- manually edit the output and move it inside the gz_packages_XML folder
"""

def find_deps_names(folder_path):
    """
    Find all dependencies in the CMakeLists.txt inside folder_path.
    Warn: This is tuned for gazebo cmake macros
    """
    deps_names = []

    cmake_file = os.path.join(folder_path, "CMakeLists.txt")
    if not os.path.isfile(cmake_file):
        return deps_names

    # This regex will match gz_find_package(gz-<name>) or gz_find_package(sdformat<version>)
    pattern = r'gz_find_package\s*\(\s*(gz-[\w\-]*|sdformat\d+)\s.*'
    with open(cmake_file, 'r') as file:
      for line in file:
          gz_cmake_match = re.search(r'find_package\(gz-cmake\d+', line)
          if gz_cmake_match:  # not using gz_find_package for this
              gz_cmake_version = gz_cmake_match.group(0).split("cmake")[1]
              deps_names.append("gz-cmake" + gz_cmake_version)
          matches = re.search(pattern, line)
          if matches:
              first_word = matches.group(1)
              deps_names.append(first_word)
    return deps_names


def find_version(folder_path):
    """Extracts the version number from the CMakeLists.txt inside folder_path
    Note: this is tuned for Gazebo cmake project style
    Warn: This will silently return 0.0.1 if the CMakeLists does not have a version declared
    """
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
    """
    Extracts the project name from the CMakeLists.txt inside folder_path
    Note: this is tuned for Gazebo cmake project style
    Warn: This will silently return NOT_FOUND if the CMakeLists does not have a version declared
    """
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
    """
    Generates a package.xml file based on the information provided in the args

    Args:
        folder_path (_type_): the folder where package.xml will be created
        package (_type_): the name of the package 
        version (_type_): the version of the package
        deps_names (_type_): a list of dependencies of the package
        xml_name (str, optional): Name of the output xml file. Defaults to "package.xml".
    """
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
    """
    Generate a custom package.xml in the top_folder for each subfolder that has a CMakeLists.txt inside
    Each custom package.xml will have the name of the subfolder used for finding information
    """
    for folder in os.listdir(top_folder):
      if not os.path.isdir(folder):
          continue
      folder_path = os.path.join(top_folder, folder)
      print("Processing folder " + folder_path)
      deps_names = find_deps_names(folder_path)
      version = find_version(folder_path)
      name = find_name(folder_path)
      generate_package_xml(top_folder, name, version, deps_names, folder + ".xml")

if len(sys.argv) < 2:
    print("Please provide the top-level folder as a command-line argument.")
    sys.exit(1)

top_folder = sys.argv[1]
process_folders(top_folder)


