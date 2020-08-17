#!/bin/bash

#常量定义
N=40 #后缀随机数的长度
FILETYPE=jpg #文件后缀名

#函数定义
function subChangeMD5()
{
    echo `pwd`
    for file in `ls`
    do
        if [[ -d "$file" ]]
        then
            cd "$file"
            subChangeMD5
            cd ..
            continue
        fi
        [[ ! -f "$file" ]] && continue
        [[ `echo "$file"|sed "s/.*\.//"` != $FILETYPE ]] && continue
        ADD=`tail -c $N "$file"|sed "s/[0-9]*//g"`
        [[ "$ADD" == "" ]] && continue #防止重复增加后缀
        ADD=""
        n=$N
        while [[ $n -gt 0 ]]
        do
            ADD="$ADD$(($RANDOM%1117%177%10))"
            n=$((n-1))
        done
        echo "`pwd`/$file+++$ADD"
        echo -n "$ADD" >>"$file"
    done
}

function showMD5()
{
    echo `pwd`
    for file in `ls`
    do
        if [[ -d "$file" ]]
        then
            cd "$file"
            showMD5
            cd ..
            continue
        fi
        [[ ! -f "$file" ]] && continue
        [[ `echo "$file"|sed "s/.*\.//"` != $FILETYPE ]] && continue
        ADD=`tail -c $N "$file"`
        echo "`pwd`/$file+++$ADD"
    done
}

#主程序
IFS="
"
if [[ $1 == -c ]]
then
    echo "Choose Y or y to continue:"
    read ans
    if [[ $ans != y && $ans!=Y ]]
    then
        exit
    fi
    subChangeMD5
elif [[ $1 == -d ]]
then
    showMD5
elif [[ $1 == -e ]]
then
    : #删除MD5后缀
elif [[ $1 == -h ]]
then
    echo "usage:changeMD5 [-c/-d/-e/-h]"
    echo "    在当前文件夹运行时，会对该文件夹以及子文件夹中的$FILETYPE(可通过修改FILETYPE变量来改变文件类型)文件进行增加$N(可通过修改N变量来改变随机数数目)个随机数后缀来修改文件的MD5值，可用于解决百度网盘屏蔽的问题"
fi