#!/bin/bash

#recieves project name and verbose flag from manager
project_name=$1
verbose=$2

#directories
if [ $verbose -eq 1 ]; then
	mkdir -v "$project_name"
	mkdir -v "$project_name"/"src"
	mkdir -v "$project_name"/"bin"
else
	mkdir "$project_name"
	mkdir "$project_name"/"src"
	mkdir "$project_name"/"bin"
fi

#makefile
echo "#compiler flags
CXX := g++
CFLAGS := -Wall -Werror -std=c++17
GTKFLAGS := ""

#directories 
bin_dir := bin
source_dir := src

#######manual input######################
target := ${project_name}
#debug mode
#CFLAGS += -g
#enable multithread
#CFLAGS += -pthread
#enable gtkmm
#GTKFLAGS += \`pkg-config gtkmm-3.0 --cflags --libs\`
#########################################

#######do not edit below this line#######
cpps := \$(shell ls \$(source_dir)/*.cpp)
objs := \$(patsubst \$(source_dir)/%.cpp,\$(bin_dir)/%.o,\$(cpps))
deps := \$(patsubst \$(bin_dir)/%.o,\$(bin_dir)/%.d,\$(objs)) 

-include \$(deps)
DEPFLAGS = -MMD -MF \$(@:.o=.d)

all: \$(target)
	@echo 'Running project \$(target)'
	@echo '------------------'
	./\$(target)
	@echo '------------------'
	@echo 'Project terminated'

\$(target): \$(objs) 
	@echo 'Invoking GNU linker'
	@echo 'Linking project \$@'
	\$(CXX) \$(CFLAGS)  -o \$@ $^ \$(GTKFLAGS)
	@echo 'Linking finished'

\$(bin_dir)/%.o: \$(source_dir)/%.cpp
	@echo 'Invoking GNU compiler'
	@echo 'Compiling $<'
	\$(CXX) \$(CFLAGS) -c $< \$(DEPFLAGS) -o \$@ \$(GTKFLAGS)

clean:
	rm -rf \$(objs) \$(deps) \$(target)

.PHONY: all
" >> "$project_name"/Makefile  

#main function template
echo "#include <iostream>


int main() {
	std::cout << \"Hello World\" << std::endl;

	return 0;
}
" >> "$project_name"/src/main.cpp

