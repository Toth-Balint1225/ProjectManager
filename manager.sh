#!/bin/bash

OPTIND=1

#help screen
show_help() {
cat << EOF 
Usage: ${0##*/} <mode> [option optarg]
	<mode>
		create/c          create specified item
		delete/d          delete specified item
		build/b           build project
		run/r             run project
		clean             clean project
		cmake             create cmake (only with project)
		config            configure cmake project
	[option]
		-h 	              display help
		-p [project_name] select project
		-c [classname]    select class
		-i [header_name]  select header file
		-s [source_name]  select source file

EOF
}


#invalid call 
if [ $# -eq 0 ]; then
	echo 'Invalid number of arguments'
	show_help
fi

#flags
f_verbose=0

#constants
source_dir="src"
bin_dir="bin"

#variable
project_dir=""
project_name=""
s_class=""
s_include=""
s_source=""
s_project=""

#argument identification
if [ "$1" = "-h" ]; then
	show_help
	exit 0
else
	arg=$1
	shift
fi
#option parsing
while getopts ":h: :v: :p: :c: :i: :s:" opt; do
	case $opt in
		h)
			show_help >&2
			exit 0
			;;
		v)
			f_verbose=1 >&2
			;;
		p)
			s_project=$OPTARG >&2
			;;
		c)
			s_class=$OPTARG >&2
			;;
		i)
			s_include=$OPTARG >&2
			;;
		s)
			s_source=$OPTARG >&2
			;;
		*)
			echo "Invalid arguments" >&2
			show_help
			exit 1
			;;
	esac
done
shift "$((OPTIND-1))"

#verbose report
if [ $f_verbose -eq 1 ]; then
	echo "verbose mode active"
fi

#argument parsing
if [ "$arg" = "create" ] || [ "$arg" = "c" ]; then
	# activate create mode
	if [ -n "$s_project" ]; then 
		createproject.sh $s_project $f_verbose
	fi
	if [ -n "$s_class" ]; then
		createclass.sh $s_class $f_verbose	
	fi
	if [ -n "$s_include" ]; then 
		if [ $f_verbose -eq 1 ]; then  
			echo "create new header ${s_include}"
		fi
	fi
	if [ -n "$s_source" ]; then 
		if [ $f_verbose -eq 1 ]; then 
			echo "create new surce ${s_source}"
		fi
	fi
elif [ -n "$s_project" ]; then
	cmakeproject.sh $s_project
elif [ "$arg" = "delete" ] || [ "$arg" = "d" ]; then
	#activate delete mode
	echo 'delete somethin'
elif [ "$arg" = "run" ] || [ "$arg" = "r" ]; then 
	#run project
	if [ $(ls -1 | grep "CMakeLists.txt" | wc -l) -eq 1 ]; then
		./bin/"`basename $(pwd)`"
	else 
		make all
	fi
elif [ "$arg" = "build" ] || [ "$arg" = "b" ]; then
	#build project
	if [ $(ls -1 | grep "CMakeLists.txt" | wc -l) -eq 1 ]; then
		cd ./bin && make
	else 
		make
	fi
elif [ "$arg" = "clean" ]; then
	#clean project
	if [ $(ls -1 | grep "CMakeLists.txt" | wc -l) -eq 1 ]; then
		cd ./bin && make clean
	else 
		make clean
	fi
elif [ "$arg" = "config" ]; then
	if [ $(ls -1 | grep "CMakeLists.txt" | wc -l) -eq 1 ]; then
		cmake -S . -B ./bin
	else
		echo "not a cmake project"
	fi
fi



exit 0
