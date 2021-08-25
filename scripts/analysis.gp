set g
set key opaque
set term pdf
set ls 1 lc rgb "dark-blue" pt 1 ps 0.5 lt 1 lw 0.5
set ls 2 lc rgb "dark-red" pt 2 ps 0.5 lt 1 lw 0.5
set ls 3 lc rgb "dark-green" pt 3 ps 0.5 lt 1 lw 0.5

file = 'data/results/system_state.txt'

box_size = system("sed -n 1p data/init_data.txt | tr -d -c 0-9.")*1
nt = int(system("sed -n 3p data/init_data.txt | tr -d -c 0-9."))
rad = system("sed -n 6p data/init_data.txt | tr -d -c 0-9.")*1

densidad = 4*(rad*rad*nt)/(box_size*box_size)

Init = sprintf(" {/:Bold Densidad:} %.2f", densidad)

set obj 1 rect from graph 0, 1 to graph 0.22, 0.93 fc rgb "white"
set lab 1 Init at graph 0, 0.96

set xr [0:]
set yr [0:]
set xl 'Porcentaje de activaciones'

f(x) = a + b*log(x) + c*log(1-x)
a = 0.2
b = -1
c = -1
fit[0.05:0.8] f(x) file u 4:(-log($3)) via a,b,c

g(x) = A*(x**B)*((1-x)**C)
A = exp(-a)
B = -b
C = -c
fit[0.05:0.8] g(x) file u 4:3 via A,B,C

set title 'Density (semilog)'
set o 'data/density_semilog.pdf'
p file u 4:(-log($3)) ls 1 t 'data', f(x) ls 2 t 'fit 1', -log(g(x)) ls 3 t 'fit 2'

set title 'Density'
set o 'data/density.pdf'
p file u 4:3 ls 1 t 'data', exp(-f(x)) ls 2 t 'fit 1', g(x) ls 3 t 'fit 2'
set xl 'Tiempo (s)'
p file u 1:3 ls 1 t 'data', file u 1:(exp(-f($4))) w l ls 2 t 'fit 1', file u 1:(g($4)) w l ls 3 t 'fit 2'

f(x) = a + b*x
a = 3.5
b = 0.025
fit[35:60] f(x) file u 1:(-log($2)) via a,b

g(x) = A*exp(B*x)
A = exp(-a)
B = -b
fit[35:60] g(x) file u 1:2 via A,B

set title 'Energy (semilog)'
set o 'data/energy_semilog.pdf'
p file u 1:(-log($2)) ls 1 t 'data', f(x) ls 2 t 'fit 1', -log(g(x)) ls 3 t 'fit 2'

set title 'Convolution'
set o 'data/convolution.pdf'
p file u 1:(exp(b*$1)*$3) ls 1 not
