#!/bin/bash

#recieves class name and verbose flag
class_name=$1
verbose=$2

if [ $verbose -eq 1 ]; then
	echo "Create class ${class_name}"
fi

#header 
header_guard=$(echo ${class_name} | tr '[:lower:]' '[:upper:]')
filename=$(echo ${class_name} | tr '[:upper:]' '[:lower:]')


if [ $verbose -eq 1 ]; then
	echo "Create header file ${filename}.h"
	echo "Create class file ${filename}.cpp"
fi

echo "#ifndef ${header_guard}_H
#define ${header_guard}_H

class ${class_name} {
public:
	${class_name}();
	~${class_name}();
};

#endif //${header_guard}_H" >> src/${filename}.h

#implementation

echo "#include \"${filename}.h\"

${class_name}::${class_name}() {

}

${class_name}::~${class_name}() {
}

" >> src/${filename}.cpp

if [ $verbose -eq 1 ]; then
	echo "Class created"
fi

exit 0
