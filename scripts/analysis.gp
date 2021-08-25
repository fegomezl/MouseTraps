set g
set key opaque
set term pdf
set ls 1 lc rgb "dark-blue" pt 1 ps 0.5 lt 1 lw 0.5
set ls 2 lc rgb "dark-red" pt 2 ps 0.5 lt 1 lw 0.5

file = 'data/results/system_state.txt'

box_size = system("sed -n 1p data/init_data.txt | tr -d -c 0-9.")*1
nt = int(system("sed -n 3p data/init_data.txt | tr -d -c 0-9."))
rad = system("sed -n 6p data/init_data.txt | tr -d -c 0-9.")*1
dt = system("sed -n 10p data/init_data.txt | tr -d -c 0-9.")*1

densidad = 4*(rad*rad*nt)/(box_size*box_size)

Init = sprintf(" {/:Bold Densidad:} %.2f", densidad)

set obj 1 rect from graph 0, 1 to graph 0.22, 0.93 fc rgb "white"
set lab 1 Init at graph 0, 0.96

set xr [0:]
set yr [0:]
set xl 'Tiempo (s)'

f(x)=-log(abs(1-x))
g(x,y) = x/(1-y)

set title 'Lambda (int)'
set o 'data/lambda_int.pdf'
p file u 1:(y=$4, f(y)) ls 1 not

h(x) = a + b*log(x) + c*log(1-x)
a = 0.2
b = -1
c = -1
fit[0.05:0.8] h(x) file u 4:(x=$3, y=$4, -log(g(x,y))) via a,b,c

set title 'Regresion'
set o 'data/regresion.pdf'
p file u 4:(x=$3, y=$4, -log(g(x,y))) ls 1 t 'data', h(x) ls 2 t 'fit'

set title 'Lambda'
set o 'data/lambda.pdf'
p file u 1:(x=$3, y=$4, g(x,y)) ls 1 not
set xl 'Porcentaje de activaciones'
p file u 4:(x=$3, y=$4, g(x,y)) ls 1 t 'data', exp(-h(x)) ls 2 t 'fit'

