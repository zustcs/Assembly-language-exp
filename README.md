# 汇编实验代码

## 说明

该项目内的代码为学校`汇编语言`课程的实验代码

历届的题目都是一样的，在百度上应该搜的到同样的实验报告

不过这里的`实验2、3`的代码会优于百度上扒的代码，并且完全符合题目要求（按我对题目的理解）

里面的注释都是边学边写的，可能存在错误

`实验1` 是排序题，书上有类似的代码，应该比较好理解，没有写注释。

`实验4`的题目有点超纲，书上找不到详细用法，代码是抄网上的，能用就懒得改进了，当时就随便看了看理解了下，没写注释。

## 关于考试

如果能完全弄懂前3个实验代码的话，相信你考试`100%`没有问题（指不挂科）

考的东西大部分都是背背记记的

特别是最后2章还是3章，不要觉得背的多，因为是真的会考，简答题里出2、3道吧（记不太清了）

考试的最后一道大题是手写编程题，注意要背一下`完整段定义`和`简化段定义`，题目会有要求的（当时好多人就没记）

最后一道大题千万别空着，真的不会也把格式写一下，你们的聪学长不会写就直接溜出考场了...然后你懂得

感觉要说的也都说的差不多了，只要认真复习都能过的~

## 实验3
### 难点

- 8255A的使用方法
- 切换 INT 9 键盘调用中断向量表

### Tip

- STI(Set Interrupt) 中断标志置1指令，使`IF = 1`
- CLI(Clear Interrupt) 中断标志置0指令，使`IF = 0`

`IF`标志位主要用于屏蔽外部中断，这里使用这里两个命令防止替换中断向量表时出错

##  实验4

`CLD`设置方向标志位`DF=0`

`SLD`设置方向标志位`DF=1`

用法（配合食用）：

```assembly
CLD
LODSB
```

等价于

```assembly
MOV AL,[DS:SI]
ADD SI,1
```

##  结语

大部分代码含义和用法书上都有~~（期末复习的时候才发现阴暗的角落里啥都有）~~

上面记的是当初刚学时一下子没（找到/明白）的

真门课可能会觉得学的不明不白的，因为汇编本来就是规定、设计好的

很多东西没什么道理可讲，你就得这么去写

不过弄明白这些代码会对`高级编程语言`有更深的理解

希望代码里的注释能对各位有帮助~



