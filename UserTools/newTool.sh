#!/bin/bash

if [ "$1" != "" ]
then
    
    mkdir $1
    more template/MyTool$2.h | sed s:MyTool$2:$1:g | sed s:MYTOOL$2_H:$1_H:g > ./$1/$1.h
    more template/MyTool$2.cpp | sed s:MyTool$2:$1:g | sed s:MyTool$2\(\):$1\(\):g > ./$1/$1.cpp
    more template/README.md | sed s:MyTool:$1:g | sed s:MyTool\(\):$1\(\):g > ./$1/README.md
    echo "#include \"$1.h\"" >>Unity.h
	
    while read line
    do
	if [ "$line" == "return ret;" ]
	then
	    echo "  if (tool==\""$1"\") ret=new "$1";" >>Factory/Factory.cpp.tmp
	fi
	echo $line >>Factory/Factory.cpp.tmp
    done < Factory/Factory.cpp
    mv Factory/Factory.cpp.tmp Factory/Factory.cpp
else
    
    echo -e "\e[38;5;196mError no name given \e[0m: usage = \"./newTool.sh \e[38;5;226m <ToolNAME> \e[38;5;46m <TemplateNAME> \e[0m\"  if <TemplateName> is blank then blank template is used"
    echo -e "Valid tools template names are:"
    echo -e "\e[38;5;46m<BLANK>"
    for name in `ls template/ |grep '\.h' |grep -v "h~" |sed s:"\.h"::|sed s:"MyTool"::`
    do
        echo $name
    done    
    echo -e "\e[0m"
fi
