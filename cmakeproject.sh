#!/bin/bash

project_name=$1

#create dirs
mkdir $project_name
mkdir "$project_name"/src "$project_name"/bin

echo "
cmake_minimum_required(VERSION 3.19.1)

project(${project_name})

file(GLOB source_files \"\${PROJECT_SOURCE_DIR}/src/*.cpp\")
file(GLOB header_files \"\${PROJECT_SOURCE_DIR}/src/*.h\")

add_executable(\${PROJECT_NAME} \${source_files} \${header_files})
" > "$project_name"/CMakeLists.txt

#main function template
echo "#include <iostream>


int main() {
	std::cout << \"Hello World\" << std::endl;

	return 0;
}
" > "$project_name"/src/main.cpp


