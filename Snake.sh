#!/bin/bash
clear
##初始化蛇和边界##
score=0
snake=("9 10" "9 11" "10 11" "11 11" "12 11")
wall_x=25
wall_y=20
key=w
function get_x()
{
echo $1
}
function get_y()
{
echo $2
}
##随机食物坐标##
function new_food()
{
xy_overlapping=0
while true
do
ran_x=$(($RANDOM%($wall_x-2)+2))
ran_y=$(($RANDOM%($wall_y-2)+2))
food_xy="$ran_x $ran_y"
for ((i=0;i<${#snake[*]};i++))
do
if [ $food_xy == ${snake[i]} ]
then
$xy_overlapping=1
break 1
fi
done
if [ $xy_overlapping == 0 ]
then
break 1
fi
done
}
new_food
while true
do

clear
##绘制边界##
for ((i=1;i<=$wall_x;i++))
do
for ((j=1;j<=$wall_y;j++))
do
if [ $i == 1 -o $i == $wall_x -o $j == 1 -o $j == $wall_y ]
then
echo -en "\033[${j};${i}HO"
echo
fi
done
done

##绘制蛇##
for ((i=0;i<${#snake[*]};i++))
do
snake_xy=(${snake[i]})
echo -en "\033[$(get_y ${snake[i]});$(get_x ${snake[i]})HO"
done
##绘制食物##
echo -en "\033[$(get_y $food_xy);$(get_x $food_xy)H*"
##显示得分##
echo -e "\033[$(($wall_y+1));0H"
echo "score:$score""0000"
##蛇身移动##
for ((i=${#snake[*]};i>1;i--))
do
snake[$(($i-1))]="${snake[$(($i-2))]}"
done

##按键控制蛇头##

read -n 1 -t 0.5 buffer_key
if [ "$buffer_key" == "w" -o "$buffer_key" == "a" -o "$buffer_key" == "s" -o "$buffer_key" == "d" ]
then

##防止反向移动##
case $key in
a)
if [ $buffer_key != "d" ]
then
key=$buffer_key
fi
;;

d)
if [ $buffer_key != "a" ]
then
key=$buffer_key
fi
;;
s)
if [ $buffer_key != "w" ]
then
key=$buffer_key
fi
;;
w)
if [ $buffer_key != "s" ]
then
key=$buffer_key
fi
;;
esac
fi

case $key in
a)
snake[0]="$(($(get_x ${snake[0]})-1)) $(get_y ${snake[0]})"
;;
d)
snake[0]="$(($(get_x ${snake[0]})+1)) $(get_y ${snake[0]})"
;;
w)
snake[0]="$(get_x ${snake[0]}) $(($(get_y ${snake[0]})-1))"
;;
s)
snake[0]="$(get_x ${snake[0]}) $(($(get_y ${snake[0]})+1))"
;;
esac
##吃到食物增加长度加分##
if [ "${snake[0]}" == "$food_xy" ]
then
score=$(($score+1))
for ((i=${#snake[*]};i>1;i--))
do
snake[$i]="${snake[$(($i-1))]}"
done
new_food
fi
##撞墙##
if [ $(get_x ${snake[0]}) == 1 -o $(get_x ${snake[0]}) == $wall_x -o $(get_y ${snake[0]}) == 1 -o $(get_y ${snake[0]}) == $wall_y ]
then
break
fi
##自杀##
for ((i=1;i<${#snake[*]};i++))
do
if [ "${snake[0]}" == "${snake[$i]}" ]
then
break 3
fi
done

done
echo "game over"

