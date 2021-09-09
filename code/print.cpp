#include "header.h"

void print(const int &time, const int &pid, const CONFIG &config,
           MPI_Datatype body_type, MPI_Datatype trap_type, domain &section){
    //Imprimir el estado del sistema en un momento específico

    //Procesadores que imprimen
    int pid_0 = time%config.nproc;

    double energy_sum = 0;  //Suma de la energía mecanica
    double activation_sum = 0;  //Numero de activaciones parcial
    double activation_acc_sum = 0;  //Numero de activaciones acumulado
    double calm_sum = 0;  //Numero de variacion de pelotas quietas 
    double calm_acc_sum = 0;  //Numero de pelotas quietas

    double E_0 = config.mass*config.g*config.z_init;
    section.calm_partial_sum = -section.calm_total_sum;
    section.calm_total_sum = 0;

    //Calcula la energia mecanica y trampas quietas de cada seccion
    for (int ii = 0; ii < section.local_size; ii++){

        //Energia mecanica por particula
        double E = 0.5*section.balls[ii].mass*norma2(section.balls[ii].vel) + 0.5*section.balls[ii].I*norma2(section.balls[ii].omega) 
                 + section.balls[ii].mass*section.balls[ii].pos.z()*config.g;
        section.energy += E*std::pow(10,-6);

        //Numero de pelotas quietas
        if (std::abs((E - section.balls[ii].mass*section.balls[ii].rad*config.g))/E_0 < config.err && section.balls[ii].active == 1)
            section.calm_total_sum += 1;
    }

    //Actualiza las activaciones acumuladas de la seccion
    section.activation_total_sum += section.activation_partial_sum;

    //Pelotas paradas en la seccion
    section.calm_partial_sum += section.calm_total_sum; 

    //Suma la cantidad de energía y activaciones totales del sistema
    MPI_Reduce(&section.energy, &energy_sum, 1, MPI_DOUBLE, MPI_SUM, pid_0, MPI_COMM_WORLD);
    MPI_Reduce(&section.activation_partial_sum, &activation_sum, 1, MPI_DOUBLE, MPI_SUM, pid_0, MPI_COMM_WORLD);
    MPI_Reduce(&section.activation_total_sum, &activation_acc_sum, 1, MPI_DOUBLE, MPI_SUM, pid_0, MPI_COMM_WORLD);
    MPI_Reduce(&section.calm_partial_sum, &calm_sum, 1, MPI_DOUBLE, MPI_SUM, pid_0, MPI_COMM_WORLD);
    MPI_Reduce(&section.calm_total_sum, &calm_acc_sum, 1, MPI_DOUBLE, MPI_SUM, pid_0, MPI_COMM_WORLD);
    
    if (pid == pid_0){  //Datos globales del sistema
        //Promedia el numero de activaciones parcial
        activation_sum /= 1.0*config.resolution*config.dt;
        //Imprime los datos
        std::string fname = "data/results/data_system-" + std::to_string(time) + ".csv";
        std::ofstream fout(fname);
        fout << energy_sum << "\t"
             << activation_sum/config.nt << "\t"
             << activation_acc_sum/config.nt << "\t"
             << calm_sum/config.nt << "\t"
             << calm_acc_sum/config.nt << "\n";
        fout.close();
    }

    //Re-inicializa la energia y el numero de activaciones parciales
    section.energy = 0; 
    section.activation_partial_sum = 0;
    section.calm_partial_sum = 0;
}
