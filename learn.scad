/**
文档
https://zh.m.wikibooks.org/wiki/OpenSCAD%E7%94%A8%E6%88%B7%E6%89%8B%E5%86%8C
*/
/** 
变换
*/

/**
translate	编辑
沿指定向量平移(移动)子元素
*/

/**
scale
利用指定的向量来缩放其子元素。参数名可以不写。
用例：
scale(v = [x, y, z]) { ... }
*/
translate([-15,15,0]) scale([0.5,1,1]) {
    cube(10);
}

/** 
resize	
根据指定的x、y、z修改子对象的尺寸。
resize()函数由CGAL来实现，就像render()这样的函数一样要处理整个几何体，因此就算是在预览模式下也要花上些时间来进行处理。

如果把'auto'参数设置为true，则resize函数将对参数值为0的维度进行自动缩放。
*/
// 将球体在x轴上的直径拓展至6，在y轴上的直径拓展至6，在z轴上的直径拓展至10。
translate([-20, 15,0]) resize([6,6,10]) {
    sphere(r=10);
}
// 将大小为1x2x0.5的长方体调整为7x14x3.5
translate([-30, 15,0])  resize([7,0,0], auto=true) {
    cube([1,2,0.5]);
}
// 将原长方体调整为10x8x1。请注意，其z维度保持不变。
translate([-45, 15,0]) resize([10,0,0], auto=[true,true,false]) {
    cube([5,4,1]);
}

/**
rotate	编辑
令子元素绕坐标轴或任意轴旋转'a'度。如果将参数按下列相同顺序指定，则可省略参数名。

rotate(a = deg_a, v = [x, y, z]) { ... }  

或
rotate(deg_a, [x, y, z]) { ... }
rotate(a = [deg_x, deg_y, deg_z]) { ... }
rotate([deg_x, deg_y, deg_z]) { ... }

这就意味着下列代码：

rotate(a=[ax,ay,az]) {...}
等价于（旋转顺序会影响最终旋转结果）：
rotate(a=[0,0,az]) rotate(a=[0,ay,0]) rotate(a=[ax,0,0]) {...}

可选参数'v'是一个向量，您可借此令对象绕任意轴进行旋转。
例如，为了让一个对象上下颠倒翻转过来，您可以令此对象绕'y'轴旋转180度。
rotate([0,180,0]) { ... }
在指定单个坐标轴时，通过设置参数'v'也能令对象绕坐标轴进行旋转。例如，以下代码是上述代码的等效实现，它令对象仅绕轴y进行旋转
rotate(a=180, v=[0,1,0]) { ... }

*/

/**
mirror	编辑
基于原点对平面上的子元素进行镜像操作。传入mirror()函数的参数为交于原点且用于镜像对象的平面上的法向量。

左侧为原始对象。请注意，镜像并非复制品。而是像rotate与scale函数那样，改变对象本身。
*/
translate([-50, 15, 0]) {
    rotate([0,0,10]) {
        cube([4,4,3]);
    }
    mirror([1,0,0]) translate([1,0,0]) rotate([0,0,10]) {
        cube([4,4,3]);
    }
}
/**
multmatrix	编辑
为所有子元素的几何体乘上指定的4x4变换矩阵。

用法: multmatrix(m = [...]) { ... }

以下为矩阵中前三行每一元素的内含解析：
[Scale X]	                [Scale X sheared along Y]	[Scale X sheared along Z]	[Translate X]
[Scale Y sheared along X]	[Scale Y]	                [Scale Y sheared along Z]	[Translate Y]
[Scale Z sheared along X]	[Scale Z sheared along Y]	[Scale Z]	                [Translate Z]

*/

translate([-60, 15, 0]) {
    M = [ [ 1  , 0  , 0  , 0   ],
      [ 0  , 1  , 0.7, 0   ],  // "0.7"为倾斜值；在这里，它令对象偏离y轴发生倾斜
      [ 0  , 0  , 1  , 0   ],
      [ 0  , 0  , 0  , 1   ] ] ;
    multmatrix(M) {  
        union() {
            cylinder(r=5,h=5,center=false);
            cube(size=[5,5,5],center=false);
        }
    }
}

/**
color
利用指定的RGB颜色 + alpha值来显示子元素。此函数仅用于F5预览，因为CGAL 与 STL (F6)当前还不支持上色。如果未指定alpha值，其默认值为1.0(不透明)。
函数签名:
color( c = [r, g, b, a] ) { ... }
color( c = [r, g, b], alpha = 1.0 ) { ... }
color( "#hexvalue" ) { ... }
color( "colorname", 1.0 ) { ... }
*/
//这里给出一个绘制多色波浪对象的代码片段
translate([0, 40, 0]) {
    for(i=[0:36]) {
        for(j=[0:36]) {
          color( [0.5+sin(10*i)/2, 0.5+sin(10*j)/2, 0.5+sin(10*(i+j))/2] )
          translate( [i, j, 0] )
          cube( size = [1, 1, 11+10*cos(10*i)*sin(10*j)] );
        }
     }
 }
 
 /**
 offset	编辑
 offset函数根据指定的值令2D轮廓外向或内向移动。
 
 参数
    r 
    双精度浮点数（double）。偏移多边形的值。此值为负时，令多边形进行内向偏移。参数r指定的是用于生成圆角的半径.
    delta
    则采用直边。
 
    chamfer
    布尔值（boolean）。 （默认值为false） 在使用delta参数时，此标志定义了是（以直线进行切割）否（扩展至边的交点）应当对边进行倒角。
 */
 translate([0, -30, 0]) {
    offset(rands = 1, chamfer = false, $fs = 1, $fa = 1) {
      square(10, center = true);
     }
 }
 
 /**
    hull
    显示子节点的凸包（convex hull）。
    2d有效
 */
 translate([-20, -30, 0]) {
     circle(5);
     translate([5,5,0]) circle(5);
     //linear_extrude(3, $fs = 1, $fa = 1) 
     hull() translate([-15, 0, 0]) {
        circle(5);
        translate([5,5,0]) circle(5);
    }
}


/**
布尔操作概述

union	编辑
创建所有子节点的并集。即，所有子节点之和(逻辑或).
可用于2D对象或3D对象, 但不能两者混用。

difference
从第一个子节点集中减去第二个（以及指定的其他）子节点集(逻辑与非).
可用于2D对象或3D对象, 但不能两者混用。

intersection
创建所有子节点的交集。这将保留集合间的重合部分(逻辑与).
只有所有子对象共用或共享的部分才会被保留下来。
可用于2D对象或3D对象, 但不能两者混用。

2d
 union()       {square(10);circle(10);} // 正方形 或   圆形
 difference()  {square(10);circle(10);} // 正方形 与非 圆形
 difference()  {circle(10);square(10);} // 圆形   与非 正方形
 intersection(){square(10);circle(10);} // 正方形 与   圆形
3d
 union()       {cube(12, center=true); sphere(8);} // 立方体 或   球体
 difference()  {cube(12, center=true); sphere(8);} // 立方体 与非 球体
 difference()  {sphere(8); cube(12, center=true);} // 球体   与非 立方体
 intersection(){cube(12, center=true); sphere(8);} // 立方体 与   球体
*/

/**
控制语句

for循环	
计算出范围或向量中的每一个值，并对其执行其后的动作（action）。

 for(variable = [start : increment : end])
 for(variable = [start : end])
 for(variable = [vector])
 
参数

针对范围 [ start : <increment : > end ] (参见range部分)
请注意: 对于范围而言，其中的值用冒号分隔，而非如向量那样用逗号。
start - 初始值
increment 或称 step（步长） - 每次循环都要为start加上此值（start = start + increment）作为比较值，该参数为可选项, 默认值 = 1
end - 当本次循环计算后的比较值大于此值时，停止循环

intersection_for
循环并取交集
Iterate over the values in a range or vector and create the intersection of objects created by each pass.

Besides creating separate instances for each pass, the standard for() also groups all these instances creating an implicit union. intersection_for() is a work around because the implicit union prevents getting the expected results using a combination of the standard for() and intersection() statements.

intersection_for() uses the same parameters, and works the same as a For Loop, other than eliminating the implicit union.

示例1 - loop over a range:
intersection_for(n = [1 : 6])
{
    rotate([0, 0, n * 60])
    {
        translate([5,0,0])
        sphere(r=12);
    }
}


if语句
执行一个测试，用于确定其子域中的动作是否该执行。

if (test) scope1
if (test){scope1}
if (test) scope1  else  scope2
if (test){scope1} else {scope2}


let语句	编辑
[请注意: 需要使用版本 2019.05]

针对一颗子树为变量设置新值。 The parameters are evaluated sequentially and may depend on each other (as opposed to the deprecated assign() statement).

for (i = [10:50])
{
    let (angle = i*360/20, r= i*2, distance = r*5)
    {
        rotate(angle, [1, 0, 0])
        translate([0, distance, 0])
        sphere(r = r);
    }
}
*/
translate([-50, -30, 0]) {
    //示例2 - 对元素为向量的向量进行迭代(平移操作)
    for(i = [ [ 0,  0,  0],
              [1.0, 1.2, 1.0],
              [2.0, 2.4, 2.0],
              [3.0, 3.6, 3.0],
              [2.0, 4.8, 4.0],
              [1.0, 6.0, 5.0] ])
    {
       translate(i)
       cube([5, 1.5, 1.0], center = true);
    }
}

/**
向量数运算符	
向量运算符
向量运算符取两个向量作为操作数来计算出一个新向量。

+	两个向量中对应元素相加
-	两个向量中对应元素相减
"-"也可用作前置运算符，令向量中的每个元素逐一取反。

示例
L1 = [1, [2, [3, "a"] ] ];
L2 = [1, [2, 3] ];
echo(L1+L1); // ECHO: [2, [4, [6, undef]]]
echo(L1+L2); // ECHO: [2, [4, undef]]

向量点积运算符
如果参与乘法运算的两个操作数都为简单向量，则根据点积的线性代数规则，计算结果为一个数。 c = u*v;的计算过程为{\displaystyle c=\sum u_{i}v_{i}}{\displaystyle c=\sum u_{i}v_{i}}。如果操作数的大小不匹配，则计算结果为undef。

矩阵乘法
如果参与乘法运算的两个操作数中存在矩阵，则根据矩阵乘积的线性代数规则，计算结果为一个简单向量或一个矩阵。在接下来的讨论中，我们设 A, B, C...为矩阵，u, v, w...为向量。下标i, j表示元素的索引。

对于规模为n × m的矩阵A与规模为m × p的矩阵B而言，二者之积C = A*B;为一个n × p矩阵，其中的元素依次为 {\displaystyle C_{ij}=\sum _{k=0}^{m-1}A_{ik}B_{kj}}{\displaystyle C_{ij}=\sum _{k=0}^{m-1}A_{ik}B_{kj}}。

而C = B*A;的结果为undef，除非n = p。

对于规模为n × m的矩阵A与规模为m的向量v而言，二者之积u = A*v;为一个规模为n的向量，其中的元素依次为 {\displaystyle u_{i}=\sum _{k=0}^{m-1}A_{ik}v_{k}}{\displaystyle u_{i}=\sum _{k=0}^{m-1}A_{ik}v_{k}}。

在线性代数中，此为矩阵与列向量的乘积.

对于规模为n的向量v与规模为n × m的矩阵A而言，二者之积u = v*A;为一个规模为m的向量，其中的元素以此为

{\displaystyle u_{j}=\sum _{k=0}^{n-1}v_{k}A_{kj}}{\displaystyle u_{j}=\sum _{k=0}^{n-1}v_{k}A_{kj}}.

在线性代数中，此为行向量与矩阵的乘积。

矩阵的乘法运算并不满足交换律，即：{\displaystyle AB\neq BA}{\displaystyle AB\neq BA}, {\displaystyle Av\neq vA}{\displaystyle Av\neq vA}。

数学函数
三角函数 (cos sin tan acos asin atan atan2)
其他数学函数 (abs ceil concat cross exp floor ln len let log lookup max min norm pow rands round sign sqrt)


str
将所有参数都转换为字符串并合而为一。


chr
[请注意: 需要使用版本 2015.03]

将数值们转换为对应编码，并合并为一个字符串。OpenSCAD采用Unicode码, 因此会将数值解释为Unicode码位(code point)。若数值超出有效码位的范围，则生成一个空字符串。
chr(数值)
如果数值的码位有效，则将仅有的一个码位转换至长度为1的字符串（字节数取决于UTF-8编码）。
chr(向量)
将向量参数中的所有码位转换为一个字符串。
chr(范围)
将范围参数生成的所有码位转换为一个字符串。


ord(字符串)
[请注意: 需要使用版本 2019.05]
将一个字符转换为对应Unicode码位的数值。如果参数并非字符串，则ord()将返回undef。
*/


/**


$fa, $fs 与 $fn
特殊变量$fa, $fs 与 $fn控制着用于生成弧的细分平面数量：

$fa为片段的最小角度。即使是一个再巨大的圆形，也不能通过此值而将其划分为多于360个片段。此特殊变量的默认值为12 (即，整个圆形分为30个片段)。其最小值为0.01。若企图将其设置为小于0.01的值，会产生一个警告。

$fs为片段的最小尺寸。Because of this variable very small circles have a smaller number of fragments than specified using $fa. 此特殊变量的默认值为2。其最小值为0.01。若企图将其设置为小于0.01的值，会产生一个警告。

$fn通常为0。当此变量大于0时，则忽略另外两个变量（$fa, $fs），且以此值作为片段数量来渲染整个圆形。其默认值为0。


$t
$t变量用于制作动画。如果您通过设置view->animate开启动画，并指定"FPS（帧率）"以及"Steps（步长）"，"Time"字段显示的就是$t的当前值。掌握了这些信息，便能令您的设计以动画效果展示出来。



$vpr, $vpt 与 $vpd
这三个特殊变量包含当前渲染时的视口旋转、视口平移与摄像机距离三种信息。移动视口并不会影响它们的值（wconly:??）。在展示动画期间会在每帧都更新它们的值。
$vpr表示旋转
$vpt表示平移(即此值不受旋转或缩放操作影响)
$vpd表示摄像机距离 [请注意: 需要使用版本 2015.03]
示例
cube([10, 10, $vpr[0] / 10]);



$preview
[请注意: 需要使用版本 2019.05]

当处于OpenCSG预览模式(F5)下，$preview为true。在处于渲染模式(F6)下，$preview为false。


echo语句
此函数会在编译窗口（又名控制台）中打印特定内容。有助于调试代码。

search	编辑
The search() function is a general-purpose function to find one or more (or all) occurrences of a value or list of values in a vector, string or more complex list-of-list construct.

查找函数的用法	编辑
search( match_value , string_or_vector [, num_returns_per_match [, index_col_num ] ] );

*/


/**
surface	编辑
Surface reads Heightmap information from text or image files.

参数

file
String. The path to the file containing the heightmap data.
center
Boolean. This determines the positioning of the generated object. If true, object is centered in X- and Y-axis. Otherwise, the object is placed in the positive quadrant. Defaults to false.
invert
Boolean. Inverts how the color values of imported images are translated into height values. This has no effect when importing text data files. Defaults to false. [请注意: 需要使用版本 2015.03]
convexity
Integer. The convexity parameter specifies the maximum number of front sides (back sides) a ray intersecting the object might penetrate. This parameter is only needed for correctly displaying the object in OpenCSG preview mode and has no effect on the final rendering.

scale([1, 1, 0.1]) {
  surface(file = "smiley.png", center = true, invert = true);
}

*/
translate([-100, 100, 0]) {
    surface(file = "BRGY-Grey.png", center = true, invert = true);
}


/**
函数与模块
OpenSCAD提供了:
返回数值的函数。
执行特定动作却不返回数值的模块。

函数的定义
function name ( parameters ) = value ;

name
    您为此函数起的名称。直观的函数名会在后面帮您的大忙。
parameters 0个或多个参数。可以为参数们赋予默认值，要使用默认值就要在调用函数时不填写参数。参数名仅用于本函数的作用域内，不会与外部的同名变量冲突。
value
    一个计算值的表达式。此项可以为一个向量。
// 示例1

function func0() = 5;
function func1(x=3) = 2*x+1;
function func2() = [1,2,3,4];
function func3(y=7) = (y==7) ? 5 : 2 ;
function func4(p0,p1,p2,p3) = [p0,p1,p2,p3];


模块	编辑
模块可用于定义对象、运算符，或使用children()。 模块一旦定义，就可以将其临时添加至语言特性中。

模块的定义
module name ( parameters ) { actions }
name
您为模块起的名字。试着起有意义的模块名吧~
parameters
0或多个参数。Parameters may be assigned default values, to use in case they are omitted in the call. Parameter names are local and do not conflict with external variables of the same name.
actions
Nearly any statement valid outside a module can be included within a module. This includes the definition of functions and other modules. Such functions and modules can only be called from within the enclosing module.
Variables can be assigned, but their scope is limited to within each individual use of the module. There is no mechanism in OpenSCAD for modules to return values to the outside. See Scope of variables for more details.



*/

function parabola(f,x) = ( 1/(4*f) ) * x*x; 
module plotParabola(f,wide,steps=1) {
function y(x) = parabola(f,x);
module   plot(x,y) {
    translate([x,y])
    circle(1,$fn=12);
}
xAxis=[-wide/2:steps:wide/2];
for (x=xAxis) 
    plot(x,y(x));
}
color("red")  plotParabola(10,100,5);
color("blue") plotParabola(4,60,2);




translate([0, 0, 0]) {
    /**
    参数:
    size
    单个值, 立方体所有边以此为边长
    3值数组[x,y,z], 立方体在x、y、z三个维度上的长度.
    center
    false (默认值), 立方体位于第一卦限中(3个坐标轴正轴围成的空间), 且一个角位于点(0,0,0)
    true, 立方体的中心位于点(0,0,0)
    */
    cube(size = [2, 5, 10], center = true);
}

translate([10, 0, 0]) {
    /**
    r 半径。此为球体的半径。球体的分辨率基于球体的大小与$fa、$fs、$fn三个变量。至于这些特殊变量的更多信息请查阅: OpenSCAD用户手册/其他语言特性
    d
    直径。此为球体的直径。
    $fa
    以度数来表示的片段角度。
    $fs
    以毫米（mm）表示的片段尺寸。
    $fn
    分辨率
    */
    sphere(r = 3, $fa = 2, $fs = 1);
}

translate([20, 0 , 0]) {
    /**
    参数
    h : 圆柱体或圆锥体的高。
    r  : 圆柱体的半径。r1 = r2 = r。
    r1 : 圆锥体的底面半径。
    r2 : 圆锥体的顶面半径。
    d  : 圆柱体的直径。r1 = r2 = d / 2. [请注意: 需要使用版本 2014.03]
    d1 : 圆锥体的底面直径。r1 = d1 / 2. [请注意: 需要使用版本 2014.03]
    d2 : 圆锥体的顶面直径。r2 = d2 / 2. [请注意: 需要使用版本 2014.03]
    center
    false (默认值),z轴的取值范围为0至h
    true, z轴的取值范围为-h/2至+h/2
    $fa : 每个片段的最小角度(以角度来表示)。
    $fs : 每个片段的最小圆周长度。
    $fn : fixed number of fragments in 360 degrees. Values of 3 or more override $fa and $fs
    $fa, $fs and $fn must be named. 点击这里来查阅更多细节。
    */
    cylinder(h=15, r1= 5, r2= 3, center=true);
}

translate([0, 20 , 0]) {
    /**
    参数
    text
    字符串。待生成的文本。
    size
    十进制数。生成的文本将逼近所指定值的大小（也就是基线以上的高度）。 默认值为10。
    请注意，特定字体或有差异，可能会导致不能按指定的size精确地填充字体，通常情况下填充的效果会稍小一些。
    
    font
    字符串。所用的字体名称。此参数并非字体文件的名称，而是字体的逻辑名称 (即，fontconfig库内部处理时所用名称)。此参数中还可以包括一个字体样式参数，参见下文。系统中安装的字体与样式列表可以通过字体列表（font list）对话框来获取 (Help -> Font List)。
    
    halign
    字符串。文本的水平对齐方式。取值可以为："left（左对齐）", "center（居中对齐）" 与 "right（右对齐）". 默认值为"left"。
    
    valign
    字符串。文本的垂直对齐方式。取值可以为"top（顶部对齐）", "center（居中对齐）", "baseline（基线对齐）" 与 "bottom（底部对齐）"。默认值为"baseline"。
    
    spacing
 十进制数。用于增减字符间距的因子。默认值1采用的是字体的一般间距，而大于1的值将导致字母间的距离更大。
    
    direction
    字符串。文本流的方向。取值可以为"ltr" (左 -> 右), "rtl" (右 -> 左), "ttb" (上 -> 下) 与 "btt" (下 -> 上)。默认值为"ltr"。
    
    language
    字符串。文本的语言。默认值为"en（英文）"。
    
    script
    字符串。文本的脚本。默认值为"latin（拉丁文）"。
    
    $fn
    用于细分freetype所提供的曲线路径片段（curved path segments）
    */
    text("bigwen");
} 

translate([40, 0, 0]) {
    //方型
    /**
    参数
    size
    单个值，方块的两对边都是这个长度
    两个值的数组 [x, y]，长方形的两对边分别为 x 和 y
    center
    false （默认值），方形在第一象限，其中一个角在原点 (0,0)
    true，方形以原点 (0,0) 为中心
    */
    square(size = [8, 8], center = true);
}

translate([40, 10, 0]) {
    //圆形
    circle(5, $fn=50);
}

translate([40, -20, 0]) {
    //椭圆，用变换来实现
    resize([30,10]) {
        circle(d=20);
    }
    scale([1.5,.5])circle(d=20);
}

translate([50, -40, 0]) {
    //	正多边形
    /**
    把 $fn 设置为想要的边数（3或以上），即可通过 circle() 得到正多边形。
    */
    circle(10,$fn=10);
}

translate([50, 0, 0]) {
    
    /**
    linear_extrude(height = fanwidth, center = true, convexity = 10, twist = -fanrot, slices = 20, scale = 1.0, $fn = 16)
    height必须为正数。

    $fn是指定linear_extrude分辨率的可选项（值越大图形越“平滑”，但计算时间也将随之增加）。
    
    convexity
    “内陷”曲线的个数
    
    twist
    旋转
    
    scale 
    缩放
    
    slices
    每一层旋转的平滑程度
    */
    linear_extrude(height = 20, twist = -500, convexity = 10, scale=[1,1], slices = 40, center = true,$fn = 100) {
        //多边形
        /**
        参数
        points
        多边形顶点 x,y 列表 ： 二元矢量的矢量
        注意： 点的下标是从 0 到 n-1。
        paths
        缺省
        如果未指定 path，所有顶点按它在矢量中的顺序依次使用。
        单个矢量
        指明连接顶点的顺序。矢量中的元素是顶点从 0 到 n-1 的下标。可以指定顶点的任意顺序、任意子集。
        多个矢量
        指明主形状与次形状。其中，次形状会用来裁剪主形状（就象差集）。次形状可以部分或完全在主形状内部。
        最终会连接最后一个顶点与第一个顶点，创建一个闭合形状。
        convexity
        “内陷”曲线的个数，或者说，一条任意直线最多可能与多边形的边相交几次。详见下文。
        */
        polygon(points = [[2,2],[2,-2],[-2,-2],[-2, 2],[1, 1],[1,-1],[-1,-1],[-1,1]],
        paths = [[0,1,2,3], [4,5,6,7]], convexity = 1);
    }
}

translate([-20, 0, 0]) {
    //曲面延展
    rotate_extrude(convexity = 10, $fs = 1, $fa = 1)
    translate([8, 0, 0])
    circle(r = 2, $fn = 100);
}

translate([-40, 0 , 10]) {
    rotate([90,0,0]) {
        polygon(points=[[0,0],[2,1],[1,2],[1,3],[3,4],[0,5]]);
    }
}

translate([-40, 0, 0]) {
    
    rotate_extrude($fn=200) polygon( points=[[0,0],[2,1],[1,2],[1,3],[3,4],[0,5]]);
}
