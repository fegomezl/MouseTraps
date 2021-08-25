set g
set key opaque
set term pdf
set ls 1 lc rgb "dark-blue" pt 0 ps 0.5 lt 1 lw 0.5
set ls 2 lc rgb "dark-red" lt 1 lw 0.5

box_size = system("sed -n 1p data/init_data.txt | tr -d -c 0-9")*1
nt = int(system("sed -n 3p data/init_data.txt | tr -d -c 0-9"))
rad = system("sed -n 6p data/init_data.txt | tr -d -c 0-9.")*1
densidad = 4*(rad*rad*nt)/(box_size*box_size)

Init = sprintf(" {/:Bold Densidad:} %.2f", densidad)

set xr [0:]
set xl 'Tiempo (s)'

set obj 1 rect from graph 0, 1 to graph 0.22, 0.93 fc rgb "white"
set lab 1 Init at graph 0, 0.96

set title 'Ln(1-F(x))'
set yr [0:]
set yl 'Ln(1-F(x))'
set o 'data/lambda_int.pdf'
p 'data/results/system_state.txt' u 1:(-log(abs(1-$4))) ls 1 t 'Ln(1-F(x))'

x0=NaN
y0=NaN

set title 'd/dx(Ln(1-F(x)))'
set yr [0:]
set yl 'd/dx(Ln(1-F(x)))'
set o 'data/lambda.pdf'
p 'data/results/system_state.txt' u (dx=$1-x0,x0=$1,$1-dx/2):(dy=(-log(abs(1-$4)))-y0,y0=(-log(abs(1-$4))),dy/dx) w l ls 1 t 'd/dx(Ln(1-F(x)))'

g(x,y) = x/(1-y)

set title 'Ln(1-F(x))'
set yr [:]
set yl 'Ln(1-F(x))'
set o 'data/lambda_3.pdf'
p 'data/results/system_state.txt' u 4:(x=$3, y=$4, g(x,y)) ls 1 t 'Ln(1-F(x))', \
    'data/results/system_state.txt' u (dx=$1-x0,x0=$1,$4):(dy=(-log(abs(1-$4)))-y0,y0=(-log(abs(1-$4))),dy/dx) w l ls 2 t 'd/dx(Ln(1-F(x)))2'
