set g
set key opaque
set term pdf
set ls 1 lc rgb "dark-blue" pt 0 ps 0.5 lt 1 lw 0.5
set ls 2 lc rgb "dark-red" pt 0 ps 0.5 lt 1 lw 0.5
set ls 3 lc rgb "dark-green" pt 0 ps 0.5 lt 1 lw 0.5

file = 'data/results/system_state.txt'

box_size = system("sed -n 1p data/init_data.txt | tr -d -c 0-9")*1
nt = int(system("sed -n 3p data/init_data.txt | tr -d -c 0-9"))
rad = system("sed -n 6p data/init_data.txt | tr -d -c 0-9.")*1
densidad = 4*(rad*rad*nt)/(box_size*box_size)

Init = sprintf(" {/:Bold Densidad:} %.2f", densidad)

set xr [0:]
set xl 'Tiempo (s)'

set obj 1 rect from graph 0, 1 to graph 0.25, 0.93 fc rgb "white"
set lab 1 Init at graph 0, 0.96

set title 'Evolucion temporal de la energia mecanica del sistema'
set yr [0:]
set yl 'Energía (MJ)'
set o 'data/energy.pdf'
p file u 1:2 ls 1 t 'Energía'

set title 'Densidad de probabilidad de activacion'
set yr [0:]
set yl 'f(x)'
set o 'data/activation_partial.pdf'
p file u 1:3 ls 1 t 'f(x)'

set title 'Distribucion acumulada de probabilidad de activacion'
set yr [0:1]
set yl 'F(x)'
set o 'data/activation_total.pdf'
p file u 1:4 ls 1 t 'F(x)'

set title 'Densidad de pelotas perturbadas'
unset yr
set yl 'z(x)'
set o 'data/calm_partial.pdf'
p file u 1:5 ls 1 t 'z(x)'

set title 'Cantidad de pelotas quietas'
set yr [0:1]
set yl 'Z(x)'
set o 'data/calm_total.pdf'
p file u 1:6 ls 1 t 'Z(x)'

set title 'Sistema total'
unset yr
set yl 'Porcentaje de pelotas'
set o 'data/system.pdf'
p file u 1:(1-$4) ls 1 t 'X', file u 1:6 ls 2 t 'Y', file u 1:($4-$6) ls 3 t 'Z'
