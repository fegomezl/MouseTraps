NPROC=$(shell sed -n 25p data/init_data.txt | tr -d -c 0-9)
OUT=/media/sf_Archdata/

#Compiling parameters
CXX = mpic++
FLAGS = -std=c++17 -O3 -g
RUN = mpirun -np $(NPROC) --oversubscribe ./
SOURCES = $(wildcard code/*.cpp)
DEPENDENCIES = $(SOURCES:code/%.cpp=.objects/%.o)

.PHONY: all run graph show send cluster clean oclean

all: main.x
	@echo 'Program Compiled.'

run: main.x
	@echo -e 'Running program...'
	@$(RUN)$<
	@echo -e 'Done!'

graph: data/results/system_state.txt
	@echo -e 'Ploting system variables... \c'
	@gnuplot scripts/plot_system_state.gp
	@gnuplot scripts/analysis.gp
	@echo -e 'Done!'

show:
	@xpdf data/energy.pdf data/activation_partial.pdf data/activation_total.pdf &

send:
	@cp data/*pdf $(OUT)

cluster: main.x
	@bash scripts/send.sh

main.x: $(DEPENDENCIES)
	@echo -e 'Compiling' $@ '... \c'
	@$(CXX) $(FLAGS) $^ -o $@
	@echo -e 'Done!\n'

.objects/%.o: code/%.cpp
	@echo -e 'Building' $@ '... \c'
	@$(CXX) $(FLAGS) -c $< -o $@
	@echo -e 'Done!\n'

data/results/system_state.txt:
	@bash scripts/print_system.sh

clean:
	@rm -f data/results/*.csv data/*.err data/*.out *.x *.log

rclean:
	@rm -f data/*.pdf data/results/*.txt

oclean:
	@rm -f .objects/*.o *.x
