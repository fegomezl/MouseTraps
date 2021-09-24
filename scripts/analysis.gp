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
set xl 'Porcentaje de pelotas en movimiento'

set title 'Calm analysis'
set o 'data/calm_analysis.pdf'
p file u 6:($3-$5) ls 1 not
